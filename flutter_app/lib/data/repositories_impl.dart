import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show Color;

import '../branding/studio_branding.dart';
import '../core/money.dart';
import '../domain/models.dart';
import '../domain/repositories.dart';
import '../features/billing/cart.dart';
import '../features/services/sample_catalog.dart';
import 'database.dart';

/// Drift-backed repositories. Widgets never see SQL — they talk to the
/// interfaces in domain/repositories.dart (plus [DraftStore] below), so the
/// future Spring Boot sync layer can slot in behind the same seams.

class DriftStudioConfigRepository implements StudioConfigRepository {
  DriftStudioConfigRepository(this._db);

  final AppDatabase _db;

  StudioBranding _toBranding(StudioProfile row) => StudioBranding(
        businessName: row.businessName,
        tagline: row.tagline,
        logoAssetPath: row.logoPath,
        primaryColor: Color(row.primaryColor),
        secondaryColor: Color(row.secondaryColor),
        address: row.address,
        phone: row.phone,
        email: row.email,
        gstin: row.gstin,
        upiId: row.upiId,
        upiPayeeName: row.upiPayeeName,
        currencyCode: row.currencyCode,
        invoicePrefix: row.invoicePrefix,
        invoiceFooter: row.invoiceFooter,
      );

  @override
  Future<StudioBranding?> load() async {
    final row = await (_db.select(_db.studioProfiles)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
    return row == null ? null : _toBranding(row);
  }

  @override
  Future<void> save(StudioBranding branding) async {
    final now = DateTime.now();
    await _db.into(_db.studioProfiles).insertOnConflictUpdate(
          StudioProfilesCompanion(
            id: const Value(1),
            businessName: Value(branding.businessName),
            tagline: Value(branding.tagline),
            logoPath: Value(branding.logoAssetPath),
            primaryColor: Value(branding.primaryColor.toARGB32()),
            secondaryColor: Value(branding.secondaryColor.toARGB32()),
            address: Value(branding.address),
            phone: Value(branding.phone),
            email: Value(branding.email),
            gstin: Value(branding.gstin),
            upiId: Value(branding.upiId),
            upiPayeeName: Value(branding.upiPayeeName),
            currencyCode: Value(branding.currencyCode),
            invoicePrefix: Value(branding.invoicePrefix),
            invoiceFooter: Value(branding.invoiceFooter),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Stream<StudioBranding?> watch() {
    return (_db.select(_db.studioProfiles)..where((t) => t.id.equals(1)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toBranding(row));
  }
}

/// Category ids are slugs of their display names ('Hair Care' ->
/// 'hair-care') — stable, human-readable, and safe to sync later.
String categoryIdFor(String categoryName) =>
    categoryName.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

String normalizeCatalogName(String name) =>
    name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

class DriftServiceRepository implements ServiceRepository {
  DriftServiceRepository(this._db);

  final AppDatabase _db;

  ServiceItem _toItem(Service row, ServiceCategoryRow category) => ServiceItem(
        id: row.id,
        name: row.name,
        category: category.name,
        categoryId: category.id,
        pricePaise: row.pricePaise,
        durationMinutes: row.durationMinutes,
        isActive: row.isActive,
        description: row.description,
        sortOrder: row.sortOrder,
      );

  Future<List<ServiceItem>> _query({required bool activeOnly}) async {
    final query = _db.select(_db.services).join([
      innerJoin(
        _db.serviceCategories,
        _db.serviceCategories.id.equalsExp(_db.services.categoryId),
      ),
    ])
      ..orderBy([
        OrderingTerm.asc(_db.serviceCategories.sortOrder),
        OrderingTerm.asc(_db.services.sortOrder),
        OrderingTerm.asc(_db.services.name),
      ]);
    if (activeOnly) {
      query.where(
        _db.services.isActive.equals(true) &
            _db.serviceCategories.isActive.equals(true),
      );
    }
    final rows = await query.get();
    return [
      for (final row in rows)
        _toItem(
          row.readTable(_db.services),
          row.readTable(_db.serviceCategories),
        ),
    ];
  }

  @override
  Future<List<ServiceItem>> listActive() => _query(activeOnly: true);

  @override
  Future<List<ServiceItem>> listAll() => _query(activeOnly: false);

  @override
  Future<void> upsert(ServiceItem service) async {
    final name = service.name.trim();
    if (name.isEmpty) {
      throw CatalogValidationException('Service name cannot be empty.');
    }
    if (name.length > 80) {
      throw CatalogValidationException(
        'Service name is too long (max 80 characters).',
      );
    }
    try {
      MoneyEngine.validateLine(service.pricePaise, 1);
    } on ArgumentError catch (e) {
      throw CatalogValidationException('Invalid price: ${e.message}');
    }
    if (service.durationMinutes < 0 || service.durationMinutes > 24 * 60) {
      throw CatalogValidationException(
        'Duration must be between 0 and 24 hours.',
      );
    }
    final categoryId = service.categoryId ?? categoryIdFor(service.category);
    await _db.transaction(() async {
      // Ensure the category exists (it is created on first use; the
      // management UI creates categories explicitly before assigning).
      await _db.into(_db.serviceCategories).insertOnConflictUpdate(
            ServiceCategoriesCompanion(
              id: Value(categoryId),
              name: Value(service.category),
            ),
          );
      // Duplicate rule: no two ACTIVE services with the same normalized
      // name in the same category. An inactive namesake does not block.
      if (service.isActive) {
        final siblings = await (_db.select(_db.services)
              ..where(
                (t) =>
                    t.categoryId.equals(categoryId) &
                    t.isActive.equals(true) &
                    t.id.equals(service.id).not(),
              ))
            .get();
        final wanted = normalizeCatalogName(name);
        if (siblings.any((s) => normalizeCatalogName(s.name) == wanted)) {
          throw CatalogValidationException(
            'An active service named "$name" already exists in '
            '${service.category}. Rename it or deactivate the other one.',
          );
        }
      }
      final existing = await (_db.select(_db.services)
            ..where((t) => t.id.equals(service.id)))
          .getSingleOrNull();
      var effectiveSortOrder = existing?.sortOrder ?? service.sortOrder;
      if (existing == null && service.sortOrder == 0) {
        final siblings = await (_db.select(_db.services)
              ..where((t) => t.categoryId.equals(categoryId)))
            .get();
        if (siblings.isNotEmpty) {
          effectiveSortOrder =
              siblings.map((s) => s.sortOrder).reduce((a, b) => a > b ? a : b) +
                  10;
        }
      }
      await _db.into(_db.services).insertOnConflictUpdate(
            ServicesCompanion(
              id: Value(service.id),
              categoryId: Value(categoryId),
              name: Value(name),
              description: Value(service.description),
              pricePaise: Value(service.pricePaise),
              durationMinutes: Value(service.durationMinutes),
              isActive: Value(service.isActive),
              sortOrder: Value(effectiveSortOrder),
              createdAt: existing == null
                  ? Value(DateTime.now())
                  : const Value.absent(),
              updatedAt: Value(DateTime.now()),
            ),
          );
    });
  }

  @override
  Future<void> deactivate(String serviceId) async {
    await (_db.update(_db.services)..where((t) => t.id.equals(serviceId)))
        .write(
      ServicesCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> reactivate(String serviceId) async {
    // Reactivation must respect the duplicate-name rule too.
    final row = await (_db.select(_db.services)
          ..where((t) => t.id.equals(serviceId)))
        .getSingleOrNull();
    if (row == null) return;
    final category = await (_db.select(_db.serviceCategories)
          ..where((t) => t.id.equals(row.categoryId)))
        .getSingle();
    await upsert(_toItem(row, category).copyWith(isActive: true));
  }

  @override
  Future<List<ServiceCategory>> listCategories() async {
    final rows = await (_db.select(_db.serviceCategories)
          ..orderBy([
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .get();
    return [
      for (final row in rows)
        ServiceCategory(
          id: row.id,
          name: row.name,
          sortOrder: row.sortOrder,
          isActive: row.isActive,
        ),
    ];
  }

  @override
  Future<void> upsertCategory(ServiceCategory category) async {
    final name = category.name.trim();
    if (name.isEmpty) {
      throw CatalogValidationException('Category name cannot be empty.');
    }
    if (name.length > 60) {
      throw CatalogValidationException(
        'Category name is too long (max 60 characters).',
      );
    }
    final all = await listCategories();
    final wanted = normalizeCatalogName(name);
    if (all.any(
      (c) => c.id != category.id && normalizeCatalogName(c.name) == wanted,
    )) {
      throw CatalogValidationException(
        'A category named "$name" already exists.',
      );
    }
    await _db.into(_db.serviceCategories).insertOnConflictUpdate(
          ServiceCategoriesCompanion(
            id: Value(category.id),
            name: Value(name),
            sortOrder: Value(category.sortOrder),
            isActive: Value(category.isActive),
          ),
        );
  }

  @override
  Future<void> setCategoryActive(String categoryId, bool active) async {
    await (_db.update(_db.serviceCategories)
          ..where((t) => t.id.equals(categoryId)))
        .write(ServiceCategoriesCompanion(isActive: Value(active)));
  }

  @override
  Future<void> reorderCategories(List<String> orderedIds) async {
    await _db.transaction(() async {
      for (var i = 0; i < orderedIds.length; i++) {
        await (_db.update(_db.serviceCategories)
              ..where((t) => t.id.equals(orderedIds[i])))
            .write(ServiceCategoriesCompanion(sortOrder: Value(i * 10)));
      }
    });
  }

  @override
  Future<void> reorderServices(List<String> orderedIds) async {
    await _db.transaction(() async {
      for (var i = 0; i < orderedIds.length; i++) {
        await (_db.update(_db.services)
              ..where((t) => t.id.equals(orderedIds[i])))
            .write(ServicesCompanion(sortOrder: Value(i * 10)));
      }
    });
  }
}

class DriftEmployeeRepository implements EmployeeRepository {
  DriftEmployeeRepository(this._db);

  final AppDatabase _db;

  Employee _toEmployee(EmployeeRow row) => Employee(
        id: row.id,
        name: row.name,
        role: row.role,
        phone: row.phone,
        salaryType:
            row.salaryType == 'daily' ? SalaryType.daily : SalaryType.monthly,
        monthlySalaryPaise: row.monthlySalaryPaise,
        isActive: row.isActive,
        joiningDate: row.joiningDate,
        photoPath: row.photoPath,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  @override
  Future<List<Employee>> listActive() async {
    final rows = await (_db.select(_db.employees)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
    return [for (final row in rows) _toEmployee(row)];
  }

  @override
  Future<List<Employee>> listAll() async {
    final rows = await (_db.select(_db.employees)
          ..orderBy([
            (t) => OrderingTerm.desc(t.isActive),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .get();
    return [for (final row in rows) _toEmployee(row)];
  }

  @override
  Future<Employee?> getById(String id) async {
    final row = await (_db.select(_db.employees)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toEmployee(row);
  }

  @override
  Future<void> upsert(Employee employee) async {
    if (employee.name.trim().isEmpty) {
      throw ArgumentError('Employee name must not be empty.');
    }
    if (employee.monthlySalaryPaise < 0) {
      throw ArgumentError('Salary must not be negative.');
    }
    final now = DateTime.now();
    final existing = await getById(employee.id);
    await _db.into(_db.employees).insertOnConflictUpdate(
          EmployeesCompanion(
            id: Value(employee.id),
            name: Value(employee.name.trim()),
            role: Value(employee.role),
            phone: Value(employee.phone),
            salaryType: Value(
              employee.salaryType == SalaryType.daily ? 'daily' : 'monthly',
            ),
            monthlySalaryPaise: Value(employee.monthlySalaryPaise),
            isActive: Value(employee.isActive),
            joiningDate: Value(employee.joiningDate),
            photoPath: Value(employee.photoPath),
            createdAt: Value(existing?.createdAt ?? employee.createdAt ?? now),
            updatedAt: Value(now),
          ),
        );
  }

  @override
  Future<void> setActive(String id, bool isActive) async {
    await (_db.update(_db.employees)..where((t) => t.id.equals(id))).write(
      EmployeesCompanion(
        isActive: Value(isActive),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

/// Persistence seam for billing drafts (Task 1.7). Kept separate from
/// the domain repositories: drafts are a local-only concern until the
/// backend exists.
abstract interface class DraftStore {
  Future<void> saveDraft(CartState draft);
  Future<CartState?> loadDraft(String draftId);
  Future<List<CartState>> listDrafts();
  Future<void> deleteDraft(String draftId);
}

class DriftDraftStore implements DraftStore {
  DriftDraftStore(this._db);

  final AppDatabase _db;

  @override
  Future<void> saveDraft(CartState draft) async {
    final draftId = draft.draftId;
    if (draftId == null) {
      throw ArgumentError('Cannot persist a draft without an id');
    }
    // Validate every line through the money engine BEFORE writing, so a
    // corrupt cart can never reach the database.
    for (final line in draft.lines) {
      MoneyEngine.validateLine(line.pricePaise, line.quantity);
    }
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db.into(_db.billDrafts).insertOnConflictUpdate(
            BillDraftsCompanion(
              draftId: Value(draftId),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
      await (_db.delete(_db.draftLines)
            ..where((t) => t.draftId.equals(draftId)))
          .go();
      for (var i = 0; i < draft.lines.length; i++) {
        final line = draft.lines[i];
        await _db.into(_db.draftLines).insert(
              DraftLinesCompanion.insert(
                draftId: draftId,
                serviceId: line.serviceId,
                serviceName: line.serviceName,
                pricePaise: line.pricePaise,
                durationMinutes: Value(line.durationMinutes),
                quantity: line.quantity,
                position: i,
              ),
            );
      }
    });
  }

  @override
  Future<CartState?> loadDraft(String draftId) async {
    final draft = await (_db.select(_db.billDrafts)
          ..where((t) => t.draftId.equals(draftId)))
        .getSingleOrNull();
    if (draft == null) return null;
    final lines = await (_db.select(_db.draftLines)
          ..where((t) => t.draftId.equals(draftId))
          ..orderBy([(t) => OrderingTerm.asc(t.position)]))
        .get();
    return CartState(
      draftId: draft.draftId,
      lines: [
        for (final line in lines)
          CartLine(
            serviceId: line.serviceId,
            serviceName: line.serviceName,
            pricePaise: line.pricePaise,
            durationMinutes: line.durationMinutes,
            quantity: line.quantity,
          ),
      ],
    );
  }

  @override
  Future<List<CartState>> listDrafts() async {
    final drafts = await (_db.select(_db.billDrafts)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    return [
      for (final draft in drafts)
        (await loadDraft(draft.draftId))!,
    ];
  }

  @override
  Future<void> deleteDraft(String draftId) async {
    // Lines are removed by the ON DELETE CASCADE foreign key.
    await (_db.delete(_db.billDrafts)
          ..where((t) => t.draftId.equals(draftId)))
        .go();
  }
}

/// First-run seed: the SAMPLE catalog and employees, so the demo behaves
/// exactly as it did in-memory. This is demo seed data (badged SAMPLE in
/// the UI), not production data — the catalog task replaces it with
/// owner-managed data. The studio profile is deliberately NOT seeded:
/// branding stays the in-memory demo preset until the owner saves real
/// details in Settings, preserving the white-label rule.
Future<void> seedSampleDataIfEmpty(AppDatabase db) async {
  final existing = await db.select(db.serviceCategories).get();
  if (existing.isNotEmpty) return;
  final services = DriftServiceRepository(db);
  for (var i = 0; i < SampleCatalog.categories.length; i++) {
    final name = SampleCatalog.categories[i];
    await db.into(db.serviceCategories).insertOnConflictUpdate(
          ServiceCategoriesCompanion(
            id: Value(categoryIdFor(name)),
            name: Value(name),
            sortOrder: Value(i * 10),
          ),
        );
  }
  for (var i = 0; i < SampleCatalog.services.length; i++) {
    await services.upsert(
      SampleCatalog.services[i].copyWith(sortOrder: i * 10),
    );
  }
  final employees = DriftEmployeeRepository(db);
  for (final employee in SampleStaff.employees) {
    await employees.upsert(employee);
  }
  await db.into(db.syncMetadata).insertOnConflictUpdate(
        SyncMetadataCompanion(
          key: const Value('seeded_sample_data'),
          value: const Value('task-1.7'),
          updatedAt: Value(DateTime.now()),
        ),
      );
}
