import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/state.dart';
import '../branding/studio_branding.dart';
import '../domain/models.dart';
import '../domain/repositories.dart';
import '../core/studio_time.dart';
import '../features/billing/cart.dart';
import '../features/services/sample_catalog.dart';
import 'database.dart';
import 'billing_repository.dart';
import 'people_repository.dart';
import 'payroll_repository.dart';
import '../core/money.dart' show newDraftId;
import 'repositories_impl.dart';

/// Riverpod wiring for the persistence layer. Feature code depends on the
/// repository interfaces and the state providers below — never on Drift
/// directly.

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.device();
  ref.onDispose(db.close);
  return db;
});

final studioConfigRepositoryProvider = Provider<StudioConfigRepository>(
  (ref) => DriftStudioConfigRepository(ref.watch(appDatabaseProvider)),
);

final serviceRepositoryProvider = Provider<ServiceRepository>(
  (ref) => DriftServiceRepository(ref.watch(appDatabaseProvider)),
);

final employeeRepositoryProvider = Provider<EmployeeRepository>(
  (ref) => DriftEmployeeRepository(ref.watch(appDatabaseProvider)),
);

final draftStoreProvider = Provider<DraftStore>(
  (ref) => DriftDraftStore(ref.watch(appDatabaseProvider)),
);

/// The service catalog the billing screen renders. Starts with the sample
/// catalog so the first frame is instant, then replaces itself with the
/// database contents (the catalog is cached locally — service selection
/// never waits on storage or network).
class CatalogNotifier extends StateNotifier<List<ServiceItem>> {
  CatalogNotifier(this._repository) : super(SampleCatalog.services);

  final ServiceRepository _repository;

  Future<void> refreshFromRepository() async {
    try {
      final services = await _repository.listActive();
      if (services.isNotEmpty) state = services;
    } catch (_) {
      // Keep the in-memory catalog: billing must never block on storage.
    }
  }
}

final catalogProvider =
    StateNotifierProvider<CatalogNotifier, List<ServiceItem>>(
  (ref) => CatalogNotifier(ref.watch(serviceRepositoryProvider)),
);

/// Saved (persisted) drafts, most recently updated first.
class SavedDraftsNotifier extends StateNotifier<List<CartState>> {
  SavedDraftsNotifier(this._store) : super(const []);

  final DraftStore _store;

  Future<void> refresh() async {
    try {
      state = await _store.listDrafts();
    } catch (_) {
      // Listing drafts is best-effort UI; failures surface via save status.
    }
  }
}

final savedDraftsProvider =
    StateNotifierProvider<SavedDraftsNotifier, List<CartState>>(
  (ref) => SavedDraftsNotifier(ref.watch(draftStoreProvider)),
);

enum DraftSaveKind { idle, saving, saved, error }

class DraftSaveStatus {
  const DraftSaveStatus._(this.kind, {this.at, this.message});

  const DraftSaveStatus.idle() : this._(DraftSaveKind.idle);
  const DraftSaveStatus.saving() : this._(DraftSaveKind.saving);
  DraftSaveStatus.saved(DateTime at) : this._(DraftSaveKind.saved, at: at);
  DraftSaveStatus.error(String message)
      : this._(DraftSaveKind.error, message: message);

  final DraftSaveKind kind;
  final DateTime? at;
  final String? message;
}

final draftSaveStatusProvider =
    StateProvider<DraftSaveStatus>((ref) => const DraftSaveStatus.idle());

String _fingerprint(CartState state) =>
    '${state.draftId}|${state.discountPercent}|${state.flatDiscountPaise}|'
    '${state.taxBasisPoints}|'
    '${state.lines.map((l) => '${l.serviceId}:${l.quantity}:${l.pricePaise}:${l.employeeId ?? ''}').join(',')}';

/// Debounced, sequential draft autosaver.
///
/// - Local cart updates are instant (StateNotifier); persistence trails
///   behind on a 300 ms debounce so rapid tapping doesn't write per tap.
/// - Writes never overlap; a change during a save re-queues.
/// - The UI only claims "saved" after the write completes
///   ([draftSaveStatusProvider]); failures surface as an error status and
///   the draft stays dirty for the next change or a manual retry.
/// - An emptied cart deletes its draft: a cleared or checked-out bill
///   must never resurrect.
class DraftAutosaver {
  DraftAutosaver(this._ref);

  final Ref _ref;
  Timer? _timer;
  bool _saving = false;
  CartState? _pending;
  String? _cleanFingerprint;

  DraftStore get _store => _ref.read(draftStoreProvider);

  /// Marks a state as already persisted (startup recovery / draft
  /// resume), so restoring doesn't trigger a redundant write.
  void noteClean(CartState state) {
    _cleanFingerprint = _fingerprint(state);
    _ref.read(draftSaveStatusProvider.notifier).state =
        DraftSaveStatus.saved(DateTime.now());
    _ref.read(savedDraftsProvider.notifier).refresh();
  }

  void onCartChanged(CartState? previous, CartState next) {
    if (next.isEmpty) {
      _timer?.cancel();
      _pending = null;
      final finishedId = previous?.draftId;
      if (finishedId != null) {
        _cleanFingerprint = null;
        unawaited(_deleteDraft(finishedId));
      }
      _ref.read(draftSaveStatusProvider.notifier).state =
          const DraftSaveStatus.idle();
      return;
    }
    if (_fingerprint(next) == _cleanFingerprint) return;
    _pending = next;
    _ref.read(draftSaveStatusProvider.notifier).state =
        const DraftSaveStatus.saving();
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 300), _flush);
  }

  Future<void> retry() async {
    final pending = _pending;
    if (pending != null) await _flush();
  }

  Future<void> _deleteDraft(String draftId) async {
    try {
      await _store.deleteDraft(draftId);
      await _ref.read(savedDraftsProvider.notifier).refresh();
    } catch (_) {
      // A failed delete leaves a stale draft that the drafts sheet can
      // still remove explicitly; never crash billing over it.
    }
  }

  Future<void> _flush() async {
    final draft = _pending;
    if (draft == null || _saving) return;
    _saving = true;
    final attempted = _fingerprint(draft);
    try {
      await _store.saveDraft(draft);
      _cleanFingerprint = attempted;
      if (_pending != null && _fingerprint(_pending!) == attempted) {
        _pending = null;
      }
      _ref.read(draftSaveStatusProvider.notifier).state =
          DraftSaveStatus.saved(DateTime.now());
      await _ref.read(savedDraftsProvider.notifier).refresh();
    } catch (e) {
      // Stay dirty: the next cart change or a manual retry re-attempts.
      // Deliberately NO auto-retry loop — a broken store must not spin.
      _ref.read(draftSaveStatusProvider.notifier).state =
          DraftSaveStatus.error(e.toString());
    } finally {
      _saving = false;
      // A newer cart state arrived while saving — persist that too.
      if (_pending != null && _fingerprint(_pending!) != attempted) {
        _timer?.cancel();
        _timer = Timer(const Duration(milliseconds: 100), _flush);
      }
    }
  }

  void dispose() => _timer?.cancel();
}

final draftAutosaverProvider = Provider<DraftAutosaver>((ref) {
  final saver = DraftAutosaver(ref);
  ref.onDispose(saver.dispose);
  return saver;
});

/// One-time wiring, read by the app root: catalog refresh, branding
/// persistence, draft autosave.
final persistenceBootstrapProvider = Provider<void>((ref) {
  ref.read(catalogProvider.notifier).refreshFromRepository();
  ref.read(savedDraftsProvider.notifier).refresh();
  ref.read(catalogAdminProvider.notifier).load();
  ref.read(employeesAdminProvider.notifier).refresh();
  ref.read(attendanceProvider.notifier).load();

  ref.listen<StudioBranding>(brandingProvider, (previous, next) {
    if (previous == null || previous == next) return;
    unawaited(
      ref.read(studioConfigRepositoryProvider).save(next).catchError((_) {}),
    );
  });

  final saver = ref.read(draftAutosaverProvider);
  ref.listen<CartState>(
    cartProvider,
    (previous, next) => saver.onCartChanged(previous, next),
  );
});

/// Everything the Services management screen needs: all categories and
/// ALL services (including inactive), plus the mutation operations.
/// Every mutation persists through the repository, reloads this state,
/// and refreshes the billing catalog so the New Bill screen reflects the
/// change immediately — no restart, no stale prices.
class CatalogAdminState {
  const CatalogAdminState({
    this.categories = const [],
    this.services = const [],
    this.loaded = false,
  });

  final List<ServiceCategory> categories;
  final List<ServiceItem> services;
  final bool loaded;
}

class CatalogAdminNotifier extends StateNotifier<CatalogAdminState> {
  CatalogAdminNotifier(this._repository, this._onCatalogChanged)
      : super(const CatalogAdminState());

  final ServiceRepository _repository;
  final void Function() _onCatalogChanged;

  Future<void> load() async {
    final categories = await _repository.listCategories();
    final services = await _repository.listAll();
    state = CatalogAdminState(
      categories: categories,
      services: services,
      loaded: true,
    );
  }

  Future<void> _mutated() async {
    await load();
    _onCatalogChanged();
  }

  /// Throws [CatalogValidationException] with an owner-readable message.
  Future<void> saveService(ServiceItem service) async {
    await _repository.upsert(service);
    await _mutated();
  }

  Future<void> setServiceActive(String serviceId, bool active) async {
    if (active) {
      await _repository.reactivate(serviceId);
    } else {
      await _repository.deactivate(serviceId);
    }
    await _mutated();
  }

  Future<void> saveCategory(ServiceCategory category) async {
    await _repository.upsertCategory(category);
    await _mutated();
  }

  Future<void> setCategoryActive(String categoryId, bool active) async {
    await _repository.setCategoryActive(categoryId, active);
    await _mutated();
  }

  Future<void> reorderCategories(List<String> orderedIds) async {
    await _repository.reorderCategories(orderedIds);
    await _mutated();
  }

  Future<void> reorderServices(List<String> orderedIds) async {
    await _repository.reorderServices(orderedIds);
    await _mutated();
  }
}

final catalogAdminProvider =
    StateNotifierProvider<CatalogAdminNotifier, CatalogAdminState>(
  (ref) => CatalogAdminNotifier(
    ref.watch(serviceRepositoryProvider),
    () => ref.read(catalogProvider.notifier).refreshFromRepository(),
  ),
);

final billingRepositoryProvider = Provider<BillingRepository>(
  (ref) => DriftBillingRepository(ref.watch(appDatabaseProvider)),
);

/// Staff available for per-line assignment (billing) — from the
/// employee repository (seeded sample staff until owners edit them).
final staffListProvider = FutureProvider<List<Employee>>(
  (ref) => ref.watch(employeeRepositoryProvider).listActive(),
);

/// Billing history state: the loaded bills plus the active filters.
/// Every mutation (finalize elsewhere, void, payment confirmation)
/// refreshes through here so the list never shows stale statuses.
class BillingHistoryState {
  const BillingHistoryState({
    this.bills = const [],
    this.query = '',
    this.paymentStatus,
    this.status,
    this.range = HistoryRange.all,
    this.loaded = false,
  });

  final List<FinalizedBill> bills;
  final String query;
  final PaymentStatus? paymentStatus;
  final FinalizedBillStatus? status;
  final HistoryRange range;
  final bool loaded;
}

enum HistoryRange { all, today, week }

class BillingHistoryNotifier extends StateNotifier<BillingHistoryState> {
  BillingHistoryNotifier(this._repository)
      : super(const BillingHistoryState());

  final BillingRepository _repository;

  Future<void> refresh() async {
    final now = DateTime.now();
    DateTime? from;
    if (state.range == HistoryRange.today) {
      from = DateTime(now.year, now.month, now.day);
    } else if (state.range == HistoryRange.week) {
      from = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 6));
    }
    final bills = await _repository.listBills(
      query: state.query,
      paymentStatus: state.paymentStatus,
      status: state.status,
      from: from,
    );
    if (mounted) {
      state = BillingHistoryState(
        bills: bills,
        query: state.query,
        paymentStatus: state.paymentStatus,
        status: state.status,
        range: state.range,
        loaded: true,
      );
    }
  }

  void setFilters({
    String? query,
    PaymentStatus? paymentStatus,
    bool clearPaymentStatus = false,
    FinalizedBillStatus? status,
    bool clearStatus = false,
    HistoryRange? range,
  }) {
    state = BillingHistoryState(
      bills: state.bills,
      query: query ?? state.query,
      paymentStatus:
          clearPaymentStatus ? null : (paymentStatus ?? state.paymentStatus),
      status: clearStatus ? null : (status ?? state.status),
      range: range ?? state.range,
      loaded: state.loaded,
    );
    refresh();
  }
}

final billingHistoryProvider =
    StateNotifierProvider<BillingHistoryNotifier, BillingHistoryState>(
  (ref) => BillingHistoryNotifier(ref.watch(billingRepositoryProvider)),
);

final attendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) => DriftAttendanceRepository(ref.watch(appDatabaseProvider)),
);

final advanceRepositoryProvider = Provider<AdvanceRepository>(
  (ref) => DriftAdvanceRepository(ref.watch(appDatabaseProvider)),
);

/// Employees admin state (Task 4): all employees incl. inactive.
class EmployeesAdminNotifier extends StateNotifier<List<Employee>> {
  EmployeesAdminNotifier(this._repository) : super(const []);

  final EmployeeRepository _repository;

  Future<void> refresh() async {
    state = await _repository.listAll();
  }

  Future<void> save(Employee employee) async {
    await _repository.upsert(employee);
    await refresh();
  }

  Future<void> setActive(String id, bool isActive) async {
    await _repository.setActive(id, isActive);
    await refresh();
  }
}

final employeesAdminProvider =
    StateNotifierProvider<EmployeesAdminNotifier, List<Employee>>(
  (ref) => EmployeesAdminNotifier(ref.watch(employeeRepositoryProvider)),
);

/// Attendance screen state: the selected studio-local date and its
/// records. Marking writes through the repository FIRST and only then
/// updates state — a status is never shown as saved before it is.
class AttendanceState {
  const AttendanceState({
    required this.dateKey,
    this.records = const {},
    this.loaded = false,
  });

  final String dateKey;
  final Map<String, AttendanceRecord> records;
  final bool loaded;
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier(this._repository)
      : super(AttendanceState(dateKey: StudioTime.todayKey()));

  final AttendanceRepository _repository;

  Future<void> load() async {
    final records = await _repository.recordsForDate(state.dateKey);
    if (mounted) {
      state = AttendanceState(
        dateKey: state.dateKey,
        records: records,
        loaded: true,
      );
    }
  }

  Future<void> setDate(String dateKey) async {
    state = AttendanceState(dateKey: dateKey);
    await load();
  }

  Future<void> mark(
    String employeeId,
    AttendanceStatus status, {
    required String actor,
  }) async {
    final record = await _repository.mark(
      employeeId: employeeId,
      dateKey: state.dateKey,
      status: status,
      actor: actor,
    );
    if (mounted) {
      state = AttendanceState(
        dateKey: state.dateKey,
        records: {...state.records, employeeId: record},
        loaded: true,
      );
    }
  }
}

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>(
  (ref) => AttendanceNotifier(ref.watch(attendanceRepositoryProvider)),
);

final payrollRepositoryProvider = Provider<PayrollRepository>((ref) {
  return DriftPayrollRepository(ref.watch(appDatabaseProvider));
});

/// State for the Salary screen: one period, its settings, the current
/// run (if any) with lines/adjustments/payments, or a live preview
/// when no run exists yet.
class PayrollState {
  const PayrollState({
    required this.periodKey,
    this.settings,
    this.run,
    this.lines = const [],
    this.adjustments = const [],
    this.payments = const [],
    this.preview,
    this.loading = true,
    this.busy = false,
    this.error,
  });

  final String periodKey;
  final PayrollSettingsState? settings;
  final PayrollRun? run;
  final List<PayrollLine> lines;
  final List<PayrollAdjustment> adjustments;
  final List<PayrollPayment> payments;
  final List<PayrollPreviewLine>? preview;
  final bool loading;
  final bool busy;
  final String? error;

  int get totalGross => lines.fold(0, (s, l) => s + l.grossPaise);
  int get totalAdvances => lines.fold(0, (s, l) => s + l.advancesPaise);
  int get totalDeductions => lines.fold(0, (s, l) => s + l.deductionsPaise);
  int get totalNet => lines.fold(0, (s, l) => s + l.netPaise);
  int get totalPaid => lines.fold(0, (s, l) => s + l.paidPaise);
  int get totalCarryForward =>
      lines.fold(0, (s, l) => s + l.carryForwardPaise);
  int get outstanding => totalNet - totalPaid;
  bool get hasIncomplete =>
      lines.any((l) => l.counts.unmarked > 0) ||
      (preview?.any((l) => l.incompleteAttendance) ?? false);

  PayrollState copyWith({
    String? periodKey,
    PayrollSettingsState? settings,
    PayrollRun? run,
    bool clearRun = false,
    List<PayrollLine>? lines,
    List<PayrollAdjustment>? adjustments,
    List<PayrollPayment>? payments,
    List<PayrollPreviewLine>? preview,
    bool clearPreview = false,
    bool? loading,
    bool? busy,
    String? error,
    bool clearError = false,
  }) =>
      PayrollState(
        periodKey: periodKey ?? this.periodKey,
        settings: settings ?? this.settings,
        run: clearRun ? null : (run ?? this.run),
        lines: lines ?? this.lines,
        adjustments: adjustments ?? this.adjustments,
        payments: payments ?? this.payments,
        preview: clearPreview ? null : (preview ?? this.preview),
        loading: loading ?? this.loading,
        busy: busy ?? this.busy,
        error: clearError ? null : (error ?? this.error),
      );
}

class PayrollNotifier extends StateNotifier<PayrollState> {
  PayrollNotifier(this._repo, this._actor)
      : super(
          PayrollState(
            periodKey: StudioTime.monthKeyOf(DateTime.now()),
          ),
        ) {
    load();
  }

  final PayrollRepository _repo;
  final String _actor;

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final settings = await _repo.getSettings();
      final runs = await _repo.listRuns(periodKey: state.periodKey);
      // The period's working run: a draft if one exists, else the
      // latest non-voided version.
      final live = runs
          .where((r) => r.status != PayrollRunStatus.voided)
          .toList()
        ..sort((a, b) => b.version.compareTo(a.version));
      final draft =
          live.where((r) => r.status == PayrollRunStatus.draft).firstOrNull;
      final run = draft ?? live.firstOrNull;
      if (run != null) {
        state = state.copyWith(
          settings: settings,
          run: run,
          lines: await _repo.linesFor(run.id),
          adjustments: await _repo.adjustmentsFor(run.id),
          payments: await _repo.paymentsFor(run.id),
          clearPreview: true,
          loading: false,
        );
      } else {
        state = state.copyWith(
          settings: settings,
          clearRun: true,
          lines: const [],
          adjustments: const [],
          payments: const [],
          preview: await _repo.preview(state.periodKey),
          loading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: '$e');
    }
  }

  Future<void> setPeriod(String periodKey) async {
    state = state.copyWith(periodKey: periodKey);
    await load();
  }

  Future<void> _busy(Future<void> Function() action) async {
    state = state.copyWith(busy: true, clearError: true);
    try {
      await action();
    } catch (e) {
      state = state.copyWith(error: '$e');
    } finally {
      state = state.copyWith(busy: false);
    }
    await load();
  }

  Future<void> createDraft() =>
      _busy(() async => _repo.getOrCreateDraft(state.periodKey, _actor));

  Future<void> refresh() => _busy(() async {
        if (state.run != null) await _repo.refreshDraft(state.run!.id);
      });

  Future<void> saveSettings(PayrollRules rules, bool markReviewed) =>
      _busy(() async =>
          _repo.saveSettings(rules, markReviewed: markReviewed));

  Future<void> approve(bool acknowledgeIncomplete) => _busy(() async {
        if (state.run != null) {
          await _repo.approve(
            state.run!.id,
            _actor,
            acknowledgeIncomplete: acknowledgeIncomplete,
          );
        }
      });

  Future<void> voidRun(String reason) => _busy(() async {
        if (state.run != null) await _repo.voidRun(state.run!.id, _actor, reason);
      });

  Future<void> revise() => _busy(() async {
        if (state.run != null) await _repo.revise(state.run!.id, _actor);
      });

  Future<void> setOvertime(String employeeId, int unitsBp) => _busy(() async {
        if (state.run != null) {
          await _repo.setOvertime(state.run!.id, employeeId, unitsBp);
        }
      });

  Future<void> addAdjustment({
    required PayrollLine line,
    required bool isBonus,
    required int amountPaise,
    required String label,
  }) =>
      _busy(() async {
        await _repo.addAdjustment(
          PayrollAdjustment(
            id: 'adj_${newDraftId()}',
            runId: line.runId,
            lineId: line.id,
            isBonus: isBonus,
            amountPaise: amountPaise,
            label: label,
            createdBy: _actor,
            createdAt: DateTime.now(),
          ),
        );
      });

  Future<void> removeAdjustment(String adjustmentId) =>
      _busy(() async => _repo.removeAdjustment(adjustmentId));

  Future<void> recordPayment({
    required PayrollLine line,
    required int amountPaise,
    required String method,
    String? notes,
    required String paymentId,
  }) =>
      _busy(() async {
        await _repo.recordPayment(
          PayrollPayment(
            id: paymentId,
            runId: line.runId,
            lineId: line.id,
            employeeId: line.employeeId,
            amountPaise: amountPaise,
            paidAt: DateTime.now(),
            method: method,
            recordedBy: _actor,
            notes: notes,
          ),
        );
      });
}

final payrollProvider =
    StateNotifierProvider<PayrollNotifier, PayrollState>((ref) {
  final role = ref.watch(roleProvider);
  return PayrollNotifier(
    ref.watch(payrollRepositoryProvider),
    role == AppRole.owner ? 'Owner' : 'Staff',
  );
});
