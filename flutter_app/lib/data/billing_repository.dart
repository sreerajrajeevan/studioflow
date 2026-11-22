import 'package:drift/drift.dart';

import '../core/money.dart';
import '../domain/models.dart';
import '../domain/repositories.dart';
import '../features/billing/cart.dart';
import 'database.dart';

String _paymentStatusName(PaymentStatus status) => switch (status) {
      PaymentStatus.pending => 'pending',
      PaymentStatus.confirmedManual => 'confirmed_manual',
      PaymentStatus.verifiedProvider => 'verified_provider',
    };

PaymentStatus _paymentStatusFrom(String raw) => switch (raw) {
      'confirmed_manual' => PaymentStatus.confirmedManual,
      'verified_provider' => PaymentStatus.verifiedProvider,
      _ => PaymentStatus.pending,
    };

String _methodName(PaymentMethod method) => method.name;

PaymentMethod _methodFrom(String raw) => switch (raw) {
      'upi' => PaymentMethod.upi,
      'card' => PaymentMethod.card,
      _ => PaymentMethod.cash,
    };

/// The bill-level payment status is DERIVED from its payments, never
/// trusted from input: fully covered by provider-verified payments →
/// verified; fully covered by confirmed (manual or verified) payments
/// → manually confirmed; anything else → pending.
PaymentStatus deriveBillPaymentStatus(
  List<BillPayment> payments,
  int totalPaise,
) {
  if (payments.isEmpty || totalPaise <= 0) {
    return payments.isNotEmpty &&
            payments.every((p) => p.status != PaymentStatus.pending)
        ? PaymentStatus.confirmedManual
        : PaymentStatus.pending;
  }
  final verified = payments
      .where((p) => p.status == PaymentStatus.verifiedProvider)
      .fold(0, (sum, p) => sum + p.amountPaise);
  if (verified >= totalPaise) return PaymentStatus.verifiedProvider;
  final confirmed = payments
      .where((p) => p.status != PaymentStatus.pending)
      .fold(0, (sum, p) => sum + p.amountPaise);
  if (confirmed >= totalPaise) return PaymentStatus.confirmedManual;
  return PaymentStatus.pending;
}

/// Drift-backed finalized billing (Task 3). See the interface docs in
/// domain/repositories.dart and docs/BILLING.md.
class DriftBillingRepository implements BillingRepository {
  DriftBillingRepository(this._db);

  final AppDatabase _db;

  @override
  Future<FinalizedBill> finalizeDraft({
    required CartState cart,
    required StudioSnapshot studio,
    required int studioPrimaryColor,
    required List<PaymentDraft> payments,
    required String actor,
    String customerName = '',
  }) async {
    final draftId = cart.draftId;
    if (draftId == null || cart.isEmpty) {
      throw ArgumentError('Cannot finalize an empty cart.');
    }
    // Totals are recomputed here, through the one money engine — the
    // UI's numbers are never trusted for a financial record.
    final totals = cart.totals;
    var paymentSum = 0;
    for (final payment in payments) {
      if (payment.amountPaise <= 0) {
        throw ArgumentError('Payment amounts must be positive.');
      }
      paymentSum += payment.amountPaise;
    }
    if (paymentSum > totals.totalPaise) {
      throw ArgumentError('Payments exceed the bill total.');
    }

    return _db.transaction(() async {
      // Idempotency: a bill already finalized from this draft is the
      // answer — return it, never duplicate it.
      final existing = await (_db.select(_db.bills)
            ..where((t) => t.draftId.equals(draftId)))
          .getSingleOrNull();
      if (existing != null) return _assemble(existing);

      final now = DateTime.now();
      // Provisional sequence, incremented inside this transaction so a
      // rollback never burns a number.
      const counterKey = 'local_invoice_seq';
      final counter = await (_db.select(_db.invoiceCounters)
            ..where((t) => t.key.equals(counterKey)))
          .getSingleOrNull();
      final seq = (counter?.value ?? 0) + 1;
      await _db.into(_db.invoiceCounters).insertOnConflictUpdate(
            InvoiceCountersCompanion(
              key: const Value(counterKey),
              value: Value(seq),
              updatedAt: Value(now),
            ),
          );
      final prefix = studio.invoicePrefix.trim().isEmpty
          ? 'INV'
          : studio.invoicePrefix.trim();
      final provisionalRef =
          '$prefix-${now.year}-${seq.toString().padLeft(4, '0')}';
      final billId = 'inv_${newDraftId().substring('draft-'.length)}';

      final paymentModels = [
        for (final p in payments)
          BillPayment(
            id: p.id,
            method: p.method,
            amountPaise: p.amountPaise,
            status: p.status,
            confirmedBy: p.confirmedBy,
            confirmedAt: p.confirmedAt,
            createdAt: now,
          ),
      ];
      final billStatus =
          deriveBillPaymentStatus(paymentModels, totals.totalPaise);

      await _db.into(_db.bills).insert(
            BillsCompanion(
              id: Value(billId),
              provisionalRef: Value(provisionalRef),
              localSeq: Value(seq),
              draftId: Value(draftId),
              customerName: Value(customerName.trim()),
              snapshotBusinessName: Value(studio.businessName),
              snapshotTagline: Value(studio.tagline),
              snapshotAddress: Value(studio.address),
              snapshotPhone: Value(studio.phone),
              snapshotEmail: Value(studio.email),
              snapshotGstin: Value(studio.gstin),
              snapshotUpiId: Value(studio.upiId),
              snapshotInvoiceFooter: Value(studio.invoiceFooter),
              snapshotPrimaryColor: Value(studioPrimaryColor),
              subtotalPaise: Value(totals.subtotalPaise),
              discountPercent: Value(cart.discountPercent),
              discountFlatPaise: Value(cart.flatDiscountPaise),
              discountPaise: Value(totals.discountPaise),
              taxBasisPoints: Value(cart.taxBasisPoints),
              taxPaise: Value(totals.taxPaise),
              totalPaise: Value(totals.totalPaise),
              status: const Value('finalized'),
              paymentStatus: Value(_paymentStatusName(billStatus)),
              createdAt: Value(now),
              finalizedAt: Value(now),
            ),
          );
      for (var i = 0; i < cart.lines.length; i++) {
        final line = cart.lines[i];
        await _db.into(_db.billLines).insert(
              BillLinesCompanion(
                billId: Value(billId),
                serviceId: Value(line.serviceId),
                serviceName: Value(line.serviceName),
                pricePaise: Value(line.pricePaise),
                durationMinutes: Value(line.durationMinutes),
                quantity: Value(line.quantity),
                employeeId: Value(line.employeeId),
                employeeName: Value(line.employeeName),
                position: Value(i),
              ),
            );
      }
      for (final payment in paymentModels) {
        await _db.into(_db.payments).insert(
              PaymentsCompanion(
                id: Value(payment.id),
                billId: Value(billId),
                method: Value(_methodName(payment.method)),
                amountPaise: Value(payment.amountPaise),
                status: Value(_paymentStatusName(payment.status)),
                confirmedBy: Value(payment.confirmedBy),
                confirmedAt: Value(payment.confirmedAt),
                createdAt: Value(now),
              ),
            );
      }
      await _audit(
        billId: billId,
        draftId: draftId,
        type: 'finalized',
        actor: actor,
        detail: 'Provisional ref $provisionalRef · total '
            '${totals.totalPaise} paise · payments '
            '${_paymentStatusName(billStatus)}',
        at: now,
      );
      // The draft is consumed by finalization — deleted in the SAME
      // transaction, so a crash can never leave both or neither.
      await (_db.delete(_db.billDrafts)
            ..where((t) => t.draftId.equals(draftId)))
          .go();

      final row = await (_db.select(_db.bills)
            ..where((t) => t.id.equals(billId)))
          .getSingle();
      return _assemble(row);
    });
  }

  Future<void> _audit({
    required String? billId,
    required String? draftId,
    required String type,
    required String actor,
    required String detail,
    required DateTime at,
  }) async {
    await _db.into(_db.billingAuditEvents).insert(
          BillingAuditEventsCompanion(
            billId: Value(billId),
            draftId: Value(draftId),
            type: Value(type),
            actor: Value(actor),
            detail: Value(detail),
            createdAt: Value(at),
          ),
        );
  }

  Future<FinalizedBill> _assemble(BillRow row) async {
    final lineRows = await (_db.select(_db.billLines)
          ..where((t) => t.billId.equals(row.id))
          ..orderBy([(t) => OrderingTerm.asc(t.position)]))
        .get();
    final paymentRows = await (_db.select(_db.payments)
          ..where((t) => t.billId.equals(row.id))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return FinalizedBill(
      id: row.id,
      provisionalRef: row.provisionalRef,
      localSeq: row.localSeq,
      draftId: row.draftId,
      customerName: row.customerName,
      studio: StudioSnapshot(
        businessName: row.snapshotBusinessName,
        tagline: row.snapshotTagline,
        address: row.snapshotAddress,
        phone: row.snapshotPhone,
        email: row.snapshotEmail,
        gstin: row.snapshotGstin,
        upiId: row.snapshotUpiId,
        invoicePrefix: row.provisionalRef.split('-').first,
        invoiceFooter: row.snapshotInvoiceFooter,
      ),
      studioPrimaryColor: row.snapshotPrimaryColor,
      lines: [
        for (final l in lineRows)
          BillLine(
            serviceId: l.serviceId,
            serviceName: l.serviceName,
            pricePaise: l.pricePaise,
            quantity: l.quantity,
            employeeId: l.employeeId,
            employeeName: l.employeeName,
            durationMinutes: l.durationMinutes,
          ),
      ],
      payments: [
        for (final p in paymentRows)
          BillPayment(
            id: p.id,
            method: _methodFrom(p.method),
            amountPaise: p.amountPaise,
            status: _paymentStatusFrom(p.status),
            confirmedBy: p.confirmedBy,
            confirmedAt: p.confirmedAt,
            createdAt: p.createdAt,
          ),
      ],
      subtotalPaise: row.subtotalPaise,
      discountPercent: row.discountPercent,
      flatDiscountPaise: row.discountFlatPaise,
      discountPaise: row.discountPaise,
      taxBasisPoints: row.taxBasisPoints,
      taxPaise: row.taxPaise,
      totalPaise: row.totalPaise,
      status: row.status == 'voided'
          ? FinalizedBillStatus.voided
          : FinalizedBillStatus.finalized,
      paymentStatus: _paymentStatusFrom(row.paymentStatus),
      createdAt: row.createdAt,
      finalizedAt: row.finalizedAt,
      voidedAt: row.voidedAt,
      voidReason: row.voidReason,
      voidedBy: row.voidedBy,
    );
  }

  @override
  Future<List<FinalizedBill>> listBills({
    String? query,
    PaymentStatus? paymentStatus,
    FinalizedBillStatus? status,
    DateTime? from,
    DateTime? to,
    int limit = 200,
  }) async {
    final select = _db.select(_db.bills)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit);
    if (query != null && query.trim().isNotEmpty) {
      final q = '%${query.trim()}%';
      select.where(
        (t) => t.provisionalRef.like(q) | t.customerName.like(q),
      );
    }
    if (paymentStatus != null) {
      select.where(
        (t) => t.paymentStatus.equals(_paymentStatusName(paymentStatus)),
      );
    }
    if (status != null) {
      select.where(
        (t) => t.status.equals(
          status == FinalizedBillStatus.voided ? 'voided' : 'finalized',
        ),
      );
    }
    if (from != null) {
      select.where((t) => t.createdAt.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      select.where((t) => t.createdAt.isSmallerThanValue(to));
    }
    final rows = await select.get();
    return [for (final row in rows) await _assemble(row)];
  }

  @override
  Future<FinalizedBill?> getBill(String id) async {
    final row = await (_db.select(_db.bills)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _assemble(row);
  }

  @override
  Future<FinalizedBill> voidBill(
    String billId, {
    required String reason,
    required String actor,
  }) async {
    if (reason.trim().isEmpty) {
      throw ArgumentError('A void reason is required.');
    }
    return _db.transaction(() async {
      final row = await (_db.select(_db.bills)
            ..where((t) => t.id.equals(billId)))
          .getSingleOrNull();
      if (row == null) throw StateError('Bill not found.');
      if (row.status == 'voided') {
        throw StateError('Bill is already voided.');
      }
      final now = DateTime.now();
      await (_db.update(_db.bills)..where((t) => t.id.equals(billId))).write(
        BillsCompanion(
          status: const Value('voided'),
          voidedAt: Value(now),
          voidReason: Value(reason.trim()),
          voidedBy: Value(actor),
        ),
      );
      await _audit(
        billId: billId,
        draftId: row.draftId,
        type: 'voided',
        actor: actor,
        detail: reason.trim(),
        at: now,
      );
      final updated = await (_db.select(_db.bills)
            ..where((t) => t.id.equals(billId)))
          .getSingle();
      return _assemble(updated);
    });
  }

  @override
  Future<FinalizedBill> confirmPayment(
    String billId,
    String paymentId, {
    required String actor,
  }) async {
    return _db.transaction(() async {
      final payment = await (_db.select(_db.payments)
            ..where((t) => t.id.equals(paymentId) & t.billId.equals(billId)))
          .getSingleOrNull();
      if (payment == null) throw StateError('Payment not found.');
      if (payment.status != 'pending') {
        throw StateError('Payment is already ${payment.status}.');
      }
      final now = DateTime.now();
      await (_db.update(_db.payments)..where((t) => t.id.equals(paymentId)))
          .write(
        PaymentsCompanion(
          status: const Value('confirmed_manual'),
          confirmedBy: Value(actor),
          confirmedAt: Value(now),
        ),
      );
      final bill = await getBill(billId);
      final newStatus =
          deriveBillPaymentStatus(bill!.payments, bill.totalPaise);
      await (_db.update(_db.bills)..where((t) => t.id.equals(billId))).write(
        BillsCompanion(paymentStatus: Value(_paymentStatusName(newStatus))),
      );
      await _audit(
        billId: billId,
        draftId: bill.draftId,
        type: 'payment_confirmed',
        actor: actor,
        detail: '${payment.method} ${payment.amountPaise} paise '
            'manually confirmed',
        at: now,
      );
      final updated = await (_db.select(_db.bills)
            ..where((t) => t.id.equals(billId)))
          .getSingle();
      return _assemble(updated);
    });
  }

  @override
  Future<List<BillingAuditEvent>> auditFor(String billId) async {
    final rows = await (_db.select(_db.billingAuditEvents)
          ..where((t) => t.billId.equals(billId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return [
      for (final row in rows)
        BillingAuditEvent(
          type: row.type,
          actor: row.actor,
          detail: row.detail,
          createdAt: row.createdAt,
        ),
    ];
  }
}
