// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StudioProfilesTable extends StudioProfiles
    with TableInfo<$StudioProfilesTable, StudioProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudioProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _businessNameMeta =
      const VerificationMeta('businessName');
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
      'business_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _taglineMeta =
      const VerificationMeta('tagline');
  @override
  late final GeneratedColumn<String> tagline = GeneratedColumn<String>(
      'tagline', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _primaryColorMeta =
      const VerificationMeta('primaryColor');
  @override
  late final GeneratedColumn<int> primaryColor = GeneratedColumn<int>(
      'primary_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _secondaryColorMeta =
      const VerificationMeta('secondaryColor');
  @override
  late final GeneratedColumn<int> secondaryColor = GeneratedColumn<int>(
      'secondary_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
      'gstin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upiIdMeta = const VerificationMeta('upiId');
  @override
  late final GeneratedColumn<String> upiId = GeneratedColumn<String>(
      'upi_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upiPayeeNameMeta =
      const VerificationMeta('upiPayeeName');
  @override
  late final GeneratedColumn<String> upiPayeeName = GeneratedColumn<String>(
      'upi_payee_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('INR'));
  static const VerificationMeta _invoicePrefixMeta =
      const VerificationMeta('invoicePrefix');
  @override
  late final GeneratedColumn<String> invoicePrefix = GeneratedColumn<String>(
      'invoice_prefix', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('INV'));
  static const VerificationMeta _invoiceFooterMeta =
      const VerificationMeta('invoiceFooter');
  @override
  late final GeneratedColumn<String> invoiceFooter = GeneratedColumn<String>(
      'invoice_footer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _darkMeta = const VerificationMeta('dark');
  @override
  late final GeneratedColumn<bool> dark = GeneratedColumn<bool>(
      'dark', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("dark" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessName,
        tagline,
        logoPath,
        primaryColor,
        secondaryColor,
        address,
        phone,
        email,
        gstin,
        upiId,
        upiPayeeName,
        currencyCode,
        invoicePrefix,
        invoiceFooter,
        dark,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'studio_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<StudioProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_name')) {
      context.handle(
          _businessNameMeta,
          businessName.isAcceptableOrUnknown(
              data['business_name']!, _businessNameMeta));
    } else if (isInserting) {
      context.missing(_businessNameMeta);
    }
    if (data.containsKey('tagline')) {
      context.handle(_taglineMeta,
          tagline.isAcceptableOrUnknown(data['tagline']!, _taglineMeta));
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    if (data.containsKey('primary_color')) {
      context.handle(
          _primaryColorMeta,
          primaryColor.isAcceptableOrUnknown(
              data['primary_color']!, _primaryColorMeta));
    } else if (isInserting) {
      context.missing(_primaryColorMeta);
    }
    if (data.containsKey('secondary_color')) {
      context.handle(
          _secondaryColorMeta,
          secondaryColor.isAcceptableOrUnknown(
              data['secondary_color']!, _secondaryColorMeta));
    } else if (isInserting) {
      context.missing(_secondaryColorMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('gstin')) {
      context.handle(
          _gstinMeta, gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta));
    }
    if (data.containsKey('upi_id')) {
      context.handle(
          _upiIdMeta, upiId.isAcceptableOrUnknown(data['upi_id']!, _upiIdMeta));
    }
    if (data.containsKey('upi_payee_name')) {
      context.handle(
          _upiPayeeNameMeta,
          upiPayeeName.isAcceptableOrUnknown(
              data['upi_payee_name']!, _upiPayeeNameMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    if (data.containsKey('invoice_prefix')) {
      context.handle(
          _invoicePrefixMeta,
          invoicePrefix.isAcceptableOrUnknown(
              data['invoice_prefix']!, _invoicePrefixMeta));
    }
    if (data.containsKey('invoice_footer')) {
      context.handle(
          _invoiceFooterMeta,
          invoiceFooter.isAcceptableOrUnknown(
              data['invoice_footer']!, _invoiceFooterMeta));
    }
    if (data.containsKey('dark')) {
      context.handle(
          _darkMeta, dark.isAcceptableOrUnknown(data['dark']!, _darkMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudioProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudioProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      businessName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_name'])!,
      tagline: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tagline']),
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
      primaryColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}primary_color'])!,
      secondaryColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}secondary_color'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      gstin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gstin']),
      upiId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}upi_id']),
      upiPayeeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}upi_payee_name']),
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      invoicePrefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_prefix'])!,
      invoiceFooter: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_footer']),
      dark: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}dark'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $StudioProfilesTable createAlias(String alias) {
    return $StudioProfilesTable(attachedDatabase, alias);
  }
}

class StudioProfile extends DataClass implements Insertable<StudioProfile> {
  final int id;
  final String businessName;
  final String? tagline;
  final String? logoPath;
  final int primaryColor;
  final int secondaryColor;
  final String address;
  final String phone;
  final String? email;
  final String? gstin;
  final String? upiId;
  final String? upiPayeeName;
  final String currencyCode;
  final String invoicePrefix;
  final String? invoiceFooter;

  /// Dark design system flag (Task 5.1) — the D POISE preset is dark
  /// (black & gold); other studios keep the light system by default.
  final bool dark;
  final DateTime createdAt;
  final DateTime updatedAt;
  const StudioProfile(
      {required this.id,
      required this.businessName,
      this.tagline,
      this.logoPath,
      required this.primaryColor,
      required this.secondaryColor,
      required this.address,
      required this.phone,
      this.email,
      this.gstin,
      this.upiId,
      this.upiPayeeName,
      required this.currencyCode,
      required this.invoicePrefix,
      this.invoiceFooter,
      required this.dark,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_name'] = Variable<String>(businessName);
    if (!nullToAbsent || tagline != null) {
      map['tagline'] = Variable<String>(tagline);
    }
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['primary_color'] = Variable<int>(primaryColor);
    map['secondary_color'] = Variable<int>(secondaryColor);
    map['address'] = Variable<String>(address);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || upiId != null) {
      map['upi_id'] = Variable<String>(upiId);
    }
    if (!nullToAbsent || upiPayeeName != null) {
      map['upi_payee_name'] = Variable<String>(upiPayeeName);
    }
    map['currency_code'] = Variable<String>(currencyCode);
    map['invoice_prefix'] = Variable<String>(invoicePrefix);
    if (!nullToAbsent || invoiceFooter != null) {
      map['invoice_footer'] = Variable<String>(invoiceFooter);
    }
    map['dark'] = Variable<bool>(dark);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StudioProfilesCompanion toCompanion(bool nullToAbsent) {
    return StudioProfilesCompanion(
      id: Value(id),
      businessName: Value(businessName),
      tagline: tagline == null && nullToAbsent
          ? const Value.absent()
          : Value(tagline),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      primaryColor: Value(primaryColor),
      secondaryColor: Value(secondaryColor),
      address: Value(address),
      phone: Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      gstin:
          gstin == null && nullToAbsent ? const Value.absent() : Value(gstin),
      upiId:
          upiId == null && nullToAbsent ? const Value.absent() : Value(upiId),
      upiPayeeName: upiPayeeName == null && nullToAbsent
          ? const Value.absent()
          : Value(upiPayeeName),
      currencyCode: Value(currencyCode),
      invoicePrefix: Value(invoicePrefix),
      invoiceFooter: invoiceFooter == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceFooter),
      dark: Value(dark),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StudioProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudioProfile(
      id: serializer.fromJson<int>(json['id']),
      businessName: serializer.fromJson<String>(json['businessName']),
      tagline: serializer.fromJson<String?>(json['tagline']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      primaryColor: serializer.fromJson<int>(json['primaryColor']),
      secondaryColor: serializer.fromJson<int>(json['secondaryColor']),
      address: serializer.fromJson<String>(json['address']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      upiId: serializer.fromJson<String?>(json['upiId']),
      upiPayeeName: serializer.fromJson<String?>(json['upiPayeeName']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      invoicePrefix: serializer.fromJson<String>(json['invoicePrefix']),
      invoiceFooter: serializer.fromJson<String?>(json['invoiceFooter']),
      dark: serializer.fromJson<bool>(json['dark']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessName': serializer.toJson<String>(businessName),
      'tagline': serializer.toJson<String?>(tagline),
      'logoPath': serializer.toJson<String?>(logoPath),
      'primaryColor': serializer.toJson<int>(primaryColor),
      'secondaryColor': serializer.toJson<int>(secondaryColor),
      'address': serializer.toJson<String>(address),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String?>(email),
      'gstin': serializer.toJson<String?>(gstin),
      'upiId': serializer.toJson<String?>(upiId),
      'upiPayeeName': serializer.toJson<String?>(upiPayeeName),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'invoicePrefix': serializer.toJson<String>(invoicePrefix),
      'invoiceFooter': serializer.toJson<String?>(invoiceFooter),
      'dark': serializer.toJson<bool>(dark),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StudioProfile copyWith(
          {int? id,
          String? businessName,
          Value<String?> tagline = const Value.absent(),
          Value<String?> logoPath = const Value.absent(),
          int? primaryColor,
          int? secondaryColor,
          String? address,
          String? phone,
          Value<String?> email = const Value.absent(),
          Value<String?> gstin = const Value.absent(),
          Value<String?> upiId = const Value.absent(),
          Value<String?> upiPayeeName = const Value.absent(),
          String? currencyCode,
          String? invoicePrefix,
          Value<String?> invoiceFooter = const Value.absent(),
          bool? dark,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      StudioProfile(
        id: id ?? this.id,
        businessName: businessName ?? this.businessName,
        tagline: tagline.present ? tagline.value : this.tagline,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        email: email.present ? email.value : this.email,
        gstin: gstin.present ? gstin.value : this.gstin,
        upiId: upiId.present ? upiId.value : this.upiId,
        upiPayeeName:
            upiPayeeName.present ? upiPayeeName.value : this.upiPayeeName,
        currencyCode: currencyCode ?? this.currencyCode,
        invoicePrefix: invoicePrefix ?? this.invoicePrefix,
        invoiceFooter:
            invoiceFooter.present ? invoiceFooter.value : this.invoiceFooter,
        dark: dark ?? this.dark,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  StudioProfile copyWithCompanion(StudioProfilesCompanion data) {
    return StudioProfile(
      id: data.id.present ? data.id.value : this.id,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      tagline: data.tagline.present ? data.tagline.value : this.tagline,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      primaryColor: data.primaryColor.present
          ? data.primaryColor.value
          : this.primaryColor,
      secondaryColor: data.secondaryColor.present
          ? data.secondaryColor.value
          : this.secondaryColor,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      upiId: data.upiId.present ? data.upiId.value : this.upiId,
      upiPayeeName: data.upiPayeeName.present
          ? data.upiPayeeName.value
          : this.upiPayeeName,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      invoicePrefix: data.invoicePrefix.present
          ? data.invoicePrefix.value
          : this.invoicePrefix,
      invoiceFooter: data.invoiceFooter.present
          ? data.invoiceFooter.value
          : this.invoiceFooter,
      dark: data.dark.present ? data.dark.value : this.dark,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudioProfile(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('tagline: $tagline, ')
          ..write('logoPath: $logoPath, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('secondaryColor: $secondaryColor, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('gstin: $gstin, ')
          ..write('upiId: $upiId, ')
          ..write('upiPayeeName: $upiPayeeName, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('invoiceFooter: $invoiceFooter, ')
          ..write('dark: $dark, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      businessName,
      tagline,
      logoPath,
      primaryColor,
      secondaryColor,
      address,
      phone,
      email,
      gstin,
      upiId,
      upiPayeeName,
      currencyCode,
      invoicePrefix,
      invoiceFooter,
      dark,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudioProfile &&
          other.id == this.id &&
          other.businessName == this.businessName &&
          other.tagline == this.tagline &&
          other.logoPath == this.logoPath &&
          other.primaryColor == this.primaryColor &&
          other.secondaryColor == this.secondaryColor &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.gstin == this.gstin &&
          other.upiId == this.upiId &&
          other.upiPayeeName == this.upiPayeeName &&
          other.currencyCode == this.currencyCode &&
          other.invoicePrefix == this.invoicePrefix &&
          other.invoiceFooter == this.invoiceFooter &&
          other.dark == this.dark &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StudioProfilesCompanion extends UpdateCompanion<StudioProfile> {
  final Value<int> id;
  final Value<String> businessName;
  final Value<String?> tagline;
  final Value<String?> logoPath;
  final Value<int> primaryColor;
  final Value<int> secondaryColor;
  final Value<String> address;
  final Value<String> phone;
  final Value<String?> email;
  final Value<String?> gstin;
  final Value<String?> upiId;
  final Value<String?> upiPayeeName;
  final Value<String> currencyCode;
  final Value<String> invoicePrefix;
  final Value<String?> invoiceFooter;
  final Value<bool> dark;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const StudioProfilesCompanion({
    this.id = const Value.absent(),
    this.businessName = const Value.absent(),
    this.tagline = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.primaryColor = const Value.absent(),
    this.secondaryColor = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.gstin = const Value.absent(),
    this.upiId = const Value.absent(),
    this.upiPayeeName = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.invoiceFooter = const Value.absent(),
    this.dark = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StudioProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String businessName,
    this.tagline = const Value.absent(),
    this.logoPath = const Value.absent(),
    required int primaryColor,
    required int secondaryColor,
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.gstin = const Value.absent(),
    this.upiId = const Value.absent(),
    this.upiPayeeName = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.invoiceFooter = const Value.absent(),
    this.dark = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : businessName = Value(businessName),
        primaryColor = Value(primaryColor),
        secondaryColor = Value(secondaryColor),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<StudioProfile> custom({
    Expression<int>? id,
    Expression<String>? businessName,
    Expression<String>? tagline,
    Expression<String>? logoPath,
    Expression<int>? primaryColor,
    Expression<int>? secondaryColor,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? gstin,
    Expression<String>? upiId,
    Expression<String>? upiPayeeName,
    Expression<String>? currencyCode,
    Expression<String>? invoicePrefix,
    Expression<String>? invoiceFooter,
    Expression<bool>? dark,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessName != null) 'business_name': businessName,
      if (tagline != null) 'tagline': tagline,
      if (logoPath != null) 'logo_path': logoPath,
      if (primaryColor != null) 'primary_color': primaryColor,
      if (secondaryColor != null) 'secondary_color': secondaryColor,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (gstin != null) 'gstin': gstin,
      if (upiId != null) 'upi_id': upiId,
      if (upiPayeeName != null) 'upi_payee_name': upiPayeeName,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (invoicePrefix != null) 'invoice_prefix': invoicePrefix,
      if (invoiceFooter != null) 'invoice_footer': invoiceFooter,
      if (dark != null) 'dark': dark,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StudioProfilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? businessName,
      Value<String?>? tagline,
      Value<String?>? logoPath,
      Value<int>? primaryColor,
      Value<int>? secondaryColor,
      Value<String>? address,
      Value<String>? phone,
      Value<String?>? email,
      Value<String?>? gstin,
      Value<String?>? upiId,
      Value<String?>? upiPayeeName,
      Value<String>? currencyCode,
      Value<String>? invoicePrefix,
      Value<String?>? invoiceFooter,
      Value<bool>? dark,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return StudioProfilesCompanion(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      tagline: tagline ?? this.tagline,
      logoPath: logoPath ?? this.logoPath,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gstin: gstin ?? this.gstin,
      upiId: upiId ?? this.upiId,
      upiPayeeName: upiPayeeName ?? this.upiPayeeName,
      currencyCode: currencyCode ?? this.currencyCode,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      invoiceFooter: invoiceFooter ?? this.invoiceFooter,
      dark: dark ?? this.dark,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (tagline.present) {
      map['tagline'] = Variable<String>(tagline.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (primaryColor.present) {
      map['primary_color'] = Variable<int>(primaryColor.value);
    }
    if (secondaryColor.present) {
      map['secondary_color'] = Variable<int>(secondaryColor.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (upiId.present) {
      map['upi_id'] = Variable<String>(upiId.value);
    }
    if (upiPayeeName.present) {
      map['upi_payee_name'] = Variable<String>(upiPayeeName.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (invoicePrefix.present) {
      map['invoice_prefix'] = Variable<String>(invoicePrefix.value);
    }
    if (invoiceFooter.present) {
      map['invoice_footer'] = Variable<String>(invoiceFooter.value);
    }
    if (dark.present) {
      map['dark'] = Variable<bool>(dark.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudioProfilesCompanion(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('tagline: $tagline, ')
          ..write('logoPath: $logoPath, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('secondaryColor: $secondaryColor, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('gstin: $gstin, ')
          ..write('upiId: $upiId, ')
          ..write('upiPayeeName: $upiPayeeName, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('invoiceFooter: $invoiceFooter, ')
          ..write('dark: $dark, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ServiceCategoriesTable extends ServiceCategories
    with TableInfo<$ServiceCategoriesTable, ServiceCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ServiceCategoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceCategoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ServiceCategoriesTable createAlias(String alias) {
    return $ServiceCategoriesTable(attachedDatabase, alias);
  }
}

class ServiceCategoryRow extends DataClass
    implements Insertable<ServiceCategoryRow> {
  final String id;
  final String name;
  final int sortOrder;
  final bool isActive;
  const ServiceCategoryRow(
      {required this.id,
      required this.name,
      required this.sortOrder,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ServiceCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ServiceCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory ServiceCategoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceCategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ServiceCategoryRow copyWith(
          {String? id, String? name, int? sortOrder, bool? isActive}) =>
      ServiceCategoryRow(
        id: id ?? this.id,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
      );
  ServiceCategoryRow copyWithCompanion(ServiceCategoriesCompanion data) {
    return ServiceCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceCategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class ServiceCategoriesCompanion extends UpdateCompanion<ServiceCategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ServiceCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceCategoriesCompanion.insert({
    required String id,
    required String name,
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<ServiceCategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? sortOrder,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return ServiceCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServicesTable extends Services with TableInfo<$ServicesTable, Service> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES service_categories (id) ON DELETE RESTRICT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pricePaiseMeta =
      const VerificationMeta('pricePaise');
  @override
  late final GeneratedColumn<int> pricePaise = GeneratedColumn<int>(
      'price_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isExtraMeta =
      const VerificationMeta('isExtra');
  @override
  late final GeneratedColumn<bool> isExtra = GeneratedColumn<bool>(
      'is_extra', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_extra" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        categoryId,
        name,
        description,
        pricePaise,
        durationMinutes,
        isExtra,
        isActive,
        sortOrder,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(Insertable<Service> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('price_paise')) {
      context.handle(
          _pricePaiseMeta,
          pricePaise.isAcceptableOrUnknown(
              data['price_paise']!, _pricePaiseMeta));
    } else if (isInserting) {
      context.missing(_pricePaiseMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    if (data.containsKey('is_extra')) {
      context.handle(_isExtraMeta,
          isExtra.isAcceptableOrUnknown(data['is_extra']!, _isExtraMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Service map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Service(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      pricePaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price_paise'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes'])!,
      isExtra: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_extra'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }
}

class Service extends DataClass implements Insertable<Service> {
  final String id;
  final String categoryId;
  final String name;
  final String? description;
  final int pricePaise;
  final int durationMinutes;
  final bool isExtra;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Service(
      {required this.id,
      required this.categoryId,
      required this.name,
      this.description,
      required this.pricePaise,
      required this.durationMinutes,
      required this.isExtra,
      required this.isActive,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['price_paise'] = Variable<int>(pricePaise);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['is_extra'] = Variable<bool>(isExtra);
    map['is_active'] = Variable<bool>(isActive);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      pricePaise: Value(pricePaise),
      durationMinutes: Value(durationMinutes),
      isExtra: Value(isExtra),
      isActive: Value(isActive),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Service.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Service(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      pricePaise: serializer.fromJson<int>(json['pricePaise']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      isExtra: serializer.fromJson<bool>(json['isExtra']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'pricePaise': serializer.toJson<int>(pricePaise),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'isExtra': serializer.toJson<bool>(isExtra),
      'isActive': serializer.toJson<bool>(isActive),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Service copyWith(
          {String? id,
          String? categoryId,
          String? name,
          Value<String?> description = const Value.absent(),
          int? pricePaise,
          int? durationMinutes,
          bool? isExtra,
          bool? isActive,
          int? sortOrder,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Service(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        pricePaise: pricePaise ?? this.pricePaise,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        isExtra: isExtra ?? this.isExtra,
        isActive: isActive ?? this.isActive,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Service copyWithCompanion(ServicesCompanion data) {
    return Service(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      pricePaise:
          data.pricePaise.present ? data.pricePaise.value : this.pricePaise,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      isExtra: data.isExtra.present ? data.isExtra.value : this.isExtra,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Service(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('pricePaise: $pricePaise, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('isExtra: $isExtra, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, name, description, pricePaise,
      durationMinutes, isExtra, isActive, sortOrder, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Service &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.description == this.description &&
          other.pricePaise == this.pricePaise &&
          other.durationMinutes == this.durationMinutes &&
          other.isExtra == this.isExtra &&
          other.isActive == this.isActive &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ServicesCompanion extends UpdateCompanion<Service> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> pricePaise;
  final Value<int> durationMinutes;
  final Value<bool> isExtra;
  final Value<bool> isActive;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.pricePaise = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.isExtra = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServicesCompanion.insert({
    required String id,
    required String categoryId,
    required String name,
    this.description = const Value.absent(),
    required int pricePaise,
    this.durationMinutes = const Value.absent(),
    this.isExtra = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        categoryId = Value(categoryId),
        name = Value(name),
        pricePaise = Value(pricePaise),
        updatedAt = Value(updatedAt);
  static Insertable<Service> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? pricePaise,
    Expression<int>? durationMinutes,
    Expression<bool>? isExtra,
    Expression<bool>? isActive,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (pricePaise != null) 'price_paise': pricePaise,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (isExtra != null) 'is_extra': isExtra,
      if (isActive != null) 'is_active': isActive,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServicesCompanion copyWith(
      {Value<String>? id,
      Value<String>? categoryId,
      Value<String>? name,
      Value<String?>? description,
      Value<int>? pricePaise,
      Value<int>? durationMinutes,
      Value<bool>? isExtra,
      Value<bool>? isActive,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ServicesCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      pricePaise: pricePaise ?? this.pricePaise,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isExtra: isExtra ?? this.isExtra,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (pricePaise.present) {
      map['price_paise'] = Variable<int>(pricePaise.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (isExtra.present) {
      map['is_extra'] = Variable<bool>(isExtra.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('pricePaise: $pricePaise, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('isExtra: $isExtra, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, EmployeeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _salaryTypeMeta =
      const VerificationMeta('salaryType');
  @override
  late final GeneratedColumn<String> salaryType = GeneratedColumn<String>(
      'salary_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('monthly'));
  static const VerificationMeta _monthlySalaryPaiseMeta =
      const VerificationMeta('monthlySalaryPaise');
  @override
  late final GeneratedColumn<int> monthlySalaryPaise = GeneratedColumn<int>(
      'monthly_salary_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _joiningDateMeta =
      const VerificationMeta('joiningDate');
  @override
  late final GeneratedColumn<DateTime> joiningDate = GeneratedColumn<DateTime>(
      'joining_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        role,
        phone,
        salaryType,
        monthlySalaryPaise,
        isActive,
        joiningDate,
        photoPath,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(Insertable<EmployeeRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('salary_type')) {
      context.handle(
          _salaryTypeMeta,
          salaryType.isAcceptableOrUnknown(
              data['salary_type']!, _salaryTypeMeta));
    }
    if (data.containsKey('monthly_salary_paise')) {
      context.handle(
          _monthlySalaryPaiseMeta,
          monthlySalaryPaise.isAcceptableOrUnknown(
              data['monthly_salary_paise']!, _monthlySalaryPaiseMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('joining_date')) {
      context.handle(
          _joiningDateMeta,
          joiningDate.isAcceptableOrUnknown(
              data['joining_date']!, _joiningDateMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      salaryType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salary_type'])!,
      monthlySalaryPaise: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}monthly_salary_paise'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      joiningDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}joining_date']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class EmployeeRow extends DataClass implements Insertable<EmployeeRow> {
  final String id;
  final String name;
  final String role;
  final String phone;
  final String salaryType;
  final int monthlySalaryPaise;
  final bool isActive;
  final DateTime? joiningDate;
  final String? photoPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const EmployeeRow(
      {required this.id,
      required this.name,
      required this.role,
      required this.phone,
      required this.salaryType,
      required this.monthlySalaryPaise,
      required this.isActive,
      this.joiningDate,
      this.photoPath,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    map['phone'] = Variable<String>(phone);
    map['salary_type'] = Variable<String>(salaryType);
    map['monthly_salary_paise'] = Variable<int>(monthlySalaryPaise);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || joiningDate != null) {
      map['joining_date'] = Variable<DateTime>(joiningDate);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      name: Value(name),
      role: Value(role),
      phone: Value(phone),
      salaryType: Value(salaryType),
      monthlySalaryPaise: Value(monthlySalaryPaise),
      isActive: Value(isActive),
      joiningDate: joiningDate == null && nullToAbsent
          ? const Value.absent()
          : Value(joiningDate),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory EmployeeRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      phone: serializer.fromJson<String>(json['phone']),
      salaryType: serializer.fromJson<String>(json['salaryType']),
      monthlySalaryPaise: serializer.fromJson<int>(json['monthlySalaryPaise']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      joiningDate: serializer.fromJson<DateTime?>(json['joiningDate']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'phone': serializer.toJson<String>(phone),
      'salaryType': serializer.toJson<String>(salaryType),
      'monthlySalaryPaise': serializer.toJson<int>(monthlySalaryPaise),
      'isActive': serializer.toJson<bool>(isActive),
      'joiningDate': serializer.toJson<DateTime?>(joiningDate),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  EmployeeRow copyWith(
          {String? id,
          String? name,
          String? role,
          String? phone,
          String? salaryType,
          int? monthlySalaryPaise,
          bool? isActive,
          Value<DateTime?> joiningDate = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      EmployeeRow(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        phone: phone ?? this.phone,
        salaryType: salaryType ?? this.salaryType,
        monthlySalaryPaise: monthlySalaryPaise ?? this.monthlySalaryPaise,
        isActive: isActive ?? this.isActive,
        joiningDate: joiningDate.present ? joiningDate.value : this.joiningDate,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  EmployeeRow copyWithCompanion(EmployeesCompanion data) {
    return EmployeeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      phone: data.phone.present ? data.phone.value : this.phone,
      salaryType:
          data.salaryType.present ? data.salaryType.value : this.salaryType,
      monthlySalaryPaise: data.monthlySalaryPaise.present
          ? data.monthlySalaryPaise.value
          : this.monthlySalaryPaise,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      joiningDate:
          data.joiningDate.present ? data.joiningDate.value : this.joiningDate,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('salaryType: $salaryType, ')
          ..write('monthlySalaryPaise: $monthlySalaryPaise, ')
          ..write('isActive: $isActive, ')
          ..write('joiningDate: $joiningDate, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      role,
      phone,
      salaryType,
      monthlySalaryPaise,
      isActive,
      joiningDate,
      photoPath,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.phone == this.phone &&
          other.salaryType == this.salaryType &&
          other.monthlySalaryPaise == this.monthlySalaryPaise &&
          other.isActive == this.isActive &&
          other.joiningDate == this.joiningDate &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmployeesCompanion extends UpdateCompanion<EmployeeRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> role;
  final Value<String> phone;
  final Value<String> salaryType;
  final Value<int> monthlySalaryPaise;
  final Value<bool> isActive;
  final Value<DateTime?> joiningDate;
  final Value<String?> photoPath;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.salaryType = const Value.absent(),
    this.monthlySalaryPaise = const Value.absent(),
    this.isActive = const Value.absent(),
    this.joiningDate = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeesCompanion.insert({
    required String id,
    required String name,
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.salaryType = const Value.absent(),
    this.monthlySalaryPaise = const Value.absent(),
    this.isActive = const Value.absent(),
    this.joiningDate = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<EmployeeRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? phone,
    Expression<String>? salaryType,
    Expression<int>? monthlySalaryPaise,
    Expression<bool>? isActive,
    Expression<DateTime>? joiningDate,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone,
      if (salaryType != null) 'salary_type': salaryType,
      if (monthlySalaryPaise != null)
        'monthly_salary_paise': monthlySalaryPaise,
      if (isActive != null) 'is_active': isActive,
      if (joiningDate != null) 'joining_date': joiningDate,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? role,
      Value<String>? phone,
      Value<String>? salaryType,
      Value<int>? monthlySalaryPaise,
      Value<bool>? isActive,
      Value<DateTime?>? joiningDate,
      Value<String?>? photoPath,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return EmployeesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      salaryType: salaryType ?? this.salaryType,
      monthlySalaryPaise: monthlySalaryPaise ?? this.monthlySalaryPaise,
      isActive: isActive ?? this.isActive,
      joiningDate: joiningDate ?? this.joiningDate,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (salaryType.present) {
      map['salary_type'] = Variable<String>(salaryType.value);
    }
    if (monthlySalaryPaise.present) {
      map['monthly_salary_paise'] = Variable<int>(monthlySalaryPaise.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (joiningDate.present) {
      map['joining_date'] = Variable<DateTime>(joiningDate.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('salaryType: $salaryType, ')
          ..write('monthlySalaryPaise: $monthlySalaryPaise, ')
          ..write('isActive: $isActive, ')
          ..write('joiningDate: $joiningDate, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillDraftsTable extends BillDrafts
    with TableInfo<$BillDraftsTable, BillDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _draftIdMeta =
      const VerificationMeta('draftId');
  @override
  late final GeneratedColumn<String> draftId = GeneratedColumn<String>(
      'draft_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _billingEmployeeIdMeta =
      const VerificationMeta('billingEmployeeId');
  @override
  late final GeneratedColumn<String> billingEmployeeId =
      GeneratedColumn<String>('billing_employee_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billingEmployeeNameMeta =
      const VerificationMeta('billingEmployeeName');
  @override
  late final GeneratedColumn<String> billingEmployeeName =
      GeneratedColumn<String>('billing_employee_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _customerPhoneMeta =
      const VerificationMeta('customerPhone');
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
      'customer_phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _customerNotesMeta =
      const VerificationMeta('customerNotes');
  @override
  late final GeneratedColumn<String> customerNotes = GeneratedColumn<String>(
      'customer_notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _discountPercentMeta =
      const VerificationMeta('discountPercent');
  @override
  late final GeneratedColumn<int> discountPercent = GeneratedColumn<int>(
      'discount_percent', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discountFlatPaiseMeta =
      const VerificationMeta('discountFlatPaise');
  @override
  late final GeneratedColumn<int> discountFlatPaise = GeneratedColumn<int>(
      'discount_flat_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxBasisPointsMeta =
      const VerificationMeta('taxBasisPoints');
  @override
  late final GeneratedColumn<int> taxBasisPoints = GeneratedColumn<int>(
      'tax_basis_points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        draftId,
        billingEmployeeId,
        billingEmployeeName,
        customerName,
        customerPhone,
        customerNotes,
        discountPercent,
        discountFlatPaise,
        taxBasisPoints,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_drafts';
  @override
  VerificationContext validateIntegrity(Insertable<BillDraft> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('draft_id')) {
      context.handle(_draftIdMeta,
          draftId.isAcceptableOrUnknown(data['draft_id']!, _draftIdMeta));
    } else if (isInserting) {
      context.missing(_draftIdMeta);
    }
    if (data.containsKey('billing_employee_id')) {
      context.handle(
          _billingEmployeeIdMeta,
          billingEmployeeId.isAcceptableOrUnknown(
              data['billing_employee_id']!, _billingEmployeeIdMeta));
    }
    if (data.containsKey('billing_employee_name')) {
      context.handle(
          _billingEmployeeNameMeta,
          billingEmployeeName.isAcceptableOrUnknown(
              data['billing_employee_name']!, _billingEmployeeNameMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
          _customerPhoneMeta,
          customerPhone.isAcceptableOrUnknown(
              data['customer_phone']!, _customerPhoneMeta));
    }
    if (data.containsKey('customer_notes')) {
      context.handle(
          _customerNotesMeta,
          customerNotes.isAcceptableOrUnknown(
              data['customer_notes']!, _customerNotesMeta));
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
          _discountPercentMeta,
          discountPercent.isAcceptableOrUnknown(
              data['discount_percent']!, _discountPercentMeta));
    }
    if (data.containsKey('discount_flat_paise')) {
      context.handle(
          _discountFlatPaiseMeta,
          discountFlatPaise.isAcceptableOrUnknown(
              data['discount_flat_paise']!, _discountFlatPaiseMeta));
    }
    if (data.containsKey('tax_basis_points')) {
      context.handle(
          _taxBasisPointsMeta,
          taxBasisPoints.isAcceptableOrUnknown(
              data['tax_basis_points']!, _taxBasisPointsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {draftId};
  @override
  BillDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillDraft(
      draftId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}draft_id'])!,
      billingEmployeeId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}billing_employee_id']),
      billingEmployeeName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}billing_employee_name']),
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone'])!,
      customerNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_notes'])!,
      discountPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_percent'])!,
      discountFlatPaise: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}discount_flat_paise'])!,
      taxBasisPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_basis_points'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BillDraftsTable createAlias(String alias) {
    return $BillDraftsTable(attachedDatabase, alias);
  }
}

class BillDraft extends DataClass implements Insertable<BillDraft> {
  final String draftId;
  final String? billingEmployeeId;
  final String? billingEmployeeName;
  final String customerName;
  final String customerPhone;
  final String customerNotes;
  final int discountPercent;
  final int discountFlatPaise;
  final int taxBasisPoints;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BillDraft(
      {required this.draftId,
      this.billingEmployeeId,
      this.billingEmployeeName,
      required this.customerName,
      required this.customerPhone,
      required this.customerNotes,
      required this.discountPercent,
      required this.discountFlatPaise,
      required this.taxBasisPoints,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['draft_id'] = Variable<String>(draftId);
    if (!nullToAbsent || billingEmployeeId != null) {
      map['billing_employee_id'] = Variable<String>(billingEmployeeId);
    }
    if (!nullToAbsent || billingEmployeeName != null) {
      map['billing_employee_name'] = Variable<String>(billingEmployeeName);
    }
    map['customer_name'] = Variable<String>(customerName);
    map['customer_phone'] = Variable<String>(customerPhone);
    map['customer_notes'] = Variable<String>(customerNotes);
    map['discount_percent'] = Variable<int>(discountPercent);
    map['discount_flat_paise'] = Variable<int>(discountFlatPaise);
    map['tax_basis_points'] = Variable<int>(taxBasisPoints);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BillDraftsCompanion toCompanion(bool nullToAbsent) {
    return BillDraftsCompanion(
      draftId: Value(draftId),
      billingEmployeeId: billingEmployeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(billingEmployeeId),
      billingEmployeeName: billingEmployeeName == null && nullToAbsent
          ? const Value.absent()
          : Value(billingEmployeeName),
      customerName: Value(customerName),
      customerPhone: Value(customerPhone),
      customerNotes: Value(customerNotes),
      discountPercent: Value(discountPercent),
      discountFlatPaise: Value(discountFlatPaise),
      taxBasisPoints: Value(taxBasisPoints),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BillDraft.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillDraft(
      draftId: serializer.fromJson<String>(json['draftId']),
      billingEmployeeId:
          serializer.fromJson<String?>(json['billingEmployeeId']),
      billingEmployeeName:
          serializer.fromJson<String?>(json['billingEmployeeName']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String>(json['customerPhone']),
      customerNotes: serializer.fromJson<String>(json['customerNotes']),
      discountPercent: serializer.fromJson<int>(json['discountPercent']),
      discountFlatPaise: serializer.fromJson<int>(json['discountFlatPaise']),
      taxBasisPoints: serializer.fromJson<int>(json['taxBasisPoints']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'draftId': serializer.toJson<String>(draftId),
      'billingEmployeeId': serializer.toJson<String?>(billingEmployeeId),
      'billingEmployeeName': serializer.toJson<String?>(billingEmployeeName),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String>(customerPhone),
      'customerNotes': serializer.toJson<String>(customerNotes),
      'discountPercent': serializer.toJson<int>(discountPercent),
      'discountFlatPaise': serializer.toJson<int>(discountFlatPaise),
      'taxBasisPoints': serializer.toJson<int>(taxBasisPoints),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BillDraft copyWith(
          {String? draftId,
          Value<String?> billingEmployeeId = const Value.absent(),
          Value<String?> billingEmployeeName = const Value.absent(),
          String? customerName,
          String? customerPhone,
          String? customerNotes,
          int? discountPercent,
          int? discountFlatPaise,
          int? taxBasisPoints,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      BillDraft(
        draftId: draftId ?? this.draftId,
        billingEmployeeId: billingEmployeeId.present
            ? billingEmployeeId.value
            : this.billingEmployeeId,
        billingEmployeeName: billingEmployeeName.present
            ? billingEmployeeName.value
            : this.billingEmployeeName,
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        customerNotes: customerNotes ?? this.customerNotes,
        discountPercent: discountPercent ?? this.discountPercent,
        discountFlatPaise: discountFlatPaise ?? this.discountFlatPaise,
        taxBasisPoints: taxBasisPoints ?? this.taxBasisPoints,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BillDraft copyWithCompanion(BillDraftsCompanion data) {
    return BillDraft(
      draftId: data.draftId.present ? data.draftId.value : this.draftId,
      billingEmployeeId: data.billingEmployeeId.present
          ? data.billingEmployeeId.value
          : this.billingEmployeeId,
      billingEmployeeName: data.billingEmployeeName.present
          ? data.billingEmployeeName.value
          : this.billingEmployeeName,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      customerNotes: data.customerNotes.present
          ? data.customerNotes.value
          : this.customerNotes,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
      discountFlatPaise: data.discountFlatPaise.present
          ? data.discountFlatPaise.value
          : this.discountFlatPaise,
      taxBasisPoints: data.taxBasisPoints.present
          ? data.taxBasisPoints.value
          : this.taxBasisPoints,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillDraft(')
          ..write('draftId: $draftId, ')
          ..write('billingEmployeeId: $billingEmployeeId, ')
          ..write('billingEmployeeName: $billingEmployeeName, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerNotes: $customerNotes, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('discountFlatPaise: $discountFlatPaise, ')
          ..write('taxBasisPoints: $taxBasisPoints, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      draftId,
      billingEmployeeId,
      billingEmployeeName,
      customerName,
      customerPhone,
      customerNotes,
      discountPercent,
      discountFlatPaise,
      taxBasisPoints,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillDraft &&
          other.draftId == this.draftId &&
          other.billingEmployeeId == this.billingEmployeeId &&
          other.billingEmployeeName == this.billingEmployeeName &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.customerNotes == this.customerNotes &&
          other.discountPercent == this.discountPercent &&
          other.discountFlatPaise == this.discountFlatPaise &&
          other.taxBasisPoints == this.taxBasisPoints &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BillDraftsCompanion extends UpdateCompanion<BillDraft> {
  final Value<String> draftId;
  final Value<String?> billingEmployeeId;
  final Value<String?> billingEmployeeName;
  final Value<String> customerName;
  final Value<String> customerPhone;
  final Value<String> customerNotes;
  final Value<int> discountPercent;
  final Value<int> discountFlatPaise;
  final Value<int> taxBasisPoints;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BillDraftsCompanion({
    this.draftId = const Value.absent(),
    this.billingEmployeeId = const Value.absent(),
    this.billingEmployeeName = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.customerNotes = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.discountFlatPaise = const Value.absent(),
    this.taxBasisPoints = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillDraftsCompanion.insert({
    required String draftId,
    this.billingEmployeeId = const Value.absent(),
    this.billingEmployeeName = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.customerNotes = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.discountFlatPaise = const Value.absent(),
    this.taxBasisPoints = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : draftId = Value(draftId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<BillDraft> custom({
    Expression<String>? draftId,
    Expression<String>? billingEmployeeId,
    Expression<String>? billingEmployeeName,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? customerNotes,
    Expression<int>? discountPercent,
    Expression<int>? discountFlatPaise,
    Expression<int>? taxBasisPoints,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (draftId != null) 'draft_id': draftId,
      if (billingEmployeeId != null) 'billing_employee_id': billingEmployeeId,
      if (billingEmployeeName != null)
        'billing_employee_name': billingEmployeeName,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (customerNotes != null) 'customer_notes': customerNotes,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (discountFlatPaise != null) 'discount_flat_paise': discountFlatPaise,
      if (taxBasisPoints != null) 'tax_basis_points': taxBasisPoints,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillDraftsCompanion copyWith(
      {Value<String>? draftId,
      Value<String?>? billingEmployeeId,
      Value<String?>? billingEmployeeName,
      Value<String>? customerName,
      Value<String>? customerPhone,
      Value<String>? customerNotes,
      Value<int>? discountPercent,
      Value<int>? discountFlatPaise,
      Value<int>? taxBasisPoints,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BillDraftsCompanion(
      draftId: draftId ?? this.draftId,
      billingEmployeeId: billingEmployeeId ?? this.billingEmployeeId,
      billingEmployeeName: billingEmployeeName ?? this.billingEmployeeName,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerNotes: customerNotes ?? this.customerNotes,
      discountPercent: discountPercent ?? this.discountPercent,
      discountFlatPaise: discountFlatPaise ?? this.discountFlatPaise,
      taxBasisPoints: taxBasisPoints ?? this.taxBasisPoints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (draftId.present) {
      map['draft_id'] = Variable<String>(draftId.value);
    }
    if (billingEmployeeId.present) {
      map['billing_employee_id'] = Variable<String>(billingEmployeeId.value);
    }
    if (billingEmployeeName.present) {
      map['billing_employee_name'] =
          Variable<String>(billingEmployeeName.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (customerNotes.present) {
      map['customer_notes'] = Variable<String>(customerNotes.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<int>(discountPercent.value);
    }
    if (discountFlatPaise.present) {
      map['discount_flat_paise'] = Variable<int>(discountFlatPaise.value);
    }
    if (taxBasisPoints.present) {
      map['tax_basis_points'] = Variable<int>(taxBasisPoints.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillDraftsCompanion(')
          ..write('draftId: $draftId, ')
          ..write('billingEmployeeId: $billingEmployeeId, ')
          ..write('billingEmployeeName: $billingEmployeeName, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerNotes: $customerNotes, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('discountFlatPaise: $discountFlatPaise, ')
          ..write('taxBasisPoints: $taxBasisPoints, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DraftLinesTable extends DraftLines
    with TableInfo<$DraftLinesTable, DraftLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DraftLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _draftIdMeta =
      const VerificationMeta('draftId');
  @override
  late final GeneratedColumn<String> draftId = GeneratedColumn<String>(
      'draft_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES bill_drafts (draft_id) ON DELETE CASCADE'));
  static const VerificationMeta _serviceIdMeta =
      const VerificationMeta('serviceId');
  @override
  late final GeneratedColumn<String> serviceId = GeneratedColumn<String>(
      'service_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serviceNameMeta =
      const VerificationMeta('serviceName');
  @override
  late final GeneratedColumn<String> serviceName = GeneratedColumn<String>(
      'service_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pricePaiseMeta =
      const VerificationMeta('pricePaise');
  @override
  late final GeneratedColumn<int> pricePaise = GeneratedColumn<int>(
      'price_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _employeeNameMeta =
      const VerificationMeta('employeeName');
  @override
  late final GeneratedColumn<String> employeeName = GeneratedColumn<String>(
      'employee_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        draftId,
        serviceId,
        serviceName,
        pricePaise,
        durationMinutes,
        quantity,
        employeeId,
        employeeName,
        position
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'draft_lines';
  @override
  VerificationContext validateIntegrity(Insertable<DraftLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('draft_id')) {
      context.handle(_draftIdMeta,
          draftId.isAcceptableOrUnknown(data['draft_id']!, _draftIdMeta));
    } else if (isInserting) {
      context.missing(_draftIdMeta);
    }
    if (data.containsKey('service_id')) {
      context.handle(_serviceIdMeta,
          serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta));
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('service_name')) {
      context.handle(
          _serviceNameMeta,
          serviceName.isAcceptableOrUnknown(
              data['service_name']!, _serviceNameMeta));
    } else if (isInserting) {
      context.missing(_serviceNameMeta);
    }
    if (data.containsKey('price_paise')) {
      context.handle(
          _pricePaiseMeta,
          pricePaise.isAcceptableOrUnknown(
              data['price_paise']!, _pricePaiseMeta));
    } else if (isInserting) {
      context.missing(_pricePaiseMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    }
    if (data.containsKey('employee_name')) {
      context.handle(
          _employeeNameMeta,
          employeeName.isAcceptableOrUnknown(
              data['employee_name']!, _employeeNameMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {draftId, serviceId, pricePaise},
      ];
  @override
  DraftLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DraftLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      draftId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}draft_id'])!,
      serviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}service_id'])!,
      serviceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}service_name'])!,
      pricePaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price_paise'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id']),
      employeeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_name']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $DraftLinesTable createAlias(String alias) {
    return $DraftLinesTable(attachedDatabase, alias);
  }
}

class DraftLine extends DataClass implements Insertable<DraftLine> {
  final int id;
  final String draftId;

  /// Plain text, NOT a foreign key: the line must survive catalog edits
  /// and deletions — it carries its own snapshot below.
  final String serviceId;
  final String serviceName;
  final int pricePaise;
  final int durationMinutes;
  final int quantity;
  final String? employeeId;
  final String? employeeName;
  final int position;
  const DraftLine(
      {required this.id,
      required this.draftId,
      required this.serviceId,
      required this.serviceName,
      required this.pricePaise,
      required this.durationMinutes,
      required this.quantity,
      this.employeeId,
      this.employeeName,
      required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['draft_id'] = Variable<String>(draftId);
    map['service_id'] = Variable<String>(serviceId);
    map['service_name'] = Variable<String>(serviceName);
    map['price_paise'] = Variable<int>(pricePaise);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || employeeId != null) {
      map['employee_id'] = Variable<String>(employeeId);
    }
    if (!nullToAbsent || employeeName != null) {
      map['employee_name'] = Variable<String>(employeeName);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  DraftLinesCompanion toCompanion(bool nullToAbsent) {
    return DraftLinesCompanion(
      id: Value(id),
      draftId: Value(draftId),
      serviceId: Value(serviceId),
      serviceName: Value(serviceName),
      pricePaise: Value(pricePaise),
      durationMinutes: Value(durationMinutes),
      quantity: Value(quantity),
      employeeId: employeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeId),
      employeeName: employeeName == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeName),
      position: Value(position),
    );
  }

  factory DraftLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DraftLine(
      id: serializer.fromJson<int>(json['id']),
      draftId: serializer.fromJson<String>(json['draftId']),
      serviceId: serializer.fromJson<String>(json['serviceId']),
      serviceName: serializer.fromJson<String>(json['serviceName']),
      pricePaise: serializer.fromJson<int>(json['pricePaise']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      quantity: serializer.fromJson<int>(json['quantity']),
      employeeId: serializer.fromJson<String?>(json['employeeId']),
      employeeName: serializer.fromJson<String?>(json['employeeName']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'draftId': serializer.toJson<String>(draftId),
      'serviceId': serializer.toJson<String>(serviceId),
      'serviceName': serializer.toJson<String>(serviceName),
      'pricePaise': serializer.toJson<int>(pricePaise),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'quantity': serializer.toJson<int>(quantity),
      'employeeId': serializer.toJson<String?>(employeeId),
      'employeeName': serializer.toJson<String?>(employeeName),
      'position': serializer.toJson<int>(position),
    };
  }

  DraftLine copyWith(
          {int? id,
          String? draftId,
          String? serviceId,
          String? serviceName,
          int? pricePaise,
          int? durationMinutes,
          int? quantity,
          Value<String?> employeeId = const Value.absent(),
          Value<String?> employeeName = const Value.absent(),
          int? position}) =>
      DraftLine(
        id: id ?? this.id,
        draftId: draftId ?? this.draftId,
        serviceId: serviceId ?? this.serviceId,
        serviceName: serviceName ?? this.serviceName,
        pricePaise: pricePaise ?? this.pricePaise,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        quantity: quantity ?? this.quantity,
        employeeId: employeeId.present ? employeeId.value : this.employeeId,
        employeeName:
            employeeName.present ? employeeName.value : this.employeeName,
        position: position ?? this.position,
      );
  DraftLine copyWithCompanion(DraftLinesCompanion data) {
    return DraftLine(
      id: data.id.present ? data.id.value : this.id,
      draftId: data.draftId.present ? data.draftId.value : this.draftId,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      serviceName:
          data.serviceName.present ? data.serviceName.value : this.serviceName,
      pricePaise:
          data.pricePaise.present ? data.pricePaise.value : this.pricePaise,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      employeeName: data.employeeName.present
          ? data.employeeName.value
          : this.employeeName,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DraftLine(')
          ..write('id: $id, ')
          ..write('draftId: $draftId, ')
          ..write('serviceId: $serviceId, ')
          ..write('serviceName: $serviceName, ')
          ..write('pricePaise: $pricePaise, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('quantity: $quantity, ')
          ..write('employeeId: $employeeId, ')
          ..write('employeeName: $employeeName, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      draftId,
      serviceId,
      serviceName,
      pricePaise,
      durationMinutes,
      quantity,
      employeeId,
      employeeName,
      position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DraftLine &&
          other.id == this.id &&
          other.draftId == this.draftId &&
          other.serviceId == this.serviceId &&
          other.serviceName == this.serviceName &&
          other.pricePaise == this.pricePaise &&
          other.durationMinutes == this.durationMinutes &&
          other.quantity == this.quantity &&
          other.employeeId == this.employeeId &&
          other.employeeName == this.employeeName &&
          other.position == this.position);
}

class DraftLinesCompanion extends UpdateCompanion<DraftLine> {
  final Value<int> id;
  final Value<String> draftId;
  final Value<String> serviceId;
  final Value<String> serviceName;
  final Value<int> pricePaise;
  final Value<int> durationMinutes;
  final Value<int> quantity;
  final Value<String?> employeeId;
  final Value<String?> employeeName;
  final Value<int> position;
  const DraftLinesCompanion({
    this.id = const Value.absent(),
    this.draftId = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.serviceName = const Value.absent(),
    this.pricePaise = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.quantity = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.employeeName = const Value.absent(),
    this.position = const Value.absent(),
  });
  DraftLinesCompanion.insert({
    this.id = const Value.absent(),
    required String draftId,
    required String serviceId,
    required String serviceName,
    required int pricePaise,
    this.durationMinutes = const Value.absent(),
    required int quantity,
    this.employeeId = const Value.absent(),
    this.employeeName = const Value.absent(),
    required int position,
  })  : draftId = Value(draftId),
        serviceId = Value(serviceId),
        serviceName = Value(serviceName),
        pricePaise = Value(pricePaise),
        quantity = Value(quantity),
        position = Value(position);
  static Insertable<DraftLine> custom({
    Expression<int>? id,
    Expression<String>? draftId,
    Expression<String>? serviceId,
    Expression<String>? serviceName,
    Expression<int>? pricePaise,
    Expression<int>? durationMinutes,
    Expression<int>? quantity,
    Expression<String>? employeeId,
    Expression<String>? employeeName,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (draftId != null) 'draft_id': draftId,
      if (serviceId != null) 'service_id': serviceId,
      if (serviceName != null) 'service_name': serviceName,
      if (pricePaise != null) 'price_paise': pricePaise,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (quantity != null) 'quantity': quantity,
      if (employeeId != null) 'employee_id': employeeId,
      if (employeeName != null) 'employee_name': employeeName,
      if (position != null) 'position': position,
    });
  }

  DraftLinesCompanion copyWith(
      {Value<int>? id,
      Value<String>? draftId,
      Value<String>? serviceId,
      Value<String>? serviceName,
      Value<int>? pricePaise,
      Value<int>? durationMinutes,
      Value<int>? quantity,
      Value<String?>? employeeId,
      Value<String?>? employeeName,
      Value<int>? position}) {
    return DraftLinesCompanion(
      id: id ?? this.id,
      draftId: draftId ?? this.draftId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      pricePaise: pricePaise ?? this.pricePaise,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      quantity: quantity ?? this.quantity,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (draftId.present) {
      map['draft_id'] = Variable<String>(draftId.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<String>(serviceId.value);
    }
    if (serviceName.present) {
      map['service_name'] = Variable<String>(serviceName.value);
    }
    if (pricePaise.present) {
      map['price_paise'] = Variable<int>(pricePaise.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (employeeName.present) {
      map['employee_name'] = Variable<String>(employeeName.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DraftLinesCompanion(')
          ..write('id: $id, ')
          ..write('draftId: $draftId, ')
          ..write('serviceId: $serviceId, ')
          ..write('serviceName: $serviceName, ')
          ..write('pricePaise: $pricePaise, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('quantity: $quantity, ')
          ..write('employeeId: $employeeId, ')
          ..write('employeeName: $employeeName, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $BillsTable extends Bills with TableInfo<$BillsTable, BillRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _provisionalRefMeta =
      const VerificationMeta('provisionalRef');
  @override
  late final GeneratedColumn<String> provisionalRef = GeneratedColumn<String>(
      'provisional_ref', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localSeqMeta =
      const VerificationMeta('localSeq');
  @override
  late final GeneratedColumn<int> localSeq = GeneratedColumn<int>(
      'local_seq', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _draftIdMeta =
      const VerificationMeta('draftId');
  @override
  late final GeneratedColumn<String> draftId = GeneratedColumn<String>(
      'draft_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _customerPhoneMeta =
      const VerificationMeta('customerPhone');
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
      'customer_phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _customerNotesMeta =
      const VerificationMeta('customerNotes');
  @override
  late final GeneratedColumn<String> customerNotes = GeneratedColumn<String>(
      'customer_notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _billingEmployeeIdMeta =
      const VerificationMeta('billingEmployeeId');
  @override
  late final GeneratedColumn<String> billingEmployeeId =
      GeneratedColumn<String>('billing_employee_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _billingEmployeeNameMeta =
      const VerificationMeta('billingEmployeeName');
  @override
  late final GeneratedColumn<String> billingEmployeeName =
      GeneratedColumn<String>('billing_employee_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _snapshotBusinessNameMeta =
      const VerificationMeta('snapshotBusinessName');
  @override
  late final GeneratedColumn<String> snapshotBusinessName =
      GeneratedColumn<String>('snapshot_business_name', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _snapshotTaglineMeta =
      const VerificationMeta('snapshotTagline');
  @override
  late final GeneratedColumn<String> snapshotTagline = GeneratedColumn<String>(
      'snapshot_tagline', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _snapshotAddressMeta =
      const VerificationMeta('snapshotAddress');
  @override
  late final GeneratedColumn<String> snapshotAddress = GeneratedColumn<String>(
      'snapshot_address', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _snapshotPhoneMeta =
      const VerificationMeta('snapshotPhone');
  @override
  late final GeneratedColumn<String> snapshotPhone = GeneratedColumn<String>(
      'snapshot_phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _snapshotEmailMeta =
      const VerificationMeta('snapshotEmail');
  @override
  late final GeneratedColumn<String> snapshotEmail = GeneratedColumn<String>(
      'snapshot_email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _snapshotGstinMeta =
      const VerificationMeta('snapshotGstin');
  @override
  late final GeneratedColumn<String> snapshotGstin = GeneratedColumn<String>(
      'snapshot_gstin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _snapshotUpiIdMeta =
      const VerificationMeta('snapshotUpiId');
  @override
  late final GeneratedColumn<String> snapshotUpiId = GeneratedColumn<String>(
      'snapshot_upi_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _snapshotInvoiceFooterMeta =
      const VerificationMeta('snapshotInvoiceFooter');
  @override
  late final GeneratedColumn<String> snapshotInvoiceFooter =
      GeneratedColumn<String>('snapshot_invoice_footer', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _snapshotPrimaryColorMeta =
      const VerificationMeta('snapshotPrimaryColor');
  @override
  late final GeneratedColumn<int> snapshotPrimaryColor = GeneratedColumn<int>(
      'snapshot_primary_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _subtotalPaiseMeta =
      const VerificationMeta('subtotalPaise');
  @override
  late final GeneratedColumn<int> subtotalPaise = GeneratedColumn<int>(
      'subtotal_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountPercentMeta =
      const VerificationMeta('discountPercent');
  @override
  late final GeneratedColumn<int> discountPercent = GeneratedColumn<int>(
      'discount_percent', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountFlatPaiseMeta =
      const VerificationMeta('discountFlatPaise');
  @override
  late final GeneratedColumn<int> discountFlatPaise = GeneratedColumn<int>(
      'discount_flat_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountPaiseMeta =
      const VerificationMeta('discountPaise');
  @override
  late final GeneratedColumn<int> discountPaise = GeneratedColumn<int>(
      'discount_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taxBasisPointsMeta =
      const VerificationMeta('taxBasisPoints');
  @override
  late final GeneratedColumn<int> taxBasisPoints = GeneratedColumn<int>(
      'tax_basis_points', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taxPaiseMeta =
      const VerificationMeta('taxPaise');
  @override
  late final GeneratedColumn<int> taxPaise = GeneratedColumn<int>(
      'tax_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalPaiseMeta =
      const VerificationMeta('totalPaise');
  @override
  late final GeneratedColumn<int> totalPaise = GeneratedColumn<int>(
      'total_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paymentStatusMeta =
      const VerificationMeta('paymentStatus');
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
      'payment_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _finalizedAtMeta =
      const VerificationMeta('finalizedAt');
  @override
  late final GeneratedColumn<DateTime> finalizedAt = GeneratedColumn<DateTime>(
      'finalized_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _voidedAtMeta =
      const VerificationMeta('voidedAt');
  @override
  late final GeneratedColumn<DateTime> voidedAt = GeneratedColumn<DateTime>(
      'voided_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _voidReasonMeta =
      const VerificationMeta('voidReason');
  @override
  late final GeneratedColumn<String> voidReason = GeneratedColumn<String>(
      'void_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _voidedByMeta =
      const VerificationMeta('voidedBy');
  @override
  late final GeneratedColumn<String> voidedBy = GeneratedColumn<String>(
      'voided_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        provisionalRef,
        localSeq,
        draftId,
        customerName,
        customerPhone,
        customerNotes,
        billingEmployeeId,
        billingEmployeeName,
        snapshotBusinessName,
        snapshotTagline,
        snapshotAddress,
        snapshotPhone,
        snapshotEmail,
        snapshotGstin,
        snapshotUpiId,
        snapshotInvoiceFooter,
        snapshotPrimaryColor,
        subtotalPaise,
        discountPercent,
        discountFlatPaise,
        discountPaise,
        taxBasisPoints,
        taxPaise,
        totalPaise,
        status,
        paymentStatus,
        createdAt,
        finalizedAt,
        voidedAt,
        voidReason,
        voidedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bills';
  @override
  VerificationContext validateIntegrity(Insertable<BillRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('provisional_ref')) {
      context.handle(
          _provisionalRefMeta,
          provisionalRef.isAcceptableOrUnknown(
              data['provisional_ref']!, _provisionalRefMeta));
    } else if (isInserting) {
      context.missing(_provisionalRefMeta);
    }
    if (data.containsKey('local_seq')) {
      context.handle(_localSeqMeta,
          localSeq.isAcceptableOrUnknown(data['local_seq']!, _localSeqMeta));
    } else if (isInserting) {
      context.missing(_localSeqMeta);
    }
    if (data.containsKey('draft_id')) {
      context.handle(_draftIdMeta,
          draftId.isAcceptableOrUnknown(data['draft_id']!, _draftIdMeta));
    } else if (isInserting) {
      context.missing(_draftIdMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
          _customerPhoneMeta,
          customerPhone.isAcceptableOrUnknown(
              data['customer_phone']!, _customerPhoneMeta));
    }
    if (data.containsKey('customer_notes')) {
      context.handle(
          _customerNotesMeta,
          customerNotes.isAcceptableOrUnknown(
              data['customer_notes']!, _customerNotesMeta));
    }
    if (data.containsKey('billing_employee_id')) {
      context.handle(
          _billingEmployeeIdMeta,
          billingEmployeeId.isAcceptableOrUnknown(
              data['billing_employee_id']!, _billingEmployeeIdMeta));
    }
    if (data.containsKey('billing_employee_name')) {
      context.handle(
          _billingEmployeeNameMeta,
          billingEmployeeName.isAcceptableOrUnknown(
              data['billing_employee_name']!, _billingEmployeeNameMeta));
    }
    if (data.containsKey('snapshot_business_name')) {
      context.handle(
          _snapshotBusinessNameMeta,
          snapshotBusinessName.isAcceptableOrUnknown(
              data['snapshot_business_name']!, _snapshotBusinessNameMeta));
    } else if (isInserting) {
      context.missing(_snapshotBusinessNameMeta);
    }
    if (data.containsKey('snapshot_tagline')) {
      context.handle(
          _snapshotTaglineMeta,
          snapshotTagline.isAcceptableOrUnknown(
              data['snapshot_tagline']!, _snapshotTaglineMeta));
    }
    if (data.containsKey('snapshot_address')) {
      context.handle(
          _snapshotAddressMeta,
          snapshotAddress.isAcceptableOrUnknown(
              data['snapshot_address']!, _snapshotAddressMeta));
    }
    if (data.containsKey('snapshot_phone')) {
      context.handle(
          _snapshotPhoneMeta,
          snapshotPhone.isAcceptableOrUnknown(
              data['snapshot_phone']!, _snapshotPhoneMeta));
    }
    if (data.containsKey('snapshot_email')) {
      context.handle(
          _snapshotEmailMeta,
          snapshotEmail.isAcceptableOrUnknown(
              data['snapshot_email']!, _snapshotEmailMeta));
    }
    if (data.containsKey('snapshot_gstin')) {
      context.handle(
          _snapshotGstinMeta,
          snapshotGstin.isAcceptableOrUnknown(
              data['snapshot_gstin']!, _snapshotGstinMeta));
    }
    if (data.containsKey('snapshot_upi_id')) {
      context.handle(
          _snapshotUpiIdMeta,
          snapshotUpiId.isAcceptableOrUnknown(
              data['snapshot_upi_id']!, _snapshotUpiIdMeta));
    }
    if (data.containsKey('snapshot_invoice_footer')) {
      context.handle(
          _snapshotInvoiceFooterMeta,
          snapshotInvoiceFooter.isAcceptableOrUnknown(
              data['snapshot_invoice_footer']!, _snapshotInvoiceFooterMeta));
    }
    if (data.containsKey('snapshot_primary_color')) {
      context.handle(
          _snapshotPrimaryColorMeta,
          snapshotPrimaryColor.isAcceptableOrUnknown(
              data['snapshot_primary_color']!, _snapshotPrimaryColorMeta));
    } else if (isInserting) {
      context.missing(_snapshotPrimaryColorMeta);
    }
    if (data.containsKey('subtotal_paise')) {
      context.handle(
          _subtotalPaiseMeta,
          subtotalPaise.isAcceptableOrUnknown(
              data['subtotal_paise']!, _subtotalPaiseMeta));
    } else if (isInserting) {
      context.missing(_subtotalPaiseMeta);
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
          _discountPercentMeta,
          discountPercent.isAcceptableOrUnknown(
              data['discount_percent']!, _discountPercentMeta));
    } else if (isInserting) {
      context.missing(_discountPercentMeta);
    }
    if (data.containsKey('discount_flat_paise')) {
      context.handle(
          _discountFlatPaiseMeta,
          discountFlatPaise.isAcceptableOrUnknown(
              data['discount_flat_paise']!, _discountFlatPaiseMeta));
    } else if (isInserting) {
      context.missing(_discountFlatPaiseMeta);
    }
    if (data.containsKey('discount_paise')) {
      context.handle(
          _discountPaiseMeta,
          discountPaise.isAcceptableOrUnknown(
              data['discount_paise']!, _discountPaiseMeta));
    } else if (isInserting) {
      context.missing(_discountPaiseMeta);
    }
    if (data.containsKey('tax_basis_points')) {
      context.handle(
          _taxBasisPointsMeta,
          taxBasisPoints.isAcceptableOrUnknown(
              data['tax_basis_points']!, _taxBasisPointsMeta));
    } else if (isInserting) {
      context.missing(_taxBasisPointsMeta);
    }
    if (data.containsKey('tax_paise')) {
      context.handle(_taxPaiseMeta,
          taxPaise.isAcceptableOrUnknown(data['tax_paise']!, _taxPaiseMeta));
    } else if (isInserting) {
      context.missing(_taxPaiseMeta);
    }
    if (data.containsKey('total_paise')) {
      context.handle(
          _totalPaiseMeta,
          totalPaise.isAcceptableOrUnknown(
              data['total_paise']!, _totalPaiseMeta));
    } else if (isInserting) {
      context.missing(_totalPaiseMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('payment_status')) {
      context.handle(
          _paymentStatusMeta,
          paymentStatus.isAcceptableOrUnknown(
              data['payment_status']!, _paymentStatusMeta));
    } else if (isInserting) {
      context.missing(_paymentStatusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('finalized_at')) {
      context.handle(
          _finalizedAtMeta,
          finalizedAt.isAcceptableOrUnknown(
              data['finalized_at']!, _finalizedAtMeta));
    } else if (isInserting) {
      context.missing(_finalizedAtMeta);
    }
    if (data.containsKey('voided_at')) {
      context.handle(_voidedAtMeta,
          voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta));
    }
    if (data.containsKey('void_reason')) {
      context.handle(
          _voidReasonMeta,
          voidReason.isAcceptableOrUnknown(
              data['void_reason']!, _voidReasonMeta));
    }
    if (data.containsKey('voided_by')) {
      context.handle(_voidedByMeta,
          voidedBy.isAcceptableOrUnknown(data['voided_by']!, _voidedByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      provisionalRef: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}provisional_ref'])!,
      localSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_seq'])!,
      draftId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}draft_id'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone'])!,
      customerNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_notes'])!,
      billingEmployeeId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}billing_employee_id']),
      billingEmployeeName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}billing_employee_name']),
      snapshotBusinessName: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}snapshot_business_name'])!,
      snapshotTagline: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}snapshot_tagline']),
      snapshotAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}snapshot_address'])!,
      snapshotPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_phone'])!,
      snapshotEmail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_email']),
      snapshotGstin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_gstin']),
      snapshotUpiId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_upi_id']),
      snapshotInvoiceFooter: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}snapshot_invoice_footer']),
      snapshotPrimaryColor: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}snapshot_primary_color'])!,
      subtotalPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subtotal_paise'])!,
      discountPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_percent'])!,
      discountFlatPaise: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}discount_flat_paise'])!,
      discountPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_paise'])!,
      taxBasisPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_basis_points'])!,
      taxPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_paise'])!,
      totalPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_paise'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      paymentStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      finalizedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}finalized_at'])!,
      voidedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}voided_at']),
      voidReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}void_reason']),
      voidedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}voided_by']),
    );
  }

  @override
  $BillsTable createAlias(String alias) {
    return $BillsTable(attachedDatabase, alias);
  }
}

class BillRow extends DataClass implements Insertable<BillRow> {
  final String id;
  final String provisionalRef;
  final int localSeq;
  final String draftId;
  final String customerName;
  final String customerPhone;
  final String customerNotes;
  final String? billingEmployeeId;
  final String? billingEmployeeName;
  final String snapshotBusinessName;
  final String? snapshotTagline;
  final String snapshotAddress;
  final String snapshotPhone;
  final String? snapshotEmail;
  final String? snapshotGstin;
  final String? snapshotUpiId;
  final String? snapshotInvoiceFooter;
  final int snapshotPrimaryColor;
  final int subtotalPaise;
  final int discountPercent;
  final int discountFlatPaise;
  final int discountPaise;
  final int taxBasisPoints;
  final int taxPaise;
  final int totalPaise;
  final String status;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime finalizedAt;
  final DateTime? voidedAt;
  final String? voidReason;
  final String? voidedBy;
  const BillRow(
      {required this.id,
      required this.provisionalRef,
      required this.localSeq,
      required this.draftId,
      required this.customerName,
      required this.customerPhone,
      required this.customerNotes,
      this.billingEmployeeId,
      this.billingEmployeeName,
      required this.snapshotBusinessName,
      this.snapshotTagline,
      required this.snapshotAddress,
      required this.snapshotPhone,
      this.snapshotEmail,
      this.snapshotGstin,
      this.snapshotUpiId,
      this.snapshotInvoiceFooter,
      required this.snapshotPrimaryColor,
      required this.subtotalPaise,
      required this.discountPercent,
      required this.discountFlatPaise,
      required this.discountPaise,
      required this.taxBasisPoints,
      required this.taxPaise,
      required this.totalPaise,
      required this.status,
      required this.paymentStatus,
      required this.createdAt,
      required this.finalizedAt,
      this.voidedAt,
      this.voidReason,
      this.voidedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['provisional_ref'] = Variable<String>(provisionalRef);
    map['local_seq'] = Variable<int>(localSeq);
    map['draft_id'] = Variable<String>(draftId);
    map['customer_name'] = Variable<String>(customerName);
    map['customer_phone'] = Variable<String>(customerPhone);
    map['customer_notes'] = Variable<String>(customerNotes);
    if (!nullToAbsent || billingEmployeeId != null) {
      map['billing_employee_id'] = Variable<String>(billingEmployeeId);
    }
    if (!nullToAbsent || billingEmployeeName != null) {
      map['billing_employee_name'] = Variable<String>(billingEmployeeName);
    }
    map['snapshot_business_name'] = Variable<String>(snapshotBusinessName);
    if (!nullToAbsent || snapshotTagline != null) {
      map['snapshot_tagline'] = Variable<String>(snapshotTagline);
    }
    map['snapshot_address'] = Variable<String>(snapshotAddress);
    map['snapshot_phone'] = Variable<String>(snapshotPhone);
    if (!nullToAbsent || snapshotEmail != null) {
      map['snapshot_email'] = Variable<String>(snapshotEmail);
    }
    if (!nullToAbsent || snapshotGstin != null) {
      map['snapshot_gstin'] = Variable<String>(snapshotGstin);
    }
    if (!nullToAbsent || snapshotUpiId != null) {
      map['snapshot_upi_id'] = Variable<String>(snapshotUpiId);
    }
    if (!nullToAbsent || snapshotInvoiceFooter != null) {
      map['snapshot_invoice_footer'] = Variable<String>(snapshotInvoiceFooter);
    }
    map['snapshot_primary_color'] = Variable<int>(snapshotPrimaryColor);
    map['subtotal_paise'] = Variable<int>(subtotalPaise);
    map['discount_percent'] = Variable<int>(discountPercent);
    map['discount_flat_paise'] = Variable<int>(discountFlatPaise);
    map['discount_paise'] = Variable<int>(discountPaise);
    map['tax_basis_points'] = Variable<int>(taxBasisPoints);
    map['tax_paise'] = Variable<int>(taxPaise);
    map['total_paise'] = Variable<int>(totalPaise);
    map['status'] = Variable<String>(status);
    map['payment_status'] = Variable<String>(paymentStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['finalized_at'] = Variable<DateTime>(finalizedAt);
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<DateTime>(voidedAt);
    }
    if (!nullToAbsent || voidReason != null) {
      map['void_reason'] = Variable<String>(voidReason);
    }
    if (!nullToAbsent || voidedBy != null) {
      map['voided_by'] = Variable<String>(voidedBy);
    }
    return map;
  }

  BillsCompanion toCompanion(bool nullToAbsent) {
    return BillsCompanion(
      id: Value(id),
      provisionalRef: Value(provisionalRef),
      localSeq: Value(localSeq),
      draftId: Value(draftId),
      customerName: Value(customerName),
      customerPhone: Value(customerPhone),
      customerNotes: Value(customerNotes),
      billingEmployeeId: billingEmployeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(billingEmployeeId),
      billingEmployeeName: billingEmployeeName == null && nullToAbsent
          ? const Value.absent()
          : Value(billingEmployeeName),
      snapshotBusinessName: Value(snapshotBusinessName),
      snapshotTagline: snapshotTagline == null && nullToAbsent
          ? const Value.absent()
          : Value(snapshotTagline),
      snapshotAddress: Value(snapshotAddress),
      snapshotPhone: Value(snapshotPhone),
      snapshotEmail: snapshotEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(snapshotEmail),
      snapshotGstin: snapshotGstin == null && nullToAbsent
          ? const Value.absent()
          : Value(snapshotGstin),
      snapshotUpiId: snapshotUpiId == null && nullToAbsent
          ? const Value.absent()
          : Value(snapshotUpiId),
      snapshotInvoiceFooter: snapshotInvoiceFooter == null && nullToAbsent
          ? const Value.absent()
          : Value(snapshotInvoiceFooter),
      snapshotPrimaryColor: Value(snapshotPrimaryColor),
      subtotalPaise: Value(subtotalPaise),
      discountPercent: Value(discountPercent),
      discountFlatPaise: Value(discountFlatPaise),
      discountPaise: Value(discountPaise),
      taxBasisPoints: Value(taxBasisPoints),
      taxPaise: Value(taxPaise),
      totalPaise: Value(totalPaise),
      status: Value(status),
      paymentStatus: Value(paymentStatus),
      createdAt: Value(createdAt),
      finalizedAt: Value(finalizedAt),
      voidedAt: voidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedAt),
      voidReason: voidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(voidReason),
      voidedBy: voidedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedBy),
    );
  }

  factory BillRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillRow(
      id: serializer.fromJson<String>(json['id']),
      provisionalRef: serializer.fromJson<String>(json['provisionalRef']),
      localSeq: serializer.fromJson<int>(json['localSeq']),
      draftId: serializer.fromJson<String>(json['draftId']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String>(json['customerPhone']),
      customerNotes: serializer.fromJson<String>(json['customerNotes']),
      billingEmployeeId:
          serializer.fromJson<String?>(json['billingEmployeeId']),
      billingEmployeeName:
          serializer.fromJson<String?>(json['billingEmployeeName']),
      snapshotBusinessName:
          serializer.fromJson<String>(json['snapshotBusinessName']),
      snapshotTagline: serializer.fromJson<String?>(json['snapshotTagline']),
      snapshotAddress: serializer.fromJson<String>(json['snapshotAddress']),
      snapshotPhone: serializer.fromJson<String>(json['snapshotPhone']),
      snapshotEmail: serializer.fromJson<String?>(json['snapshotEmail']),
      snapshotGstin: serializer.fromJson<String?>(json['snapshotGstin']),
      snapshotUpiId: serializer.fromJson<String?>(json['snapshotUpiId']),
      snapshotInvoiceFooter:
          serializer.fromJson<String?>(json['snapshotInvoiceFooter']),
      snapshotPrimaryColor:
          serializer.fromJson<int>(json['snapshotPrimaryColor']),
      subtotalPaise: serializer.fromJson<int>(json['subtotalPaise']),
      discountPercent: serializer.fromJson<int>(json['discountPercent']),
      discountFlatPaise: serializer.fromJson<int>(json['discountFlatPaise']),
      discountPaise: serializer.fromJson<int>(json['discountPaise']),
      taxBasisPoints: serializer.fromJson<int>(json['taxBasisPoints']),
      taxPaise: serializer.fromJson<int>(json['taxPaise']),
      totalPaise: serializer.fromJson<int>(json['totalPaise']),
      status: serializer.fromJson<String>(json['status']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      finalizedAt: serializer.fromJson<DateTime>(json['finalizedAt']),
      voidedAt: serializer.fromJson<DateTime?>(json['voidedAt']),
      voidReason: serializer.fromJson<String?>(json['voidReason']),
      voidedBy: serializer.fromJson<String?>(json['voidedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'provisionalRef': serializer.toJson<String>(provisionalRef),
      'localSeq': serializer.toJson<int>(localSeq),
      'draftId': serializer.toJson<String>(draftId),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String>(customerPhone),
      'customerNotes': serializer.toJson<String>(customerNotes),
      'billingEmployeeId': serializer.toJson<String?>(billingEmployeeId),
      'billingEmployeeName': serializer.toJson<String?>(billingEmployeeName),
      'snapshotBusinessName': serializer.toJson<String>(snapshotBusinessName),
      'snapshotTagline': serializer.toJson<String?>(snapshotTagline),
      'snapshotAddress': serializer.toJson<String>(snapshotAddress),
      'snapshotPhone': serializer.toJson<String>(snapshotPhone),
      'snapshotEmail': serializer.toJson<String?>(snapshotEmail),
      'snapshotGstin': serializer.toJson<String?>(snapshotGstin),
      'snapshotUpiId': serializer.toJson<String?>(snapshotUpiId),
      'snapshotInvoiceFooter':
          serializer.toJson<String?>(snapshotInvoiceFooter),
      'snapshotPrimaryColor': serializer.toJson<int>(snapshotPrimaryColor),
      'subtotalPaise': serializer.toJson<int>(subtotalPaise),
      'discountPercent': serializer.toJson<int>(discountPercent),
      'discountFlatPaise': serializer.toJson<int>(discountFlatPaise),
      'discountPaise': serializer.toJson<int>(discountPaise),
      'taxBasisPoints': serializer.toJson<int>(taxBasisPoints),
      'taxPaise': serializer.toJson<int>(taxPaise),
      'totalPaise': serializer.toJson<int>(totalPaise),
      'status': serializer.toJson<String>(status),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'finalizedAt': serializer.toJson<DateTime>(finalizedAt),
      'voidedAt': serializer.toJson<DateTime?>(voidedAt),
      'voidReason': serializer.toJson<String?>(voidReason),
      'voidedBy': serializer.toJson<String?>(voidedBy),
    };
  }

  BillRow copyWith(
          {String? id,
          String? provisionalRef,
          int? localSeq,
          String? draftId,
          String? customerName,
          String? customerPhone,
          String? customerNotes,
          Value<String?> billingEmployeeId = const Value.absent(),
          Value<String?> billingEmployeeName = const Value.absent(),
          String? snapshotBusinessName,
          Value<String?> snapshotTagline = const Value.absent(),
          String? snapshotAddress,
          String? snapshotPhone,
          Value<String?> snapshotEmail = const Value.absent(),
          Value<String?> snapshotGstin = const Value.absent(),
          Value<String?> snapshotUpiId = const Value.absent(),
          Value<String?> snapshotInvoiceFooter = const Value.absent(),
          int? snapshotPrimaryColor,
          int? subtotalPaise,
          int? discountPercent,
          int? discountFlatPaise,
          int? discountPaise,
          int? taxBasisPoints,
          int? taxPaise,
          int? totalPaise,
          String? status,
          String? paymentStatus,
          DateTime? createdAt,
          DateTime? finalizedAt,
          Value<DateTime?> voidedAt = const Value.absent(),
          Value<String?> voidReason = const Value.absent(),
          Value<String?> voidedBy = const Value.absent()}) =>
      BillRow(
        id: id ?? this.id,
        provisionalRef: provisionalRef ?? this.provisionalRef,
        localSeq: localSeq ?? this.localSeq,
        draftId: draftId ?? this.draftId,
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        customerNotes: customerNotes ?? this.customerNotes,
        billingEmployeeId: billingEmployeeId.present
            ? billingEmployeeId.value
            : this.billingEmployeeId,
        billingEmployeeName: billingEmployeeName.present
            ? billingEmployeeName.value
            : this.billingEmployeeName,
        snapshotBusinessName: snapshotBusinessName ?? this.snapshotBusinessName,
        snapshotTagline: snapshotTagline.present
            ? snapshotTagline.value
            : this.snapshotTagline,
        snapshotAddress: snapshotAddress ?? this.snapshotAddress,
        snapshotPhone: snapshotPhone ?? this.snapshotPhone,
        snapshotEmail:
            snapshotEmail.present ? snapshotEmail.value : this.snapshotEmail,
        snapshotGstin:
            snapshotGstin.present ? snapshotGstin.value : this.snapshotGstin,
        snapshotUpiId:
            snapshotUpiId.present ? snapshotUpiId.value : this.snapshotUpiId,
        snapshotInvoiceFooter: snapshotInvoiceFooter.present
            ? snapshotInvoiceFooter.value
            : this.snapshotInvoiceFooter,
        snapshotPrimaryColor: snapshotPrimaryColor ?? this.snapshotPrimaryColor,
        subtotalPaise: subtotalPaise ?? this.subtotalPaise,
        discountPercent: discountPercent ?? this.discountPercent,
        discountFlatPaise: discountFlatPaise ?? this.discountFlatPaise,
        discountPaise: discountPaise ?? this.discountPaise,
        taxBasisPoints: taxBasisPoints ?? this.taxBasisPoints,
        taxPaise: taxPaise ?? this.taxPaise,
        totalPaise: totalPaise ?? this.totalPaise,
        status: status ?? this.status,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        createdAt: createdAt ?? this.createdAt,
        finalizedAt: finalizedAt ?? this.finalizedAt,
        voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
        voidReason: voidReason.present ? voidReason.value : this.voidReason,
        voidedBy: voidedBy.present ? voidedBy.value : this.voidedBy,
      );
  BillRow copyWithCompanion(BillsCompanion data) {
    return BillRow(
      id: data.id.present ? data.id.value : this.id,
      provisionalRef: data.provisionalRef.present
          ? data.provisionalRef.value
          : this.provisionalRef,
      localSeq: data.localSeq.present ? data.localSeq.value : this.localSeq,
      draftId: data.draftId.present ? data.draftId.value : this.draftId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      customerNotes: data.customerNotes.present
          ? data.customerNotes.value
          : this.customerNotes,
      billingEmployeeId: data.billingEmployeeId.present
          ? data.billingEmployeeId.value
          : this.billingEmployeeId,
      billingEmployeeName: data.billingEmployeeName.present
          ? data.billingEmployeeName.value
          : this.billingEmployeeName,
      snapshotBusinessName: data.snapshotBusinessName.present
          ? data.snapshotBusinessName.value
          : this.snapshotBusinessName,
      snapshotTagline: data.snapshotTagline.present
          ? data.snapshotTagline.value
          : this.snapshotTagline,
      snapshotAddress: data.snapshotAddress.present
          ? data.snapshotAddress.value
          : this.snapshotAddress,
      snapshotPhone: data.snapshotPhone.present
          ? data.snapshotPhone.value
          : this.snapshotPhone,
      snapshotEmail: data.snapshotEmail.present
          ? data.snapshotEmail.value
          : this.snapshotEmail,
      snapshotGstin: data.snapshotGstin.present
          ? data.snapshotGstin.value
          : this.snapshotGstin,
      snapshotUpiId: data.snapshotUpiId.present
          ? data.snapshotUpiId.value
          : this.snapshotUpiId,
      snapshotInvoiceFooter: data.snapshotInvoiceFooter.present
          ? data.snapshotInvoiceFooter.value
          : this.snapshotInvoiceFooter,
      snapshotPrimaryColor: data.snapshotPrimaryColor.present
          ? data.snapshotPrimaryColor.value
          : this.snapshotPrimaryColor,
      subtotalPaise: data.subtotalPaise.present
          ? data.subtotalPaise.value
          : this.subtotalPaise,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
      discountFlatPaise: data.discountFlatPaise.present
          ? data.discountFlatPaise.value
          : this.discountFlatPaise,
      discountPaise: data.discountPaise.present
          ? data.discountPaise.value
          : this.discountPaise,
      taxBasisPoints: data.taxBasisPoints.present
          ? data.taxBasisPoints.value
          : this.taxBasisPoints,
      taxPaise: data.taxPaise.present ? data.taxPaise.value : this.taxPaise,
      totalPaise:
          data.totalPaise.present ? data.totalPaise.value : this.totalPaise,
      status: data.status.present ? data.status.value : this.status,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      finalizedAt:
          data.finalizedAt.present ? data.finalizedAt.value : this.finalizedAt,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      voidReason:
          data.voidReason.present ? data.voidReason.value : this.voidReason,
      voidedBy: data.voidedBy.present ? data.voidedBy.value : this.voidedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillRow(')
          ..write('id: $id, ')
          ..write('provisionalRef: $provisionalRef, ')
          ..write('localSeq: $localSeq, ')
          ..write('draftId: $draftId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerNotes: $customerNotes, ')
          ..write('billingEmployeeId: $billingEmployeeId, ')
          ..write('billingEmployeeName: $billingEmployeeName, ')
          ..write('snapshotBusinessName: $snapshotBusinessName, ')
          ..write('snapshotTagline: $snapshotTagline, ')
          ..write('snapshotAddress: $snapshotAddress, ')
          ..write('snapshotPhone: $snapshotPhone, ')
          ..write('snapshotEmail: $snapshotEmail, ')
          ..write('snapshotGstin: $snapshotGstin, ')
          ..write('snapshotUpiId: $snapshotUpiId, ')
          ..write('snapshotInvoiceFooter: $snapshotInvoiceFooter, ')
          ..write('snapshotPrimaryColor: $snapshotPrimaryColor, ')
          ..write('subtotalPaise: $subtotalPaise, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('discountFlatPaise: $discountFlatPaise, ')
          ..write('discountPaise: $discountPaise, ')
          ..write('taxBasisPoints: $taxBasisPoints, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('status: $status, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('finalizedAt: $finalizedAt, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason, ')
          ..write('voidedBy: $voidedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        provisionalRef,
        localSeq,
        draftId,
        customerName,
        customerPhone,
        customerNotes,
        billingEmployeeId,
        billingEmployeeName,
        snapshotBusinessName,
        snapshotTagline,
        snapshotAddress,
        snapshotPhone,
        snapshotEmail,
        snapshotGstin,
        snapshotUpiId,
        snapshotInvoiceFooter,
        snapshotPrimaryColor,
        subtotalPaise,
        discountPercent,
        discountFlatPaise,
        discountPaise,
        taxBasisPoints,
        taxPaise,
        totalPaise,
        status,
        paymentStatus,
        createdAt,
        finalizedAt,
        voidedAt,
        voidReason,
        voidedBy
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillRow &&
          other.id == this.id &&
          other.provisionalRef == this.provisionalRef &&
          other.localSeq == this.localSeq &&
          other.draftId == this.draftId &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.customerNotes == this.customerNotes &&
          other.billingEmployeeId == this.billingEmployeeId &&
          other.billingEmployeeName == this.billingEmployeeName &&
          other.snapshotBusinessName == this.snapshotBusinessName &&
          other.snapshotTagline == this.snapshotTagline &&
          other.snapshotAddress == this.snapshotAddress &&
          other.snapshotPhone == this.snapshotPhone &&
          other.snapshotEmail == this.snapshotEmail &&
          other.snapshotGstin == this.snapshotGstin &&
          other.snapshotUpiId == this.snapshotUpiId &&
          other.snapshotInvoiceFooter == this.snapshotInvoiceFooter &&
          other.snapshotPrimaryColor == this.snapshotPrimaryColor &&
          other.subtotalPaise == this.subtotalPaise &&
          other.discountPercent == this.discountPercent &&
          other.discountFlatPaise == this.discountFlatPaise &&
          other.discountPaise == this.discountPaise &&
          other.taxBasisPoints == this.taxBasisPoints &&
          other.taxPaise == this.taxPaise &&
          other.totalPaise == this.totalPaise &&
          other.status == this.status &&
          other.paymentStatus == this.paymentStatus &&
          other.createdAt == this.createdAt &&
          other.finalizedAt == this.finalizedAt &&
          other.voidedAt == this.voidedAt &&
          other.voidReason == this.voidReason &&
          other.voidedBy == this.voidedBy);
}

class BillsCompanion extends UpdateCompanion<BillRow> {
  final Value<String> id;
  final Value<String> provisionalRef;
  final Value<int> localSeq;
  final Value<String> draftId;
  final Value<String> customerName;
  final Value<String> customerPhone;
  final Value<String> customerNotes;
  final Value<String?> billingEmployeeId;
  final Value<String?> billingEmployeeName;
  final Value<String> snapshotBusinessName;
  final Value<String?> snapshotTagline;
  final Value<String> snapshotAddress;
  final Value<String> snapshotPhone;
  final Value<String?> snapshotEmail;
  final Value<String?> snapshotGstin;
  final Value<String?> snapshotUpiId;
  final Value<String?> snapshotInvoiceFooter;
  final Value<int> snapshotPrimaryColor;
  final Value<int> subtotalPaise;
  final Value<int> discountPercent;
  final Value<int> discountFlatPaise;
  final Value<int> discountPaise;
  final Value<int> taxBasisPoints;
  final Value<int> taxPaise;
  final Value<int> totalPaise;
  final Value<String> status;
  final Value<String> paymentStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> finalizedAt;
  final Value<DateTime?> voidedAt;
  final Value<String?> voidReason;
  final Value<String?> voidedBy;
  final Value<int> rowid;
  const BillsCompanion({
    this.id = const Value.absent(),
    this.provisionalRef = const Value.absent(),
    this.localSeq = const Value.absent(),
    this.draftId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.customerNotes = const Value.absent(),
    this.billingEmployeeId = const Value.absent(),
    this.billingEmployeeName = const Value.absent(),
    this.snapshotBusinessName = const Value.absent(),
    this.snapshotTagline = const Value.absent(),
    this.snapshotAddress = const Value.absent(),
    this.snapshotPhone = const Value.absent(),
    this.snapshotEmail = const Value.absent(),
    this.snapshotGstin = const Value.absent(),
    this.snapshotUpiId = const Value.absent(),
    this.snapshotInvoiceFooter = const Value.absent(),
    this.snapshotPrimaryColor = const Value.absent(),
    this.subtotalPaise = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.discountFlatPaise = const Value.absent(),
    this.discountPaise = const Value.absent(),
    this.taxBasisPoints = const Value.absent(),
    this.taxPaise = const Value.absent(),
    this.totalPaise = const Value.absent(),
    this.status = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.finalizedAt = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.voidedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillsCompanion.insert({
    required String id,
    required String provisionalRef,
    required int localSeq,
    required String draftId,
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.customerNotes = const Value.absent(),
    this.billingEmployeeId = const Value.absent(),
    this.billingEmployeeName = const Value.absent(),
    required String snapshotBusinessName,
    this.snapshotTagline = const Value.absent(),
    this.snapshotAddress = const Value.absent(),
    this.snapshotPhone = const Value.absent(),
    this.snapshotEmail = const Value.absent(),
    this.snapshotGstin = const Value.absent(),
    this.snapshotUpiId = const Value.absent(),
    this.snapshotInvoiceFooter = const Value.absent(),
    required int snapshotPrimaryColor,
    required int subtotalPaise,
    required int discountPercent,
    required int discountFlatPaise,
    required int discountPaise,
    required int taxBasisPoints,
    required int taxPaise,
    required int totalPaise,
    required String status,
    required String paymentStatus,
    required DateTime createdAt,
    required DateTime finalizedAt,
    this.voidedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.voidedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        provisionalRef = Value(provisionalRef),
        localSeq = Value(localSeq),
        draftId = Value(draftId),
        snapshotBusinessName = Value(snapshotBusinessName),
        snapshotPrimaryColor = Value(snapshotPrimaryColor),
        subtotalPaise = Value(subtotalPaise),
        discountPercent = Value(discountPercent),
        discountFlatPaise = Value(discountFlatPaise),
        discountPaise = Value(discountPaise),
        taxBasisPoints = Value(taxBasisPoints),
        taxPaise = Value(taxPaise),
        totalPaise = Value(totalPaise),
        status = Value(status),
        paymentStatus = Value(paymentStatus),
        createdAt = Value(createdAt),
        finalizedAt = Value(finalizedAt);
  static Insertable<BillRow> custom({
    Expression<String>? id,
    Expression<String>? provisionalRef,
    Expression<int>? localSeq,
    Expression<String>? draftId,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? customerNotes,
    Expression<String>? billingEmployeeId,
    Expression<String>? billingEmployeeName,
    Expression<String>? snapshotBusinessName,
    Expression<String>? snapshotTagline,
    Expression<String>? snapshotAddress,
    Expression<String>? snapshotPhone,
    Expression<String>? snapshotEmail,
    Expression<String>? snapshotGstin,
    Expression<String>? snapshotUpiId,
    Expression<String>? snapshotInvoiceFooter,
    Expression<int>? snapshotPrimaryColor,
    Expression<int>? subtotalPaise,
    Expression<int>? discountPercent,
    Expression<int>? discountFlatPaise,
    Expression<int>? discountPaise,
    Expression<int>? taxBasisPoints,
    Expression<int>? taxPaise,
    Expression<int>? totalPaise,
    Expression<String>? status,
    Expression<String>? paymentStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? finalizedAt,
    Expression<DateTime>? voidedAt,
    Expression<String>? voidReason,
    Expression<String>? voidedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provisionalRef != null) 'provisional_ref': provisionalRef,
      if (localSeq != null) 'local_seq': localSeq,
      if (draftId != null) 'draft_id': draftId,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (customerNotes != null) 'customer_notes': customerNotes,
      if (billingEmployeeId != null) 'billing_employee_id': billingEmployeeId,
      if (billingEmployeeName != null)
        'billing_employee_name': billingEmployeeName,
      if (snapshotBusinessName != null)
        'snapshot_business_name': snapshotBusinessName,
      if (snapshotTagline != null) 'snapshot_tagline': snapshotTagline,
      if (snapshotAddress != null) 'snapshot_address': snapshotAddress,
      if (snapshotPhone != null) 'snapshot_phone': snapshotPhone,
      if (snapshotEmail != null) 'snapshot_email': snapshotEmail,
      if (snapshotGstin != null) 'snapshot_gstin': snapshotGstin,
      if (snapshotUpiId != null) 'snapshot_upi_id': snapshotUpiId,
      if (snapshotInvoiceFooter != null)
        'snapshot_invoice_footer': snapshotInvoiceFooter,
      if (snapshotPrimaryColor != null)
        'snapshot_primary_color': snapshotPrimaryColor,
      if (subtotalPaise != null) 'subtotal_paise': subtotalPaise,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (discountFlatPaise != null) 'discount_flat_paise': discountFlatPaise,
      if (discountPaise != null) 'discount_paise': discountPaise,
      if (taxBasisPoints != null) 'tax_basis_points': taxBasisPoints,
      if (taxPaise != null) 'tax_paise': taxPaise,
      if (totalPaise != null) 'total_paise': totalPaise,
      if (status != null) 'status': status,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (finalizedAt != null) 'finalized_at': finalizedAt,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (voidReason != null) 'void_reason': voidReason,
      if (voidedBy != null) 'voided_by': voidedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillsCompanion copyWith(
      {Value<String>? id,
      Value<String>? provisionalRef,
      Value<int>? localSeq,
      Value<String>? draftId,
      Value<String>? customerName,
      Value<String>? customerPhone,
      Value<String>? customerNotes,
      Value<String?>? billingEmployeeId,
      Value<String?>? billingEmployeeName,
      Value<String>? snapshotBusinessName,
      Value<String?>? snapshotTagline,
      Value<String>? snapshotAddress,
      Value<String>? snapshotPhone,
      Value<String?>? snapshotEmail,
      Value<String?>? snapshotGstin,
      Value<String?>? snapshotUpiId,
      Value<String?>? snapshotInvoiceFooter,
      Value<int>? snapshotPrimaryColor,
      Value<int>? subtotalPaise,
      Value<int>? discountPercent,
      Value<int>? discountFlatPaise,
      Value<int>? discountPaise,
      Value<int>? taxBasisPoints,
      Value<int>? taxPaise,
      Value<int>? totalPaise,
      Value<String>? status,
      Value<String>? paymentStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? finalizedAt,
      Value<DateTime?>? voidedAt,
      Value<String?>? voidReason,
      Value<String?>? voidedBy,
      Value<int>? rowid}) {
    return BillsCompanion(
      id: id ?? this.id,
      provisionalRef: provisionalRef ?? this.provisionalRef,
      localSeq: localSeq ?? this.localSeq,
      draftId: draftId ?? this.draftId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerNotes: customerNotes ?? this.customerNotes,
      billingEmployeeId: billingEmployeeId ?? this.billingEmployeeId,
      billingEmployeeName: billingEmployeeName ?? this.billingEmployeeName,
      snapshotBusinessName: snapshotBusinessName ?? this.snapshotBusinessName,
      snapshotTagline: snapshotTagline ?? this.snapshotTagline,
      snapshotAddress: snapshotAddress ?? this.snapshotAddress,
      snapshotPhone: snapshotPhone ?? this.snapshotPhone,
      snapshotEmail: snapshotEmail ?? this.snapshotEmail,
      snapshotGstin: snapshotGstin ?? this.snapshotGstin,
      snapshotUpiId: snapshotUpiId ?? this.snapshotUpiId,
      snapshotInvoiceFooter:
          snapshotInvoiceFooter ?? this.snapshotInvoiceFooter,
      snapshotPrimaryColor: snapshotPrimaryColor ?? this.snapshotPrimaryColor,
      subtotalPaise: subtotalPaise ?? this.subtotalPaise,
      discountPercent: discountPercent ?? this.discountPercent,
      discountFlatPaise: discountFlatPaise ?? this.discountFlatPaise,
      discountPaise: discountPaise ?? this.discountPaise,
      taxBasisPoints: taxBasisPoints ?? this.taxBasisPoints,
      taxPaise: taxPaise ?? this.taxPaise,
      totalPaise: totalPaise ?? this.totalPaise,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      finalizedAt: finalizedAt ?? this.finalizedAt,
      voidedAt: voidedAt ?? this.voidedAt,
      voidReason: voidReason ?? this.voidReason,
      voidedBy: voidedBy ?? this.voidedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (provisionalRef.present) {
      map['provisional_ref'] = Variable<String>(provisionalRef.value);
    }
    if (localSeq.present) {
      map['local_seq'] = Variable<int>(localSeq.value);
    }
    if (draftId.present) {
      map['draft_id'] = Variable<String>(draftId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (customerNotes.present) {
      map['customer_notes'] = Variable<String>(customerNotes.value);
    }
    if (billingEmployeeId.present) {
      map['billing_employee_id'] = Variable<String>(billingEmployeeId.value);
    }
    if (billingEmployeeName.present) {
      map['billing_employee_name'] =
          Variable<String>(billingEmployeeName.value);
    }
    if (snapshotBusinessName.present) {
      map['snapshot_business_name'] =
          Variable<String>(snapshotBusinessName.value);
    }
    if (snapshotTagline.present) {
      map['snapshot_tagline'] = Variable<String>(snapshotTagline.value);
    }
    if (snapshotAddress.present) {
      map['snapshot_address'] = Variable<String>(snapshotAddress.value);
    }
    if (snapshotPhone.present) {
      map['snapshot_phone'] = Variable<String>(snapshotPhone.value);
    }
    if (snapshotEmail.present) {
      map['snapshot_email'] = Variable<String>(snapshotEmail.value);
    }
    if (snapshotGstin.present) {
      map['snapshot_gstin'] = Variable<String>(snapshotGstin.value);
    }
    if (snapshotUpiId.present) {
      map['snapshot_upi_id'] = Variable<String>(snapshotUpiId.value);
    }
    if (snapshotInvoiceFooter.present) {
      map['snapshot_invoice_footer'] =
          Variable<String>(snapshotInvoiceFooter.value);
    }
    if (snapshotPrimaryColor.present) {
      map['snapshot_primary_color'] = Variable<int>(snapshotPrimaryColor.value);
    }
    if (subtotalPaise.present) {
      map['subtotal_paise'] = Variable<int>(subtotalPaise.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<int>(discountPercent.value);
    }
    if (discountFlatPaise.present) {
      map['discount_flat_paise'] = Variable<int>(discountFlatPaise.value);
    }
    if (discountPaise.present) {
      map['discount_paise'] = Variable<int>(discountPaise.value);
    }
    if (taxBasisPoints.present) {
      map['tax_basis_points'] = Variable<int>(taxBasisPoints.value);
    }
    if (taxPaise.present) {
      map['tax_paise'] = Variable<int>(taxPaise.value);
    }
    if (totalPaise.present) {
      map['total_paise'] = Variable<int>(totalPaise.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (finalizedAt.present) {
      map['finalized_at'] = Variable<DateTime>(finalizedAt.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<DateTime>(voidedAt.value);
    }
    if (voidReason.present) {
      map['void_reason'] = Variable<String>(voidReason.value);
    }
    if (voidedBy.present) {
      map['voided_by'] = Variable<String>(voidedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillsCompanion(')
          ..write('id: $id, ')
          ..write('provisionalRef: $provisionalRef, ')
          ..write('localSeq: $localSeq, ')
          ..write('draftId: $draftId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerNotes: $customerNotes, ')
          ..write('billingEmployeeId: $billingEmployeeId, ')
          ..write('billingEmployeeName: $billingEmployeeName, ')
          ..write('snapshotBusinessName: $snapshotBusinessName, ')
          ..write('snapshotTagline: $snapshotTagline, ')
          ..write('snapshotAddress: $snapshotAddress, ')
          ..write('snapshotPhone: $snapshotPhone, ')
          ..write('snapshotEmail: $snapshotEmail, ')
          ..write('snapshotGstin: $snapshotGstin, ')
          ..write('snapshotUpiId: $snapshotUpiId, ')
          ..write('snapshotInvoiceFooter: $snapshotInvoiceFooter, ')
          ..write('snapshotPrimaryColor: $snapshotPrimaryColor, ')
          ..write('subtotalPaise: $subtotalPaise, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('discountFlatPaise: $discountFlatPaise, ')
          ..write('discountPaise: $discountPaise, ')
          ..write('taxBasisPoints: $taxBasisPoints, ')
          ..write('taxPaise: $taxPaise, ')
          ..write('totalPaise: $totalPaise, ')
          ..write('status: $status, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('finalizedAt: $finalizedAt, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidReason: $voidReason, ')
          ..write('voidedBy: $voidedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillLinesTable extends BillLines
    with TableInfo<$BillLinesTable, BillLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<String> billId = GeneratedColumn<String>(
      'bill_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES bills (id) ON DELETE CASCADE'));
  static const VerificationMeta _serviceIdMeta =
      const VerificationMeta('serviceId');
  @override
  late final GeneratedColumn<String> serviceId = GeneratedColumn<String>(
      'service_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serviceNameMeta =
      const VerificationMeta('serviceName');
  @override
  late final GeneratedColumn<String> serviceName = GeneratedColumn<String>(
      'service_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pricePaiseMeta =
      const VerificationMeta('pricePaise');
  @override
  late final GeneratedColumn<int> pricePaise = GeneratedColumn<int>(
      'price_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _employeeNameMeta =
      const VerificationMeta('employeeName');
  @override
  late final GeneratedColumn<String> employeeName = GeneratedColumn<String>(
      'employee_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        billId,
        serviceId,
        serviceName,
        pricePaise,
        durationMinutes,
        quantity,
        employeeId,
        employeeName,
        position
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_lines';
  @override
  VerificationContext validateIntegrity(Insertable<BillLineRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bill_id')) {
      context.handle(_billIdMeta,
          billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta));
    } else if (isInserting) {
      context.missing(_billIdMeta);
    }
    if (data.containsKey('service_id')) {
      context.handle(_serviceIdMeta,
          serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta));
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('service_name')) {
      context.handle(
          _serviceNameMeta,
          serviceName.isAcceptableOrUnknown(
              data['service_name']!, _serviceNameMeta));
    } else if (isInserting) {
      context.missing(_serviceNameMeta);
    }
    if (data.containsKey('price_paise')) {
      context.handle(
          _pricePaiseMeta,
          pricePaise.isAcceptableOrUnknown(
              data['price_paise']!, _pricePaiseMeta));
    } else if (isInserting) {
      context.missing(_pricePaiseMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    }
    if (data.containsKey('employee_name')) {
      context.handle(
          _employeeNameMeta,
          employeeName.isAcceptableOrUnknown(
              data['employee_name']!, _employeeNameMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {billId, position},
      ];
  @override
  BillLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillLineRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      billId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bill_id'])!,
      serviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}service_id'])!,
      serviceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}service_name'])!,
      pricePaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price_paise'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id']),
      employeeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_name']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $BillLinesTable createAlias(String alias) {
    return $BillLinesTable(attachedDatabase, alias);
  }
}

class BillLineRow extends DataClass implements Insertable<BillLineRow> {
  final int id;
  final String billId;
  final String serviceId;
  final String serviceName;
  final int pricePaise;
  final int durationMinutes;
  final int quantity;
  final String? employeeId;
  final String? employeeName;
  final int position;
  const BillLineRow(
      {required this.id,
      required this.billId,
      required this.serviceId,
      required this.serviceName,
      required this.pricePaise,
      required this.durationMinutes,
      required this.quantity,
      this.employeeId,
      this.employeeName,
      required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bill_id'] = Variable<String>(billId);
    map['service_id'] = Variable<String>(serviceId);
    map['service_name'] = Variable<String>(serviceName);
    map['price_paise'] = Variable<int>(pricePaise);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || employeeId != null) {
      map['employee_id'] = Variable<String>(employeeId);
    }
    if (!nullToAbsent || employeeName != null) {
      map['employee_name'] = Variable<String>(employeeName);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  BillLinesCompanion toCompanion(bool nullToAbsent) {
    return BillLinesCompanion(
      id: Value(id),
      billId: Value(billId),
      serviceId: Value(serviceId),
      serviceName: Value(serviceName),
      pricePaise: Value(pricePaise),
      durationMinutes: Value(durationMinutes),
      quantity: Value(quantity),
      employeeId: employeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeId),
      employeeName: employeeName == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeName),
      position: Value(position),
    );
  }

  factory BillLineRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillLineRow(
      id: serializer.fromJson<int>(json['id']),
      billId: serializer.fromJson<String>(json['billId']),
      serviceId: serializer.fromJson<String>(json['serviceId']),
      serviceName: serializer.fromJson<String>(json['serviceName']),
      pricePaise: serializer.fromJson<int>(json['pricePaise']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      quantity: serializer.fromJson<int>(json['quantity']),
      employeeId: serializer.fromJson<String?>(json['employeeId']),
      employeeName: serializer.fromJson<String?>(json['employeeName']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'billId': serializer.toJson<String>(billId),
      'serviceId': serializer.toJson<String>(serviceId),
      'serviceName': serializer.toJson<String>(serviceName),
      'pricePaise': serializer.toJson<int>(pricePaise),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'quantity': serializer.toJson<int>(quantity),
      'employeeId': serializer.toJson<String?>(employeeId),
      'employeeName': serializer.toJson<String?>(employeeName),
      'position': serializer.toJson<int>(position),
    };
  }

  BillLineRow copyWith(
          {int? id,
          String? billId,
          String? serviceId,
          String? serviceName,
          int? pricePaise,
          int? durationMinutes,
          int? quantity,
          Value<String?> employeeId = const Value.absent(),
          Value<String?> employeeName = const Value.absent(),
          int? position}) =>
      BillLineRow(
        id: id ?? this.id,
        billId: billId ?? this.billId,
        serviceId: serviceId ?? this.serviceId,
        serviceName: serviceName ?? this.serviceName,
        pricePaise: pricePaise ?? this.pricePaise,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        quantity: quantity ?? this.quantity,
        employeeId: employeeId.present ? employeeId.value : this.employeeId,
        employeeName:
            employeeName.present ? employeeName.value : this.employeeName,
        position: position ?? this.position,
      );
  BillLineRow copyWithCompanion(BillLinesCompanion data) {
    return BillLineRow(
      id: data.id.present ? data.id.value : this.id,
      billId: data.billId.present ? data.billId.value : this.billId,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      serviceName:
          data.serviceName.present ? data.serviceName.value : this.serviceName,
      pricePaise:
          data.pricePaise.present ? data.pricePaise.value : this.pricePaise,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      employeeName: data.employeeName.present
          ? data.employeeName.value
          : this.employeeName,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillLineRow(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('serviceId: $serviceId, ')
          ..write('serviceName: $serviceName, ')
          ..write('pricePaise: $pricePaise, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('quantity: $quantity, ')
          ..write('employeeId: $employeeId, ')
          ..write('employeeName: $employeeName, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      billId,
      serviceId,
      serviceName,
      pricePaise,
      durationMinutes,
      quantity,
      employeeId,
      employeeName,
      position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillLineRow &&
          other.id == this.id &&
          other.billId == this.billId &&
          other.serviceId == this.serviceId &&
          other.serviceName == this.serviceName &&
          other.pricePaise == this.pricePaise &&
          other.durationMinutes == this.durationMinutes &&
          other.quantity == this.quantity &&
          other.employeeId == this.employeeId &&
          other.employeeName == this.employeeName &&
          other.position == this.position);
}

class BillLinesCompanion extends UpdateCompanion<BillLineRow> {
  final Value<int> id;
  final Value<String> billId;
  final Value<String> serviceId;
  final Value<String> serviceName;
  final Value<int> pricePaise;
  final Value<int> durationMinutes;
  final Value<int> quantity;
  final Value<String?> employeeId;
  final Value<String?> employeeName;
  final Value<int> position;
  const BillLinesCompanion({
    this.id = const Value.absent(),
    this.billId = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.serviceName = const Value.absent(),
    this.pricePaise = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.quantity = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.employeeName = const Value.absent(),
    this.position = const Value.absent(),
  });
  BillLinesCompanion.insert({
    this.id = const Value.absent(),
    required String billId,
    required String serviceId,
    required String serviceName,
    required int pricePaise,
    this.durationMinutes = const Value.absent(),
    required int quantity,
    this.employeeId = const Value.absent(),
    this.employeeName = const Value.absent(),
    required int position,
  })  : billId = Value(billId),
        serviceId = Value(serviceId),
        serviceName = Value(serviceName),
        pricePaise = Value(pricePaise),
        quantity = Value(quantity),
        position = Value(position);
  static Insertable<BillLineRow> custom({
    Expression<int>? id,
    Expression<String>? billId,
    Expression<String>? serviceId,
    Expression<String>? serviceName,
    Expression<int>? pricePaise,
    Expression<int>? durationMinutes,
    Expression<int>? quantity,
    Expression<String>? employeeId,
    Expression<String>? employeeName,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billId != null) 'bill_id': billId,
      if (serviceId != null) 'service_id': serviceId,
      if (serviceName != null) 'service_name': serviceName,
      if (pricePaise != null) 'price_paise': pricePaise,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (quantity != null) 'quantity': quantity,
      if (employeeId != null) 'employee_id': employeeId,
      if (employeeName != null) 'employee_name': employeeName,
      if (position != null) 'position': position,
    });
  }

  BillLinesCompanion copyWith(
      {Value<int>? id,
      Value<String>? billId,
      Value<String>? serviceId,
      Value<String>? serviceName,
      Value<int>? pricePaise,
      Value<int>? durationMinutes,
      Value<int>? quantity,
      Value<String?>? employeeId,
      Value<String?>? employeeName,
      Value<int>? position}) {
    return BillLinesCompanion(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      pricePaise: pricePaise ?? this.pricePaise,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      quantity: quantity ?? this.quantity,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<String>(billId.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<String>(serviceId.value);
    }
    if (serviceName.present) {
      map['service_name'] = Variable<String>(serviceName.value);
    }
    if (pricePaise.present) {
      map['price_paise'] = Variable<int>(pricePaise.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (employeeName.present) {
      map['employee_name'] = Variable<String>(employeeName.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillLinesCompanion(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('serviceId: $serviceId, ')
          ..write('serviceName: $serviceName, ')
          ..write('pricePaise: $pricePaise, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('quantity: $quantity, ')
          ..write('employeeId: $employeeId, ')
          ..write('employeeName: $employeeName, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments
    with TableInfo<$PaymentsTable, PaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<String> billId = GeneratedColumn<String>(
      'bill_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES bills (id) ON DELETE CASCADE'));
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPaiseMeta =
      const VerificationMeta('amountPaise');
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
      'amount_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confirmedByMeta =
      const VerificationMeta('confirmedBy');
  @override
  late final GeneratedColumn<String> confirmedBy = GeneratedColumn<String>(
      'confirmed_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _confirmedAtMeta =
      const VerificationMeta('confirmedAt');
  @override
  late final GeneratedColumn<DateTime> confirmedAt = GeneratedColumn<DateTime>(
      'confirmed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        billId,
        method,
        amountPaise,
        status,
        confirmedBy,
        confirmedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bill_id')) {
      context.handle(_billIdMeta,
          billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta));
    } else if (isInserting) {
      context.missing(_billIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
          _amountPaiseMeta,
          amountPaise.isAcceptableOrUnknown(
              data['amount_paise']!, _amountPaiseMeta));
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('confirmed_by')) {
      context.handle(
          _confirmedByMeta,
          confirmedBy.isAcceptableOrUnknown(
              data['confirmed_by']!, _confirmedByMeta));
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
          _confirmedAtMeta,
          confirmedAt.isAcceptableOrUnknown(
              data['confirmed_at']!, _confirmedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      billId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bill_id'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      amountPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paise'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      confirmedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}confirmed_by']),
      confirmedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}confirmed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class PaymentRow extends DataClass implements Insertable<PaymentRow> {
  final String id;
  final String billId;
  final String method;
  final int amountPaise;
  final String status;
  final String? confirmedBy;
  final DateTime? confirmedAt;
  final DateTime createdAt;
  const PaymentRow(
      {required this.id,
      required this.billId,
      required this.method,
      required this.amountPaise,
      required this.status,
      this.confirmedBy,
      this.confirmedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bill_id'] = Variable<String>(billId);
    map['method'] = Variable<String>(method);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || confirmedBy != null) {
      map['confirmed_by'] = Variable<String>(confirmedBy);
    }
    if (!nullToAbsent || confirmedAt != null) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      billId: Value(billId),
      method: Value(method),
      amountPaise: Value(amountPaise),
      status: Value(status),
      confirmedBy: confirmedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedBy),
      confirmedAt: confirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAt),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentRow(
      id: serializer.fromJson<String>(json['id']),
      billId: serializer.fromJson<String>(json['billId']),
      method: serializer.fromJson<String>(json['method']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      status: serializer.fromJson<String>(json['status']),
      confirmedBy: serializer.fromJson<String?>(json['confirmedBy']),
      confirmedAt: serializer.fromJson<DateTime?>(json['confirmedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'billId': serializer.toJson<String>(billId),
      'method': serializer.toJson<String>(method),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'status': serializer.toJson<String>(status),
      'confirmedBy': serializer.toJson<String?>(confirmedBy),
      'confirmedAt': serializer.toJson<DateTime?>(confirmedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentRow copyWith(
          {String? id,
          String? billId,
          String? method,
          int? amountPaise,
          String? status,
          Value<String?> confirmedBy = const Value.absent(),
          Value<DateTime?> confirmedAt = const Value.absent(),
          DateTime? createdAt}) =>
      PaymentRow(
        id: id ?? this.id,
        billId: billId ?? this.billId,
        method: method ?? this.method,
        amountPaise: amountPaise ?? this.amountPaise,
        status: status ?? this.status,
        confirmedBy: confirmedBy.present ? confirmedBy.value : this.confirmedBy,
        confirmedAt: confirmedAt.present ? confirmedAt.value : this.confirmedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  PaymentRow copyWithCompanion(PaymentsCompanion data) {
    return PaymentRow(
      id: data.id.present ? data.id.value : this.id,
      billId: data.billId.present ? data.billId.value : this.billId,
      method: data.method.present ? data.method.value : this.method,
      amountPaise:
          data.amountPaise.present ? data.amountPaise.value : this.amountPaise,
      status: data.status.present ? data.status.value : this.status,
      confirmedBy:
          data.confirmedBy.present ? data.confirmedBy.value : this.confirmedBy,
      confirmedAt:
          data.confirmedAt.present ? data.confirmedAt.value : this.confirmedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentRow(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('method: $method, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('status: $status, ')
          ..write('confirmedBy: $confirmedBy, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, billId, method, amountPaise, status,
      confirmedBy, confirmedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentRow &&
          other.id == this.id &&
          other.billId == this.billId &&
          other.method == this.method &&
          other.amountPaise == this.amountPaise &&
          other.status == this.status &&
          other.confirmedBy == this.confirmedBy &&
          other.confirmedAt == this.confirmedAt &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<PaymentRow> {
  final Value<String> id;
  final Value<String> billId;
  final Value<String> method;
  final Value<int> amountPaise;
  final Value<String> status;
  final Value<String?> confirmedBy;
  final Value<DateTime?> confirmedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.billId = const Value.absent(),
    this.method = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.status = const Value.absent(),
    this.confirmedBy = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    required String billId,
    required String method,
    required int amountPaise,
    required String status,
    this.confirmedBy = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        billId = Value(billId),
        method = Value(method),
        amountPaise = Value(amountPaise),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<PaymentRow> custom({
    Expression<String>? id,
    Expression<String>? billId,
    Expression<String>? method,
    Expression<int>? amountPaise,
    Expression<String>? status,
    Expression<String>? confirmedBy,
    Expression<DateTime>? confirmedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billId != null) 'bill_id': billId,
      if (method != null) 'method': method,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (status != null) 'status': status,
      if (confirmedBy != null) 'confirmed_by': confirmedBy,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? billId,
      Value<String>? method,
      Value<int>? amountPaise,
      Value<String>? status,
      Value<String?>? confirmedBy,
      Value<DateTime?>? confirmedAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      method: method ?? this.method,
      amountPaise: amountPaise ?? this.amountPaise,
      status: status ?? this.status,
      confirmedBy: confirmedBy ?? this.confirmedBy,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<String>(billId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (confirmedBy.present) {
      map['confirmed_by'] = Variable<String>(confirmedBy.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('method: $method, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('status: $status, ')
          ..write('confirmedBy: $confirmedBy, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoiceCountersTable extends InvoiceCounters
    with TableInfo<$InvoiceCountersTable, InvoiceCounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceCountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
      'value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_counters';
  @override
  VerificationContext validateIntegrity(Insertable<InvoiceCounter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  InvoiceCounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceCounter(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}value'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $InvoiceCountersTable createAlias(String alias) {
    return $InvoiceCountersTable(attachedDatabase, alias);
  }
}

class InvoiceCounter extends DataClass implements Insertable<InvoiceCounter> {
  final String key;
  final int value;
  final DateTime updatedAt;
  const InvoiceCounter(
      {required this.key, required this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<int>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InvoiceCountersCompanion toCompanion(bool nullToAbsent) {
    return InvoiceCountersCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory InvoiceCounter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceCounter(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<int>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<int>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InvoiceCounter copyWith({String? key, int? value, DateTime? updatedAt}) =>
      InvoiceCounter(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  InvoiceCounter copyWithCompanion(InvoiceCountersCompanion data) {
    return InvoiceCounter(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceCounter(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceCounter &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class InvoiceCountersCompanion extends UpdateCompanion<InvoiceCounter> {
  final Value<String> key;
  final Value<int> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const InvoiceCountersCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoiceCountersCompanion.insert({
    required String key,
    required int value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value),
        updatedAt = Value(updatedAt);
  static Insertable<InvoiceCounter> custom({
    Expression<String>? key,
    Expression<int>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoiceCountersCompanion copyWith(
      {Value<String>? key,
      Value<int>? value,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return InvoiceCountersCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceCountersCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillingAuditEventsTable extends BillingAuditEvents
    with TableInfo<$BillingAuditEventsTable, AuditEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillingAuditEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<String> billId = GeneratedColumn<String>(
      'bill_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _draftIdMeta =
      const VerificationMeta('draftId');
  @override
  late final GeneratedColumn<String> draftId = GeneratedColumn<String>(
      'draft_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
      'actor', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
      'detail', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, billId, draftId, type, actor, detail, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'billing_audit_events';
  @override
  VerificationContext validateIntegrity(Insertable<AuditEventRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bill_id')) {
      context.handle(_billIdMeta,
          billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta));
    }
    if (data.containsKey('draft_id')) {
      context.handle(_draftIdMeta,
          draftId.isAcceptableOrUnknown(data['draft_id']!, _draftIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
          _actorMeta, actor.isAcceptableOrUnknown(data['actor']!, _actorMeta));
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(_detailMeta,
          detail.isAcceptableOrUnknown(data['detail']!, _detailMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEventRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      billId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bill_id']),
      draftId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}draft_id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      actor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor'])!,
      detail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}detail'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BillingAuditEventsTable createAlias(String alias) {
    return $BillingAuditEventsTable(attachedDatabase, alias);
  }
}

class AuditEventRow extends DataClass implements Insertable<AuditEventRow> {
  final int id;
  final String? billId;
  final String? draftId;
  final String type;
  final String actor;
  final String detail;
  final DateTime createdAt;
  const AuditEventRow(
      {required this.id,
      this.billId,
      this.draftId,
      required this.type,
      required this.actor,
      required this.detail,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || billId != null) {
      map['bill_id'] = Variable<String>(billId);
    }
    if (!nullToAbsent || draftId != null) {
      map['draft_id'] = Variable<String>(draftId);
    }
    map['type'] = Variable<String>(type);
    map['actor'] = Variable<String>(actor);
    map['detail'] = Variable<String>(detail);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BillingAuditEventsCompanion toCompanion(bool nullToAbsent) {
    return BillingAuditEventsCompanion(
      id: Value(id),
      billId:
          billId == null && nullToAbsent ? const Value.absent() : Value(billId),
      draftId: draftId == null && nullToAbsent
          ? const Value.absent()
          : Value(draftId),
      type: Value(type),
      actor: Value(actor),
      detail: Value(detail),
      createdAt: Value(createdAt),
    );
  }

  factory AuditEventRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEventRow(
      id: serializer.fromJson<int>(json['id']),
      billId: serializer.fromJson<String?>(json['billId']),
      draftId: serializer.fromJson<String?>(json['draftId']),
      type: serializer.fromJson<String>(json['type']),
      actor: serializer.fromJson<String>(json['actor']),
      detail: serializer.fromJson<String>(json['detail']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'billId': serializer.toJson<String?>(billId),
      'draftId': serializer.toJson<String?>(draftId),
      'type': serializer.toJson<String>(type),
      'actor': serializer.toJson<String>(actor),
      'detail': serializer.toJson<String>(detail),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditEventRow copyWith(
          {int? id,
          Value<String?> billId = const Value.absent(),
          Value<String?> draftId = const Value.absent(),
          String? type,
          String? actor,
          String? detail,
          DateTime? createdAt}) =>
      AuditEventRow(
        id: id ?? this.id,
        billId: billId.present ? billId.value : this.billId,
        draftId: draftId.present ? draftId.value : this.draftId,
        type: type ?? this.type,
        actor: actor ?? this.actor,
        detail: detail ?? this.detail,
        createdAt: createdAt ?? this.createdAt,
      );
  AuditEventRow copyWithCompanion(BillingAuditEventsCompanion data) {
    return AuditEventRow(
      id: data.id.present ? data.id.value : this.id,
      billId: data.billId.present ? data.billId.value : this.billId,
      draftId: data.draftId.present ? data.draftId.value : this.draftId,
      type: data.type.present ? data.type.value : this.type,
      actor: data.actor.present ? data.actor.value : this.actor,
      detail: data.detail.present ? data.detail.value : this.detail,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEventRow(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('draftId: $draftId, ')
          ..write('type: $type, ')
          ..write('actor: $actor, ')
          ..write('detail: $detail, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, billId, draftId, type, actor, detail, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEventRow &&
          other.id == this.id &&
          other.billId == this.billId &&
          other.draftId == this.draftId &&
          other.type == this.type &&
          other.actor == this.actor &&
          other.detail == this.detail &&
          other.createdAt == this.createdAt);
}

class BillingAuditEventsCompanion extends UpdateCompanion<AuditEventRow> {
  final Value<int> id;
  final Value<String?> billId;
  final Value<String?> draftId;
  final Value<String> type;
  final Value<String> actor;
  final Value<String> detail;
  final Value<DateTime> createdAt;
  const BillingAuditEventsCompanion({
    this.id = const Value.absent(),
    this.billId = const Value.absent(),
    this.draftId = const Value.absent(),
    this.type = const Value.absent(),
    this.actor = const Value.absent(),
    this.detail = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BillingAuditEventsCompanion.insert({
    this.id = const Value.absent(),
    this.billId = const Value.absent(),
    this.draftId = const Value.absent(),
    required String type,
    required String actor,
    this.detail = const Value.absent(),
    required DateTime createdAt,
  })  : type = Value(type),
        actor = Value(actor),
        createdAt = Value(createdAt);
  static Insertable<AuditEventRow> custom({
    Expression<int>? id,
    Expression<String>? billId,
    Expression<String>? draftId,
    Expression<String>? type,
    Expression<String>? actor,
    Expression<String>? detail,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billId != null) 'bill_id': billId,
      if (draftId != null) 'draft_id': draftId,
      if (type != null) 'type': type,
      if (actor != null) 'actor': actor,
      if (detail != null) 'detail': detail,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BillingAuditEventsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? billId,
      Value<String?>? draftId,
      Value<String>? type,
      Value<String>? actor,
      Value<String>? detail,
      Value<DateTime>? createdAt}) {
    return BillingAuditEventsCompanion(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      draftId: draftId ?? this.draftId,
      type: type ?? this.type,
      actor: actor ?? this.actor,
      detail: detail ?? this.detail,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<String>(billId.value);
    }
    if (draftId.present) {
      map['draft_id'] = Variable<String>(draftId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillingAuditEventsCompanion(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('draftId: $draftId, ')
          ..write('type: $type, ')
          ..write('actor: $actor, ')
          ..write('detail: $detail, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AttendanceRecordsTable extends AttendanceRecords
    with TableInfo<$AttendanceRecordsTable, AttendanceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES employees (id) ON DELETE RESTRICT'));
  static const VerificationMeta _dateKeyMeta =
      const VerificationMeta('dateKey');
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
      'date_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _markedByMeta =
      const VerificationMeta('markedBy');
  @override
  late final GeneratedColumn<String> markedBy = GeneratedColumn<String>(
      'marked_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _markedAtMeta =
      const VerificationMeta('markedAt');
  @override
  late final GeneratedColumn<DateTime> markedAt = GeneratedColumn<DateTime>(
      'marked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, employeeId, dateKey, status, markedBy, markedAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_records';
  @override
  VerificationContext validateIntegrity(Insertable<AttendanceRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(_dateKeyMeta,
          dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta));
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('marked_by')) {
      context.handle(_markedByMeta,
          markedBy.isAcceptableOrUnknown(data['marked_by']!, _markedByMeta));
    } else if (isInserting) {
      context.missing(_markedByMeta);
    }
    if (data.containsKey('marked_at')) {
      context.handle(_markedAtMeta,
          markedAt.isAcceptableOrUnknown(data['marked_at']!, _markedAtMeta));
    } else if (isInserting) {
      context.missing(_markedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {employeeId, dateKey},
      ];
  @override
  AttendanceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      dateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_key'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      markedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}marked_by'])!,
      markedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}marked_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AttendanceRecordsTable createAlias(String alias) {
    return $AttendanceRecordsTable(attachedDatabase, alias);
  }
}

class AttendanceRow extends DataClass implements Insertable<AttendanceRow> {
  final int id;
  final String employeeId;
  final String dateKey;
  final String status;
  final String markedBy;
  final DateTime markedAt;
  final DateTime updatedAt;
  const AttendanceRow(
      {required this.id,
      required this.employeeId,
      required this.dateKey,
      required this.status,
      required this.markedBy,
      required this.markedAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['date_key'] = Variable<String>(dateKey);
    map['status'] = Variable<String>(status);
    map['marked_by'] = Variable<String>(markedBy);
    map['marked_at'] = Variable<DateTime>(markedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AttendanceRecordsCompanion toCompanion(bool nullToAbsent) {
    return AttendanceRecordsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      dateKey: Value(dateKey),
      status: Value(status),
      markedBy: Value(markedBy),
      markedAt: Value(markedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AttendanceRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceRow(
      id: serializer.fromJson<int>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      status: serializer.fromJson<String>(json['status']),
      markedBy: serializer.fromJson<String>(json['markedBy']),
      markedAt: serializer.fromJson<DateTime>(json['markedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'dateKey': serializer.toJson<String>(dateKey),
      'status': serializer.toJson<String>(status),
      'markedBy': serializer.toJson<String>(markedBy),
      'markedAt': serializer.toJson<DateTime>(markedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AttendanceRow copyWith(
          {int? id,
          String? employeeId,
          String? dateKey,
          String? status,
          String? markedBy,
          DateTime? markedAt,
          DateTime? updatedAt}) =>
      AttendanceRow(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        dateKey: dateKey ?? this.dateKey,
        status: status ?? this.status,
        markedBy: markedBy ?? this.markedBy,
        markedAt: markedAt ?? this.markedAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AttendanceRow copyWithCompanion(AttendanceRecordsCompanion data) {
    return AttendanceRow(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      status: data.status.present ? data.status.value : this.status,
      markedBy: data.markedBy.present ? data.markedBy.value : this.markedBy,
      markedAt: data.markedAt.present ? data.markedAt.value : this.markedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRow(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('dateKey: $dateKey, ')
          ..write('status: $status, ')
          ..write('markedBy: $markedBy, ')
          ..write('markedAt: $markedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, employeeId, dateKey, status, markedBy, markedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceRow &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.dateKey == this.dateKey &&
          other.status == this.status &&
          other.markedBy == this.markedBy &&
          other.markedAt == this.markedAt &&
          other.updatedAt == this.updatedAt);
}

class AttendanceRecordsCompanion extends UpdateCompanion<AttendanceRow> {
  final Value<int> id;
  final Value<String> employeeId;
  final Value<String> dateKey;
  final Value<String> status;
  final Value<String> markedBy;
  final Value<DateTime> markedAt;
  final Value<DateTime> updatedAt;
  const AttendanceRecordsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.status = const Value.absent(),
    this.markedBy = const Value.absent(),
    this.markedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AttendanceRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String employeeId,
    required String dateKey,
    required String status,
    required String markedBy,
    required DateTime markedAt,
    required DateTime updatedAt,
  })  : employeeId = Value(employeeId),
        dateKey = Value(dateKey),
        status = Value(status),
        markedBy = Value(markedBy),
        markedAt = Value(markedAt),
        updatedAt = Value(updatedAt);
  static Insertable<AttendanceRow> custom({
    Expression<int>? id,
    Expression<String>? employeeId,
    Expression<String>? dateKey,
    Expression<String>? status,
    Expression<String>? markedBy,
    Expression<DateTime>? markedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (dateKey != null) 'date_key': dateKey,
      if (status != null) 'status': status,
      if (markedBy != null) 'marked_by': markedBy,
      if (markedAt != null) 'marked_at': markedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AttendanceRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? employeeId,
      Value<String>? dateKey,
      Value<String>? status,
      Value<String>? markedBy,
      Value<DateTime>? markedAt,
      Value<DateTime>? updatedAt}) {
    return AttendanceRecordsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      dateKey: dateKey ?? this.dateKey,
      status: status ?? this.status,
      markedBy: markedBy ?? this.markedBy,
      markedAt: markedAt ?? this.markedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (markedBy.present) {
      map['marked_by'] = Variable<String>(markedBy.value);
    }
    if (markedAt.present) {
      map['marked_at'] = Variable<DateTime>(markedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('dateKey: $dateKey, ')
          ..write('status: $status, ')
          ..write('markedBy: $markedBy, ')
          ..write('markedAt: $markedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AttendanceAuditEventsTable extends AttendanceAuditEvents
    with TableInfo<$AttendanceAuditEventsTable, AttendanceAuditRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceAuditEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateKeyMeta =
      const VerificationMeta('dateKey');
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
      'date_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _oldStatusMeta =
      const VerificationMeta('oldStatus');
  @override
  late final GeneratedColumn<String> oldStatus = GeneratedColumn<String>(
      'old_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _newStatusMeta =
      const VerificationMeta('newStatus');
  @override
  late final GeneratedColumn<String> newStatus = GeneratedColumn<String>(
      'new_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
      'actor', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, employeeId, dateKey, oldStatus, newStatus, actor, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_audit_events';
  @override
  VerificationContext validateIntegrity(Insertable<AttendanceAuditRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(_dateKeyMeta,
          dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta));
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('old_status')) {
      context.handle(_oldStatusMeta,
          oldStatus.isAcceptableOrUnknown(data['old_status']!, _oldStatusMeta));
    }
    if (data.containsKey('new_status')) {
      context.handle(_newStatusMeta,
          newStatus.isAcceptableOrUnknown(data['new_status']!, _newStatusMeta));
    } else if (isInserting) {
      context.missing(_newStatusMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
          _actorMeta, actor.isAcceptableOrUnknown(data['actor']!, _actorMeta));
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceAuditRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceAuditRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      dateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_key'])!,
      oldStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}old_status']),
      newStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}new_status'])!,
      actor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AttendanceAuditEventsTable createAlias(String alias) {
    return $AttendanceAuditEventsTable(attachedDatabase, alias);
  }
}

class AttendanceAuditRow extends DataClass
    implements Insertable<AttendanceAuditRow> {
  final int id;
  final String employeeId;
  final String dateKey;
  final String? oldStatus;
  final String newStatus;
  final String actor;
  final DateTime createdAt;
  const AttendanceAuditRow(
      {required this.id,
      required this.employeeId,
      required this.dateKey,
      this.oldStatus,
      required this.newStatus,
      required this.actor,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['date_key'] = Variable<String>(dateKey);
    if (!nullToAbsent || oldStatus != null) {
      map['old_status'] = Variable<String>(oldStatus);
    }
    map['new_status'] = Variable<String>(newStatus);
    map['actor'] = Variable<String>(actor);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttendanceAuditEventsCompanion toCompanion(bool nullToAbsent) {
    return AttendanceAuditEventsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      dateKey: Value(dateKey),
      oldStatus: oldStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(oldStatus),
      newStatus: Value(newStatus),
      actor: Value(actor),
      createdAt: Value(createdAt),
    );
  }

  factory AttendanceAuditRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceAuditRow(
      id: serializer.fromJson<int>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      oldStatus: serializer.fromJson<String?>(json['oldStatus']),
      newStatus: serializer.fromJson<String>(json['newStatus']),
      actor: serializer.fromJson<String>(json['actor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'dateKey': serializer.toJson<String>(dateKey),
      'oldStatus': serializer.toJson<String?>(oldStatus),
      'newStatus': serializer.toJson<String>(newStatus),
      'actor': serializer.toJson<String>(actor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AttendanceAuditRow copyWith(
          {int? id,
          String? employeeId,
          String? dateKey,
          Value<String?> oldStatus = const Value.absent(),
          String? newStatus,
          String? actor,
          DateTime? createdAt}) =>
      AttendanceAuditRow(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        dateKey: dateKey ?? this.dateKey,
        oldStatus: oldStatus.present ? oldStatus.value : this.oldStatus,
        newStatus: newStatus ?? this.newStatus,
        actor: actor ?? this.actor,
        createdAt: createdAt ?? this.createdAt,
      );
  AttendanceAuditRow copyWithCompanion(AttendanceAuditEventsCompanion data) {
    return AttendanceAuditRow(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      oldStatus: data.oldStatus.present ? data.oldStatus.value : this.oldStatus,
      newStatus: data.newStatus.present ? data.newStatus.value : this.newStatus,
      actor: data.actor.present ? data.actor.value : this.actor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceAuditRow(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('dateKey: $dateKey, ')
          ..write('oldStatus: $oldStatus, ')
          ..write('newStatus: $newStatus, ')
          ..write('actor: $actor, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, employeeId, dateKey, oldStatus, newStatus, actor, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceAuditRow &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.dateKey == this.dateKey &&
          other.oldStatus == this.oldStatus &&
          other.newStatus == this.newStatus &&
          other.actor == this.actor &&
          other.createdAt == this.createdAt);
}

class AttendanceAuditEventsCompanion
    extends UpdateCompanion<AttendanceAuditRow> {
  final Value<int> id;
  final Value<String> employeeId;
  final Value<String> dateKey;
  final Value<String?> oldStatus;
  final Value<String> newStatus;
  final Value<String> actor;
  final Value<DateTime> createdAt;
  const AttendanceAuditEventsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.oldStatus = const Value.absent(),
    this.newStatus = const Value.absent(),
    this.actor = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AttendanceAuditEventsCompanion.insert({
    this.id = const Value.absent(),
    required String employeeId,
    required String dateKey,
    this.oldStatus = const Value.absent(),
    required String newStatus,
    required String actor,
    required DateTime createdAt,
  })  : employeeId = Value(employeeId),
        dateKey = Value(dateKey),
        newStatus = Value(newStatus),
        actor = Value(actor),
        createdAt = Value(createdAt);
  static Insertable<AttendanceAuditRow> custom({
    Expression<int>? id,
    Expression<String>? employeeId,
    Expression<String>? dateKey,
    Expression<String>? oldStatus,
    Expression<String>? newStatus,
    Expression<String>? actor,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (dateKey != null) 'date_key': dateKey,
      if (oldStatus != null) 'old_status': oldStatus,
      if (newStatus != null) 'new_status': newStatus,
      if (actor != null) 'actor': actor,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AttendanceAuditEventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? employeeId,
      Value<String>? dateKey,
      Value<String?>? oldStatus,
      Value<String>? newStatus,
      Value<String>? actor,
      Value<DateTime>? createdAt}) {
    return AttendanceAuditEventsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      dateKey: dateKey ?? this.dateKey,
      oldStatus: oldStatus ?? this.oldStatus,
      newStatus: newStatus ?? this.newStatus,
      actor: actor ?? this.actor,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (oldStatus.present) {
      map['old_status'] = Variable<String>(oldStatus.value);
    }
    if (newStatus.present) {
      map['new_status'] = Variable<String>(newStatus.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceAuditEventsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('dateKey: $dateKey, ')
          ..write('oldStatus: $oldStatus, ')
          ..write('newStatus: $newStatus, ')
          ..write('actor: $actor, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SalaryAdvancesTable extends SalaryAdvances
    with TableInfo<$SalaryAdvancesTable, AdvanceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalaryAdvancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES employees (id) ON DELETE RESTRICT'));
  static const VerificationMeta _amountPaiseMeta =
      const VerificationMeta('amountPaise');
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
      'amount_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _businessDateKeyMeta =
      const VerificationMeta('businessDateKey');
  @override
  late final GeneratedColumn<String> businessDateKey = GeneratedColumn<String>(
      'business_date_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordedByMeta =
      const VerificationMeta('recordedBy');
  @override
  late final GeneratedColumn<String> recordedBy = GeneratedColumn<String>(
      'recorded_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reversalOfIdMeta =
      const VerificationMeta('reversalOfId');
  @override
  late final GeneratedColumn<String> reversalOfId = GeneratedColumn<String>(
      'reversal_of_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        employeeId,
        amountPaise,
        businessDateKey,
        recordedAt,
        method,
        notes,
        recordedBy,
        reversalOfId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'salary_advances';
  @override
  VerificationContext validateIntegrity(Insertable<AdvanceRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
          _amountPaiseMeta,
          amountPaise.isAcceptableOrUnknown(
              data['amount_paise']!, _amountPaiseMeta));
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('business_date_key')) {
      context.handle(
          _businessDateKeyMeta,
          businessDateKey.isAcceptableOrUnknown(
              data['business_date_key']!, _businessDateKeyMeta));
    } else if (isInserting) {
      context.missing(_businessDateKeyMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('recorded_by')) {
      context.handle(
          _recordedByMeta,
          recordedBy.isAcceptableOrUnknown(
              data['recorded_by']!, _recordedByMeta));
    } else if (isInserting) {
      context.missing(_recordedByMeta);
    }
    if (data.containsKey('reversal_of_id')) {
      context.handle(
          _reversalOfIdMeta,
          reversalOfId.isAcceptableOrUnknown(
              data['reversal_of_id']!, _reversalOfIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdvanceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdvanceRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      amountPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paise'])!,
      businessDateKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}business_date_key'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      recordedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recorded_by'])!,
      reversalOfId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reversal_of_id']),
    );
  }

  @override
  $SalaryAdvancesTable createAlias(String alias) {
    return $SalaryAdvancesTable(attachedDatabase, alias);
  }
}

class AdvanceRow extends DataClass implements Insertable<AdvanceRow> {
  final String id;
  final String employeeId;
  final int amountPaise;
  final String businessDateKey;
  final DateTime recordedAt;
  final String method;
  final String? notes;
  final String recordedBy;
  final String? reversalOfId;
  const AdvanceRow(
      {required this.id,
      required this.employeeId,
      required this.amountPaise,
      required this.businessDateKey,
      required this.recordedAt,
      required this.method,
      this.notes,
      required this.recordedBy,
      this.reversalOfId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['business_date_key'] = Variable<String>(businessDateKey);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['recorded_by'] = Variable<String>(recordedBy);
    if (!nullToAbsent || reversalOfId != null) {
      map['reversal_of_id'] = Variable<String>(reversalOfId);
    }
    return map;
  }

  SalaryAdvancesCompanion toCompanion(bool nullToAbsent) {
    return SalaryAdvancesCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      amountPaise: Value(amountPaise),
      businessDateKey: Value(businessDateKey),
      recordedAt: Value(recordedAt),
      method: Value(method),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      recordedBy: Value(recordedBy),
      reversalOfId: reversalOfId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversalOfId),
    );
  }

  factory AdvanceRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdvanceRow(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      businessDateKey: serializer.fromJson<String>(json['businessDateKey']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      method: serializer.fromJson<String>(json['method']),
      notes: serializer.fromJson<String?>(json['notes']),
      recordedBy: serializer.fromJson<String>(json['recordedBy']),
      reversalOfId: serializer.fromJson<String?>(json['reversalOfId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'businessDateKey': serializer.toJson<String>(businessDateKey),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'method': serializer.toJson<String>(method),
      'notes': serializer.toJson<String?>(notes),
      'recordedBy': serializer.toJson<String>(recordedBy),
      'reversalOfId': serializer.toJson<String?>(reversalOfId),
    };
  }

  AdvanceRow copyWith(
          {String? id,
          String? employeeId,
          int? amountPaise,
          String? businessDateKey,
          DateTime? recordedAt,
          String? method,
          Value<String?> notes = const Value.absent(),
          String? recordedBy,
          Value<String?> reversalOfId = const Value.absent()}) =>
      AdvanceRow(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        amountPaise: amountPaise ?? this.amountPaise,
        businessDateKey: businessDateKey ?? this.businessDateKey,
        recordedAt: recordedAt ?? this.recordedAt,
        method: method ?? this.method,
        notes: notes.present ? notes.value : this.notes,
        recordedBy: recordedBy ?? this.recordedBy,
        reversalOfId:
            reversalOfId.present ? reversalOfId.value : this.reversalOfId,
      );
  AdvanceRow copyWithCompanion(SalaryAdvancesCompanion data) {
    return AdvanceRow(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      amountPaise:
          data.amountPaise.present ? data.amountPaise.value : this.amountPaise,
      businessDateKey: data.businessDateKey.present
          ? data.businessDateKey.value
          : this.businessDateKey,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      method: data.method.present ? data.method.value : this.method,
      notes: data.notes.present ? data.notes.value : this.notes,
      recordedBy:
          data.recordedBy.present ? data.recordedBy.value : this.recordedBy,
      reversalOfId: data.reversalOfId.present
          ? data.reversalOfId.value
          : this.reversalOfId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdvanceRow(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('businessDateKey: $businessDateKey, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('method: $method, ')
          ..write('notes: $notes, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('reversalOfId: $reversalOfId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, employeeId, amountPaise, businessDateKey,
      recordedAt, method, notes, recordedBy, reversalOfId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdvanceRow &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.amountPaise == this.amountPaise &&
          other.businessDateKey == this.businessDateKey &&
          other.recordedAt == this.recordedAt &&
          other.method == this.method &&
          other.notes == this.notes &&
          other.recordedBy == this.recordedBy &&
          other.reversalOfId == this.reversalOfId);
}

class SalaryAdvancesCompanion extends UpdateCompanion<AdvanceRow> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<int> amountPaise;
  final Value<String> businessDateKey;
  final Value<DateTime> recordedAt;
  final Value<String> method;
  final Value<String?> notes;
  final Value<String> recordedBy;
  final Value<String?> reversalOfId;
  final Value<int> rowid;
  const SalaryAdvancesCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.businessDateKey = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.method = const Value.absent(),
    this.notes = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.reversalOfId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalaryAdvancesCompanion.insert({
    required String id,
    required String employeeId,
    required int amountPaise,
    required String businessDateKey,
    required DateTime recordedAt,
    required String method,
    this.notes = const Value.absent(),
    required String recordedBy,
    this.reversalOfId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId),
        amountPaise = Value(amountPaise),
        businessDateKey = Value(businessDateKey),
        recordedAt = Value(recordedAt),
        method = Value(method),
        recordedBy = Value(recordedBy);
  static Insertable<AdvanceRow> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<int>? amountPaise,
    Expression<String>? businessDateKey,
    Expression<DateTime>? recordedAt,
    Expression<String>? method,
    Expression<String>? notes,
    Expression<String>? recordedBy,
    Expression<String>? reversalOfId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (businessDateKey != null) 'business_date_key': businessDateKey,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (method != null) 'method': method,
      if (notes != null) 'notes': notes,
      if (recordedBy != null) 'recorded_by': recordedBy,
      if (reversalOfId != null) 'reversal_of_id': reversalOfId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalaryAdvancesCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<int>? amountPaise,
      Value<String>? businessDateKey,
      Value<DateTime>? recordedAt,
      Value<String>? method,
      Value<String?>? notes,
      Value<String>? recordedBy,
      Value<String?>? reversalOfId,
      Value<int>? rowid}) {
    return SalaryAdvancesCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      amountPaise: amountPaise ?? this.amountPaise,
      businessDateKey: businessDateKey ?? this.businessDateKey,
      recordedAt: recordedAt ?? this.recordedAt,
      method: method ?? this.method,
      notes: notes ?? this.notes,
      recordedBy: recordedBy ?? this.recordedBy,
      reversalOfId: reversalOfId ?? this.reversalOfId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (businessDateKey.present) {
      map['business_date_key'] = Variable<String>(businessDateKey.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (recordedBy.present) {
      map['recorded_by'] = Variable<String>(recordedBy.value);
    }
    if (reversalOfId.present) {
      map['reversal_of_id'] = Variable<String>(reversalOfId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalaryAdvancesCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('businessDateKey: $businessDateKey, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('method: $method, ')
          ..write('notes: $notes, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('reversalOfId: $reversalOfId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayrollSettingsTable extends PayrollSettings
    with TableInfo<$PayrollSettingsTable, PayrollSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayrollSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _rulesJsonMeta =
      const VerificationMeta('rulesJson');
  @override
  late final GeneratedColumn<String> rulesJson = GeneratedColumn<String>(
      'rules_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reviewedAtMeta =
      const VerificationMeta('reviewedAt');
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
      'reviewed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, rulesJson, reviewedAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payroll_settings';
  @override
  VerificationContext validateIntegrity(Insertable<PayrollSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rules_json')) {
      context.handle(_rulesJsonMeta,
          rulesJson.isAcceptableOrUnknown(data['rules_json']!, _rulesJsonMeta));
    } else if (isInserting) {
      context.missing(_rulesJsonMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
          _reviewedAtMeta,
          reviewedAt.isAcceptableOrUnknown(
              data['reviewed_at']!, _reviewedAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PayrollSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayrollSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      rulesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rules_json'])!,
      reviewedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reviewed_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PayrollSettingsTable createAlias(String alias) {
    return $PayrollSettingsTable(attachedDatabase, alias);
  }
}

class PayrollSetting extends DataClass implements Insertable<PayrollSetting> {
  final int id;
  final String rulesJson;
  final DateTime? reviewedAt;
  final DateTime updatedAt;
  const PayrollSetting(
      {required this.id,
      required this.rulesJson,
      this.reviewedAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rules_json'] = Variable<String>(rulesJson);
    if (!nullToAbsent || reviewedAt != null) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PayrollSettingsCompanion toCompanion(bool nullToAbsent) {
    return PayrollSettingsCompanion(
      id: Value(id),
      rulesJson: Value(rulesJson),
      reviewedAt: reviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PayrollSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayrollSetting(
      id: serializer.fromJson<int>(json['id']),
      rulesJson: serializer.fromJson<String>(json['rulesJson']),
      reviewedAt: serializer.fromJson<DateTime?>(json['reviewedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'rulesJson': serializer.toJson<String>(rulesJson),
      'reviewedAt': serializer.toJson<DateTime?>(reviewedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PayrollSetting copyWith(
          {int? id,
          String? rulesJson,
          Value<DateTime?> reviewedAt = const Value.absent(),
          DateTime? updatedAt}) =>
      PayrollSetting(
        id: id ?? this.id,
        rulesJson: rulesJson ?? this.rulesJson,
        reviewedAt: reviewedAt.present ? reviewedAt.value : this.reviewedAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PayrollSetting copyWithCompanion(PayrollSettingsCompanion data) {
    return PayrollSetting(
      id: data.id.present ? data.id.value : this.id,
      rulesJson: data.rulesJson.present ? data.rulesJson.value : this.rulesJson,
      reviewedAt:
          data.reviewedAt.present ? data.reviewedAt.value : this.reviewedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayrollSetting(')
          ..write('id: $id, ')
          ..write('rulesJson: $rulesJson, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rulesJson, reviewedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayrollSetting &&
          other.id == this.id &&
          other.rulesJson == this.rulesJson &&
          other.reviewedAt == this.reviewedAt &&
          other.updatedAt == this.updatedAt);
}

class PayrollSettingsCompanion extends UpdateCompanion<PayrollSetting> {
  final Value<int> id;
  final Value<String> rulesJson;
  final Value<DateTime?> reviewedAt;
  final Value<DateTime> updatedAt;
  const PayrollSettingsCompanion({
    this.id = const Value.absent(),
    this.rulesJson = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PayrollSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String rulesJson,
    this.reviewedAt = const Value.absent(),
    required DateTime updatedAt,
  })  : rulesJson = Value(rulesJson),
        updatedAt = Value(updatedAt);
  static Insertable<PayrollSetting> custom({
    Expression<int>? id,
    Expression<String>? rulesJson,
    Expression<DateTime>? reviewedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rulesJson != null) 'rules_json': rulesJson,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PayrollSettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? rulesJson,
      Value<DateTime?>? reviewedAt,
      Value<DateTime>? updatedAt}) {
    return PayrollSettingsCompanion(
      id: id ?? this.id,
      rulesJson: rulesJson ?? this.rulesJson,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rulesJson.present) {
      map['rules_json'] = Variable<String>(rulesJson.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayrollSettingsCompanion(')
          ..write('id: $id, ')
          ..write('rulesJson: $rulesJson, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PayrollRunsTable extends PayrollRuns
    with TableInfo<$PayrollRunsTable, PayrollRunRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayrollRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _periodKeyMeta =
      const VerificationMeta('periodKey');
  @override
  late final GeneratedColumn<String> periodKey = GeneratedColumn<String>(
      'period_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rulesJsonMeta =
      const VerificationMeta('rulesJson');
  @override
  late final GeneratedColumn<String> rulesJson = GeneratedColumn<String>(
      'rules_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _approvedByMeta =
      const VerificationMeta('approvedBy');
  @override
  late final GeneratedColumn<String> approvedBy = GeneratedColumn<String>(
      'approved_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _approvedAtMeta =
      const VerificationMeta('approvedAt');
  @override
  late final GeneratedColumn<DateTime> approvedAt = GeneratedColumn<DateTime>(
      'approved_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _voidReasonMeta =
      const VerificationMeta('voidReason');
  @override
  late final GeneratedColumn<String> voidReason = GeneratedColumn<String>(
      'void_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        periodKey,
        version,
        status,
        rulesJson,
        createdBy,
        createdAt,
        approvedBy,
        approvedAt,
        voidReason
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payroll_runs';
  @override
  VerificationContext validateIntegrity(Insertable<PayrollRunRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('period_key')) {
      context.handle(_periodKeyMeta,
          periodKey.isAcceptableOrUnknown(data['period_key']!, _periodKeyMeta));
    } else if (isInserting) {
      context.missing(_periodKeyMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('rules_json')) {
      context.handle(_rulesJsonMeta,
          rulesJson.isAcceptableOrUnknown(data['rules_json']!, _rulesJsonMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('approved_by')) {
      context.handle(
          _approvedByMeta,
          approvedBy.isAcceptableOrUnknown(
              data['approved_by']!, _approvedByMeta));
    }
    if (data.containsKey('approved_at')) {
      context.handle(
          _approvedAtMeta,
          approvedAt.isAcceptableOrUnknown(
              data['approved_at']!, _approvedAtMeta));
    }
    if (data.containsKey('void_reason')) {
      context.handle(
          _voidReasonMeta,
          voidReason.isAcceptableOrUnknown(
              data['void_reason']!, _voidReasonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {periodKey, version},
      ];
  @override
  PayrollRunRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayrollRunRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      periodKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}period_key'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      rulesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rules_json']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      approvedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}approved_by']),
      approvedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}approved_at']),
      voidReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}void_reason']),
    );
  }

  @override
  $PayrollRunsTable createAlias(String alias) {
    return $PayrollRunsTable(attachedDatabase, alias);
  }
}

class PayrollRunRow extends DataClass implements Insertable<PayrollRunRow> {
  final String id;
  final String periodKey;
  final int version;

  /// draft | approved | partially_paid | paid | voided
  final String status;
  final String? rulesJson;
  final String createdBy;
  final DateTime createdAt;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? voidReason;
  const PayrollRunRow(
      {required this.id,
      required this.periodKey,
      required this.version,
      required this.status,
      this.rulesJson,
      required this.createdBy,
      required this.createdAt,
      this.approvedBy,
      this.approvedAt,
      this.voidReason});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['period_key'] = Variable<String>(periodKey);
    map['version'] = Variable<int>(version);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || rulesJson != null) {
      map['rules_json'] = Variable<String>(rulesJson);
    }
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || approvedBy != null) {
      map['approved_by'] = Variable<String>(approvedBy);
    }
    if (!nullToAbsent || approvedAt != null) {
      map['approved_at'] = Variable<DateTime>(approvedAt);
    }
    if (!nullToAbsent || voidReason != null) {
      map['void_reason'] = Variable<String>(voidReason);
    }
    return map;
  }

  PayrollRunsCompanion toCompanion(bool nullToAbsent) {
    return PayrollRunsCompanion(
      id: Value(id),
      periodKey: Value(periodKey),
      version: Value(version),
      status: Value(status),
      rulesJson: rulesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(rulesJson),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      approvedBy: approvedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedBy),
      approvedAt: approvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedAt),
      voidReason: voidReason == null && nullToAbsent
          ? const Value.absent()
          : Value(voidReason),
    );
  }

  factory PayrollRunRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayrollRunRow(
      id: serializer.fromJson<String>(json['id']),
      periodKey: serializer.fromJson<String>(json['periodKey']),
      version: serializer.fromJson<int>(json['version']),
      status: serializer.fromJson<String>(json['status']),
      rulesJson: serializer.fromJson<String?>(json['rulesJson']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      approvedBy: serializer.fromJson<String?>(json['approvedBy']),
      approvedAt: serializer.fromJson<DateTime?>(json['approvedAt']),
      voidReason: serializer.fromJson<String?>(json['voidReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'periodKey': serializer.toJson<String>(periodKey),
      'version': serializer.toJson<int>(version),
      'status': serializer.toJson<String>(status),
      'rulesJson': serializer.toJson<String?>(rulesJson),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'approvedBy': serializer.toJson<String?>(approvedBy),
      'approvedAt': serializer.toJson<DateTime?>(approvedAt),
      'voidReason': serializer.toJson<String?>(voidReason),
    };
  }

  PayrollRunRow copyWith(
          {String? id,
          String? periodKey,
          int? version,
          String? status,
          Value<String?> rulesJson = const Value.absent(),
          String? createdBy,
          DateTime? createdAt,
          Value<String?> approvedBy = const Value.absent(),
          Value<DateTime?> approvedAt = const Value.absent(),
          Value<String?> voidReason = const Value.absent()}) =>
      PayrollRunRow(
        id: id ?? this.id,
        periodKey: periodKey ?? this.periodKey,
        version: version ?? this.version,
        status: status ?? this.status,
        rulesJson: rulesJson.present ? rulesJson.value : this.rulesJson,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        approvedBy: approvedBy.present ? approvedBy.value : this.approvedBy,
        approvedAt: approvedAt.present ? approvedAt.value : this.approvedAt,
        voidReason: voidReason.present ? voidReason.value : this.voidReason,
      );
  PayrollRunRow copyWithCompanion(PayrollRunsCompanion data) {
    return PayrollRunRow(
      id: data.id.present ? data.id.value : this.id,
      periodKey: data.periodKey.present ? data.periodKey.value : this.periodKey,
      version: data.version.present ? data.version.value : this.version,
      status: data.status.present ? data.status.value : this.status,
      rulesJson: data.rulesJson.present ? data.rulesJson.value : this.rulesJson,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      approvedBy:
          data.approvedBy.present ? data.approvedBy.value : this.approvedBy,
      approvedAt:
          data.approvedAt.present ? data.approvedAt.value : this.approvedAt,
      voidReason:
          data.voidReason.present ? data.voidReason.value : this.voidReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayrollRunRow(')
          ..write('id: $id, ')
          ..write('periodKey: $periodKey, ')
          ..write('version: $version, ')
          ..write('status: $status, ')
          ..write('rulesJson: $rulesJson, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('voidReason: $voidReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, periodKey, version, status, rulesJson,
      createdBy, createdAt, approvedBy, approvedAt, voidReason);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayrollRunRow &&
          other.id == this.id &&
          other.periodKey == this.periodKey &&
          other.version == this.version &&
          other.status == this.status &&
          other.rulesJson == this.rulesJson &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.approvedBy == this.approvedBy &&
          other.approvedAt == this.approvedAt &&
          other.voidReason == this.voidReason);
}

class PayrollRunsCompanion extends UpdateCompanion<PayrollRunRow> {
  final Value<String> id;
  final Value<String> periodKey;
  final Value<int> version;
  final Value<String> status;
  final Value<String?> rulesJson;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<String?> approvedBy;
  final Value<DateTime?> approvedAt;
  final Value<String?> voidReason;
  final Value<int> rowid;
  const PayrollRunsCompanion({
    this.id = const Value.absent(),
    this.periodKey = const Value.absent(),
    this.version = const Value.absent(),
    this.status = const Value.absent(),
    this.rulesJson = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.approvedBy = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayrollRunsCompanion.insert({
    required String id,
    required String periodKey,
    this.version = const Value.absent(),
    required String status,
    this.rulesJson = const Value.absent(),
    required String createdBy,
    required DateTime createdAt,
    this.approvedBy = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.voidReason = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        periodKey = Value(periodKey),
        status = Value(status),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt);
  static Insertable<PayrollRunRow> custom({
    Expression<String>? id,
    Expression<String>? periodKey,
    Expression<int>? version,
    Expression<String>? status,
    Expression<String>? rulesJson,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<String>? approvedBy,
    Expression<DateTime>? approvedAt,
    Expression<String>? voidReason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (periodKey != null) 'period_key': periodKey,
      if (version != null) 'version': version,
      if (status != null) 'status': status,
      if (rulesJson != null) 'rules_json': rulesJson,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (approvedAt != null) 'approved_at': approvedAt,
      if (voidReason != null) 'void_reason': voidReason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayrollRunsCompanion copyWith(
      {Value<String>? id,
      Value<String>? periodKey,
      Value<int>? version,
      Value<String>? status,
      Value<String?>? rulesJson,
      Value<String>? createdBy,
      Value<DateTime>? createdAt,
      Value<String?>? approvedBy,
      Value<DateTime?>? approvedAt,
      Value<String?>? voidReason,
      Value<int>? rowid}) {
    return PayrollRunsCompanion(
      id: id ?? this.id,
      periodKey: periodKey ?? this.periodKey,
      version: version ?? this.version,
      status: status ?? this.status,
      rulesJson: rulesJson ?? this.rulesJson,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      voidReason: voidReason ?? this.voidReason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (periodKey.present) {
      map['period_key'] = Variable<String>(periodKey.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rulesJson.present) {
      map['rules_json'] = Variable<String>(rulesJson.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (approvedBy.present) {
      map['approved_by'] = Variable<String>(approvedBy.value);
    }
    if (approvedAt.present) {
      map['approved_at'] = Variable<DateTime>(approvedAt.value);
    }
    if (voidReason.present) {
      map['void_reason'] = Variable<String>(voidReason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayrollRunsCompanion(')
          ..write('id: $id, ')
          ..write('periodKey: $periodKey, ')
          ..write('version: $version, ')
          ..write('status: $status, ')
          ..write('rulesJson: $rulesJson, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('approvedBy: $approvedBy, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('voidReason: $voidReason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayrollLinesTable extends PayrollLines
    with TableInfo<$PayrollLinesTable, PayrollLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayrollLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<String> runId = GeneratedColumn<String>(
      'run_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES payroll_runs (id) ON DELETE CASCADE'));
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeNameMeta =
      const VerificationMeta('employeeName');
  @override
  late final GeneratedColumn<String> employeeName = GeneratedColumn<String>(
      'employee_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _salaryTypeMeta =
      const VerificationMeta('salaryType');
  @override
  late final GeneratedColumn<String> salaryType = GeneratedColumn<String>(
      'salary_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ratePaiseMeta =
      const VerificationMeta('ratePaise');
  @override
  late final GeneratedColumn<int> ratePaise = GeneratedColumn<int>(
      'rate_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _presentDaysMeta =
      const VerificationMeta('presentDays');
  @override
  late final GeneratedColumn<int> presentDays = GeneratedColumn<int>(
      'present_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _halfDaysMeta =
      const VerificationMeta('halfDays');
  @override
  late final GeneratedColumn<int> halfDays = GeneratedColumn<int>(
      'half_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _leaveDaysMeta =
      const VerificationMeta('leaveDays');
  @override
  late final GeneratedColumn<int> leaveDays = GeneratedColumn<int>(
      'leave_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _absentDaysMeta =
      const VerificationMeta('absentDays');
  @override
  late final GeneratedColumn<int> absentDays = GeneratedColumn<int>(
      'absent_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unmarkedDaysMeta =
      const VerificationMeta('unmarkedDays');
  @override
  late final GeneratedColumn<int> unmarkedDays = GeneratedColumn<int>(
      'unmarked_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _weeklyOffDaysMeta =
      const VerificationMeta('weeklyOffDays');
  @override
  late final GeneratedColumn<int> weeklyOffDays = GeneratedColumn<int>(
      'weekly_off_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _holidayDaysMeta =
      const VerificationMeta('holidayDays');
  @override
  late final GeneratedColumn<int> holidayDays = GeneratedColumn<int>(
      'holiday_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _payableUnitsBpMeta =
      const VerificationMeta('payableUnitsBp');
  @override
  late final GeneratedColumn<int> payableUnitsBp = GeneratedColumn<int>(
      'payable_units_bp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _basisDaysMeta =
      const VerificationMeta('basisDays');
  @override
  late final GeneratedColumn<int> basisDays = GeneratedColumn<int>(
      'basis_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _earningsPaiseMeta =
      const VerificationMeta('earningsPaise');
  @override
  late final GeneratedColumn<int> earningsPaise = GeneratedColumn<int>(
      'earnings_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _overtimeUnitsBpMeta =
      const VerificationMeta('overtimeUnitsBp');
  @override
  late final GeneratedColumn<int> overtimeUnitsBp = GeneratedColumn<int>(
      'overtime_units_bp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _overtimePaiseMeta =
      const VerificationMeta('overtimePaise');
  @override
  late final GeneratedColumn<int> overtimePaise = GeneratedColumn<int>(
      'overtime_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _bonusPaiseMeta =
      const VerificationMeta('bonusPaise');
  @override
  late final GeneratedColumn<int> bonusPaise = GeneratedColumn<int>(
      'bonus_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _deductionsPaiseMeta =
      const VerificationMeta('deductionsPaise');
  @override
  late final GeneratedColumn<int> deductionsPaise = GeneratedColumn<int>(
      'deductions_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _advancesPaiseMeta =
      const VerificationMeta('advancesPaise');
  @override
  late final GeneratedColumn<int> advancesPaise = GeneratedColumn<int>(
      'advances_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _grossPaiseMeta =
      const VerificationMeta('grossPaise');
  @override
  late final GeneratedColumn<int> grossPaise = GeneratedColumn<int>(
      'gross_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _netPaiseMeta =
      const VerificationMeta('netPaise');
  @override
  late final GeneratedColumn<int> netPaise = GeneratedColumn<int>(
      'net_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _carryForwardPaiseMeta =
      const VerificationMeta('carryForwardPaise');
  @override
  late final GeneratedColumn<int> carryForwardPaise = GeneratedColumn<int>(
      'carry_forward_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _paidPaiseMeta =
      const VerificationMeta('paidPaise');
  @override
  late final GeneratedColumn<int> paidPaise = GeneratedColumn<int>(
      'paid_paise', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        runId,
        employeeId,
        employeeName,
        salaryType,
        ratePaise,
        presentDays,
        halfDays,
        leaveDays,
        absentDays,
        unmarkedDays,
        weeklyOffDays,
        holidayDays,
        payableUnitsBp,
        basisDays,
        earningsPaise,
        overtimeUnitsBp,
        overtimePaise,
        bonusPaise,
        deductionsPaise,
        advancesPaise,
        grossPaise,
        netPaise,
        carryForwardPaise,
        paidPaise
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payroll_lines';
  @override
  VerificationContext validateIntegrity(Insertable<PayrollLineRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('run_id')) {
      context.handle(
          _runIdMeta, runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta));
    } else if (isInserting) {
      context.missing(_runIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('employee_name')) {
      context.handle(
          _employeeNameMeta,
          employeeName.isAcceptableOrUnknown(
              data['employee_name']!, _employeeNameMeta));
    } else if (isInserting) {
      context.missing(_employeeNameMeta);
    }
    if (data.containsKey('salary_type')) {
      context.handle(
          _salaryTypeMeta,
          salaryType.isAcceptableOrUnknown(
              data['salary_type']!, _salaryTypeMeta));
    } else if (isInserting) {
      context.missing(_salaryTypeMeta);
    }
    if (data.containsKey('rate_paise')) {
      context.handle(_ratePaiseMeta,
          ratePaise.isAcceptableOrUnknown(data['rate_paise']!, _ratePaiseMeta));
    } else if (isInserting) {
      context.missing(_ratePaiseMeta);
    }
    if (data.containsKey('present_days')) {
      context.handle(
          _presentDaysMeta,
          presentDays.isAcceptableOrUnknown(
              data['present_days']!, _presentDaysMeta));
    }
    if (data.containsKey('half_days')) {
      context.handle(_halfDaysMeta,
          halfDays.isAcceptableOrUnknown(data['half_days']!, _halfDaysMeta));
    }
    if (data.containsKey('leave_days')) {
      context.handle(_leaveDaysMeta,
          leaveDays.isAcceptableOrUnknown(data['leave_days']!, _leaveDaysMeta));
    }
    if (data.containsKey('absent_days')) {
      context.handle(
          _absentDaysMeta,
          absentDays.isAcceptableOrUnknown(
              data['absent_days']!, _absentDaysMeta));
    }
    if (data.containsKey('unmarked_days')) {
      context.handle(
          _unmarkedDaysMeta,
          unmarkedDays.isAcceptableOrUnknown(
              data['unmarked_days']!, _unmarkedDaysMeta));
    }
    if (data.containsKey('weekly_off_days')) {
      context.handle(
          _weeklyOffDaysMeta,
          weeklyOffDays.isAcceptableOrUnknown(
              data['weekly_off_days']!, _weeklyOffDaysMeta));
    }
    if (data.containsKey('holiday_days')) {
      context.handle(
          _holidayDaysMeta,
          holidayDays.isAcceptableOrUnknown(
              data['holiday_days']!, _holidayDaysMeta));
    }
    if (data.containsKey('payable_units_bp')) {
      context.handle(
          _payableUnitsBpMeta,
          payableUnitsBp.isAcceptableOrUnknown(
              data['payable_units_bp']!, _payableUnitsBpMeta));
    }
    if (data.containsKey('basis_days')) {
      context.handle(_basisDaysMeta,
          basisDays.isAcceptableOrUnknown(data['basis_days']!, _basisDaysMeta));
    }
    if (data.containsKey('earnings_paise')) {
      context.handle(
          _earningsPaiseMeta,
          earningsPaise.isAcceptableOrUnknown(
              data['earnings_paise']!, _earningsPaiseMeta));
    }
    if (data.containsKey('overtime_units_bp')) {
      context.handle(
          _overtimeUnitsBpMeta,
          overtimeUnitsBp.isAcceptableOrUnknown(
              data['overtime_units_bp']!, _overtimeUnitsBpMeta));
    }
    if (data.containsKey('overtime_paise')) {
      context.handle(
          _overtimePaiseMeta,
          overtimePaise.isAcceptableOrUnknown(
              data['overtime_paise']!, _overtimePaiseMeta));
    }
    if (data.containsKey('bonus_paise')) {
      context.handle(
          _bonusPaiseMeta,
          bonusPaise.isAcceptableOrUnknown(
              data['bonus_paise']!, _bonusPaiseMeta));
    }
    if (data.containsKey('deductions_paise')) {
      context.handle(
          _deductionsPaiseMeta,
          deductionsPaise.isAcceptableOrUnknown(
              data['deductions_paise']!, _deductionsPaiseMeta));
    }
    if (data.containsKey('advances_paise')) {
      context.handle(
          _advancesPaiseMeta,
          advancesPaise.isAcceptableOrUnknown(
              data['advances_paise']!, _advancesPaiseMeta));
    }
    if (data.containsKey('gross_paise')) {
      context.handle(
          _grossPaiseMeta,
          grossPaise.isAcceptableOrUnknown(
              data['gross_paise']!, _grossPaiseMeta));
    }
    if (data.containsKey('net_paise')) {
      context.handle(_netPaiseMeta,
          netPaise.isAcceptableOrUnknown(data['net_paise']!, _netPaiseMeta));
    }
    if (data.containsKey('carry_forward_paise')) {
      context.handle(
          _carryForwardPaiseMeta,
          carryForwardPaise.isAcceptableOrUnknown(
              data['carry_forward_paise']!, _carryForwardPaiseMeta));
    }
    if (data.containsKey('paid_paise')) {
      context.handle(_paidPaiseMeta,
          paidPaise.isAcceptableOrUnknown(data['paid_paise']!, _paidPaiseMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {runId, employeeId},
      ];
  @override
  PayrollLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayrollLineRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      runId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}run_id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      employeeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_name'])!,
      salaryType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salary_type'])!,
      ratePaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rate_paise'])!,
      presentDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}present_days'])!,
      halfDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}half_days'])!,
      leaveDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}leave_days'])!,
      absentDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}absent_days'])!,
      unmarkedDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unmarked_days'])!,
      weeklyOffDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekly_off_days'])!,
      holidayDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}holiday_days'])!,
      payableUnitsBp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}payable_units_bp'])!,
      basisDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}basis_days'])!,
      earningsPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}earnings_paise'])!,
      overtimeUnitsBp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}overtime_units_bp'])!,
      overtimePaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}overtime_paise'])!,
      bonusPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bonus_paise'])!,
      deductionsPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deductions_paise'])!,
      advancesPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}advances_paise'])!,
      grossPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gross_paise'])!,
      netPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}net_paise'])!,
      carryForwardPaise: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}carry_forward_paise'])!,
      paidPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paid_paise'])!,
    );
  }

  @override
  $PayrollLinesTable createAlias(String alias) {
    return $PayrollLinesTable(attachedDatabase, alias);
  }
}

class PayrollLineRow extends DataClass implements Insertable<PayrollLineRow> {
  final String id;
  final String runId;
  final String employeeId;
  final String employeeName;
  final String salaryType;
  final int ratePaise;
  final int presentDays;
  final int halfDays;
  final int leaveDays;
  final int absentDays;
  final int unmarkedDays;
  final int weeklyOffDays;
  final int holidayDays;
  final int payableUnitsBp;
  final int basisDays;
  final int earningsPaise;
  final int overtimeUnitsBp;
  final int overtimePaise;
  final int bonusPaise;
  final int deductionsPaise;
  final int advancesPaise;
  final int grossPaise;
  final int netPaise;
  final int carryForwardPaise;
  final int paidPaise;
  const PayrollLineRow(
      {required this.id,
      required this.runId,
      required this.employeeId,
      required this.employeeName,
      required this.salaryType,
      required this.ratePaise,
      required this.presentDays,
      required this.halfDays,
      required this.leaveDays,
      required this.absentDays,
      required this.unmarkedDays,
      required this.weeklyOffDays,
      required this.holidayDays,
      required this.payableUnitsBp,
      required this.basisDays,
      required this.earningsPaise,
      required this.overtimeUnitsBp,
      required this.overtimePaise,
      required this.bonusPaise,
      required this.deductionsPaise,
      required this.advancesPaise,
      required this.grossPaise,
      required this.netPaise,
      required this.carryForwardPaise,
      required this.paidPaise});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['run_id'] = Variable<String>(runId);
    map['employee_id'] = Variable<String>(employeeId);
    map['employee_name'] = Variable<String>(employeeName);
    map['salary_type'] = Variable<String>(salaryType);
    map['rate_paise'] = Variable<int>(ratePaise);
    map['present_days'] = Variable<int>(presentDays);
    map['half_days'] = Variable<int>(halfDays);
    map['leave_days'] = Variable<int>(leaveDays);
    map['absent_days'] = Variable<int>(absentDays);
    map['unmarked_days'] = Variable<int>(unmarkedDays);
    map['weekly_off_days'] = Variable<int>(weeklyOffDays);
    map['holiday_days'] = Variable<int>(holidayDays);
    map['payable_units_bp'] = Variable<int>(payableUnitsBp);
    map['basis_days'] = Variable<int>(basisDays);
    map['earnings_paise'] = Variable<int>(earningsPaise);
    map['overtime_units_bp'] = Variable<int>(overtimeUnitsBp);
    map['overtime_paise'] = Variable<int>(overtimePaise);
    map['bonus_paise'] = Variable<int>(bonusPaise);
    map['deductions_paise'] = Variable<int>(deductionsPaise);
    map['advances_paise'] = Variable<int>(advancesPaise);
    map['gross_paise'] = Variable<int>(grossPaise);
    map['net_paise'] = Variable<int>(netPaise);
    map['carry_forward_paise'] = Variable<int>(carryForwardPaise);
    map['paid_paise'] = Variable<int>(paidPaise);
    return map;
  }

  PayrollLinesCompanion toCompanion(bool nullToAbsent) {
    return PayrollLinesCompanion(
      id: Value(id),
      runId: Value(runId),
      employeeId: Value(employeeId),
      employeeName: Value(employeeName),
      salaryType: Value(salaryType),
      ratePaise: Value(ratePaise),
      presentDays: Value(presentDays),
      halfDays: Value(halfDays),
      leaveDays: Value(leaveDays),
      absentDays: Value(absentDays),
      unmarkedDays: Value(unmarkedDays),
      weeklyOffDays: Value(weeklyOffDays),
      holidayDays: Value(holidayDays),
      payableUnitsBp: Value(payableUnitsBp),
      basisDays: Value(basisDays),
      earningsPaise: Value(earningsPaise),
      overtimeUnitsBp: Value(overtimeUnitsBp),
      overtimePaise: Value(overtimePaise),
      bonusPaise: Value(bonusPaise),
      deductionsPaise: Value(deductionsPaise),
      advancesPaise: Value(advancesPaise),
      grossPaise: Value(grossPaise),
      netPaise: Value(netPaise),
      carryForwardPaise: Value(carryForwardPaise),
      paidPaise: Value(paidPaise),
    );
  }

  factory PayrollLineRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayrollLineRow(
      id: serializer.fromJson<String>(json['id']),
      runId: serializer.fromJson<String>(json['runId']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      employeeName: serializer.fromJson<String>(json['employeeName']),
      salaryType: serializer.fromJson<String>(json['salaryType']),
      ratePaise: serializer.fromJson<int>(json['ratePaise']),
      presentDays: serializer.fromJson<int>(json['presentDays']),
      halfDays: serializer.fromJson<int>(json['halfDays']),
      leaveDays: serializer.fromJson<int>(json['leaveDays']),
      absentDays: serializer.fromJson<int>(json['absentDays']),
      unmarkedDays: serializer.fromJson<int>(json['unmarkedDays']),
      weeklyOffDays: serializer.fromJson<int>(json['weeklyOffDays']),
      holidayDays: serializer.fromJson<int>(json['holidayDays']),
      payableUnitsBp: serializer.fromJson<int>(json['payableUnitsBp']),
      basisDays: serializer.fromJson<int>(json['basisDays']),
      earningsPaise: serializer.fromJson<int>(json['earningsPaise']),
      overtimeUnitsBp: serializer.fromJson<int>(json['overtimeUnitsBp']),
      overtimePaise: serializer.fromJson<int>(json['overtimePaise']),
      bonusPaise: serializer.fromJson<int>(json['bonusPaise']),
      deductionsPaise: serializer.fromJson<int>(json['deductionsPaise']),
      advancesPaise: serializer.fromJson<int>(json['advancesPaise']),
      grossPaise: serializer.fromJson<int>(json['grossPaise']),
      netPaise: serializer.fromJson<int>(json['netPaise']),
      carryForwardPaise: serializer.fromJson<int>(json['carryForwardPaise']),
      paidPaise: serializer.fromJson<int>(json['paidPaise']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'runId': serializer.toJson<String>(runId),
      'employeeId': serializer.toJson<String>(employeeId),
      'employeeName': serializer.toJson<String>(employeeName),
      'salaryType': serializer.toJson<String>(salaryType),
      'ratePaise': serializer.toJson<int>(ratePaise),
      'presentDays': serializer.toJson<int>(presentDays),
      'halfDays': serializer.toJson<int>(halfDays),
      'leaveDays': serializer.toJson<int>(leaveDays),
      'absentDays': serializer.toJson<int>(absentDays),
      'unmarkedDays': serializer.toJson<int>(unmarkedDays),
      'weeklyOffDays': serializer.toJson<int>(weeklyOffDays),
      'holidayDays': serializer.toJson<int>(holidayDays),
      'payableUnitsBp': serializer.toJson<int>(payableUnitsBp),
      'basisDays': serializer.toJson<int>(basisDays),
      'earningsPaise': serializer.toJson<int>(earningsPaise),
      'overtimeUnitsBp': serializer.toJson<int>(overtimeUnitsBp),
      'overtimePaise': serializer.toJson<int>(overtimePaise),
      'bonusPaise': serializer.toJson<int>(bonusPaise),
      'deductionsPaise': serializer.toJson<int>(deductionsPaise),
      'advancesPaise': serializer.toJson<int>(advancesPaise),
      'grossPaise': serializer.toJson<int>(grossPaise),
      'netPaise': serializer.toJson<int>(netPaise),
      'carryForwardPaise': serializer.toJson<int>(carryForwardPaise),
      'paidPaise': serializer.toJson<int>(paidPaise),
    };
  }

  PayrollLineRow copyWith(
          {String? id,
          String? runId,
          String? employeeId,
          String? employeeName,
          String? salaryType,
          int? ratePaise,
          int? presentDays,
          int? halfDays,
          int? leaveDays,
          int? absentDays,
          int? unmarkedDays,
          int? weeklyOffDays,
          int? holidayDays,
          int? payableUnitsBp,
          int? basisDays,
          int? earningsPaise,
          int? overtimeUnitsBp,
          int? overtimePaise,
          int? bonusPaise,
          int? deductionsPaise,
          int? advancesPaise,
          int? grossPaise,
          int? netPaise,
          int? carryForwardPaise,
          int? paidPaise}) =>
      PayrollLineRow(
        id: id ?? this.id,
        runId: runId ?? this.runId,
        employeeId: employeeId ?? this.employeeId,
        employeeName: employeeName ?? this.employeeName,
        salaryType: salaryType ?? this.salaryType,
        ratePaise: ratePaise ?? this.ratePaise,
        presentDays: presentDays ?? this.presentDays,
        halfDays: halfDays ?? this.halfDays,
        leaveDays: leaveDays ?? this.leaveDays,
        absentDays: absentDays ?? this.absentDays,
        unmarkedDays: unmarkedDays ?? this.unmarkedDays,
        weeklyOffDays: weeklyOffDays ?? this.weeklyOffDays,
        holidayDays: holidayDays ?? this.holidayDays,
        payableUnitsBp: payableUnitsBp ?? this.payableUnitsBp,
        basisDays: basisDays ?? this.basisDays,
        earningsPaise: earningsPaise ?? this.earningsPaise,
        overtimeUnitsBp: overtimeUnitsBp ?? this.overtimeUnitsBp,
        overtimePaise: overtimePaise ?? this.overtimePaise,
        bonusPaise: bonusPaise ?? this.bonusPaise,
        deductionsPaise: deductionsPaise ?? this.deductionsPaise,
        advancesPaise: advancesPaise ?? this.advancesPaise,
        grossPaise: grossPaise ?? this.grossPaise,
        netPaise: netPaise ?? this.netPaise,
        carryForwardPaise: carryForwardPaise ?? this.carryForwardPaise,
        paidPaise: paidPaise ?? this.paidPaise,
      );
  PayrollLineRow copyWithCompanion(PayrollLinesCompanion data) {
    return PayrollLineRow(
      id: data.id.present ? data.id.value : this.id,
      runId: data.runId.present ? data.runId.value : this.runId,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      employeeName: data.employeeName.present
          ? data.employeeName.value
          : this.employeeName,
      salaryType:
          data.salaryType.present ? data.salaryType.value : this.salaryType,
      ratePaise: data.ratePaise.present ? data.ratePaise.value : this.ratePaise,
      presentDays:
          data.presentDays.present ? data.presentDays.value : this.presentDays,
      halfDays: data.halfDays.present ? data.halfDays.value : this.halfDays,
      leaveDays: data.leaveDays.present ? data.leaveDays.value : this.leaveDays,
      absentDays:
          data.absentDays.present ? data.absentDays.value : this.absentDays,
      unmarkedDays: data.unmarkedDays.present
          ? data.unmarkedDays.value
          : this.unmarkedDays,
      weeklyOffDays: data.weeklyOffDays.present
          ? data.weeklyOffDays.value
          : this.weeklyOffDays,
      holidayDays:
          data.holidayDays.present ? data.holidayDays.value : this.holidayDays,
      payableUnitsBp: data.payableUnitsBp.present
          ? data.payableUnitsBp.value
          : this.payableUnitsBp,
      basisDays: data.basisDays.present ? data.basisDays.value : this.basisDays,
      earningsPaise: data.earningsPaise.present
          ? data.earningsPaise.value
          : this.earningsPaise,
      overtimeUnitsBp: data.overtimeUnitsBp.present
          ? data.overtimeUnitsBp.value
          : this.overtimeUnitsBp,
      overtimePaise: data.overtimePaise.present
          ? data.overtimePaise.value
          : this.overtimePaise,
      bonusPaise:
          data.bonusPaise.present ? data.bonusPaise.value : this.bonusPaise,
      deductionsPaise: data.deductionsPaise.present
          ? data.deductionsPaise.value
          : this.deductionsPaise,
      advancesPaise: data.advancesPaise.present
          ? data.advancesPaise.value
          : this.advancesPaise,
      grossPaise:
          data.grossPaise.present ? data.grossPaise.value : this.grossPaise,
      netPaise: data.netPaise.present ? data.netPaise.value : this.netPaise,
      carryForwardPaise: data.carryForwardPaise.present
          ? data.carryForwardPaise.value
          : this.carryForwardPaise,
      paidPaise: data.paidPaise.present ? data.paidPaise.value : this.paidPaise,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayrollLineRow(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('employeeId: $employeeId, ')
          ..write('employeeName: $employeeName, ')
          ..write('salaryType: $salaryType, ')
          ..write('ratePaise: $ratePaise, ')
          ..write('presentDays: $presentDays, ')
          ..write('halfDays: $halfDays, ')
          ..write('leaveDays: $leaveDays, ')
          ..write('absentDays: $absentDays, ')
          ..write('unmarkedDays: $unmarkedDays, ')
          ..write('weeklyOffDays: $weeklyOffDays, ')
          ..write('holidayDays: $holidayDays, ')
          ..write('payableUnitsBp: $payableUnitsBp, ')
          ..write('basisDays: $basisDays, ')
          ..write('earningsPaise: $earningsPaise, ')
          ..write('overtimeUnitsBp: $overtimeUnitsBp, ')
          ..write('overtimePaise: $overtimePaise, ')
          ..write('bonusPaise: $bonusPaise, ')
          ..write('deductionsPaise: $deductionsPaise, ')
          ..write('advancesPaise: $advancesPaise, ')
          ..write('grossPaise: $grossPaise, ')
          ..write('netPaise: $netPaise, ')
          ..write('carryForwardPaise: $carryForwardPaise, ')
          ..write('paidPaise: $paidPaise')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        runId,
        employeeId,
        employeeName,
        salaryType,
        ratePaise,
        presentDays,
        halfDays,
        leaveDays,
        absentDays,
        unmarkedDays,
        weeklyOffDays,
        holidayDays,
        payableUnitsBp,
        basisDays,
        earningsPaise,
        overtimeUnitsBp,
        overtimePaise,
        bonusPaise,
        deductionsPaise,
        advancesPaise,
        grossPaise,
        netPaise,
        carryForwardPaise,
        paidPaise
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayrollLineRow &&
          other.id == this.id &&
          other.runId == this.runId &&
          other.employeeId == this.employeeId &&
          other.employeeName == this.employeeName &&
          other.salaryType == this.salaryType &&
          other.ratePaise == this.ratePaise &&
          other.presentDays == this.presentDays &&
          other.halfDays == this.halfDays &&
          other.leaveDays == this.leaveDays &&
          other.absentDays == this.absentDays &&
          other.unmarkedDays == this.unmarkedDays &&
          other.weeklyOffDays == this.weeklyOffDays &&
          other.holidayDays == this.holidayDays &&
          other.payableUnitsBp == this.payableUnitsBp &&
          other.basisDays == this.basisDays &&
          other.earningsPaise == this.earningsPaise &&
          other.overtimeUnitsBp == this.overtimeUnitsBp &&
          other.overtimePaise == this.overtimePaise &&
          other.bonusPaise == this.bonusPaise &&
          other.deductionsPaise == this.deductionsPaise &&
          other.advancesPaise == this.advancesPaise &&
          other.grossPaise == this.grossPaise &&
          other.netPaise == this.netPaise &&
          other.carryForwardPaise == this.carryForwardPaise &&
          other.paidPaise == this.paidPaise);
}

class PayrollLinesCompanion extends UpdateCompanion<PayrollLineRow> {
  final Value<String> id;
  final Value<String> runId;
  final Value<String> employeeId;
  final Value<String> employeeName;
  final Value<String> salaryType;
  final Value<int> ratePaise;
  final Value<int> presentDays;
  final Value<int> halfDays;
  final Value<int> leaveDays;
  final Value<int> absentDays;
  final Value<int> unmarkedDays;
  final Value<int> weeklyOffDays;
  final Value<int> holidayDays;
  final Value<int> payableUnitsBp;
  final Value<int> basisDays;
  final Value<int> earningsPaise;
  final Value<int> overtimeUnitsBp;
  final Value<int> overtimePaise;
  final Value<int> bonusPaise;
  final Value<int> deductionsPaise;
  final Value<int> advancesPaise;
  final Value<int> grossPaise;
  final Value<int> netPaise;
  final Value<int> carryForwardPaise;
  final Value<int> paidPaise;
  final Value<int> rowid;
  const PayrollLinesCompanion({
    this.id = const Value.absent(),
    this.runId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.employeeName = const Value.absent(),
    this.salaryType = const Value.absent(),
    this.ratePaise = const Value.absent(),
    this.presentDays = const Value.absent(),
    this.halfDays = const Value.absent(),
    this.leaveDays = const Value.absent(),
    this.absentDays = const Value.absent(),
    this.unmarkedDays = const Value.absent(),
    this.weeklyOffDays = const Value.absent(),
    this.holidayDays = const Value.absent(),
    this.payableUnitsBp = const Value.absent(),
    this.basisDays = const Value.absent(),
    this.earningsPaise = const Value.absent(),
    this.overtimeUnitsBp = const Value.absent(),
    this.overtimePaise = const Value.absent(),
    this.bonusPaise = const Value.absent(),
    this.deductionsPaise = const Value.absent(),
    this.advancesPaise = const Value.absent(),
    this.grossPaise = const Value.absent(),
    this.netPaise = const Value.absent(),
    this.carryForwardPaise = const Value.absent(),
    this.paidPaise = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayrollLinesCompanion.insert({
    required String id,
    required String runId,
    required String employeeId,
    required String employeeName,
    required String salaryType,
    required int ratePaise,
    this.presentDays = const Value.absent(),
    this.halfDays = const Value.absent(),
    this.leaveDays = const Value.absent(),
    this.absentDays = const Value.absent(),
    this.unmarkedDays = const Value.absent(),
    this.weeklyOffDays = const Value.absent(),
    this.holidayDays = const Value.absent(),
    this.payableUnitsBp = const Value.absent(),
    this.basisDays = const Value.absent(),
    this.earningsPaise = const Value.absent(),
    this.overtimeUnitsBp = const Value.absent(),
    this.overtimePaise = const Value.absent(),
    this.bonusPaise = const Value.absent(),
    this.deductionsPaise = const Value.absent(),
    this.advancesPaise = const Value.absent(),
    this.grossPaise = const Value.absent(),
    this.netPaise = const Value.absent(),
    this.carryForwardPaise = const Value.absent(),
    this.paidPaise = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        runId = Value(runId),
        employeeId = Value(employeeId),
        employeeName = Value(employeeName),
        salaryType = Value(salaryType),
        ratePaise = Value(ratePaise);
  static Insertable<PayrollLineRow> custom({
    Expression<String>? id,
    Expression<String>? runId,
    Expression<String>? employeeId,
    Expression<String>? employeeName,
    Expression<String>? salaryType,
    Expression<int>? ratePaise,
    Expression<int>? presentDays,
    Expression<int>? halfDays,
    Expression<int>? leaveDays,
    Expression<int>? absentDays,
    Expression<int>? unmarkedDays,
    Expression<int>? weeklyOffDays,
    Expression<int>? holidayDays,
    Expression<int>? payableUnitsBp,
    Expression<int>? basisDays,
    Expression<int>? earningsPaise,
    Expression<int>? overtimeUnitsBp,
    Expression<int>? overtimePaise,
    Expression<int>? bonusPaise,
    Expression<int>? deductionsPaise,
    Expression<int>? advancesPaise,
    Expression<int>? grossPaise,
    Expression<int>? netPaise,
    Expression<int>? carryForwardPaise,
    Expression<int>? paidPaise,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (runId != null) 'run_id': runId,
      if (employeeId != null) 'employee_id': employeeId,
      if (employeeName != null) 'employee_name': employeeName,
      if (salaryType != null) 'salary_type': salaryType,
      if (ratePaise != null) 'rate_paise': ratePaise,
      if (presentDays != null) 'present_days': presentDays,
      if (halfDays != null) 'half_days': halfDays,
      if (leaveDays != null) 'leave_days': leaveDays,
      if (absentDays != null) 'absent_days': absentDays,
      if (unmarkedDays != null) 'unmarked_days': unmarkedDays,
      if (weeklyOffDays != null) 'weekly_off_days': weeklyOffDays,
      if (holidayDays != null) 'holiday_days': holidayDays,
      if (payableUnitsBp != null) 'payable_units_bp': payableUnitsBp,
      if (basisDays != null) 'basis_days': basisDays,
      if (earningsPaise != null) 'earnings_paise': earningsPaise,
      if (overtimeUnitsBp != null) 'overtime_units_bp': overtimeUnitsBp,
      if (overtimePaise != null) 'overtime_paise': overtimePaise,
      if (bonusPaise != null) 'bonus_paise': bonusPaise,
      if (deductionsPaise != null) 'deductions_paise': deductionsPaise,
      if (advancesPaise != null) 'advances_paise': advancesPaise,
      if (grossPaise != null) 'gross_paise': grossPaise,
      if (netPaise != null) 'net_paise': netPaise,
      if (carryForwardPaise != null) 'carry_forward_paise': carryForwardPaise,
      if (paidPaise != null) 'paid_paise': paidPaise,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayrollLinesCompanion copyWith(
      {Value<String>? id,
      Value<String>? runId,
      Value<String>? employeeId,
      Value<String>? employeeName,
      Value<String>? salaryType,
      Value<int>? ratePaise,
      Value<int>? presentDays,
      Value<int>? halfDays,
      Value<int>? leaveDays,
      Value<int>? absentDays,
      Value<int>? unmarkedDays,
      Value<int>? weeklyOffDays,
      Value<int>? holidayDays,
      Value<int>? payableUnitsBp,
      Value<int>? basisDays,
      Value<int>? earningsPaise,
      Value<int>? overtimeUnitsBp,
      Value<int>? overtimePaise,
      Value<int>? bonusPaise,
      Value<int>? deductionsPaise,
      Value<int>? advancesPaise,
      Value<int>? grossPaise,
      Value<int>? netPaise,
      Value<int>? carryForwardPaise,
      Value<int>? paidPaise,
      Value<int>? rowid}) {
    return PayrollLinesCompanion(
      id: id ?? this.id,
      runId: runId ?? this.runId,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      salaryType: salaryType ?? this.salaryType,
      ratePaise: ratePaise ?? this.ratePaise,
      presentDays: presentDays ?? this.presentDays,
      halfDays: halfDays ?? this.halfDays,
      leaveDays: leaveDays ?? this.leaveDays,
      absentDays: absentDays ?? this.absentDays,
      unmarkedDays: unmarkedDays ?? this.unmarkedDays,
      weeklyOffDays: weeklyOffDays ?? this.weeklyOffDays,
      holidayDays: holidayDays ?? this.holidayDays,
      payableUnitsBp: payableUnitsBp ?? this.payableUnitsBp,
      basisDays: basisDays ?? this.basisDays,
      earningsPaise: earningsPaise ?? this.earningsPaise,
      overtimeUnitsBp: overtimeUnitsBp ?? this.overtimeUnitsBp,
      overtimePaise: overtimePaise ?? this.overtimePaise,
      bonusPaise: bonusPaise ?? this.bonusPaise,
      deductionsPaise: deductionsPaise ?? this.deductionsPaise,
      advancesPaise: advancesPaise ?? this.advancesPaise,
      grossPaise: grossPaise ?? this.grossPaise,
      netPaise: netPaise ?? this.netPaise,
      carryForwardPaise: carryForwardPaise ?? this.carryForwardPaise,
      paidPaise: paidPaise ?? this.paidPaise,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (runId.present) {
      map['run_id'] = Variable<String>(runId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (employeeName.present) {
      map['employee_name'] = Variable<String>(employeeName.value);
    }
    if (salaryType.present) {
      map['salary_type'] = Variable<String>(salaryType.value);
    }
    if (ratePaise.present) {
      map['rate_paise'] = Variable<int>(ratePaise.value);
    }
    if (presentDays.present) {
      map['present_days'] = Variable<int>(presentDays.value);
    }
    if (halfDays.present) {
      map['half_days'] = Variable<int>(halfDays.value);
    }
    if (leaveDays.present) {
      map['leave_days'] = Variable<int>(leaveDays.value);
    }
    if (absentDays.present) {
      map['absent_days'] = Variable<int>(absentDays.value);
    }
    if (unmarkedDays.present) {
      map['unmarked_days'] = Variable<int>(unmarkedDays.value);
    }
    if (weeklyOffDays.present) {
      map['weekly_off_days'] = Variable<int>(weeklyOffDays.value);
    }
    if (holidayDays.present) {
      map['holiday_days'] = Variable<int>(holidayDays.value);
    }
    if (payableUnitsBp.present) {
      map['payable_units_bp'] = Variable<int>(payableUnitsBp.value);
    }
    if (basisDays.present) {
      map['basis_days'] = Variable<int>(basisDays.value);
    }
    if (earningsPaise.present) {
      map['earnings_paise'] = Variable<int>(earningsPaise.value);
    }
    if (overtimeUnitsBp.present) {
      map['overtime_units_bp'] = Variable<int>(overtimeUnitsBp.value);
    }
    if (overtimePaise.present) {
      map['overtime_paise'] = Variable<int>(overtimePaise.value);
    }
    if (bonusPaise.present) {
      map['bonus_paise'] = Variable<int>(bonusPaise.value);
    }
    if (deductionsPaise.present) {
      map['deductions_paise'] = Variable<int>(deductionsPaise.value);
    }
    if (advancesPaise.present) {
      map['advances_paise'] = Variable<int>(advancesPaise.value);
    }
    if (grossPaise.present) {
      map['gross_paise'] = Variable<int>(grossPaise.value);
    }
    if (netPaise.present) {
      map['net_paise'] = Variable<int>(netPaise.value);
    }
    if (carryForwardPaise.present) {
      map['carry_forward_paise'] = Variable<int>(carryForwardPaise.value);
    }
    if (paidPaise.present) {
      map['paid_paise'] = Variable<int>(paidPaise.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayrollLinesCompanion(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('employeeId: $employeeId, ')
          ..write('employeeName: $employeeName, ')
          ..write('salaryType: $salaryType, ')
          ..write('ratePaise: $ratePaise, ')
          ..write('presentDays: $presentDays, ')
          ..write('halfDays: $halfDays, ')
          ..write('leaveDays: $leaveDays, ')
          ..write('absentDays: $absentDays, ')
          ..write('unmarkedDays: $unmarkedDays, ')
          ..write('weeklyOffDays: $weeklyOffDays, ')
          ..write('holidayDays: $holidayDays, ')
          ..write('payableUnitsBp: $payableUnitsBp, ')
          ..write('basisDays: $basisDays, ')
          ..write('earningsPaise: $earningsPaise, ')
          ..write('overtimeUnitsBp: $overtimeUnitsBp, ')
          ..write('overtimePaise: $overtimePaise, ')
          ..write('bonusPaise: $bonusPaise, ')
          ..write('deductionsPaise: $deductionsPaise, ')
          ..write('advancesPaise: $advancesPaise, ')
          ..write('grossPaise: $grossPaise, ')
          ..write('netPaise: $netPaise, ')
          ..write('carryForwardPaise: $carryForwardPaise, ')
          ..write('paidPaise: $paidPaise, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayrollAdjustmentsTable extends PayrollAdjustments
    with TableInfo<$PayrollAdjustmentsTable, PayrollAdjustmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayrollAdjustmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<String> runId = GeneratedColumn<String>(
      'run_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES payroll_runs (id) ON DELETE CASCADE'));
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<String> lineId = GeneratedColumn<String>(
      'line_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES payroll_lines (id) ON DELETE CASCADE'));
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPaiseMeta =
      const VerificationMeta('amountPaise');
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
      'amount_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, runId, lineId, kind, amountPaise, label, createdBy, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payroll_adjustments';
  @override
  VerificationContext validateIntegrity(
      Insertable<PayrollAdjustmentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('run_id')) {
      context.handle(
          _runIdMeta, runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta));
    } else if (isInserting) {
      context.missing(_runIdMeta);
    }
    if (data.containsKey('line_id')) {
      context.handle(_lineIdMeta,
          lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta));
    } else if (isInserting) {
      context.missing(_lineIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
          _amountPaiseMeta,
          amountPaise.isAcceptableOrUnknown(
              data['amount_paise']!, _amountPaiseMeta));
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PayrollAdjustmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayrollAdjustmentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      runId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}run_id'])!,
      lineId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}line_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      amountPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paise'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PayrollAdjustmentsTable createAlias(String alias) {
    return $PayrollAdjustmentsTable(attachedDatabase, alias);
  }
}

class PayrollAdjustmentRow extends DataClass
    implements Insertable<PayrollAdjustmentRow> {
  final String id;
  final String runId;
  final String lineId;
  final String kind;
  final int amountPaise;
  final String label;
  final String createdBy;
  final DateTime createdAt;
  const PayrollAdjustmentRow(
      {required this.id,
      required this.runId,
      required this.lineId,
      required this.kind,
      required this.amountPaise,
      required this.label,
      required this.createdBy,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['run_id'] = Variable<String>(runId);
    map['line_id'] = Variable<String>(lineId);
    map['kind'] = Variable<String>(kind);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['label'] = Variable<String>(label);
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PayrollAdjustmentsCompanion toCompanion(bool nullToAbsent) {
    return PayrollAdjustmentsCompanion(
      id: Value(id),
      runId: Value(runId),
      lineId: Value(lineId),
      kind: Value(kind),
      amountPaise: Value(amountPaise),
      label: Value(label),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
    );
  }

  factory PayrollAdjustmentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayrollAdjustmentRow(
      id: serializer.fromJson<String>(json['id']),
      runId: serializer.fromJson<String>(json['runId']),
      lineId: serializer.fromJson<String>(json['lineId']),
      kind: serializer.fromJson<String>(json['kind']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      label: serializer.fromJson<String>(json['label']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'runId': serializer.toJson<String>(runId),
      'lineId': serializer.toJson<String>(lineId),
      'kind': serializer.toJson<String>(kind),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'label': serializer.toJson<String>(label),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PayrollAdjustmentRow copyWith(
          {String? id,
          String? runId,
          String? lineId,
          String? kind,
          int? amountPaise,
          String? label,
          String? createdBy,
          DateTime? createdAt}) =>
      PayrollAdjustmentRow(
        id: id ?? this.id,
        runId: runId ?? this.runId,
        lineId: lineId ?? this.lineId,
        kind: kind ?? this.kind,
        amountPaise: amountPaise ?? this.amountPaise,
        label: label ?? this.label,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
      );
  PayrollAdjustmentRow copyWithCompanion(PayrollAdjustmentsCompanion data) {
    return PayrollAdjustmentRow(
      id: data.id.present ? data.id.value : this.id,
      runId: data.runId.present ? data.runId.value : this.runId,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      kind: data.kind.present ? data.kind.value : this.kind,
      amountPaise:
          data.amountPaise.present ? data.amountPaise.value : this.amountPaise,
      label: data.label.present ? data.label.value : this.label,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayrollAdjustmentRow(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('lineId: $lineId, ')
          ..write('kind: $kind, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('label: $label, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, runId, lineId, kind, amountPaise, label, createdBy, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayrollAdjustmentRow &&
          other.id == this.id &&
          other.runId == this.runId &&
          other.lineId == this.lineId &&
          other.kind == this.kind &&
          other.amountPaise == this.amountPaise &&
          other.label == this.label &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt);
}

class PayrollAdjustmentsCompanion
    extends UpdateCompanion<PayrollAdjustmentRow> {
  final Value<String> id;
  final Value<String> runId;
  final Value<String> lineId;
  final Value<String> kind;
  final Value<int> amountPaise;
  final Value<String> label;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PayrollAdjustmentsCompanion({
    this.id = const Value.absent(),
    this.runId = const Value.absent(),
    this.lineId = const Value.absent(),
    this.kind = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.label = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayrollAdjustmentsCompanion.insert({
    required String id,
    required String runId,
    required String lineId,
    required String kind,
    required int amountPaise,
    required String label,
    required String createdBy,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        runId = Value(runId),
        lineId = Value(lineId),
        kind = Value(kind),
        amountPaise = Value(amountPaise),
        label = Value(label),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt);
  static Insertable<PayrollAdjustmentRow> custom({
    Expression<String>? id,
    Expression<String>? runId,
    Expression<String>? lineId,
    Expression<String>? kind,
    Expression<int>? amountPaise,
    Expression<String>? label,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (runId != null) 'run_id': runId,
      if (lineId != null) 'line_id': lineId,
      if (kind != null) 'kind': kind,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (label != null) 'label': label,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayrollAdjustmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? runId,
      Value<String>? lineId,
      Value<String>? kind,
      Value<int>? amountPaise,
      Value<String>? label,
      Value<String>? createdBy,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PayrollAdjustmentsCompanion(
      id: id ?? this.id,
      runId: runId ?? this.runId,
      lineId: lineId ?? this.lineId,
      kind: kind ?? this.kind,
      amountPaise: amountPaise ?? this.amountPaise,
      label: label ?? this.label,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (runId.present) {
      map['run_id'] = Variable<String>(runId.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<String>(lineId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayrollAdjustmentsCompanion(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('lineId: $lineId, ')
          ..write('kind: $kind, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('label: $label, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayrollPaymentsTable extends PayrollPayments
    with TableInfo<$PayrollPaymentsTable, PayrollPaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayrollPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<String> runId = GeneratedColumn<String>(
      'run_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES payroll_runs (id) ON DELETE CASCADE'));
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<String> lineId = GeneratedColumn<String>(
      'line_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES payroll_lines (id) ON DELETE CASCADE'));
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPaiseMeta =
      const VerificationMeta('amountPaise');
  @override
  late final GeneratedColumn<int> amountPaise = GeneratedColumn<int>(
      'amount_paise', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordedByMeta =
      const VerificationMeta('recordedBy');
  @override
  late final GeneratedColumn<String> recordedBy = GeneratedColumn<String>(
      'recorded_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        runId,
        lineId,
        employeeId,
        amountPaise,
        paidAt,
        method,
        notes,
        recordedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payroll_payments';
  @override
  VerificationContext validateIntegrity(Insertable<PayrollPaymentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('run_id')) {
      context.handle(
          _runIdMeta, runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta));
    } else if (isInserting) {
      context.missing(_runIdMeta);
    }
    if (data.containsKey('line_id')) {
      context.handle(_lineIdMeta,
          lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta));
    } else if (isInserting) {
      context.missing(_lineIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('amount_paise')) {
      context.handle(
          _amountPaiseMeta,
          amountPaise.isAcceptableOrUnknown(
              data['amount_paise']!, _amountPaiseMeta));
    } else if (isInserting) {
      context.missing(_amountPaiseMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('recorded_by')) {
      context.handle(
          _recordedByMeta,
          recordedBy.isAcceptableOrUnknown(
              data['recorded_by']!, _recordedByMeta));
    } else if (isInserting) {
      context.missing(_recordedByMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PayrollPaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayrollPaymentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      runId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}run_id'])!,
      lineId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}line_id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      amountPaise: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_paise'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      recordedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recorded_by'])!,
    );
  }

  @override
  $PayrollPaymentsTable createAlias(String alias) {
    return $PayrollPaymentsTable(attachedDatabase, alias);
  }
}

class PayrollPaymentRow extends DataClass
    implements Insertable<PayrollPaymentRow> {
  final String id;
  final String runId;
  final String lineId;
  final String employeeId;
  final int amountPaise;
  final DateTime paidAt;
  final String method;
  final String? notes;
  final String recordedBy;
  const PayrollPaymentRow(
      {required this.id,
      required this.runId,
      required this.lineId,
      required this.employeeId,
      required this.amountPaise,
      required this.paidAt,
      required this.method,
      this.notes,
      required this.recordedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['run_id'] = Variable<String>(runId);
    map['line_id'] = Variable<String>(lineId);
    map['employee_id'] = Variable<String>(employeeId);
    map['amount_paise'] = Variable<int>(amountPaise);
    map['paid_at'] = Variable<DateTime>(paidAt);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['recorded_by'] = Variable<String>(recordedBy);
    return map;
  }

  PayrollPaymentsCompanion toCompanion(bool nullToAbsent) {
    return PayrollPaymentsCompanion(
      id: Value(id),
      runId: Value(runId),
      lineId: Value(lineId),
      employeeId: Value(employeeId),
      amountPaise: Value(amountPaise),
      paidAt: Value(paidAt),
      method: Value(method),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      recordedBy: Value(recordedBy),
    );
  }

  factory PayrollPaymentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayrollPaymentRow(
      id: serializer.fromJson<String>(json['id']),
      runId: serializer.fromJson<String>(json['runId']),
      lineId: serializer.fromJson<String>(json['lineId']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      amountPaise: serializer.fromJson<int>(json['amountPaise']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      method: serializer.fromJson<String>(json['method']),
      notes: serializer.fromJson<String?>(json['notes']),
      recordedBy: serializer.fromJson<String>(json['recordedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'runId': serializer.toJson<String>(runId),
      'lineId': serializer.toJson<String>(lineId),
      'employeeId': serializer.toJson<String>(employeeId),
      'amountPaise': serializer.toJson<int>(amountPaise),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'method': serializer.toJson<String>(method),
      'notes': serializer.toJson<String?>(notes),
      'recordedBy': serializer.toJson<String>(recordedBy),
    };
  }

  PayrollPaymentRow copyWith(
          {String? id,
          String? runId,
          String? lineId,
          String? employeeId,
          int? amountPaise,
          DateTime? paidAt,
          String? method,
          Value<String?> notes = const Value.absent(),
          String? recordedBy}) =>
      PayrollPaymentRow(
        id: id ?? this.id,
        runId: runId ?? this.runId,
        lineId: lineId ?? this.lineId,
        employeeId: employeeId ?? this.employeeId,
        amountPaise: amountPaise ?? this.amountPaise,
        paidAt: paidAt ?? this.paidAt,
        method: method ?? this.method,
        notes: notes.present ? notes.value : this.notes,
        recordedBy: recordedBy ?? this.recordedBy,
      );
  PayrollPaymentRow copyWithCompanion(PayrollPaymentsCompanion data) {
    return PayrollPaymentRow(
      id: data.id.present ? data.id.value : this.id,
      runId: data.runId.present ? data.runId.value : this.runId,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      amountPaise:
          data.amountPaise.present ? data.amountPaise.value : this.amountPaise,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      method: data.method.present ? data.method.value : this.method,
      notes: data.notes.present ? data.notes.value : this.notes,
      recordedBy:
          data.recordedBy.present ? data.recordedBy.value : this.recordedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayrollPaymentRow(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('lineId: $lineId, ')
          ..write('employeeId: $employeeId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('paidAt: $paidAt, ')
          ..write('method: $method, ')
          ..write('notes: $notes, ')
          ..write('recordedBy: $recordedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, runId, lineId, employeeId, amountPaise,
      paidAt, method, notes, recordedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayrollPaymentRow &&
          other.id == this.id &&
          other.runId == this.runId &&
          other.lineId == this.lineId &&
          other.employeeId == this.employeeId &&
          other.amountPaise == this.amountPaise &&
          other.paidAt == this.paidAt &&
          other.method == this.method &&
          other.notes == this.notes &&
          other.recordedBy == this.recordedBy);
}

class PayrollPaymentsCompanion extends UpdateCompanion<PayrollPaymentRow> {
  final Value<String> id;
  final Value<String> runId;
  final Value<String> lineId;
  final Value<String> employeeId;
  final Value<int> amountPaise;
  final Value<DateTime> paidAt;
  final Value<String> method;
  final Value<String?> notes;
  final Value<String> recordedBy;
  final Value<int> rowid;
  const PayrollPaymentsCompanion({
    this.id = const Value.absent(),
    this.runId = const Value.absent(),
    this.lineId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.amountPaise = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.method = const Value.absent(),
    this.notes = const Value.absent(),
    this.recordedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayrollPaymentsCompanion.insert({
    required String id,
    required String runId,
    required String lineId,
    required String employeeId,
    required int amountPaise,
    required DateTime paidAt,
    required String method,
    this.notes = const Value.absent(),
    required String recordedBy,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        runId = Value(runId),
        lineId = Value(lineId),
        employeeId = Value(employeeId),
        amountPaise = Value(amountPaise),
        paidAt = Value(paidAt),
        method = Value(method),
        recordedBy = Value(recordedBy);
  static Insertable<PayrollPaymentRow> custom({
    Expression<String>? id,
    Expression<String>? runId,
    Expression<String>? lineId,
    Expression<String>? employeeId,
    Expression<int>? amountPaise,
    Expression<DateTime>? paidAt,
    Expression<String>? method,
    Expression<String>? notes,
    Expression<String>? recordedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (runId != null) 'run_id': runId,
      if (lineId != null) 'line_id': lineId,
      if (employeeId != null) 'employee_id': employeeId,
      if (amountPaise != null) 'amount_paise': amountPaise,
      if (paidAt != null) 'paid_at': paidAt,
      if (method != null) 'method': method,
      if (notes != null) 'notes': notes,
      if (recordedBy != null) 'recorded_by': recordedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayrollPaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? runId,
      Value<String>? lineId,
      Value<String>? employeeId,
      Value<int>? amountPaise,
      Value<DateTime>? paidAt,
      Value<String>? method,
      Value<String?>? notes,
      Value<String>? recordedBy,
      Value<int>? rowid}) {
    return PayrollPaymentsCompanion(
      id: id ?? this.id,
      runId: runId ?? this.runId,
      lineId: lineId ?? this.lineId,
      employeeId: employeeId ?? this.employeeId,
      amountPaise: amountPaise ?? this.amountPaise,
      paidAt: paidAt ?? this.paidAt,
      method: method ?? this.method,
      notes: notes ?? this.notes,
      recordedBy: recordedBy ?? this.recordedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (runId.present) {
      map['run_id'] = Variable<String>(runId.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<String>(lineId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (amountPaise.present) {
      map['amount_paise'] = Variable<int>(amountPaise.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (recordedBy.present) {
      map['recorded_by'] = Variable<String>(recordedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayrollPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('lineId: $lineId, ')
          ..write('employeeId: $employeeId, ')
          ..write('amountPaise: $amountPaise, ')
          ..write('paidAt: $paidAt, ')
          ..write('method: $method, ')
          ..write('notes: $notes, ')
          ..write('recordedBy: $recordedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayrollAuditEventsTable extends PayrollAuditEvents
    with TableInfo<$PayrollAuditEventsTable, PayrollAuditRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayrollAuditEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<String> runId = GeneratedColumn<String>(
      'run_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
      'actor', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
      'detail', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, runId, type, actor, detail, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payroll_audit_events';
  @override
  VerificationContext validateIntegrity(Insertable<PayrollAuditRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('run_id')) {
      context.handle(
          _runIdMeta, runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta));
    } else if (isInserting) {
      context.missing(_runIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
          _actorMeta, actor.isAcceptableOrUnknown(data['actor']!, _actorMeta));
    } else if (isInserting) {
      context.missing(_actorMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(_detailMeta,
          detail.isAcceptableOrUnknown(data['detail']!, _detailMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PayrollAuditRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayrollAuditRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      runId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}run_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      actor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor'])!,
      detail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}detail']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PayrollAuditEventsTable createAlias(String alias) {
    return $PayrollAuditEventsTable(attachedDatabase, alias);
  }
}

class PayrollAuditRow extends DataClass implements Insertable<PayrollAuditRow> {
  final int id;
  final String runId;
  final String type;
  final String actor;
  final String? detail;
  final DateTime createdAt;
  const PayrollAuditRow(
      {required this.id,
      required this.runId,
      required this.type,
      required this.actor,
      this.detail,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['run_id'] = Variable<String>(runId);
    map['type'] = Variable<String>(type);
    map['actor'] = Variable<String>(actor);
    if (!nullToAbsent || detail != null) {
      map['detail'] = Variable<String>(detail);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PayrollAuditEventsCompanion toCompanion(bool nullToAbsent) {
    return PayrollAuditEventsCompanion(
      id: Value(id),
      runId: Value(runId),
      type: Value(type),
      actor: Value(actor),
      detail:
          detail == null && nullToAbsent ? const Value.absent() : Value(detail),
      createdAt: Value(createdAt),
    );
  }

  factory PayrollAuditRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayrollAuditRow(
      id: serializer.fromJson<int>(json['id']),
      runId: serializer.fromJson<String>(json['runId']),
      type: serializer.fromJson<String>(json['type']),
      actor: serializer.fromJson<String>(json['actor']),
      detail: serializer.fromJson<String?>(json['detail']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'runId': serializer.toJson<String>(runId),
      'type': serializer.toJson<String>(type),
      'actor': serializer.toJson<String>(actor),
      'detail': serializer.toJson<String?>(detail),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PayrollAuditRow copyWith(
          {int? id,
          String? runId,
          String? type,
          String? actor,
          Value<String?> detail = const Value.absent(),
          DateTime? createdAt}) =>
      PayrollAuditRow(
        id: id ?? this.id,
        runId: runId ?? this.runId,
        type: type ?? this.type,
        actor: actor ?? this.actor,
        detail: detail.present ? detail.value : this.detail,
        createdAt: createdAt ?? this.createdAt,
      );
  PayrollAuditRow copyWithCompanion(PayrollAuditEventsCompanion data) {
    return PayrollAuditRow(
      id: data.id.present ? data.id.value : this.id,
      runId: data.runId.present ? data.runId.value : this.runId,
      type: data.type.present ? data.type.value : this.type,
      actor: data.actor.present ? data.actor.value : this.actor,
      detail: data.detail.present ? data.detail.value : this.detail,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayrollAuditRow(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('type: $type, ')
          ..write('actor: $actor, ')
          ..write('detail: $detail, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, runId, type, actor, detail, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayrollAuditRow &&
          other.id == this.id &&
          other.runId == this.runId &&
          other.type == this.type &&
          other.actor == this.actor &&
          other.detail == this.detail &&
          other.createdAt == this.createdAt);
}

class PayrollAuditEventsCompanion extends UpdateCompanion<PayrollAuditRow> {
  final Value<int> id;
  final Value<String> runId;
  final Value<String> type;
  final Value<String> actor;
  final Value<String?> detail;
  final Value<DateTime> createdAt;
  const PayrollAuditEventsCompanion({
    this.id = const Value.absent(),
    this.runId = const Value.absent(),
    this.type = const Value.absent(),
    this.actor = const Value.absent(),
    this.detail = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PayrollAuditEventsCompanion.insert({
    this.id = const Value.absent(),
    required String runId,
    required String type,
    required String actor,
    this.detail = const Value.absent(),
    required DateTime createdAt,
  })  : runId = Value(runId),
        type = Value(type),
        actor = Value(actor),
        createdAt = Value(createdAt);
  static Insertable<PayrollAuditRow> custom({
    Expression<int>? id,
    Expression<String>? runId,
    Expression<String>? type,
    Expression<String>? actor,
    Expression<String>? detail,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (runId != null) 'run_id': runId,
      if (type != null) 'type': type,
      if (actor != null) 'actor': actor,
      if (detail != null) 'detail': detail,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PayrollAuditEventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? runId,
      Value<String>? type,
      Value<String>? actor,
      Value<String?>? detail,
      Value<DateTime>? createdAt}) {
    return PayrollAuditEventsCompanion(
      id: id ?? this.id,
      runId: runId ?? this.runId,
      type: type ?? this.type,
      actor: actor ?? this.actor,
      detail: detail ?? this.detail,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (runId.present) {
      map['run_id'] = Variable<String>(runId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayrollAuditEventsCompanion(')
          ..write('id: $id, ')
          ..write('runId: $runId, ')
          ..write('type: $type, ')
          ..write('actor: $actor, ')
          ..write('detail: $detail, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PayrollAdvanceLinksTable extends PayrollAdvanceLinks
    with TableInfo<$PayrollAdvanceLinksTable, PayrollAdvanceLinkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayrollAdvanceLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _advanceIdMeta =
      const VerificationMeta('advanceId');
  @override
  late final GeneratedColumn<String> advanceId = GeneratedColumn<String>(
      'advance_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _runIdMeta = const VerificationMeta('runId');
  @override
  late final GeneratedColumn<String> runId = GeneratedColumn<String>(
      'run_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES payroll_runs (id) ON DELETE CASCADE'));
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<String> lineId = GeneratedColumn<String>(
      'line_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES payroll_lines (id) ON DELETE CASCADE'));
  static const VerificationMeta _linkedAtMeta =
      const VerificationMeta('linkedAt');
  @override
  late final GeneratedColumn<DateTime> linkedAt = GeneratedColumn<DateTime>(
      'linked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [advanceId, runId, lineId, linkedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payroll_advance_links';
  @override
  VerificationContext validateIntegrity(
      Insertable<PayrollAdvanceLinkRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('advance_id')) {
      context.handle(_advanceIdMeta,
          advanceId.isAcceptableOrUnknown(data['advance_id']!, _advanceIdMeta));
    } else if (isInserting) {
      context.missing(_advanceIdMeta);
    }
    if (data.containsKey('run_id')) {
      context.handle(
          _runIdMeta, runId.isAcceptableOrUnknown(data['run_id']!, _runIdMeta));
    } else if (isInserting) {
      context.missing(_runIdMeta);
    }
    if (data.containsKey('line_id')) {
      context.handle(_lineIdMeta,
          lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta));
    } else if (isInserting) {
      context.missing(_lineIdMeta);
    }
    if (data.containsKey('linked_at')) {
      context.handle(_linkedAtMeta,
          linkedAt.isAcceptableOrUnknown(data['linked_at']!, _linkedAtMeta));
    } else if (isInserting) {
      context.missing(_linkedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {advanceId};
  @override
  PayrollAdvanceLinkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayrollAdvanceLinkRow(
      advanceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}advance_id'])!,
      runId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}run_id'])!,
      lineId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}line_id'])!,
      linkedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}linked_at'])!,
    );
  }

  @override
  $PayrollAdvanceLinksTable createAlias(String alias) {
    return $PayrollAdvanceLinksTable(attachedDatabase, alias);
  }
}

class PayrollAdvanceLinkRow extends DataClass
    implements Insertable<PayrollAdvanceLinkRow> {
  final String advanceId;
  final String runId;
  final String lineId;
  final DateTime linkedAt;
  const PayrollAdvanceLinkRow(
      {required this.advanceId,
      required this.runId,
      required this.lineId,
      required this.linkedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['advance_id'] = Variable<String>(advanceId);
    map['run_id'] = Variable<String>(runId);
    map['line_id'] = Variable<String>(lineId);
    map['linked_at'] = Variable<DateTime>(linkedAt);
    return map;
  }

  PayrollAdvanceLinksCompanion toCompanion(bool nullToAbsent) {
    return PayrollAdvanceLinksCompanion(
      advanceId: Value(advanceId),
      runId: Value(runId),
      lineId: Value(lineId),
      linkedAt: Value(linkedAt),
    );
  }

  factory PayrollAdvanceLinkRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayrollAdvanceLinkRow(
      advanceId: serializer.fromJson<String>(json['advanceId']),
      runId: serializer.fromJson<String>(json['runId']),
      lineId: serializer.fromJson<String>(json['lineId']),
      linkedAt: serializer.fromJson<DateTime>(json['linkedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'advanceId': serializer.toJson<String>(advanceId),
      'runId': serializer.toJson<String>(runId),
      'lineId': serializer.toJson<String>(lineId),
      'linkedAt': serializer.toJson<DateTime>(linkedAt),
    };
  }

  PayrollAdvanceLinkRow copyWith(
          {String? advanceId,
          String? runId,
          String? lineId,
          DateTime? linkedAt}) =>
      PayrollAdvanceLinkRow(
        advanceId: advanceId ?? this.advanceId,
        runId: runId ?? this.runId,
        lineId: lineId ?? this.lineId,
        linkedAt: linkedAt ?? this.linkedAt,
      );
  PayrollAdvanceLinkRow copyWithCompanion(PayrollAdvanceLinksCompanion data) {
    return PayrollAdvanceLinkRow(
      advanceId: data.advanceId.present ? data.advanceId.value : this.advanceId,
      runId: data.runId.present ? data.runId.value : this.runId,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      linkedAt: data.linkedAt.present ? data.linkedAt.value : this.linkedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayrollAdvanceLinkRow(')
          ..write('advanceId: $advanceId, ')
          ..write('runId: $runId, ')
          ..write('lineId: $lineId, ')
          ..write('linkedAt: $linkedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(advanceId, runId, lineId, linkedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayrollAdvanceLinkRow &&
          other.advanceId == this.advanceId &&
          other.runId == this.runId &&
          other.lineId == this.lineId &&
          other.linkedAt == this.linkedAt);
}

class PayrollAdvanceLinksCompanion
    extends UpdateCompanion<PayrollAdvanceLinkRow> {
  final Value<String> advanceId;
  final Value<String> runId;
  final Value<String> lineId;
  final Value<DateTime> linkedAt;
  final Value<int> rowid;
  const PayrollAdvanceLinksCompanion({
    this.advanceId = const Value.absent(),
    this.runId = const Value.absent(),
    this.lineId = const Value.absent(),
    this.linkedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayrollAdvanceLinksCompanion.insert({
    required String advanceId,
    required String runId,
    required String lineId,
    required DateTime linkedAt,
    this.rowid = const Value.absent(),
  })  : advanceId = Value(advanceId),
        runId = Value(runId),
        lineId = Value(lineId),
        linkedAt = Value(linkedAt);
  static Insertable<PayrollAdvanceLinkRow> custom({
    Expression<String>? advanceId,
    Expression<String>? runId,
    Expression<String>? lineId,
    Expression<DateTime>? linkedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (advanceId != null) 'advance_id': advanceId,
      if (runId != null) 'run_id': runId,
      if (lineId != null) 'line_id': lineId,
      if (linkedAt != null) 'linked_at': linkedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayrollAdvanceLinksCompanion copyWith(
      {Value<String>? advanceId,
      Value<String>? runId,
      Value<String>? lineId,
      Value<DateTime>? linkedAt,
      Value<int>? rowid}) {
    return PayrollAdvanceLinksCompanion(
      advanceId: advanceId ?? this.advanceId,
      runId: runId ?? this.runId,
      lineId: lineId ?? this.lineId,
      linkedAt: linkedAt ?? this.linkedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (advanceId.present) {
      map['advance_id'] = Variable<String>(advanceId.value);
    }
    if (runId.present) {
      map['run_id'] = Variable<String>(runId.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<String>(lineId.value);
    }
    if (linkedAt.present) {
      map['linked_at'] = Variable<DateTime>(linkedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayrollAdvanceLinksCompanion(')
          ..write('advanceId: $advanceId, ')
          ..write('runId: $runId, ')
          ..write('lineId: $lineId, ')
          ..write('linkedAt: $linkedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(Insertable<SyncMetadataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const SyncMetadataData(
      {required this.key, required this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncMetadataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncMetadataData copyWith(
          {String? key, String? value, DateTime? updatedAt}) =>
      SyncMetadataData(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value),
        updatedAt = Value(updatedAt);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith(
      {Value<String>? key,
      Value<String>? value,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SyncMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudioProfilesTable studioProfiles = $StudioProfilesTable(this);
  late final $ServiceCategoriesTable serviceCategories =
      $ServiceCategoriesTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $BillDraftsTable billDrafts = $BillDraftsTable(this);
  late final $DraftLinesTable draftLines = $DraftLinesTable(this);
  late final $BillsTable bills = $BillsTable(this);
  late final $BillLinesTable billLines = $BillLinesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $InvoiceCountersTable invoiceCounters =
      $InvoiceCountersTable(this);
  late final $BillingAuditEventsTable billingAuditEvents =
      $BillingAuditEventsTable(this);
  late final $AttendanceRecordsTable attendanceRecords =
      $AttendanceRecordsTable(this);
  late final $AttendanceAuditEventsTable attendanceAuditEvents =
      $AttendanceAuditEventsTable(this);
  late final $SalaryAdvancesTable salaryAdvances = $SalaryAdvancesTable(this);
  late final $PayrollSettingsTable payrollSettings =
      $PayrollSettingsTable(this);
  late final $PayrollRunsTable payrollRuns = $PayrollRunsTable(this);
  late final $PayrollLinesTable payrollLines = $PayrollLinesTable(this);
  late final $PayrollAdjustmentsTable payrollAdjustments =
      $PayrollAdjustmentsTable(this);
  late final $PayrollPaymentsTable payrollPayments =
      $PayrollPaymentsTable(this);
  late final $PayrollAuditEventsTable payrollAuditEvents =
      $PayrollAuditEventsTable(this);
  late final $PayrollAdvanceLinksTable payrollAdvanceLinks =
      $PayrollAdvanceLinksTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        studioProfiles,
        serviceCategories,
        services,
        employees,
        billDrafts,
        draftLines,
        bills,
        billLines,
        payments,
        invoiceCounters,
        billingAuditEvents,
        attendanceRecords,
        attendanceAuditEvents,
        salaryAdvances,
        payrollSettings,
        payrollRuns,
        payrollLines,
        payrollAdjustments,
        payrollPayments,
        payrollAuditEvents,
        payrollAdvanceLinks,
        syncMetadata
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('bill_drafts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('draft_lines', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('bills',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('bill_lines', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('bills',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('payroll_runs',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payroll_lines', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('payroll_runs',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payroll_adjustments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('payroll_lines',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payroll_adjustments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('payroll_runs',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payroll_payments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('payroll_lines',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payroll_payments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('payroll_runs',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payroll_advance_links', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('payroll_lines',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payroll_advance_links', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$StudioProfilesTableCreateCompanionBuilder = StudioProfilesCompanion
    Function({
  Value<int> id,
  required String businessName,
  Value<String?> tagline,
  Value<String?> logoPath,
  required int primaryColor,
  required int secondaryColor,
  Value<String> address,
  Value<String> phone,
  Value<String?> email,
  Value<String?> gstin,
  Value<String?> upiId,
  Value<String?> upiPayeeName,
  Value<String> currencyCode,
  Value<String> invoicePrefix,
  Value<String?> invoiceFooter,
  Value<bool> dark,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$StudioProfilesTableUpdateCompanionBuilder = StudioProfilesCompanion
    Function({
  Value<int> id,
  Value<String> businessName,
  Value<String?> tagline,
  Value<String?> logoPath,
  Value<int> primaryColor,
  Value<int> secondaryColor,
  Value<String> address,
  Value<String> phone,
  Value<String?> email,
  Value<String?> gstin,
  Value<String?> upiId,
  Value<String?> upiPayeeName,
  Value<String> currencyCode,
  Value<String> invoicePrefix,
  Value<String?> invoiceFooter,
  Value<bool> dark,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$StudioProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $StudioProfilesTable> {
  $$StudioProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagline => $composableBuilder(
      column: $table.tagline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get primaryColor => $composableBuilder(
      column: $table.primaryColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get secondaryColor => $composableBuilder(
      column: $table.secondaryColor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gstin => $composableBuilder(
      column: $table.gstin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get upiId => $composableBuilder(
      column: $table.upiId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get upiPayeeName => $composableBuilder(
      column: $table.upiPayeeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoicePrefix => $composableBuilder(
      column: $table.invoicePrefix, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoiceFooter => $composableBuilder(
      column: $table.invoiceFooter, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get dark => $composableBuilder(
      column: $table.dark, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$StudioProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $StudioProfilesTable> {
  $$StudioProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessName => $composableBuilder(
      column: $table.businessName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagline => $composableBuilder(
      column: $table.tagline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get primaryColor => $composableBuilder(
      column: $table.primaryColor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get secondaryColor => $composableBuilder(
      column: $table.secondaryColor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gstin => $composableBuilder(
      column: $table.gstin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get upiId => $composableBuilder(
      column: $table.upiId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get upiPayeeName => $composableBuilder(
      column: $table.upiPayeeName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoicePrefix => $composableBuilder(
      column: $table.invoicePrefix,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoiceFooter => $composableBuilder(
      column: $table.invoiceFooter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get dark => $composableBuilder(
      column: $table.dark, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$StudioProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudioProfilesTable> {
  $$StudioProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => column);

  GeneratedColumn<String> get tagline =>
      $composableBuilder(column: $table.tagline, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<int> get primaryColor => $composableBuilder(
      column: $table.primaryColor, builder: (column) => column);

  GeneratedColumn<int> get secondaryColor => $composableBuilder(
      column: $table.secondaryColor, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get upiId =>
      $composableBuilder(column: $table.upiId, builder: (column) => column);

  GeneratedColumn<String> get upiPayeeName => $composableBuilder(
      column: $table.upiPayeeName, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<String> get invoicePrefix => $composableBuilder(
      column: $table.invoicePrefix, builder: (column) => column);

  GeneratedColumn<String> get invoiceFooter => $composableBuilder(
      column: $table.invoiceFooter, builder: (column) => column);

  GeneratedColumn<bool> get dark =>
      $composableBuilder(column: $table.dark, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StudioProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudioProfilesTable,
    StudioProfile,
    $$StudioProfilesTableFilterComposer,
    $$StudioProfilesTableOrderingComposer,
    $$StudioProfilesTableAnnotationComposer,
    $$StudioProfilesTableCreateCompanionBuilder,
    $$StudioProfilesTableUpdateCompanionBuilder,
    (
      StudioProfile,
      BaseReferences<_$AppDatabase, $StudioProfilesTable, StudioProfile>
    ),
    StudioProfile,
    PrefetchHooks Function()> {
  $$StudioProfilesTableTableManager(
      _$AppDatabase db, $StudioProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudioProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudioProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudioProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> businessName = const Value.absent(),
            Value<String?> tagline = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<int> primaryColor = const Value.absent(),
            Value<int> secondaryColor = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> gstin = const Value.absent(),
            Value<String?> upiId = const Value.absent(),
            Value<String?> upiPayeeName = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String> invoicePrefix = const Value.absent(),
            Value<String?> invoiceFooter = const Value.absent(),
            Value<bool> dark = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              StudioProfilesCompanion(
            id: id,
            businessName: businessName,
            tagline: tagline,
            logoPath: logoPath,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            address: address,
            phone: phone,
            email: email,
            gstin: gstin,
            upiId: upiId,
            upiPayeeName: upiPayeeName,
            currencyCode: currencyCode,
            invoicePrefix: invoicePrefix,
            invoiceFooter: invoiceFooter,
            dark: dark,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String businessName,
            Value<String?> tagline = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            required int primaryColor,
            required int secondaryColor,
            Value<String> address = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> gstin = const Value.absent(),
            Value<String?> upiId = const Value.absent(),
            Value<String?> upiPayeeName = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<String> invoicePrefix = const Value.absent(),
            Value<String?> invoiceFooter = const Value.absent(),
            Value<bool> dark = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              StudioProfilesCompanion.insert(
            id: id,
            businessName: businessName,
            tagline: tagline,
            logoPath: logoPath,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            address: address,
            phone: phone,
            email: email,
            gstin: gstin,
            upiId: upiId,
            upiPayeeName: upiPayeeName,
            currencyCode: currencyCode,
            invoicePrefix: invoicePrefix,
            invoiceFooter: invoiceFooter,
            dark: dark,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$StudioProfilesTable, StudioProfile>(table),
                    BaseReferences<_$AppDatabase, $StudioProfilesTable,
                        StudioProfile>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudioProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudioProfilesTable,
    StudioProfile,
    $$StudioProfilesTableFilterComposer,
    $$StudioProfilesTableOrderingComposer,
    $$StudioProfilesTableAnnotationComposer,
    $$StudioProfilesTableCreateCompanionBuilder,
    $$StudioProfilesTableUpdateCompanionBuilder,
    (
      StudioProfile,
      BaseReferences<_$AppDatabase, $StudioProfilesTable, StudioProfile>
    ),
    StudioProfile,
    PrefetchHooks Function()>;
typedef $$ServiceCategoriesTableCreateCompanionBuilder
    = ServiceCategoriesCompanion Function({
  required String id,
  required String name,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$ServiceCategoriesTableUpdateCompanionBuilder
    = ServiceCategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<int> rowid,
});

final class $$ServiceCategoriesTableReferences extends BaseReferences<
    _$AppDatabase, $ServiceCategoriesTable, ServiceCategoryRow> {
  $$ServiceCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ServicesTable, List<Service>> _servicesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.services,
          aliasName: 'service_categories__id__services__category_id');

  $$ServicesTableProcessedTableManager get servicesRefs {
    final manager = $$ServicesTableTableManager($_db, $_db.services)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_servicesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ServiceCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> servicesRefs(
      Expression<bool> Function($$ServicesTableFilterComposer f) f) {
    final $$ServicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.services,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServicesTableFilterComposer(
              $db: $db,
              $table: $db.services,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ServiceCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$ServiceCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> servicesRefs<T extends Object>(
      Expression<T> Function($$ServicesTableAnnotationComposer a) f) {
    final $$ServicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.services,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServicesTableAnnotationComposer(
              $db: $db,
              $table: $db.services,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ServiceCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServiceCategoriesTable,
    ServiceCategoryRow,
    $$ServiceCategoriesTableFilterComposer,
    $$ServiceCategoriesTableOrderingComposer,
    $$ServiceCategoriesTableAnnotationComposer,
    $$ServiceCategoriesTableCreateCompanionBuilder,
    $$ServiceCategoriesTableUpdateCompanionBuilder,
    (ServiceCategoryRow, $$ServiceCategoriesTableReferences),
    ServiceCategoryRow,
    PrefetchHooks Function({bool servicesRefs})> {
  $$ServiceCategoriesTableTableManager(
      _$AppDatabase db, $ServiceCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceCategoriesCompanion(
            id: id,
            name: name,
            sortOrder: sortOrder,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceCategoriesCompanion.insert(
            id: id,
            name: name,
            sortOrder: sortOrder,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ServiceCategoriesTable, ServiceCategoryRow>(
                        table),
                    $$ServiceCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({servicesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (servicesRefs) db.services],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (servicesRefs)
                    await $_getPrefetchedDataByColumns<ServiceCategoryRow,
                            $ServiceCategoriesTable, Service, $ServicesTable>(
                        currentTable: table,
                        referencedTable: $$ServiceCategoriesTableReferences
                            ._servicesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ServiceCategoriesTableReferences(db, table, p0)
                                .servicesRefs,
                        currentColumn: 'id',
                        referencedColumn: 'category_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ServiceCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServiceCategoriesTable,
    ServiceCategoryRow,
    $$ServiceCategoriesTableFilterComposer,
    $$ServiceCategoriesTableOrderingComposer,
    $$ServiceCategoriesTableAnnotationComposer,
    $$ServiceCategoriesTableCreateCompanionBuilder,
    $$ServiceCategoriesTableUpdateCompanionBuilder,
    (ServiceCategoryRow, $$ServiceCategoriesTableReferences),
    ServiceCategoryRow,
    PrefetchHooks Function({bool servicesRefs})>;
typedef $$ServicesTableCreateCompanionBuilder = ServicesCompanion Function({
  required String id,
  required String categoryId,
  required String name,
  Value<String?> description,
  required int pricePaise,
  Value<int> durationMinutes,
  Value<bool> isExtra,
  Value<bool> isActive,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ServicesTableUpdateCompanionBuilder = ServicesCompanion Function({
  Value<String> id,
  Value<String> categoryId,
  Value<String> name,
  Value<String?> description,
  Value<int> pricePaise,
  Value<int> durationMinutes,
  Value<bool> isExtra,
  Value<bool> isActive,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ServicesTableReferences
    extends BaseReferences<_$AppDatabase, $ServicesTable, Service> {
  $$ServicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServiceCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.serviceCategories
          .createAlias('services__category_id__service_categories__id');

  $$ServiceCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager =
        $$ServiceCategoriesTableTableManager($_db, $_db.serviceCategories)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ServicesTableFilterComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pricePaise => $composableBuilder(
      column: $table.pricePaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isExtra => $composableBuilder(
      column: $table.isExtra, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ServiceCategoriesTableFilterComposer get categoryId {
    final $$ServiceCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.serviceCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.serviceCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pricePaise => $composableBuilder(
      column: $table.pricePaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isExtra => $composableBuilder(
      column: $table.isExtra, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ServiceCategoriesTableOrderingComposer get categoryId {
    final $$ServiceCategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.serviceCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiceCategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.serviceCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get pricePaise => $composableBuilder(
      column: $table.pricePaise, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<bool> get isExtra =>
      $composableBuilder(column: $table.isExtra, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ServiceCategoriesTableAnnotationComposer get categoryId {
    final $$ServiceCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $db.serviceCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ServiceCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.serviceCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ServicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServicesTable,
    Service,
    $$ServicesTableFilterComposer,
    $$ServicesTableOrderingComposer,
    $$ServicesTableAnnotationComposer,
    $$ServicesTableCreateCompanionBuilder,
    $$ServicesTableUpdateCompanionBuilder,
    (Service, $$ServicesTableReferences),
    Service,
    PrefetchHooks Function({bool categoryId})> {
  $$ServicesTableTableManager(_$AppDatabase db, $ServicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> pricePaise = const Value.absent(),
            Value<int> durationMinutes = const Value.absent(),
            Value<bool> isExtra = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServicesCompanion(
            id: id,
            categoryId: categoryId,
            name: name,
            description: description,
            pricePaise: pricePaise,
            durationMinutes: durationMinutes,
            isExtra: isExtra,
            isActive: isActive,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String categoryId,
            required String name,
            Value<String?> description = const Value.absent(),
            required int pricePaise,
            Value<int> durationMinutes = const Value.absent(),
            Value<bool> isExtra = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ServicesCompanion.insert(
            id: id,
            categoryId: categoryId,
            name: name,
            description: description,
            pricePaise: pricePaise,
            durationMinutes: durationMinutes,
            isExtra: isExtra,
            isActive: isActive,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ServicesTable, Service>(table),
                    $$ServicesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$ServicesTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$ServicesTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ServicesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServicesTable,
    Service,
    $$ServicesTableFilterComposer,
    $$ServicesTableOrderingComposer,
    $$ServicesTableAnnotationComposer,
    $$ServicesTableCreateCompanionBuilder,
    $$ServicesTableUpdateCompanionBuilder,
    (Service, $$ServicesTableReferences),
    Service,
    PrefetchHooks Function({bool categoryId})>;
typedef $$EmployeesTableCreateCompanionBuilder = EmployeesCompanion Function({
  required String id,
  required String name,
  Value<String> role,
  Value<String> phone,
  Value<String> salaryType,
  Value<int> monthlySalaryPaise,
  Value<bool> isActive,
  Value<DateTime?> joiningDate,
  Value<String?> photoPath,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$EmployeesTableUpdateCompanionBuilder = EmployeesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> role,
  Value<String> phone,
  Value<String> salaryType,
  Value<int> monthlySalaryPaise,
  Value<bool> isActive,
  Value<DateTime?> joiningDate,
  Value<String?> photoPath,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$EmployeesTableReferences
    extends BaseReferences<_$AppDatabase, $EmployeesTable, EmployeeRow> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttendanceRecordsTable, List<AttendanceRow>>
      _attendanceRecordsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.attendanceRecords,
              aliasName: 'employees__id__attendance_records__employee_id');

  $$AttendanceRecordsTableProcessedTableManager get attendanceRecordsRefs {
    final manager = $$AttendanceRecordsTableTableManager(
            $_db, $_db.attendanceRecords)
        .filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_attendanceRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SalaryAdvancesTable, List<AdvanceRow>>
      _salaryAdvancesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.salaryAdvances,
              aliasName: 'employees__id__salary_advances__employee_id');

  $$SalaryAdvancesTableProcessedTableManager get salaryAdvancesRefs {
    final manager = $$SalaryAdvancesTableTableManager($_db, $_db.salaryAdvances)
        .filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_salaryAdvancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get monthlySalaryPaise => $composableBuilder(
      column: $table.monthlySalaryPaise,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get joiningDate => $composableBuilder(
      column: $table.joiningDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> attendanceRecordsRefs(
      Expression<bool> Function($$AttendanceRecordsTableFilterComposer f) f) {
    final $$AttendanceRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendanceRecords,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendanceRecordsTableFilterComposer(
              $db: $db,
              $table: $db.attendanceRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> salaryAdvancesRefs(
      Expression<bool> Function($$SalaryAdvancesTableFilterComposer f) f) {
    final $$SalaryAdvancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.salaryAdvances,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalaryAdvancesTableFilterComposer(
              $db: $db,
              $table: $db.salaryAdvances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get monthlySalaryPaise => $composableBuilder(
      column: $table.monthlySalaryPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get joiningDate => $composableBuilder(
      column: $table.joiningDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => column);

  GeneratedColumn<int> get monthlySalaryPaise => $composableBuilder(
      column: $table.monthlySalaryPaise, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get joiningDate => $composableBuilder(
      column: $table.joiningDate, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> attendanceRecordsRefs<T extends Object>(
      Expression<T> Function($$AttendanceRecordsTableAnnotationComposer a) f) {
    final $$AttendanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.attendanceRecords,
            getReferencedColumn: (t) => t.employeeId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$AttendanceRecordsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.attendanceRecords,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> salaryAdvancesRefs<T extends Object>(
      Expression<T> Function($$SalaryAdvancesTableAnnotationComposer a) f) {
    final $$SalaryAdvancesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.salaryAdvances,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalaryAdvancesTableAnnotationComposer(
              $db: $db,
              $table: $db.salaryAdvances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EmployeesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeesTable,
    EmployeeRow,
    $$EmployeesTableFilterComposer,
    $$EmployeesTableOrderingComposer,
    $$EmployeesTableAnnotationComposer,
    $$EmployeesTableCreateCompanionBuilder,
    $$EmployeesTableUpdateCompanionBuilder,
    (EmployeeRow, $$EmployeesTableReferences),
    EmployeeRow,
    PrefetchHooks Function(
        {bool attendanceRecordsRefs, bool salaryAdvancesRefs})> {
  $$EmployeesTableTableManager(_$AppDatabase db, $EmployeesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> salaryType = const Value.absent(),
            Value<int> monthlySalaryPaise = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> joiningDate = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeesCompanion(
            id: id,
            name: name,
            role: role,
            phone: phone,
            salaryType: salaryType,
            monthlySalaryPaise: monthlySalaryPaise,
            isActive: isActive,
            joiningDate: joiningDate,
            photoPath: photoPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> role = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> salaryType = const Value.absent(),
            Value<int> monthlySalaryPaise = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> joiningDate = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeesCompanion.insert(
            id: id,
            name: name,
            role: role,
            phone: phone,
            salaryType: salaryType,
            monthlySalaryPaise: monthlySalaryPaise,
            isActive: isActive,
            joiningDate: joiningDate,
            photoPath: photoPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$EmployeesTable, EmployeeRow>(table),
                    $$EmployeesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {attendanceRecordsRefs = false, salaryAdvancesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (attendanceRecordsRefs) db.attendanceRecords,
                if (salaryAdvancesRefs) db.salaryAdvances
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attendanceRecordsRefs)
                    await $_getPrefetchedDataByColumns<
                            EmployeeRow,
                            $EmployeesTable,
                            AttendanceRow,
                            $AttendanceRecordsTable>(
                        currentTable: table,
                        referencedTable: $$EmployeesTableReferences
                            ._attendanceRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmployeesTableReferences(db, table, p0)
                                .attendanceRecordsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'employee_id',
                        typedResults: items),
                  if (salaryAdvancesRefs)
                    await $_getPrefetchedDataByColumns<EmployeeRow,
                            $EmployeesTable, AdvanceRow, $SalaryAdvancesTable>(
                        currentTable: table,
                        referencedTable: $$EmployeesTableReferences
                            ._salaryAdvancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmployeesTableReferences(db, table, p0)
                                .salaryAdvancesRefs,
                        currentColumn: 'id',
                        referencedColumn: 'employee_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EmployeesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeesTable,
    EmployeeRow,
    $$EmployeesTableFilterComposer,
    $$EmployeesTableOrderingComposer,
    $$EmployeesTableAnnotationComposer,
    $$EmployeesTableCreateCompanionBuilder,
    $$EmployeesTableUpdateCompanionBuilder,
    (EmployeeRow, $$EmployeesTableReferences),
    EmployeeRow,
    PrefetchHooks Function(
        {bool attendanceRecordsRefs, bool salaryAdvancesRefs})>;
typedef $$BillDraftsTableCreateCompanionBuilder = BillDraftsCompanion Function({
  required String draftId,
  Value<String?> billingEmployeeId,
  Value<String?> billingEmployeeName,
  Value<String> customerName,
  Value<String> customerPhone,
  Value<String> customerNotes,
  Value<int> discountPercent,
  Value<int> discountFlatPaise,
  Value<int> taxBasisPoints,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BillDraftsTableUpdateCompanionBuilder = BillDraftsCompanion Function({
  Value<String> draftId,
  Value<String?> billingEmployeeId,
  Value<String?> billingEmployeeName,
  Value<String> customerName,
  Value<String> customerPhone,
  Value<String> customerNotes,
  Value<int> discountPercent,
  Value<int> discountFlatPaise,
  Value<int> taxBasisPoints,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$BillDraftsTableReferences
    extends BaseReferences<_$AppDatabase, $BillDraftsTable, BillDraft> {
  $$BillDraftsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DraftLinesTable, List<DraftLine>>
      _draftLinesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.draftLines,
              aliasName: 'bill_drafts__draft_id__draft_lines__draft_id');

  $$DraftLinesTableProcessedTableManager get draftLinesRefs {
    final manager = $$DraftLinesTableTableManager($_db, $_db.draftLines).filter(
        (f) => f.draftId.draftId.sqlEquals($_itemColumn<String>('draft_id')!));

    final cache = $_typedResult.readTableOrNull(_draftLinesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BillDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $BillDraftsTable> {
  $$BillDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get draftId => $composableBuilder(
      column: $table.draftId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingEmployeeId => $composableBuilder(
      column: $table.billingEmployeeId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingEmployeeName => $composableBuilder(
      column: $table.billingEmployeeName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerNotes => $composableBuilder(
      column: $table.customerNotes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountPercent => $composableBuilder(
      column: $table.discountPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountFlatPaise => $composableBuilder(
      column: $table.discountFlatPaise,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxBasisPoints => $composableBuilder(
      column: $table.taxBasisPoints,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> draftLinesRefs(
      Expression<bool> Function($$DraftLinesTableFilterComposer f) f) {
    final $$DraftLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.draftId,
        referencedTable: $db.draftLines,
        getReferencedColumn: (t) => t.draftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DraftLinesTableFilterComposer(
              $db: $db,
              $table: $db.draftLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BillDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillDraftsTable> {
  $$BillDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get draftId => $composableBuilder(
      column: $table.draftId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingEmployeeId => $composableBuilder(
      column: $table.billingEmployeeId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingEmployeeName => $composableBuilder(
      column: $table.billingEmployeeName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerNotes => $composableBuilder(
      column: $table.customerNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountPercent => $composableBuilder(
      column: $table.discountPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountFlatPaise => $composableBuilder(
      column: $table.discountFlatPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxBasisPoints => $composableBuilder(
      column: $table.taxBasisPoints,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BillDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillDraftsTable> {
  $$BillDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get draftId =>
      $composableBuilder(column: $table.draftId, builder: (column) => column);

  GeneratedColumn<String> get billingEmployeeId => $composableBuilder(
      column: $table.billingEmployeeId, builder: (column) => column);

  GeneratedColumn<String> get billingEmployeeName => $composableBuilder(
      column: $table.billingEmployeeName, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => column);

  GeneratedColumn<String> get customerNotes => $composableBuilder(
      column: $table.customerNotes, builder: (column) => column);

  GeneratedColumn<int> get discountPercent => $composableBuilder(
      column: $table.discountPercent, builder: (column) => column);

  GeneratedColumn<int> get discountFlatPaise => $composableBuilder(
      column: $table.discountFlatPaise, builder: (column) => column);

  GeneratedColumn<int> get taxBasisPoints => $composableBuilder(
      column: $table.taxBasisPoints, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> draftLinesRefs<T extends Object>(
      Expression<T> Function($$DraftLinesTableAnnotationComposer a) f) {
    final $$DraftLinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.draftId,
        referencedTable: $db.draftLines,
        getReferencedColumn: (t) => t.draftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DraftLinesTableAnnotationComposer(
              $db: $db,
              $table: $db.draftLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BillDraftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillDraftsTable,
    BillDraft,
    $$BillDraftsTableFilterComposer,
    $$BillDraftsTableOrderingComposer,
    $$BillDraftsTableAnnotationComposer,
    $$BillDraftsTableCreateCompanionBuilder,
    $$BillDraftsTableUpdateCompanionBuilder,
    (BillDraft, $$BillDraftsTableReferences),
    BillDraft,
    PrefetchHooks Function({bool draftLinesRefs})> {
  $$BillDraftsTableTableManager(_$AppDatabase db, $BillDraftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> draftId = const Value.absent(),
            Value<String?> billingEmployeeId = const Value.absent(),
            Value<String?> billingEmployeeName = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<String> customerPhone = const Value.absent(),
            Value<String> customerNotes = const Value.absent(),
            Value<int> discountPercent = const Value.absent(),
            Value<int> discountFlatPaise = const Value.absent(),
            Value<int> taxBasisPoints = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BillDraftsCompanion(
            draftId: draftId,
            billingEmployeeId: billingEmployeeId,
            billingEmployeeName: billingEmployeeName,
            customerName: customerName,
            customerPhone: customerPhone,
            customerNotes: customerNotes,
            discountPercent: discountPercent,
            discountFlatPaise: discountFlatPaise,
            taxBasisPoints: taxBasisPoints,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String draftId,
            Value<String?> billingEmployeeId = const Value.absent(),
            Value<String?> billingEmployeeName = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<String> customerPhone = const Value.absent(),
            Value<String> customerNotes = const Value.absent(),
            Value<int> discountPercent = const Value.absent(),
            Value<int> discountFlatPaise = const Value.absent(),
            Value<int> taxBasisPoints = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BillDraftsCompanion.insert(
            draftId: draftId,
            billingEmployeeId: billingEmployeeId,
            billingEmployeeName: billingEmployeeName,
            customerName: customerName,
            customerPhone: customerPhone,
            customerNotes: customerNotes,
            discountPercent: discountPercent,
            discountFlatPaise: discountFlatPaise,
            taxBasisPoints: taxBasisPoints,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$BillDraftsTable, BillDraft>(table),
                    $$BillDraftsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({draftLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (draftLinesRefs) db.draftLines],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (draftLinesRefs)
                    await $_getPrefetchedDataByColumns<BillDraft,
                            $BillDraftsTable, DraftLine, $DraftLinesTable>(
                        currentTable: table,
                        referencedTable: $$BillDraftsTableReferences
                            ._draftLinesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BillDraftsTableReferences(db, table, p0)
                                .draftLinesRefs,
                        currentColumn: 'draft_id',
                        referencedColumn: 'draft_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BillDraftsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillDraftsTable,
    BillDraft,
    $$BillDraftsTableFilterComposer,
    $$BillDraftsTableOrderingComposer,
    $$BillDraftsTableAnnotationComposer,
    $$BillDraftsTableCreateCompanionBuilder,
    $$BillDraftsTableUpdateCompanionBuilder,
    (BillDraft, $$BillDraftsTableReferences),
    BillDraft,
    PrefetchHooks Function({bool draftLinesRefs})>;
typedef $$DraftLinesTableCreateCompanionBuilder = DraftLinesCompanion Function({
  Value<int> id,
  required String draftId,
  required String serviceId,
  required String serviceName,
  required int pricePaise,
  Value<int> durationMinutes,
  required int quantity,
  Value<String?> employeeId,
  Value<String?> employeeName,
  required int position,
});
typedef $$DraftLinesTableUpdateCompanionBuilder = DraftLinesCompanion Function({
  Value<int> id,
  Value<String> draftId,
  Value<String> serviceId,
  Value<String> serviceName,
  Value<int> pricePaise,
  Value<int> durationMinutes,
  Value<int> quantity,
  Value<String?> employeeId,
  Value<String?> employeeName,
  Value<int> position,
});

final class $$DraftLinesTableReferences
    extends BaseReferences<_$AppDatabase, $DraftLinesTable, DraftLine> {
  $$DraftLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BillDraftsTable _draftIdTable(_$AppDatabase db) =>
      db.billDrafts.createAlias('draft_lines__draft_id__bill_drafts__draft_id');

  $$BillDraftsTableProcessedTableManager get draftId {
    final $_column = $_itemColumn<String>('draft_id')!;

    final manager = $$BillDraftsTableTableManager($_db, $_db.billDrafts)
        .filter((f) => f.draftId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_draftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DraftLinesTableFilterComposer
    extends Composer<_$AppDatabase, $DraftLinesTable> {
  $$DraftLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serviceId => $composableBuilder(
      column: $table.serviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serviceName => $composableBuilder(
      column: $table.serviceName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pricePaise => $composableBuilder(
      column: $table.pricePaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeName => $composableBuilder(
      column: $table.employeeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  $$BillDraftsTableFilterComposer get draftId {
    final $$BillDraftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.draftId,
        referencedTable: $db.billDrafts,
        getReferencedColumn: (t) => t.draftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillDraftsTableFilterComposer(
              $db: $db,
              $table: $db.billDrafts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DraftLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $DraftLinesTable> {
  $$DraftLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serviceId => $composableBuilder(
      column: $table.serviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serviceName => $composableBuilder(
      column: $table.serviceName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pricePaise => $composableBuilder(
      column: $table.pricePaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeName => $composableBuilder(
      column: $table.employeeName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  $$BillDraftsTableOrderingComposer get draftId {
    final $$BillDraftsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.draftId,
        referencedTable: $db.billDrafts,
        getReferencedColumn: (t) => t.draftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillDraftsTableOrderingComposer(
              $db: $db,
              $table: $db.billDrafts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DraftLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DraftLinesTable> {
  $$DraftLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serviceId =>
      $composableBuilder(column: $table.serviceId, builder: (column) => column);

  GeneratedColumn<String> get serviceName => $composableBuilder(
      column: $table.serviceName, builder: (column) => column);

  GeneratedColumn<int> get pricePaise => $composableBuilder(
      column: $table.pricePaise, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get employeeName => $composableBuilder(
      column: $table.employeeName, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$BillDraftsTableAnnotationComposer get draftId {
    final $$BillDraftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.draftId,
        referencedTable: $db.billDrafts,
        getReferencedColumn: (t) => t.draftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillDraftsTableAnnotationComposer(
              $db: $db,
              $table: $db.billDrafts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DraftLinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DraftLinesTable,
    DraftLine,
    $$DraftLinesTableFilterComposer,
    $$DraftLinesTableOrderingComposer,
    $$DraftLinesTableAnnotationComposer,
    $$DraftLinesTableCreateCompanionBuilder,
    $$DraftLinesTableUpdateCompanionBuilder,
    (DraftLine, $$DraftLinesTableReferences),
    DraftLine,
    PrefetchHooks Function({bool draftId})> {
  $$DraftLinesTableTableManager(_$AppDatabase db, $DraftLinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DraftLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DraftLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DraftLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> draftId = const Value.absent(),
            Value<String> serviceId = const Value.absent(),
            Value<String> serviceName = const Value.absent(),
            Value<int> pricePaise = const Value.absent(),
            Value<int> durationMinutes = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String?> employeeId = const Value.absent(),
            Value<String?> employeeName = const Value.absent(),
            Value<int> position = const Value.absent(),
          }) =>
              DraftLinesCompanion(
            id: id,
            draftId: draftId,
            serviceId: serviceId,
            serviceName: serviceName,
            pricePaise: pricePaise,
            durationMinutes: durationMinutes,
            quantity: quantity,
            employeeId: employeeId,
            employeeName: employeeName,
            position: position,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String draftId,
            required String serviceId,
            required String serviceName,
            required int pricePaise,
            Value<int> durationMinutes = const Value.absent(),
            required int quantity,
            Value<String?> employeeId = const Value.absent(),
            Value<String?> employeeName = const Value.absent(),
            required int position,
          }) =>
              DraftLinesCompanion.insert(
            id: id,
            draftId: draftId,
            serviceId: serviceId,
            serviceName: serviceName,
            pricePaise: pricePaise,
            durationMinutes: durationMinutes,
            quantity: quantity,
            employeeId: employeeId,
            employeeName: employeeName,
            position: position,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DraftLinesTable, DraftLine>(table),
                    $$DraftLinesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({draftId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (draftId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.draftId,
                    referencedTable:
                        $$DraftLinesTableReferences._draftIdTable(db),
                    referencedColumn:
                        $$DraftLinesTableReferences._draftIdTable(db).draftId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DraftLinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DraftLinesTable,
    DraftLine,
    $$DraftLinesTableFilterComposer,
    $$DraftLinesTableOrderingComposer,
    $$DraftLinesTableAnnotationComposer,
    $$DraftLinesTableCreateCompanionBuilder,
    $$DraftLinesTableUpdateCompanionBuilder,
    (DraftLine, $$DraftLinesTableReferences),
    DraftLine,
    PrefetchHooks Function({bool draftId})>;
typedef $$BillsTableCreateCompanionBuilder = BillsCompanion Function({
  required String id,
  required String provisionalRef,
  required int localSeq,
  required String draftId,
  Value<String> customerName,
  Value<String> customerPhone,
  Value<String> customerNotes,
  Value<String?> billingEmployeeId,
  Value<String?> billingEmployeeName,
  required String snapshotBusinessName,
  Value<String?> snapshotTagline,
  Value<String> snapshotAddress,
  Value<String> snapshotPhone,
  Value<String?> snapshotEmail,
  Value<String?> snapshotGstin,
  Value<String?> snapshotUpiId,
  Value<String?> snapshotInvoiceFooter,
  required int snapshotPrimaryColor,
  required int subtotalPaise,
  required int discountPercent,
  required int discountFlatPaise,
  required int discountPaise,
  required int taxBasisPoints,
  required int taxPaise,
  required int totalPaise,
  required String status,
  required String paymentStatus,
  required DateTime createdAt,
  required DateTime finalizedAt,
  Value<DateTime?> voidedAt,
  Value<String?> voidReason,
  Value<String?> voidedBy,
  Value<int> rowid,
});
typedef $$BillsTableUpdateCompanionBuilder = BillsCompanion Function({
  Value<String> id,
  Value<String> provisionalRef,
  Value<int> localSeq,
  Value<String> draftId,
  Value<String> customerName,
  Value<String> customerPhone,
  Value<String> customerNotes,
  Value<String?> billingEmployeeId,
  Value<String?> billingEmployeeName,
  Value<String> snapshotBusinessName,
  Value<String?> snapshotTagline,
  Value<String> snapshotAddress,
  Value<String> snapshotPhone,
  Value<String?> snapshotEmail,
  Value<String?> snapshotGstin,
  Value<String?> snapshotUpiId,
  Value<String?> snapshotInvoiceFooter,
  Value<int> snapshotPrimaryColor,
  Value<int> subtotalPaise,
  Value<int> discountPercent,
  Value<int> discountFlatPaise,
  Value<int> discountPaise,
  Value<int> taxBasisPoints,
  Value<int> taxPaise,
  Value<int> totalPaise,
  Value<String> status,
  Value<String> paymentStatus,
  Value<DateTime> createdAt,
  Value<DateTime> finalizedAt,
  Value<DateTime?> voidedAt,
  Value<String?> voidReason,
  Value<String?> voidedBy,
  Value<int> rowid,
});

final class $$BillsTableReferences
    extends BaseReferences<_$AppDatabase, $BillsTable, BillRow> {
  $$BillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BillLinesTable, List<BillLineRow>>
      _billLinesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.billLines,
              aliasName: 'bills__id__bill_lines__bill_id');

  $$BillLinesTableProcessedTableManager get billLinesRefs {
    final manager = $$BillLinesTableTableManager($_db, $_db.billLines)
        .filter((f) => f.billId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_billLinesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PaymentsTable, List<PaymentRow>>
      _paymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.payments,
              aliasName: 'bills__id__payments__bill_id');

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager($_db, $_db.payments)
        .filter((f) => f.billId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BillsTableFilterComposer extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get provisionalRef => $composableBuilder(
      column: $table.provisionalRef,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localSeq => $composableBuilder(
      column: $table.localSeq, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get draftId => $composableBuilder(
      column: $table.draftId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerNotes => $composableBuilder(
      column: $table.customerNotes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingEmployeeId => $composableBuilder(
      column: $table.billingEmployeeId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingEmployeeName => $composableBuilder(
      column: $table.billingEmployeeName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotBusinessName => $composableBuilder(
      column: $table.snapshotBusinessName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotTagline => $composableBuilder(
      column: $table.snapshotTagline,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotAddress => $composableBuilder(
      column: $table.snapshotAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotPhone => $composableBuilder(
      column: $table.snapshotPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotEmail => $composableBuilder(
      column: $table.snapshotEmail, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotGstin => $composableBuilder(
      column: $table.snapshotGstin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotUpiId => $composableBuilder(
      column: $table.snapshotUpiId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotInvoiceFooter => $composableBuilder(
      column: $table.snapshotInvoiceFooter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get snapshotPrimaryColor => $composableBuilder(
      column: $table.snapshotPrimaryColor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get subtotalPaise => $composableBuilder(
      column: $table.subtotalPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountPercent => $composableBuilder(
      column: $table.discountPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountFlatPaise => $composableBuilder(
      column: $table.discountFlatPaise,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountPaise => $composableBuilder(
      column: $table.discountPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxBasisPoints => $composableBuilder(
      column: $table.taxBasisPoints,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxPaise => $composableBuilder(
      column: $table.taxPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalPaise => $composableBuilder(
      column: $table.totalPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get finalizedAt => $composableBuilder(
      column: $table.finalizedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get voidedAt => $composableBuilder(
      column: $table.voidedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voidReason => $composableBuilder(
      column: $table.voidReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voidedBy => $composableBuilder(
      column: $table.voidedBy, builder: (column) => ColumnFilters(column));

  Expression<bool> billLinesRefs(
      Expression<bool> Function($$BillLinesTableFilterComposer f) f) {
    final $$BillLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.billLines,
        getReferencedColumn: (t) => t.billId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillLinesTableFilterComposer(
              $db: $db,
              $table: $db.billLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> paymentsRefs(
      Expression<bool> Function($$PaymentsTableFilterComposer f) f) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.billId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableFilterComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BillsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get provisionalRef => $composableBuilder(
      column: $table.provisionalRef,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localSeq => $composableBuilder(
      column: $table.localSeq, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get draftId => $composableBuilder(
      column: $table.draftId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerNotes => $composableBuilder(
      column: $table.customerNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingEmployeeId => $composableBuilder(
      column: $table.billingEmployeeId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingEmployeeName => $composableBuilder(
      column: $table.billingEmployeeName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotBusinessName => $composableBuilder(
      column: $table.snapshotBusinessName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotTagline => $composableBuilder(
      column: $table.snapshotTagline,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotAddress => $composableBuilder(
      column: $table.snapshotAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotPhone => $composableBuilder(
      column: $table.snapshotPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotEmail => $composableBuilder(
      column: $table.snapshotEmail,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotGstin => $composableBuilder(
      column: $table.snapshotGstin,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotUpiId => $composableBuilder(
      column: $table.snapshotUpiId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotInvoiceFooter => $composableBuilder(
      column: $table.snapshotInvoiceFooter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get snapshotPrimaryColor => $composableBuilder(
      column: $table.snapshotPrimaryColor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get subtotalPaise => $composableBuilder(
      column: $table.subtotalPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountPercent => $composableBuilder(
      column: $table.discountPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountFlatPaise => $composableBuilder(
      column: $table.discountFlatPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountPaise => $composableBuilder(
      column: $table.discountPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxBasisPoints => $composableBuilder(
      column: $table.taxBasisPoints,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxPaise => $composableBuilder(
      column: $table.taxPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalPaise => $composableBuilder(
      column: $table.totalPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get finalizedAt => $composableBuilder(
      column: $table.finalizedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get voidedAt => $composableBuilder(
      column: $table.voidedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voidReason => $composableBuilder(
      column: $table.voidReason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voidedBy => $composableBuilder(
      column: $table.voidedBy, builder: (column) => ColumnOrderings(column));
}

class $$BillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get provisionalRef => $composableBuilder(
      column: $table.provisionalRef, builder: (column) => column);

  GeneratedColumn<int> get localSeq =>
      $composableBuilder(column: $table.localSeq, builder: (column) => column);

  GeneratedColumn<String> get draftId =>
      $composableBuilder(column: $table.draftId, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => column);

  GeneratedColumn<String> get customerNotes => $composableBuilder(
      column: $table.customerNotes, builder: (column) => column);

  GeneratedColumn<String> get billingEmployeeId => $composableBuilder(
      column: $table.billingEmployeeId, builder: (column) => column);

  GeneratedColumn<String> get billingEmployeeName => $composableBuilder(
      column: $table.billingEmployeeName, builder: (column) => column);

  GeneratedColumn<String> get snapshotBusinessName => $composableBuilder(
      column: $table.snapshotBusinessName, builder: (column) => column);

  GeneratedColumn<String> get snapshotTagline => $composableBuilder(
      column: $table.snapshotTagline, builder: (column) => column);

  GeneratedColumn<String> get snapshotAddress => $composableBuilder(
      column: $table.snapshotAddress, builder: (column) => column);

  GeneratedColumn<String> get snapshotPhone => $composableBuilder(
      column: $table.snapshotPhone, builder: (column) => column);

  GeneratedColumn<String> get snapshotEmail => $composableBuilder(
      column: $table.snapshotEmail, builder: (column) => column);

  GeneratedColumn<String> get snapshotGstin => $composableBuilder(
      column: $table.snapshotGstin, builder: (column) => column);

  GeneratedColumn<String> get snapshotUpiId => $composableBuilder(
      column: $table.snapshotUpiId, builder: (column) => column);

  GeneratedColumn<String> get snapshotInvoiceFooter => $composableBuilder(
      column: $table.snapshotInvoiceFooter, builder: (column) => column);

  GeneratedColumn<int> get snapshotPrimaryColor => $composableBuilder(
      column: $table.snapshotPrimaryColor, builder: (column) => column);

  GeneratedColumn<int> get subtotalPaise => $composableBuilder(
      column: $table.subtotalPaise, builder: (column) => column);

  GeneratedColumn<int> get discountPercent => $composableBuilder(
      column: $table.discountPercent, builder: (column) => column);

  GeneratedColumn<int> get discountFlatPaise => $composableBuilder(
      column: $table.discountFlatPaise, builder: (column) => column);

  GeneratedColumn<int> get discountPaise => $composableBuilder(
      column: $table.discountPaise, builder: (column) => column);

  GeneratedColumn<int> get taxBasisPoints => $composableBuilder(
      column: $table.taxBasisPoints, builder: (column) => column);

  GeneratedColumn<int> get taxPaise =>
      $composableBuilder(column: $table.taxPaise, builder: (column) => column);

  GeneratedColumn<int> get totalPaise => $composableBuilder(
      column: $table.totalPaise, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finalizedAt => $composableBuilder(
      column: $table.finalizedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<String> get voidReason => $composableBuilder(
      column: $table.voidReason, builder: (column) => column);

  GeneratedColumn<String> get voidedBy =>
      $composableBuilder(column: $table.voidedBy, builder: (column) => column);

  Expression<T> billLinesRefs<T extends Object>(
      Expression<T> Function($$BillLinesTableAnnotationComposer a) f) {
    final $$BillLinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.billLines,
        getReferencedColumn: (t) => t.billId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillLinesTableAnnotationComposer(
              $db: $db,
              $table: $db.billLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
      Expression<T> Function($$PaymentsTableAnnotationComposer a) f) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.billId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BillsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillsTable,
    BillRow,
    $$BillsTableFilterComposer,
    $$BillsTableOrderingComposer,
    $$BillsTableAnnotationComposer,
    $$BillsTableCreateCompanionBuilder,
    $$BillsTableUpdateCompanionBuilder,
    (BillRow, $$BillsTableReferences),
    BillRow,
    PrefetchHooks Function({bool billLinesRefs, bool paymentsRefs})> {
  $$BillsTableTableManager(_$AppDatabase db, $BillsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> provisionalRef = const Value.absent(),
            Value<int> localSeq = const Value.absent(),
            Value<String> draftId = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<String> customerPhone = const Value.absent(),
            Value<String> customerNotes = const Value.absent(),
            Value<String?> billingEmployeeId = const Value.absent(),
            Value<String?> billingEmployeeName = const Value.absent(),
            Value<String> snapshotBusinessName = const Value.absent(),
            Value<String?> snapshotTagline = const Value.absent(),
            Value<String> snapshotAddress = const Value.absent(),
            Value<String> snapshotPhone = const Value.absent(),
            Value<String?> snapshotEmail = const Value.absent(),
            Value<String?> snapshotGstin = const Value.absent(),
            Value<String?> snapshotUpiId = const Value.absent(),
            Value<String?> snapshotInvoiceFooter = const Value.absent(),
            Value<int> snapshotPrimaryColor = const Value.absent(),
            Value<int> subtotalPaise = const Value.absent(),
            Value<int> discountPercent = const Value.absent(),
            Value<int> discountFlatPaise = const Value.absent(),
            Value<int> discountPaise = const Value.absent(),
            Value<int> taxBasisPoints = const Value.absent(),
            Value<int> taxPaise = const Value.absent(),
            Value<int> totalPaise = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> paymentStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> finalizedAt = const Value.absent(),
            Value<DateTime?> voidedAt = const Value.absent(),
            Value<String?> voidReason = const Value.absent(),
            Value<String?> voidedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BillsCompanion(
            id: id,
            provisionalRef: provisionalRef,
            localSeq: localSeq,
            draftId: draftId,
            customerName: customerName,
            customerPhone: customerPhone,
            customerNotes: customerNotes,
            billingEmployeeId: billingEmployeeId,
            billingEmployeeName: billingEmployeeName,
            snapshotBusinessName: snapshotBusinessName,
            snapshotTagline: snapshotTagline,
            snapshotAddress: snapshotAddress,
            snapshotPhone: snapshotPhone,
            snapshotEmail: snapshotEmail,
            snapshotGstin: snapshotGstin,
            snapshotUpiId: snapshotUpiId,
            snapshotInvoiceFooter: snapshotInvoiceFooter,
            snapshotPrimaryColor: snapshotPrimaryColor,
            subtotalPaise: subtotalPaise,
            discountPercent: discountPercent,
            discountFlatPaise: discountFlatPaise,
            discountPaise: discountPaise,
            taxBasisPoints: taxBasisPoints,
            taxPaise: taxPaise,
            totalPaise: totalPaise,
            status: status,
            paymentStatus: paymentStatus,
            createdAt: createdAt,
            finalizedAt: finalizedAt,
            voidedAt: voidedAt,
            voidReason: voidReason,
            voidedBy: voidedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String provisionalRef,
            required int localSeq,
            required String draftId,
            Value<String> customerName = const Value.absent(),
            Value<String> customerPhone = const Value.absent(),
            Value<String> customerNotes = const Value.absent(),
            Value<String?> billingEmployeeId = const Value.absent(),
            Value<String?> billingEmployeeName = const Value.absent(),
            required String snapshotBusinessName,
            Value<String?> snapshotTagline = const Value.absent(),
            Value<String> snapshotAddress = const Value.absent(),
            Value<String> snapshotPhone = const Value.absent(),
            Value<String?> snapshotEmail = const Value.absent(),
            Value<String?> snapshotGstin = const Value.absent(),
            Value<String?> snapshotUpiId = const Value.absent(),
            Value<String?> snapshotInvoiceFooter = const Value.absent(),
            required int snapshotPrimaryColor,
            required int subtotalPaise,
            required int discountPercent,
            required int discountFlatPaise,
            required int discountPaise,
            required int taxBasisPoints,
            required int taxPaise,
            required int totalPaise,
            required String status,
            required String paymentStatus,
            required DateTime createdAt,
            required DateTime finalizedAt,
            Value<DateTime?> voidedAt = const Value.absent(),
            Value<String?> voidReason = const Value.absent(),
            Value<String?> voidedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BillsCompanion.insert(
            id: id,
            provisionalRef: provisionalRef,
            localSeq: localSeq,
            draftId: draftId,
            customerName: customerName,
            customerPhone: customerPhone,
            customerNotes: customerNotes,
            billingEmployeeId: billingEmployeeId,
            billingEmployeeName: billingEmployeeName,
            snapshotBusinessName: snapshotBusinessName,
            snapshotTagline: snapshotTagline,
            snapshotAddress: snapshotAddress,
            snapshotPhone: snapshotPhone,
            snapshotEmail: snapshotEmail,
            snapshotGstin: snapshotGstin,
            snapshotUpiId: snapshotUpiId,
            snapshotInvoiceFooter: snapshotInvoiceFooter,
            snapshotPrimaryColor: snapshotPrimaryColor,
            subtotalPaise: subtotalPaise,
            discountPercent: discountPercent,
            discountFlatPaise: discountFlatPaise,
            discountPaise: discountPaise,
            taxBasisPoints: taxBasisPoints,
            taxPaise: taxPaise,
            totalPaise: totalPaise,
            status: status,
            paymentStatus: paymentStatus,
            createdAt: createdAt,
            finalizedAt: finalizedAt,
            voidedAt: voidedAt,
            voidReason: voidReason,
            voidedBy: voidedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$BillsTable, BillRow>(table),
                    $$BillsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {billLinesRefs = false, paymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (billLinesRefs) db.billLines,
                if (paymentsRefs) db.payments
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (billLinesRefs)
                    await $_getPrefetchedDataByColumns<BillRow, $BillsTable,
                            BillLineRow, $BillLinesTable>(
                        currentTable: table,
                        referencedTable:
                            $$BillsTableReferences._billLinesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BillsTableReferences(db, table, p0).billLinesRefs,
                        currentColumn: 'id',
                        referencedColumn: 'bill_id',
                        typedResults: items),
                  if (paymentsRefs)
                    await $_getPrefetchedDataByColumns<BillRow, $BillsTable,
                            PaymentRow, $PaymentsTable>(
                        currentTable: table,
                        referencedTable:
                            $$BillsTableReferences._paymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BillsTableReferences(db, table, p0).paymentsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'bill_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BillsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillsTable,
    BillRow,
    $$BillsTableFilterComposer,
    $$BillsTableOrderingComposer,
    $$BillsTableAnnotationComposer,
    $$BillsTableCreateCompanionBuilder,
    $$BillsTableUpdateCompanionBuilder,
    (BillRow, $$BillsTableReferences),
    BillRow,
    PrefetchHooks Function({bool billLinesRefs, bool paymentsRefs})>;
typedef $$BillLinesTableCreateCompanionBuilder = BillLinesCompanion Function({
  Value<int> id,
  required String billId,
  required String serviceId,
  required String serviceName,
  required int pricePaise,
  Value<int> durationMinutes,
  required int quantity,
  Value<String?> employeeId,
  Value<String?> employeeName,
  required int position,
});
typedef $$BillLinesTableUpdateCompanionBuilder = BillLinesCompanion Function({
  Value<int> id,
  Value<String> billId,
  Value<String> serviceId,
  Value<String> serviceName,
  Value<int> pricePaise,
  Value<int> durationMinutes,
  Value<int> quantity,
  Value<String?> employeeId,
  Value<String?> employeeName,
  Value<int> position,
});

final class $$BillLinesTableReferences
    extends BaseReferences<_$AppDatabase, $BillLinesTable, BillLineRow> {
  $$BillLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BillsTable _billIdTable(_$AppDatabase db) =>
      db.bills.createAlias('bill_lines__bill_id__bills__id');

  $$BillsTableProcessedTableManager get billId {
    final $_column = $_itemColumn<String>('bill_id')!;

    final manager = $$BillsTableTableManager($_db, $_db.bills)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BillLinesTableFilterComposer
    extends Composer<_$AppDatabase, $BillLinesTable> {
  $$BillLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serviceId => $composableBuilder(
      column: $table.serviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serviceName => $composableBuilder(
      column: $table.serviceName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pricePaise => $composableBuilder(
      column: $table.pricePaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeName => $composableBuilder(
      column: $table.employeeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  $$BillsTableFilterComposer get billId {
    final $$BillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.billId,
        referencedTable: $db.bills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillsTableFilterComposer(
              $db: $db,
              $table: $db.bills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BillLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $BillLinesTable> {
  $$BillLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serviceId => $composableBuilder(
      column: $table.serviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serviceName => $composableBuilder(
      column: $table.serviceName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pricePaise => $composableBuilder(
      column: $table.pricePaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeName => $composableBuilder(
      column: $table.employeeName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  $$BillsTableOrderingComposer get billId {
    final $$BillsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.billId,
        referencedTable: $db.bills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillsTableOrderingComposer(
              $db: $db,
              $table: $db.bills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BillLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillLinesTable> {
  $$BillLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serviceId =>
      $composableBuilder(column: $table.serviceId, builder: (column) => column);

  GeneratedColumn<String> get serviceName => $composableBuilder(
      column: $table.serviceName, builder: (column) => column);

  GeneratedColumn<int> get pricePaise => $composableBuilder(
      column: $table.pricePaise, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get employeeName => $composableBuilder(
      column: $table.employeeName, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$BillsTableAnnotationComposer get billId {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.billId,
        referencedTable: $db.bills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillsTableAnnotationComposer(
              $db: $db,
              $table: $db.bills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BillLinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillLinesTable,
    BillLineRow,
    $$BillLinesTableFilterComposer,
    $$BillLinesTableOrderingComposer,
    $$BillLinesTableAnnotationComposer,
    $$BillLinesTableCreateCompanionBuilder,
    $$BillLinesTableUpdateCompanionBuilder,
    (BillLineRow, $$BillLinesTableReferences),
    BillLineRow,
    PrefetchHooks Function({bool billId})> {
  $$BillLinesTableTableManager(_$AppDatabase db, $BillLinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> billId = const Value.absent(),
            Value<String> serviceId = const Value.absent(),
            Value<String> serviceName = const Value.absent(),
            Value<int> pricePaise = const Value.absent(),
            Value<int> durationMinutes = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String?> employeeId = const Value.absent(),
            Value<String?> employeeName = const Value.absent(),
            Value<int> position = const Value.absent(),
          }) =>
              BillLinesCompanion(
            id: id,
            billId: billId,
            serviceId: serviceId,
            serviceName: serviceName,
            pricePaise: pricePaise,
            durationMinutes: durationMinutes,
            quantity: quantity,
            employeeId: employeeId,
            employeeName: employeeName,
            position: position,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String billId,
            required String serviceId,
            required String serviceName,
            required int pricePaise,
            Value<int> durationMinutes = const Value.absent(),
            required int quantity,
            Value<String?> employeeId = const Value.absent(),
            Value<String?> employeeName = const Value.absent(),
            required int position,
          }) =>
              BillLinesCompanion.insert(
            id: id,
            billId: billId,
            serviceId: serviceId,
            serviceName: serviceName,
            pricePaise: pricePaise,
            durationMinutes: durationMinutes,
            quantity: quantity,
            employeeId: employeeId,
            employeeName: employeeName,
            position: position,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$BillLinesTable, BillLineRow>(table),
                    $$BillLinesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({billId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (billId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.billId,
                    referencedTable:
                        $$BillLinesTableReferences._billIdTable(db),
                    referencedColumn:
                        $$BillLinesTableReferences._billIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BillLinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillLinesTable,
    BillLineRow,
    $$BillLinesTableFilterComposer,
    $$BillLinesTableOrderingComposer,
    $$BillLinesTableAnnotationComposer,
    $$BillLinesTableCreateCompanionBuilder,
    $$BillLinesTableUpdateCompanionBuilder,
    (BillLineRow, $$BillLinesTableReferences),
    BillLineRow,
    PrefetchHooks Function({bool billId})>;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  required String id,
  required String billId,
  required String method,
  required int amountPaise,
  required String status,
  Value<String?> confirmedBy,
  Value<DateTime?> confirmedAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<String> id,
  Value<String> billId,
  Value<String> method,
  Value<int> amountPaise,
  Value<String> status,
  Value<String?> confirmedBy,
  Value<DateTime?> confirmedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, PaymentRow> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BillsTable _billIdTable(_$AppDatabase db) =>
      db.bills.createAlias('payments__bill_id__bills__id');

  $$BillsTableProcessedTableManager get billId {
    final $_column = $_itemColumn<String>('bill_id')!;

    final manager = $$BillsTableTableManager($_db, $_db.bills)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get confirmedBy => $composableBuilder(
      column: $table.confirmedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get confirmedAt => $composableBuilder(
      column: $table.confirmedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$BillsTableFilterComposer get billId {
    final $$BillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.billId,
        referencedTable: $db.bills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillsTableFilterComposer(
              $db: $db,
              $table: $db.bills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get confirmedBy => $composableBuilder(
      column: $table.confirmedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get confirmedAt => $composableBuilder(
      column: $table.confirmedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$BillsTableOrderingComposer get billId {
    final $$BillsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.billId,
        referencedTable: $db.bills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillsTableOrderingComposer(
              $db: $db,
              $table: $db.bills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get confirmedBy => $composableBuilder(
      column: $table.confirmedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get confirmedAt => $composableBuilder(
      column: $table.confirmedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BillsTableAnnotationComposer get billId {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.billId,
        referencedTable: $db.bills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BillsTableAnnotationComposer(
              $db: $db,
              $table: $db.bills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    PaymentRow,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (PaymentRow, $$PaymentsTableReferences),
    PaymentRow,
    PrefetchHooks Function({bool billId})> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> billId = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<int> amountPaise = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> confirmedBy = const Value.absent(),
            Value<DateTime?> confirmedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion(
            id: id,
            billId: billId,
            method: method,
            amountPaise: amountPaise,
            status: status,
            confirmedBy: confirmedBy,
            confirmedAt: confirmedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String billId,
            required String method,
            required int amountPaise,
            required String status,
            Value<String?> confirmedBy = const Value.absent(),
            Value<DateTime?> confirmedAt = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            id: id,
            billId: billId,
            method: method,
            amountPaise: amountPaise,
            status: status,
            confirmedBy: confirmedBy,
            confirmedAt: confirmedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PaymentsTable, PaymentRow>(table),
                    $$PaymentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({billId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (billId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.billId,
                    referencedTable: $$PaymentsTableReferences._billIdTable(db),
                    referencedColumn:
                        $$PaymentsTableReferences._billIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTable,
    PaymentRow,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (PaymentRow, $$PaymentsTableReferences),
    PaymentRow,
    PrefetchHooks Function({bool billId})>;
typedef $$InvoiceCountersTableCreateCompanionBuilder = InvoiceCountersCompanion
    Function({
  required String key,
  required int value,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$InvoiceCountersTableUpdateCompanionBuilder = InvoiceCountersCompanion
    Function({
  Value<String> key,
  Value<int> value,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$InvoiceCountersTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceCountersTable> {
  $$InvoiceCountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$InvoiceCountersTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceCountersTable> {
  $$InvoiceCountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$InvoiceCountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceCountersTable> {
  $$InvoiceCountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InvoiceCountersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvoiceCountersTable,
    InvoiceCounter,
    $$InvoiceCountersTableFilterComposer,
    $$InvoiceCountersTableOrderingComposer,
    $$InvoiceCountersTableAnnotationComposer,
    $$InvoiceCountersTableCreateCompanionBuilder,
    $$InvoiceCountersTableUpdateCompanionBuilder,
    (
      InvoiceCounter,
      BaseReferences<_$AppDatabase, $InvoiceCountersTable, InvoiceCounter>
    ),
    InvoiceCounter,
    PrefetchHooks Function()> {
  $$InvoiceCountersTableTableManager(
      _$AppDatabase db, $InvoiceCountersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<int> value = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvoiceCountersCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required int value,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              InvoiceCountersCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$InvoiceCountersTable, InvoiceCounter>(table),
                    BaseReferences<_$AppDatabase, $InvoiceCountersTable,
                        InvoiceCounter>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InvoiceCountersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InvoiceCountersTable,
    InvoiceCounter,
    $$InvoiceCountersTableFilterComposer,
    $$InvoiceCountersTableOrderingComposer,
    $$InvoiceCountersTableAnnotationComposer,
    $$InvoiceCountersTableCreateCompanionBuilder,
    $$InvoiceCountersTableUpdateCompanionBuilder,
    (
      InvoiceCounter,
      BaseReferences<_$AppDatabase, $InvoiceCountersTable, InvoiceCounter>
    ),
    InvoiceCounter,
    PrefetchHooks Function()>;
typedef $$BillingAuditEventsTableCreateCompanionBuilder
    = BillingAuditEventsCompanion Function({
  Value<int> id,
  Value<String?> billId,
  Value<String?> draftId,
  required String type,
  required String actor,
  Value<String> detail,
  required DateTime createdAt,
});
typedef $$BillingAuditEventsTableUpdateCompanionBuilder
    = BillingAuditEventsCompanion Function({
  Value<int> id,
  Value<String?> billId,
  Value<String?> draftId,
  Value<String> type,
  Value<String> actor,
  Value<String> detail,
  Value<DateTime> createdAt,
});

class $$BillingAuditEventsTableFilterComposer
    extends Composer<_$AppDatabase, $BillingAuditEventsTable> {
  $$BillingAuditEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billId => $composableBuilder(
      column: $table.billId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get draftId => $composableBuilder(
      column: $table.draftId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actor => $composableBuilder(
      column: $table.actor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detail => $composableBuilder(
      column: $table.detail, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BillingAuditEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillingAuditEventsTable> {
  $$BillingAuditEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billId => $composableBuilder(
      column: $table.billId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get draftId => $composableBuilder(
      column: $table.draftId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actor => $composableBuilder(
      column: $table.actor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detail => $composableBuilder(
      column: $table.detail, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BillingAuditEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillingAuditEventsTable> {
  $$BillingAuditEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get billId =>
      $composableBuilder(column: $table.billId, builder: (column) => column);

  GeneratedColumn<String> get draftId =>
      $composableBuilder(column: $table.draftId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BillingAuditEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BillingAuditEventsTable,
    AuditEventRow,
    $$BillingAuditEventsTableFilterComposer,
    $$BillingAuditEventsTableOrderingComposer,
    $$BillingAuditEventsTableAnnotationComposer,
    $$BillingAuditEventsTableCreateCompanionBuilder,
    $$BillingAuditEventsTableUpdateCompanionBuilder,
    (
      AuditEventRow,
      BaseReferences<_$AppDatabase, $BillingAuditEventsTable, AuditEventRow>
    ),
    AuditEventRow,
    PrefetchHooks Function()> {
  $$BillingAuditEventsTableTableManager(
      _$AppDatabase db, $BillingAuditEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillingAuditEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillingAuditEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillingAuditEventsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> billId = const Value.absent(),
            Value<String?> draftId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> actor = const Value.absent(),
            Value<String> detail = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BillingAuditEventsCompanion(
            id: id,
            billId: billId,
            draftId: draftId,
            type: type,
            actor: actor,
            detail: detail,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> billId = const Value.absent(),
            Value<String?> draftId = const Value.absent(),
            required String type,
            required String actor,
            Value<String> detail = const Value.absent(),
            required DateTime createdAt,
          }) =>
              BillingAuditEventsCompanion.insert(
            id: id,
            billId: billId,
            draftId: draftId,
            type: type,
            actor: actor,
            detail: detail,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$BillingAuditEventsTable, AuditEventRow>(table),
                    BaseReferences<_$AppDatabase, $BillingAuditEventsTable,
                        AuditEventRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BillingAuditEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BillingAuditEventsTable,
    AuditEventRow,
    $$BillingAuditEventsTableFilterComposer,
    $$BillingAuditEventsTableOrderingComposer,
    $$BillingAuditEventsTableAnnotationComposer,
    $$BillingAuditEventsTableCreateCompanionBuilder,
    $$BillingAuditEventsTableUpdateCompanionBuilder,
    (
      AuditEventRow,
      BaseReferences<_$AppDatabase, $BillingAuditEventsTable, AuditEventRow>
    ),
    AuditEventRow,
    PrefetchHooks Function()>;
typedef $$AttendanceRecordsTableCreateCompanionBuilder
    = AttendanceRecordsCompanion Function({
  Value<int> id,
  required String employeeId,
  required String dateKey,
  required String status,
  required String markedBy,
  required DateTime markedAt,
  required DateTime updatedAt,
});
typedef $$AttendanceRecordsTableUpdateCompanionBuilder
    = AttendanceRecordsCompanion Function({
  Value<int> id,
  Value<String> employeeId,
  Value<String> dateKey,
  Value<String> status,
  Value<String> markedBy,
  Value<DateTime> markedAt,
  Value<DateTime> updatedAt,
});

final class $$AttendanceRecordsTableReferences extends BaseReferences<
    _$AppDatabase, $AttendanceRecordsTable, AttendanceRow> {
  $$AttendanceRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) => db.employees
      .createAlias('attendance_records__employee_id__employees__id');

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<String>('employee_id')!;

    final manager = $$EmployeesTableTableManager($_db, $_db.employees)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AttendanceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get markedBy => $composableBuilder(
      column: $table.markedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get markedAt => $composableBuilder(
      column: $table.markedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableFilterComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendanceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get markedBy => $composableBuilder(
      column: $table.markedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get markedAt => $composableBuilder(
      column: $table.markedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableOrderingComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendanceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get markedBy =>
      $composableBuilder(column: $table.markedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get markedAt =>
      $composableBuilder(column: $table.markedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableAnnotationComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendanceRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttendanceRecordsTable,
    AttendanceRow,
    $$AttendanceRecordsTableFilterComposer,
    $$AttendanceRecordsTableOrderingComposer,
    $$AttendanceRecordsTableAnnotationComposer,
    $$AttendanceRecordsTableCreateCompanionBuilder,
    $$AttendanceRecordsTableUpdateCompanionBuilder,
    (AttendanceRow, $$AttendanceRecordsTableReferences),
    AttendanceRow,
    PrefetchHooks Function({bool employeeId})> {
  $$AttendanceRecordsTableTableManager(
      _$AppDatabase db, $AttendanceRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<String> dateKey = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> markedBy = const Value.absent(),
            Value<DateTime> markedAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AttendanceRecordsCompanion(
            id: id,
            employeeId: employeeId,
            dateKey: dateKey,
            status: status,
            markedBy: markedBy,
            markedAt: markedAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String employeeId,
            required String dateKey,
            required String status,
            required String markedBy,
            required DateTime markedAt,
            required DateTime updatedAt,
          }) =>
              AttendanceRecordsCompanion.insert(
            id: id,
            employeeId: employeeId,
            dateKey: dateKey,
            status: status,
            markedBy: markedBy,
            markedAt: markedAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AttendanceRecordsTable, AttendanceRow>(table),
                    $$AttendanceRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (employeeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.employeeId,
                    referencedTable:
                        $$AttendanceRecordsTableReferences._employeeIdTable(db),
                    referencedColumn: $$AttendanceRecordsTableReferences
                        ._employeeIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AttendanceRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttendanceRecordsTable,
    AttendanceRow,
    $$AttendanceRecordsTableFilterComposer,
    $$AttendanceRecordsTableOrderingComposer,
    $$AttendanceRecordsTableAnnotationComposer,
    $$AttendanceRecordsTableCreateCompanionBuilder,
    $$AttendanceRecordsTableUpdateCompanionBuilder,
    (AttendanceRow, $$AttendanceRecordsTableReferences),
    AttendanceRow,
    PrefetchHooks Function({bool employeeId})>;
typedef $$AttendanceAuditEventsTableCreateCompanionBuilder
    = AttendanceAuditEventsCompanion Function({
  Value<int> id,
  required String employeeId,
  required String dateKey,
  Value<String?> oldStatus,
  required String newStatus,
  required String actor,
  required DateTime createdAt,
});
typedef $$AttendanceAuditEventsTableUpdateCompanionBuilder
    = AttendanceAuditEventsCompanion Function({
  Value<int> id,
  Value<String> employeeId,
  Value<String> dateKey,
  Value<String?> oldStatus,
  Value<String> newStatus,
  Value<String> actor,
  Value<DateTime> createdAt,
});

class $$AttendanceAuditEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceAuditEventsTable> {
  $$AttendanceAuditEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get oldStatus => $composableBuilder(
      column: $table.oldStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get newStatus => $composableBuilder(
      column: $table.newStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actor => $composableBuilder(
      column: $table.actor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AttendanceAuditEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceAuditEventsTable> {
  $$AttendanceAuditEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get oldStatus => $composableBuilder(
      column: $table.oldStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get newStatus => $composableBuilder(
      column: $table.newStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actor => $composableBuilder(
      column: $table.actor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AttendanceAuditEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceAuditEventsTable> {
  $$AttendanceAuditEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<String> get oldStatus =>
      $composableBuilder(column: $table.oldStatus, builder: (column) => column);

  GeneratedColumn<String> get newStatus =>
      $composableBuilder(column: $table.newStatus, builder: (column) => column);

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AttendanceAuditEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttendanceAuditEventsTable,
    AttendanceAuditRow,
    $$AttendanceAuditEventsTableFilterComposer,
    $$AttendanceAuditEventsTableOrderingComposer,
    $$AttendanceAuditEventsTableAnnotationComposer,
    $$AttendanceAuditEventsTableCreateCompanionBuilder,
    $$AttendanceAuditEventsTableUpdateCompanionBuilder,
    (
      AttendanceAuditRow,
      BaseReferences<_$AppDatabase, $AttendanceAuditEventsTable,
          AttendanceAuditRow>
    ),
    AttendanceAuditRow,
    PrefetchHooks Function()> {
  $$AttendanceAuditEventsTableTableManager(
      _$AppDatabase db, $AttendanceAuditEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceAuditEventsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceAuditEventsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceAuditEventsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<String> dateKey = const Value.absent(),
            Value<String?> oldStatus = const Value.absent(),
            Value<String> newStatus = const Value.absent(),
            Value<String> actor = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AttendanceAuditEventsCompanion(
            id: id,
            employeeId: employeeId,
            dateKey: dateKey,
            oldStatus: oldStatus,
            newStatus: newStatus,
            actor: actor,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String employeeId,
            required String dateKey,
            Value<String?> oldStatus = const Value.absent(),
            required String newStatus,
            required String actor,
            required DateTime createdAt,
          }) =>
              AttendanceAuditEventsCompanion.insert(
            id: id,
            employeeId: employeeId,
            dateKey: dateKey,
            oldStatus: oldStatus,
            newStatus: newStatus,
            actor: actor,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AttendanceAuditEventsTable,
                        AttendanceAuditRow>(table),
                    BaseReferences<_$AppDatabase, $AttendanceAuditEventsTable,
                        AttendanceAuditRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AttendanceAuditEventsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $AttendanceAuditEventsTable,
        AttendanceAuditRow,
        $$AttendanceAuditEventsTableFilterComposer,
        $$AttendanceAuditEventsTableOrderingComposer,
        $$AttendanceAuditEventsTableAnnotationComposer,
        $$AttendanceAuditEventsTableCreateCompanionBuilder,
        $$AttendanceAuditEventsTableUpdateCompanionBuilder,
        (
          AttendanceAuditRow,
          BaseReferences<_$AppDatabase, $AttendanceAuditEventsTable,
              AttendanceAuditRow>
        ),
        AttendanceAuditRow,
        PrefetchHooks Function()>;
typedef $$SalaryAdvancesTableCreateCompanionBuilder = SalaryAdvancesCompanion
    Function({
  required String id,
  required String employeeId,
  required int amountPaise,
  required String businessDateKey,
  required DateTime recordedAt,
  required String method,
  Value<String?> notes,
  required String recordedBy,
  Value<String?> reversalOfId,
  Value<int> rowid,
});
typedef $$SalaryAdvancesTableUpdateCompanionBuilder = SalaryAdvancesCompanion
    Function({
  Value<String> id,
  Value<String> employeeId,
  Value<int> amountPaise,
  Value<String> businessDateKey,
  Value<DateTime> recordedAt,
  Value<String> method,
  Value<String?> notes,
  Value<String> recordedBy,
  Value<String?> reversalOfId,
  Value<int> rowid,
});

final class $$SalaryAdvancesTableReferences
    extends BaseReferences<_$AppDatabase, $SalaryAdvancesTable, AdvanceRow> {
  $$SalaryAdvancesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias('salary_advances__employee_id__employees__id');

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<String>('employee_id')!;

    final manager = $$EmployeesTableTableManager($_db, $_db.employees)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SalaryAdvancesTableFilterComposer
    extends Composer<_$AppDatabase, $SalaryAdvancesTable> {
  $$SalaryAdvancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessDateKey => $composableBuilder(
      column: $table.businessDateKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reversalOfId => $composableBuilder(
      column: $table.reversalOfId, builder: (column) => ColumnFilters(column));

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableFilterComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalaryAdvancesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalaryAdvancesTable> {
  $$SalaryAdvancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessDateKey => $composableBuilder(
      column: $table.businessDateKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reversalOfId => $composableBuilder(
      column: $table.reversalOfId,
      builder: (column) => ColumnOrderings(column));

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableOrderingComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalaryAdvancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalaryAdvancesTable> {
  $$SalaryAdvancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => column);

  GeneratedColumn<String> get businessDateKey => $composableBuilder(
      column: $table.businessDateKey, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => column);

  GeneratedColumn<String> get reversalOfId => $composableBuilder(
      column: $table.reversalOfId, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableAnnotationComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalaryAdvancesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalaryAdvancesTable,
    AdvanceRow,
    $$SalaryAdvancesTableFilterComposer,
    $$SalaryAdvancesTableOrderingComposer,
    $$SalaryAdvancesTableAnnotationComposer,
    $$SalaryAdvancesTableCreateCompanionBuilder,
    $$SalaryAdvancesTableUpdateCompanionBuilder,
    (AdvanceRow, $$SalaryAdvancesTableReferences),
    AdvanceRow,
    PrefetchHooks Function({bool employeeId})> {
  $$SalaryAdvancesTableTableManager(
      _$AppDatabase db, $SalaryAdvancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalaryAdvancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalaryAdvancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalaryAdvancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<int> amountPaise = const Value.absent(),
            Value<String> businessDateKey = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> recordedBy = const Value.absent(),
            Value<String?> reversalOfId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalaryAdvancesCompanion(
            id: id,
            employeeId: employeeId,
            amountPaise: amountPaise,
            businessDateKey: businessDateKey,
            recordedAt: recordedAt,
            method: method,
            notes: notes,
            recordedBy: recordedBy,
            reversalOfId: reversalOfId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            required int amountPaise,
            required String businessDateKey,
            required DateTime recordedAt,
            required String method,
            Value<String?> notes = const Value.absent(),
            required String recordedBy,
            Value<String?> reversalOfId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalaryAdvancesCompanion.insert(
            id: id,
            employeeId: employeeId,
            amountPaise: amountPaise,
            businessDateKey: businessDateKey,
            recordedAt: recordedAt,
            method: method,
            notes: notes,
            recordedBy: recordedBy,
            reversalOfId: reversalOfId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SalaryAdvancesTable, AdvanceRow>(table),
                    $$SalaryAdvancesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (employeeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.employeeId,
                    referencedTable:
                        $$SalaryAdvancesTableReferences._employeeIdTable(db),
                    referencedColumn:
                        $$SalaryAdvancesTableReferences._employeeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SalaryAdvancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalaryAdvancesTable,
    AdvanceRow,
    $$SalaryAdvancesTableFilterComposer,
    $$SalaryAdvancesTableOrderingComposer,
    $$SalaryAdvancesTableAnnotationComposer,
    $$SalaryAdvancesTableCreateCompanionBuilder,
    $$SalaryAdvancesTableUpdateCompanionBuilder,
    (AdvanceRow, $$SalaryAdvancesTableReferences),
    AdvanceRow,
    PrefetchHooks Function({bool employeeId})>;
typedef $$PayrollSettingsTableCreateCompanionBuilder = PayrollSettingsCompanion
    Function({
  Value<int> id,
  required String rulesJson,
  Value<DateTime?> reviewedAt,
  required DateTime updatedAt,
});
typedef $$PayrollSettingsTableUpdateCompanionBuilder = PayrollSettingsCompanion
    Function({
  Value<int> id,
  Value<String> rulesJson,
  Value<DateTime?> reviewedAt,
  Value<DateTime> updatedAt,
});

class $$PayrollSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $PayrollSettingsTable> {
  $$PayrollSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rulesJson => $composableBuilder(
      column: $table.rulesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PayrollSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $PayrollSettingsTable> {
  $$PayrollSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rulesJson => $composableBuilder(
      column: $table.rulesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PayrollSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayrollSettingsTable> {
  $$PayrollSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rulesJson =>
      $composableBuilder(column: $table.rulesJson, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
      column: $table.reviewedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PayrollSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PayrollSettingsTable,
    PayrollSetting,
    $$PayrollSettingsTableFilterComposer,
    $$PayrollSettingsTableOrderingComposer,
    $$PayrollSettingsTableAnnotationComposer,
    $$PayrollSettingsTableCreateCompanionBuilder,
    $$PayrollSettingsTableUpdateCompanionBuilder,
    (
      PayrollSetting,
      BaseReferences<_$AppDatabase, $PayrollSettingsTable, PayrollSetting>
    ),
    PayrollSetting,
    PrefetchHooks Function()> {
  $$PayrollSettingsTableTableManager(
      _$AppDatabase db, $PayrollSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayrollSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayrollSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayrollSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> rulesJson = const Value.absent(),
            Value<DateTime?> reviewedAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PayrollSettingsCompanion(
            id: id,
            rulesJson: rulesJson,
            reviewedAt: reviewedAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String rulesJson,
            Value<DateTime?> reviewedAt = const Value.absent(),
            required DateTime updatedAt,
          }) =>
              PayrollSettingsCompanion.insert(
            id: id,
            rulesJson: rulesJson,
            reviewedAt: reviewedAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PayrollSettingsTable, PayrollSetting>(table),
                    BaseReferences<_$AppDatabase, $PayrollSettingsTable,
                        PayrollSetting>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PayrollSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PayrollSettingsTable,
    PayrollSetting,
    $$PayrollSettingsTableFilterComposer,
    $$PayrollSettingsTableOrderingComposer,
    $$PayrollSettingsTableAnnotationComposer,
    $$PayrollSettingsTableCreateCompanionBuilder,
    $$PayrollSettingsTableUpdateCompanionBuilder,
    (
      PayrollSetting,
      BaseReferences<_$AppDatabase, $PayrollSettingsTable, PayrollSetting>
    ),
    PayrollSetting,
    PrefetchHooks Function()>;
typedef $$PayrollRunsTableCreateCompanionBuilder = PayrollRunsCompanion
    Function({
  required String id,
  required String periodKey,
  Value<int> version,
  required String status,
  Value<String?> rulesJson,
  required String createdBy,
  required DateTime createdAt,
  Value<String?> approvedBy,
  Value<DateTime?> approvedAt,
  Value<String?> voidReason,
  Value<int> rowid,
});
typedef $$PayrollRunsTableUpdateCompanionBuilder = PayrollRunsCompanion
    Function({
  Value<String> id,
  Value<String> periodKey,
  Value<int> version,
  Value<String> status,
  Value<String?> rulesJson,
  Value<String> createdBy,
  Value<DateTime> createdAt,
  Value<String?> approvedBy,
  Value<DateTime?> approvedAt,
  Value<String?> voidReason,
  Value<int> rowid,
});

final class $$PayrollRunsTableReferences
    extends BaseReferences<_$AppDatabase, $PayrollRunsTable, PayrollRunRow> {
  $$PayrollRunsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PayrollLinesTable, List<PayrollLineRow>>
      _payrollLinesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.payrollLines,
              aliasName: 'payroll_runs__id__payroll_lines__run_id');

  $$PayrollLinesTableProcessedTableManager get payrollLinesRefs {
    final manager = $$PayrollLinesTableTableManager($_db, $_db.payrollLines)
        .filter((f) => f.runId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_payrollLinesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PayrollAdjustmentsTable,
      List<PayrollAdjustmentRow>> _payrollAdjustmentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.payrollAdjustments,
          aliasName: 'payroll_runs__id__payroll_adjustments__run_id');

  $$PayrollAdjustmentsTableProcessedTableManager get payrollAdjustmentsRefs {
    final manager =
        $$PayrollAdjustmentsTableTableManager($_db, $_db.payrollAdjustments)
            .filter((f) => f.runId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_payrollAdjustmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PayrollPaymentsTable, List<PayrollPaymentRow>>
      _payrollPaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.payrollPayments,
              aliasName: 'payroll_runs__id__payroll_payments__run_id');

  $$PayrollPaymentsTableProcessedTableManager get payrollPaymentsRefs {
    final manager =
        $$PayrollPaymentsTableTableManager($_db, $_db.payrollPayments)
            .filter((f) => f.runId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_payrollPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PayrollAdvanceLinksTable,
      List<PayrollAdvanceLinkRow>> _payrollAdvanceLinksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.payrollAdvanceLinks,
          aliasName: 'payroll_runs__id__payroll_advance_links__run_id');

  $$PayrollAdvanceLinksTableProcessedTableManager get payrollAdvanceLinksRefs {
    final manager =
        $$PayrollAdvanceLinksTableTableManager($_db, $_db.payrollAdvanceLinks)
            .filter((f) => f.runId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_payrollAdvanceLinksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PayrollRunsTableFilterComposer
    extends Composer<_$AppDatabase, $PayrollRunsTable> {
  $$PayrollRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get periodKey => $composableBuilder(
      column: $table.periodKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rulesJson => $composableBuilder(
      column: $table.rulesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get approvedBy => $composableBuilder(
      column: $table.approvedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get voidReason => $composableBuilder(
      column: $table.voidReason, builder: (column) => ColumnFilters(column));

  Expression<bool> payrollLinesRefs(
      Expression<bool> Function($$PayrollLinesTableFilterComposer f) f) {
    final $$PayrollLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payrollLines,
        getReferencedColumn: (t) => t.runId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollLinesTableFilterComposer(
              $db: $db,
              $table: $db.payrollLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> payrollAdjustmentsRefs(
      Expression<bool> Function($$PayrollAdjustmentsTableFilterComposer f) f) {
    final $$PayrollAdjustmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payrollAdjustments,
        getReferencedColumn: (t) => t.runId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollAdjustmentsTableFilterComposer(
              $db: $db,
              $table: $db.payrollAdjustments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> payrollPaymentsRefs(
      Expression<bool> Function($$PayrollPaymentsTableFilterComposer f) f) {
    final $$PayrollPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payrollPayments,
        getReferencedColumn: (t) => t.runId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.payrollPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> payrollAdvanceLinksRefs(
      Expression<bool> Function($$PayrollAdvanceLinksTableFilterComposer f) f) {
    final $$PayrollAdvanceLinksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payrollAdvanceLinks,
        getReferencedColumn: (t) => t.runId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollAdvanceLinksTableFilterComposer(
              $db: $db,
              $table: $db.payrollAdvanceLinks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PayrollRunsTableOrderingComposer
    extends Composer<_$AppDatabase, $PayrollRunsTable> {
  $$PayrollRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get periodKey => $composableBuilder(
      column: $table.periodKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rulesJson => $composableBuilder(
      column: $table.rulesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get approvedBy => $composableBuilder(
      column: $table.approvedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get voidReason => $composableBuilder(
      column: $table.voidReason, builder: (column) => ColumnOrderings(column));
}

class $$PayrollRunsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayrollRunsTable> {
  $$PayrollRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get periodKey =>
      $composableBuilder(column: $table.periodKey, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get rulesJson =>
      $composableBuilder(column: $table.rulesJson, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get approvedBy => $composableBuilder(
      column: $table.approvedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => column);

  GeneratedColumn<String> get voidReason => $composableBuilder(
      column: $table.voidReason, builder: (column) => column);

  Expression<T> payrollLinesRefs<T extends Object>(
      Expression<T> Function($$PayrollLinesTableAnnotationComposer a) f) {
    final $$PayrollLinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payrollLines,
        getReferencedColumn: (t) => t.runId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollLinesTableAnnotationComposer(
              $db: $db,
              $table: $db.payrollLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> payrollAdjustmentsRefs<T extends Object>(
      Expression<T> Function($$PayrollAdjustmentsTableAnnotationComposer a) f) {
    final $$PayrollAdjustmentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.payrollAdjustments,
            getReferencedColumn: (t) => t.runId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PayrollAdjustmentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.payrollAdjustments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> payrollPaymentsRefs<T extends Object>(
      Expression<T> Function($$PayrollPaymentsTableAnnotationComposer a) f) {
    final $$PayrollPaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payrollPayments,
        getReferencedColumn: (t) => t.runId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollPaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.payrollPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> payrollAdvanceLinksRefs<T extends Object>(
      Expression<T> Function($$PayrollAdvanceLinksTableAnnotationComposer a)
          f) {
    final $$PayrollAdvanceLinksTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.payrollAdvanceLinks,
            getReferencedColumn: (t) => t.runId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PayrollAdvanceLinksTableAnnotationComposer(
                  $db: $db,
                  $table: $db.payrollAdvanceLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PayrollRunsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PayrollRunsTable,
    PayrollRunRow,
    $$PayrollRunsTableFilterComposer,
    $$PayrollRunsTableOrderingComposer,
    $$PayrollRunsTableAnnotationComposer,
    $$PayrollRunsTableCreateCompanionBuilder,
    $$PayrollRunsTableUpdateCompanionBuilder,
    (PayrollRunRow, $$PayrollRunsTableReferences),
    PayrollRunRow,
    PrefetchHooks Function(
        {bool payrollLinesRefs,
        bool payrollAdjustmentsRefs,
        bool payrollPaymentsRefs,
        bool payrollAdvanceLinksRefs})> {
  $$PayrollRunsTableTableManager(_$AppDatabase db, $PayrollRunsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayrollRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayrollRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayrollRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> periodKey = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> rulesJson = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> approvedBy = const Value.absent(),
            Value<DateTime?> approvedAt = const Value.absent(),
            Value<String?> voidReason = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollRunsCompanion(
            id: id,
            periodKey: periodKey,
            version: version,
            status: status,
            rulesJson: rulesJson,
            createdBy: createdBy,
            createdAt: createdAt,
            approvedBy: approvedBy,
            approvedAt: approvedAt,
            voidReason: voidReason,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String periodKey,
            Value<int> version = const Value.absent(),
            required String status,
            Value<String?> rulesJson = const Value.absent(),
            required String createdBy,
            required DateTime createdAt,
            Value<String?> approvedBy = const Value.absent(),
            Value<DateTime?> approvedAt = const Value.absent(),
            Value<String?> voidReason = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollRunsCompanion.insert(
            id: id,
            periodKey: periodKey,
            version: version,
            status: status,
            rulesJson: rulesJson,
            createdBy: createdBy,
            createdAt: createdAt,
            approvedBy: approvedBy,
            approvedAt: approvedAt,
            voidReason: voidReason,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PayrollRunsTable, PayrollRunRow>(table),
                    $$PayrollRunsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {payrollLinesRefs = false,
              payrollAdjustmentsRefs = false,
              payrollPaymentsRefs = false,
              payrollAdvanceLinksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (payrollLinesRefs) db.payrollLines,
                if (payrollAdjustmentsRefs) db.payrollAdjustments,
                if (payrollPaymentsRefs) db.payrollPayments,
                if (payrollAdvanceLinksRefs) db.payrollAdvanceLinks
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (payrollLinesRefs)
                    await $_getPrefetchedDataByColumns<
                            PayrollRunRow,
                            $PayrollRunsTable,
                            PayrollLineRow,
                            $PayrollLinesTable>(
                        currentTable: table,
                        referencedTable: $$PayrollRunsTableReferences
                            ._payrollLinesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PayrollRunsTableReferences(db, table, p0)
                                .payrollLinesRefs,
                        currentColumn: 'id',
                        referencedColumn: 'run_id',
                        typedResults: items),
                  if (payrollAdjustmentsRefs)
                    await $_getPrefetchedDataByColumns<
                            PayrollRunRow,
                            $PayrollRunsTable,
                            PayrollAdjustmentRow,
                            $PayrollAdjustmentsTable>(
                        currentTable: table,
                        referencedTable: $$PayrollRunsTableReferences
                            ._payrollAdjustmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PayrollRunsTableReferences(db, table, p0)
                                .payrollAdjustmentsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'run_id',
                        typedResults: items),
                  if (payrollPaymentsRefs)
                    await $_getPrefetchedDataByColumns<
                            PayrollRunRow,
                            $PayrollRunsTable,
                            PayrollPaymentRow,
                            $PayrollPaymentsTable>(
                        currentTable: table,
                        referencedTable: $$PayrollRunsTableReferences
                            ._payrollPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PayrollRunsTableReferences(db, table, p0)
                                .payrollPaymentsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'run_id',
                        typedResults: items),
                  if (payrollAdvanceLinksRefs)
                    await $_getPrefetchedDataByColumns<
                            PayrollRunRow,
                            $PayrollRunsTable,
                            PayrollAdvanceLinkRow,
                            $PayrollAdvanceLinksTable>(
                        currentTable: table,
                        referencedTable: $$PayrollRunsTableReferences
                            ._payrollAdvanceLinksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PayrollRunsTableReferences(db, table, p0)
                                .payrollAdvanceLinksRefs,
                        currentColumn: 'id',
                        referencedColumn: 'run_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PayrollRunsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PayrollRunsTable,
    PayrollRunRow,
    $$PayrollRunsTableFilterComposer,
    $$PayrollRunsTableOrderingComposer,
    $$PayrollRunsTableAnnotationComposer,
    $$PayrollRunsTableCreateCompanionBuilder,
    $$PayrollRunsTableUpdateCompanionBuilder,
    (PayrollRunRow, $$PayrollRunsTableReferences),
    PayrollRunRow,
    PrefetchHooks Function(
        {bool payrollLinesRefs,
        bool payrollAdjustmentsRefs,
        bool payrollPaymentsRefs,
        bool payrollAdvanceLinksRefs})>;
typedef $$PayrollLinesTableCreateCompanionBuilder = PayrollLinesCompanion
    Function({
  required String id,
  required String runId,
  required String employeeId,
  required String employeeName,
  required String salaryType,
  required int ratePaise,
  Value<int> presentDays,
  Value<int> halfDays,
  Value<int> leaveDays,
  Value<int> absentDays,
  Value<int> unmarkedDays,
  Value<int> weeklyOffDays,
  Value<int> holidayDays,
  Value<int> payableUnitsBp,
  Value<int> basisDays,
  Value<int> earningsPaise,
  Value<int> overtimeUnitsBp,
  Value<int> overtimePaise,
  Value<int> bonusPaise,
  Value<int> deductionsPaise,
  Value<int> advancesPaise,
  Value<int> grossPaise,
  Value<int> netPaise,
  Value<int> carryForwardPaise,
  Value<int> paidPaise,
  Value<int> rowid,
});
typedef $$PayrollLinesTableUpdateCompanionBuilder = PayrollLinesCompanion
    Function({
  Value<String> id,
  Value<String> runId,
  Value<String> employeeId,
  Value<String> employeeName,
  Value<String> salaryType,
  Value<int> ratePaise,
  Value<int> presentDays,
  Value<int> halfDays,
  Value<int> leaveDays,
  Value<int> absentDays,
  Value<int> unmarkedDays,
  Value<int> weeklyOffDays,
  Value<int> holidayDays,
  Value<int> payableUnitsBp,
  Value<int> basisDays,
  Value<int> earningsPaise,
  Value<int> overtimeUnitsBp,
  Value<int> overtimePaise,
  Value<int> bonusPaise,
  Value<int> deductionsPaise,
  Value<int> advancesPaise,
  Value<int> grossPaise,
  Value<int> netPaise,
  Value<int> carryForwardPaise,
  Value<int> paidPaise,
  Value<int> rowid,
});

final class $$PayrollLinesTableReferences
    extends BaseReferences<_$AppDatabase, $PayrollLinesTable, PayrollLineRow> {
  $$PayrollLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PayrollRunsTable _runIdTable(_$AppDatabase db) =>
      db.payrollRuns.createAlias('payroll_lines__run_id__payroll_runs__id');

  $$PayrollRunsTableProcessedTableManager get runId {
    final $_column = $_itemColumn<String>('run_id')!;

    final manager = $$PayrollRunsTableTableManager($_db, $_db.payrollRuns)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_runIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PayrollAdjustmentsTable,
      List<PayrollAdjustmentRow>> _payrollAdjustmentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.payrollAdjustments,
          aliasName: 'payroll_lines__id__payroll_adjustments__line_id');

  $$PayrollAdjustmentsTableProcessedTableManager get payrollAdjustmentsRefs {
    final manager =
        $$PayrollAdjustmentsTableTableManager($_db, $_db.payrollAdjustments)
            .filter((f) => f.lineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_payrollAdjustmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PayrollPaymentsTable, List<PayrollPaymentRow>>
      _payrollPaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.payrollPayments,
              aliasName: 'payroll_lines__id__payroll_payments__line_id');

  $$PayrollPaymentsTableProcessedTableManager get payrollPaymentsRefs {
    final manager =
        $$PayrollPaymentsTableTableManager($_db, $_db.payrollPayments)
            .filter((f) => f.lineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_payrollPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PayrollAdvanceLinksTable,
      List<PayrollAdvanceLinkRow>> _payrollAdvanceLinksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.payrollAdvanceLinks,
          aliasName: 'payroll_lines__id__payroll_advance_links__line_id');

  $$PayrollAdvanceLinksTableProcessedTableManager get payrollAdvanceLinksRefs {
    final manager =
        $$PayrollAdvanceLinksTableTableManager($_db, $_db.payrollAdvanceLinks)
            .filter((f) => f.lineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_payrollAdvanceLinksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PayrollLinesTableFilterComposer
    extends Composer<_$AppDatabase, $PayrollLinesTable> {
  $$PayrollLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeName => $composableBuilder(
      column: $table.employeeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ratePaise => $composableBuilder(
      column: $table.ratePaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get presentDays => $composableBuilder(
      column: $table.presentDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get halfDays => $composableBuilder(
      column: $table.halfDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get leaveDays => $composableBuilder(
      column: $table.leaveDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get absentDays => $composableBuilder(
      column: $table.absentDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unmarkedDays => $composableBuilder(
      column: $table.unmarkedDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weeklyOffDays => $composableBuilder(
      column: $table.weeklyOffDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get holidayDays => $composableBuilder(
      column: $table.holidayDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get payableUnitsBp => $composableBuilder(
      column: $table.payableUnitsBp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get basisDays => $composableBuilder(
      column: $table.basisDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get earningsPaise => $composableBuilder(
      column: $table.earningsPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get overtimeUnitsBp => $composableBuilder(
      column: $table.overtimeUnitsBp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get overtimePaise => $composableBuilder(
      column: $table.overtimePaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bonusPaise => $composableBuilder(
      column: $table.bonusPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deductionsPaise => $composableBuilder(
      column: $table.deductionsPaise,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get advancesPaise => $composableBuilder(
      column: $table.advancesPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get grossPaise => $composableBuilder(
      column: $table.grossPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get netPaise => $composableBuilder(
      column: $table.netPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carryForwardPaise => $composableBuilder(
      column: $table.carryForwardPaise,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paidPaise => $composableBuilder(
      column: $table.paidPaise, builder: (column) => ColumnFilters(column));

  $$PayrollRunsTableFilterComposer get runId {
    final $$PayrollRunsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableFilterComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> payrollAdjustmentsRefs(
      Expression<bool> Function($$PayrollAdjustmentsTableFilterComposer f) f) {
    final $$PayrollAdjustmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payrollAdjustments,
        getReferencedColumn: (t) => t.lineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollAdjustmentsTableFilterComposer(
              $db: $db,
              $table: $db.payrollAdjustments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> payrollPaymentsRefs(
      Expression<bool> Function($$PayrollPaymentsTableFilterComposer f) f) {
    final $$PayrollPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payrollPayments,
        getReferencedColumn: (t) => t.lineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.payrollPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> payrollAdvanceLinksRefs(
      Expression<bool> Function($$PayrollAdvanceLinksTableFilterComposer f) f) {
    final $$PayrollAdvanceLinksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payrollAdvanceLinks,
        getReferencedColumn: (t) => t.lineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollAdvanceLinksTableFilterComposer(
              $db: $db,
              $table: $db.payrollAdvanceLinks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PayrollLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $PayrollLinesTable> {
  $$PayrollLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeName => $composableBuilder(
      column: $table.employeeName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ratePaise => $composableBuilder(
      column: $table.ratePaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get presentDays => $composableBuilder(
      column: $table.presentDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get halfDays => $composableBuilder(
      column: $table.halfDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get leaveDays => $composableBuilder(
      column: $table.leaveDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get absentDays => $composableBuilder(
      column: $table.absentDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unmarkedDays => $composableBuilder(
      column: $table.unmarkedDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weeklyOffDays => $composableBuilder(
      column: $table.weeklyOffDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get holidayDays => $composableBuilder(
      column: $table.holidayDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get payableUnitsBp => $composableBuilder(
      column: $table.payableUnitsBp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get basisDays => $composableBuilder(
      column: $table.basisDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get earningsPaise => $composableBuilder(
      column: $table.earningsPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get overtimeUnitsBp => $composableBuilder(
      column: $table.overtimeUnitsBp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get overtimePaise => $composableBuilder(
      column: $table.overtimePaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bonusPaise => $composableBuilder(
      column: $table.bonusPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deductionsPaise => $composableBuilder(
      column: $table.deductionsPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get advancesPaise => $composableBuilder(
      column: $table.advancesPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get grossPaise => $composableBuilder(
      column: $table.grossPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get netPaise => $composableBuilder(
      column: $table.netPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carryForwardPaise => $composableBuilder(
      column: $table.carryForwardPaise,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paidPaise => $composableBuilder(
      column: $table.paidPaise, builder: (column) => ColumnOrderings(column));

  $$PayrollRunsTableOrderingComposer get runId {
    final $$PayrollRunsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableOrderingComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PayrollLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayrollLinesTable> {
  $$PayrollLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<String> get employeeName => $composableBuilder(
      column: $table.employeeName, builder: (column) => column);

  GeneratedColumn<String> get salaryType => $composableBuilder(
      column: $table.salaryType, builder: (column) => column);

  GeneratedColumn<int> get ratePaise =>
      $composableBuilder(column: $table.ratePaise, builder: (column) => column);

  GeneratedColumn<int> get presentDays => $composableBuilder(
      column: $table.presentDays, builder: (column) => column);

  GeneratedColumn<int> get halfDays =>
      $composableBuilder(column: $table.halfDays, builder: (column) => column);

  GeneratedColumn<int> get leaveDays =>
      $composableBuilder(column: $table.leaveDays, builder: (column) => column);

  GeneratedColumn<int> get absentDays => $composableBuilder(
      column: $table.absentDays, builder: (column) => column);

  GeneratedColumn<int> get unmarkedDays => $composableBuilder(
      column: $table.unmarkedDays, builder: (column) => column);

  GeneratedColumn<int> get weeklyOffDays => $composableBuilder(
      column: $table.weeklyOffDays, builder: (column) => column);

  GeneratedColumn<int> get holidayDays => $composableBuilder(
      column: $table.holidayDays, builder: (column) => column);

  GeneratedColumn<int> get payableUnitsBp => $composableBuilder(
      column: $table.payableUnitsBp, builder: (column) => column);

  GeneratedColumn<int> get basisDays =>
      $composableBuilder(column: $table.basisDays, builder: (column) => column);

  GeneratedColumn<int> get earningsPaise => $composableBuilder(
      column: $table.earningsPaise, builder: (column) => column);

  GeneratedColumn<int> get overtimeUnitsBp => $composableBuilder(
      column: $table.overtimeUnitsBp, builder: (column) => column);

  GeneratedColumn<int> get overtimePaise => $composableBuilder(
      column: $table.overtimePaise, builder: (column) => column);

  GeneratedColumn<int> get bonusPaise => $composableBuilder(
      column: $table.bonusPaise, builder: (column) => column);

  GeneratedColumn<int> get deductionsPaise => $composableBuilder(
      column: $table.deductionsPaise, builder: (column) => column);

  GeneratedColumn<int> get advancesPaise => $composableBuilder(
      column: $table.advancesPaise, builder: (column) => column);

  GeneratedColumn<int> get grossPaise => $composableBuilder(
      column: $table.grossPaise, builder: (column) => column);

  GeneratedColumn<int> get netPaise =>
      $composableBuilder(column: $table.netPaise, builder: (column) => column);

  GeneratedColumn<int> get carryForwardPaise => $composableBuilder(
      column: $table.carryForwardPaise, builder: (column) => column);

  GeneratedColumn<int> get paidPaise =>
      $composableBuilder(column: $table.paidPaise, builder: (column) => column);

  $$PayrollRunsTableAnnotationComposer get runId {
    final $$PayrollRunsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableAnnotationComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> payrollAdjustmentsRefs<T extends Object>(
      Expression<T> Function($$PayrollAdjustmentsTableAnnotationComposer a) f) {
    final $$PayrollAdjustmentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.payrollAdjustments,
            getReferencedColumn: (t) => t.lineId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PayrollAdjustmentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.payrollAdjustments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> payrollPaymentsRefs<T extends Object>(
      Expression<T> Function($$PayrollPaymentsTableAnnotationComposer a) f) {
    final $$PayrollPaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payrollPayments,
        getReferencedColumn: (t) => t.lineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollPaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.payrollPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> payrollAdvanceLinksRefs<T extends Object>(
      Expression<T> Function($$PayrollAdvanceLinksTableAnnotationComposer a)
          f) {
    final $$PayrollAdvanceLinksTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.payrollAdvanceLinks,
            getReferencedColumn: (t) => t.lineId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PayrollAdvanceLinksTableAnnotationComposer(
                  $db: $db,
                  $table: $db.payrollAdvanceLinks,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PayrollLinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PayrollLinesTable,
    PayrollLineRow,
    $$PayrollLinesTableFilterComposer,
    $$PayrollLinesTableOrderingComposer,
    $$PayrollLinesTableAnnotationComposer,
    $$PayrollLinesTableCreateCompanionBuilder,
    $$PayrollLinesTableUpdateCompanionBuilder,
    (PayrollLineRow, $$PayrollLinesTableReferences),
    PayrollLineRow,
    PrefetchHooks Function(
        {bool runId,
        bool payrollAdjustmentsRefs,
        bool payrollPaymentsRefs,
        bool payrollAdvanceLinksRefs})> {
  $$PayrollLinesTableTableManager(_$AppDatabase db, $PayrollLinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayrollLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayrollLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayrollLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> runId = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<String> employeeName = const Value.absent(),
            Value<String> salaryType = const Value.absent(),
            Value<int> ratePaise = const Value.absent(),
            Value<int> presentDays = const Value.absent(),
            Value<int> halfDays = const Value.absent(),
            Value<int> leaveDays = const Value.absent(),
            Value<int> absentDays = const Value.absent(),
            Value<int> unmarkedDays = const Value.absent(),
            Value<int> weeklyOffDays = const Value.absent(),
            Value<int> holidayDays = const Value.absent(),
            Value<int> payableUnitsBp = const Value.absent(),
            Value<int> basisDays = const Value.absent(),
            Value<int> earningsPaise = const Value.absent(),
            Value<int> overtimeUnitsBp = const Value.absent(),
            Value<int> overtimePaise = const Value.absent(),
            Value<int> bonusPaise = const Value.absent(),
            Value<int> deductionsPaise = const Value.absent(),
            Value<int> advancesPaise = const Value.absent(),
            Value<int> grossPaise = const Value.absent(),
            Value<int> netPaise = const Value.absent(),
            Value<int> carryForwardPaise = const Value.absent(),
            Value<int> paidPaise = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollLinesCompanion(
            id: id,
            runId: runId,
            employeeId: employeeId,
            employeeName: employeeName,
            salaryType: salaryType,
            ratePaise: ratePaise,
            presentDays: presentDays,
            halfDays: halfDays,
            leaveDays: leaveDays,
            absentDays: absentDays,
            unmarkedDays: unmarkedDays,
            weeklyOffDays: weeklyOffDays,
            holidayDays: holidayDays,
            payableUnitsBp: payableUnitsBp,
            basisDays: basisDays,
            earningsPaise: earningsPaise,
            overtimeUnitsBp: overtimeUnitsBp,
            overtimePaise: overtimePaise,
            bonusPaise: bonusPaise,
            deductionsPaise: deductionsPaise,
            advancesPaise: advancesPaise,
            grossPaise: grossPaise,
            netPaise: netPaise,
            carryForwardPaise: carryForwardPaise,
            paidPaise: paidPaise,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String runId,
            required String employeeId,
            required String employeeName,
            required String salaryType,
            required int ratePaise,
            Value<int> presentDays = const Value.absent(),
            Value<int> halfDays = const Value.absent(),
            Value<int> leaveDays = const Value.absent(),
            Value<int> absentDays = const Value.absent(),
            Value<int> unmarkedDays = const Value.absent(),
            Value<int> weeklyOffDays = const Value.absent(),
            Value<int> holidayDays = const Value.absent(),
            Value<int> payableUnitsBp = const Value.absent(),
            Value<int> basisDays = const Value.absent(),
            Value<int> earningsPaise = const Value.absent(),
            Value<int> overtimeUnitsBp = const Value.absent(),
            Value<int> overtimePaise = const Value.absent(),
            Value<int> bonusPaise = const Value.absent(),
            Value<int> deductionsPaise = const Value.absent(),
            Value<int> advancesPaise = const Value.absent(),
            Value<int> grossPaise = const Value.absent(),
            Value<int> netPaise = const Value.absent(),
            Value<int> carryForwardPaise = const Value.absent(),
            Value<int> paidPaise = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollLinesCompanion.insert(
            id: id,
            runId: runId,
            employeeId: employeeId,
            employeeName: employeeName,
            salaryType: salaryType,
            ratePaise: ratePaise,
            presentDays: presentDays,
            halfDays: halfDays,
            leaveDays: leaveDays,
            absentDays: absentDays,
            unmarkedDays: unmarkedDays,
            weeklyOffDays: weeklyOffDays,
            holidayDays: holidayDays,
            payableUnitsBp: payableUnitsBp,
            basisDays: basisDays,
            earningsPaise: earningsPaise,
            overtimeUnitsBp: overtimeUnitsBp,
            overtimePaise: overtimePaise,
            bonusPaise: bonusPaise,
            deductionsPaise: deductionsPaise,
            advancesPaise: advancesPaise,
            grossPaise: grossPaise,
            netPaise: netPaise,
            carryForwardPaise: carryForwardPaise,
            paidPaise: paidPaise,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PayrollLinesTable, PayrollLineRow>(table),
                    $$PayrollLinesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {runId = false,
              payrollAdjustmentsRefs = false,
              payrollPaymentsRefs = false,
              payrollAdvanceLinksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (payrollAdjustmentsRefs) db.payrollAdjustments,
                if (payrollPaymentsRefs) db.payrollPayments,
                if (payrollAdvanceLinksRefs) db.payrollAdvanceLinks
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (runId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.runId,
                    referencedTable:
                        $$PayrollLinesTableReferences._runIdTable(db),
                    referencedColumn:
                        $$PayrollLinesTableReferences._runIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (payrollAdjustmentsRefs)
                    await $_getPrefetchedDataByColumns<
                            PayrollLineRow,
                            $PayrollLinesTable,
                            PayrollAdjustmentRow,
                            $PayrollAdjustmentsTable>(
                        currentTable: table,
                        referencedTable: $$PayrollLinesTableReferences
                            ._payrollAdjustmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PayrollLinesTableReferences(db, table, p0)
                                .payrollAdjustmentsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'line_id',
                        typedResults: items),
                  if (payrollPaymentsRefs)
                    await $_getPrefetchedDataByColumns<
                            PayrollLineRow,
                            $PayrollLinesTable,
                            PayrollPaymentRow,
                            $PayrollPaymentsTable>(
                        currentTable: table,
                        referencedTable: $$PayrollLinesTableReferences
                            ._payrollPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PayrollLinesTableReferences(db, table, p0)
                                .payrollPaymentsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'line_id',
                        typedResults: items),
                  if (payrollAdvanceLinksRefs)
                    await $_getPrefetchedDataByColumns<
                            PayrollLineRow,
                            $PayrollLinesTable,
                            PayrollAdvanceLinkRow,
                            $PayrollAdvanceLinksTable>(
                        currentTable: table,
                        referencedTable: $$PayrollLinesTableReferences
                            ._payrollAdvanceLinksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PayrollLinesTableReferences(db, table, p0)
                                .payrollAdvanceLinksRefs,
                        currentColumn: 'id',
                        referencedColumn: 'line_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PayrollLinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PayrollLinesTable,
    PayrollLineRow,
    $$PayrollLinesTableFilterComposer,
    $$PayrollLinesTableOrderingComposer,
    $$PayrollLinesTableAnnotationComposer,
    $$PayrollLinesTableCreateCompanionBuilder,
    $$PayrollLinesTableUpdateCompanionBuilder,
    (PayrollLineRow, $$PayrollLinesTableReferences),
    PayrollLineRow,
    PrefetchHooks Function(
        {bool runId,
        bool payrollAdjustmentsRefs,
        bool payrollPaymentsRefs,
        bool payrollAdvanceLinksRefs})>;
typedef $$PayrollAdjustmentsTableCreateCompanionBuilder
    = PayrollAdjustmentsCompanion Function({
  required String id,
  required String runId,
  required String lineId,
  required String kind,
  required int amountPaise,
  required String label,
  required String createdBy,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$PayrollAdjustmentsTableUpdateCompanionBuilder
    = PayrollAdjustmentsCompanion Function({
  Value<String> id,
  Value<String> runId,
  Value<String> lineId,
  Value<String> kind,
  Value<int> amountPaise,
  Value<String> label,
  Value<String> createdBy,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PayrollAdjustmentsTableReferences extends BaseReferences<
    _$AppDatabase, $PayrollAdjustmentsTable, PayrollAdjustmentRow> {
  $$PayrollAdjustmentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PayrollRunsTable _runIdTable(_$AppDatabase db) => db.payrollRuns
      .createAlias('payroll_adjustments__run_id__payroll_runs__id');

  $$PayrollRunsTableProcessedTableManager get runId {
    final $_column = $_itemColumn<String>('run_id')!;

    final manager = $$PayrollRunsTableTableManager($_db, $_db.payrollRuns)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_runIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PayrollLinesTable _lineIdTable(_$AppDatabase db) => db.payrollLines
      .createAlias('payroll_adjustments__line_id__payroll_lines__id');

  $$PayrollLinesTableProcessedTableManager get lineId {
    final $_column = $_itemColumn<String>('line_id')!;

    final manager = $$PayrollLinesTableTableManager($_db, $_db.payrollLines)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PayrollAdjustmentsTableFilterComposer
    extends Composer<_$AppDatabase, $PayrollAdjustmentsTable> {
  $$PayrollAdjustmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PayrollRunsTableFilterComposer get runId {
    final $$PayrollRunsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableFilterComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PayrollLinesTableFilterComposer get lineId {
    final $$PayrollLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lineId,
        referencedTable: $db.payrollLines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollLinesTableFilterComposer(
              $db: $db,
              $table: $db.payrollLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PayrollAdjustmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PayrollAdjustmentsTable> {
  $$PayrollAdjustmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PayrollRunsTableOrderingComposer get runId {
    final $$PayrollRunsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableOrderingComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PayrollLinesTableOrderingComposer get lineId {
    final $$PayrollLinesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lineId,
        referencedTable: $db.payrollLines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollLinesTableOrderingComposer(
              $db: $db,
              $table: $db.payrollLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PayrollAdjustmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayrollAdjustmentsTable> {
  $$PayrollAdjustmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PayrollRunsTableAnnotationComposer get runId {
    final $$PayrollRunsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableAnnotationComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PayrollLinesTableAnnotationComposer get lineId {
    final $$PayrollLinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lineId,
        referencedTable: $db.payrollLines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollLinesTableAnnotationComposer(
              $db: $db,
              $table: $db.payrollLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PayrollAdjustmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PayrollAdjustmentsTable,
    PayrollAdjustmentRow,
    $$PayrollAdjustmentsTableFilterComposer,
    $$PayrollAdjustmentsTableOrderingComposer,
    $$PayrollAdjustmentsTableAnnotationComposer,
    $$PayrollAdjustmentsTableCreateCompanionBuilder,
    $$PayrollAdjustmentsTableUpdateCompanionBuilder,
    (PayrollAdjustmentRow, $$PayrollAdjustmentsTableReferences),
    PayrollAdjustmentRow,
    PrefetchHooks Function({bool runId, bool lineId})> {
  $$PayrollAdjustmentsTableTableManager(
      _$AppDatabase db, $PayrollAdjustmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayrollAdjustmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayrollAdjustmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayrollAdjustmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> runId = const Value.absent(),
            Value<String> lineId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<int> amountPaise = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollAdjustmentsCompanion(
            id: id,
            runId: runId,
            lineId: lineId,
            kind: kind,
            amountPaise: amountPaise,
            label: label,
            createdBy: createdBy,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String runId,
            required String lineId,
            required String kind,
            required int amountPaise,
            required String label,
            required String createdBy,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollAdjustmentsCompanion.insert(
            id: id,
            runId: runId,
            lineId: lineId,
            kind: kind,
            amountPaise: amountPaise,
            label: label,
            createdBy: createdBy,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PayrollAdjustmentsTable, PayrollAdjustmentRow>(
                        table),
                    $$PayrollAdjustmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({runId = false, lineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (runId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.runId,
                    referencedTable:
                        $$PayrollAdjustmentsTableReferences._runIdTable(db),
                    referencedColumn:
                        $$PayrollAdjustmentsTableReferences._runIdTable(db).id,
                  ) as T;
                }
                if (lineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lineId,
                    referencedTable:
                        $$PayrollAdjustmentsTableReferences._lineIdTable(db),
                    referencedColumn:
                        $$PayrollAdjustmentsTableReferences._lineIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PayrollAdjustmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PayrollAdjustmentsTable,
    PayrollAdjustmentRow,
    $$PayrollAdjustmentsTableFilterComposer,
    $$PayrollAdjustmentsTableOrderingComposer,
    $$PayrollAdjustmentsTableAnnotationComposer,
    $$PayrollAdjustmentsTableCreateCompanionBuilder,
    $$PayrollAdjustmentsTableUpdateCompanionBuilder,
    (PayrollAdjustmentRow, $$PayrollAdjustmentsTableReferences),
    PayrollAdjustmentRow,
    PrefetchHooks Function({bool runId, bool lineId})>;
typedef $$PayrollPaymentsTableCreateCompanionBuilder = PayrollPaymentsCompanion
    Function({
  required String id,
  required String runId,
  required String lineId,
  required String employeeId,
  required int amountPaise,
  required DateTime paidAt,
  required String method,
  Value<String?> notes,
  required String recordedBy,
  Value<int> rowid,
});
typedef $$PayrollPaymentsTableUpdateCompanionBuilder = PayrollPaymentsCompanion
    Function({
  Value<String> id,
  Value<String> runId,
  Value<String> lineId,
  Value<String> employeeId,
  Value<int> amountPaise,
  Value<DateTime> paidAt,
  Value<String> method,
  Value<String?> notes,
  Value<String> recordedBy,
  Value<int> rowid,
});

final class $$PayrollPaymentsTableReferences extends BaseReferences<
    _$AppDatabase, $PayrollPaymentsTable, PayrollPaymentRow> {
  $$PayrollPaymentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PayrollRunsTable _runIdTable(_$AppDatabase db) =>
      db.payrollRuns.createAlias('payroll_payments__run_id__payroll_runs__id');

  $$PayrollRunsTableProcessedTableManager get runId {
    final $_column = $_itemColumn<String>('run_id')!;

    final manager = $$PayrollRunsTableTableManager($_db, $_db.payrollRuns)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_runIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PayrollLinesTable _lineIdTable(_$AppDatabase db) => db.payrollLines
      .createAlias('payroll_payments__line_id__payroll_lines__id');

  $$PayrollLinesTableProcessedTableManager get lineId {
    final $_column = $_itemColumn<String>('line_id')!;

    final manager = $$PayrollLinesTableTableManager($_db, $_db.payrollLines)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PayrollPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PayrollPaymentsTable> {
  $$PayrollPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnFilters(column));

  $$PayrollRunsTableFilterComposer get runId {
    final $$PayrollRunsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableFilterComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PayrollLinesTableFilterComposer get lineId {
    final $$PayrollLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lineId,
        referencedTable: $db.payrollLines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollLinesTableFilterComposer(
              $db: $db,
              $table: $db.payrollLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PayrollPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PayrollPaymentsTable> {
  $$PayrollPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => ColumnOrderings(column));

  $$PayrollRunsTableOrderingComposer get runId {
    final $$PayrollRunsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableOrderingComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PayrollLinesTableOrderingComposer get lineId {
    final $$PayrollLinesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lineId,
        referencedTable: $db.payrollLines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollLinesTableOrderingComposer(
              $db: $db,
              $table: $db.payrollLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PayrollPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayrollPaymentsTable> {
  $$PayrollPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
      column: $table.employeeId, builder: (column) => column);

  GeneratedColumn<int> get amountPaise => $composableBuilder(
      column: $table.amountPaise, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get recordedBy => $composableBuilder(
      column: $table.recordedBy, builder: (column) => column);

  $$PayrollRunsTableAnnotationComposer get runId {
    final $$PayrollRunsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableAnnotationComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PayrollLinesTableAnnotationComposer get lineId {
    final $$PayrollLinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lineId,
        referencedTable: $db.payrollLines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollLinesTableAnnotationComposer(
              $db: $db,
              $table: $db.payrollLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PayrollPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PayrollPaymentsTable,
    PayrollPaymentRow,
    $$PayrollPaymentsTableFilterComposer,
    $$PayrollPaymentsTableOrderingComposer,
    $$PayrollPaymentsTableAnnotationComposer,
    $$PayrollPaymentsTableCreateCompanionBuilder,
    $$PayrollPaymentsTableUpdateCompanionBuilder,
    (PayrollPaymentRow, $$PayrollPaymentsTableReferences),
    PayrollPaymentRow,
    PrefetchHooks Function({bool runId, bool lineId})> {
  $$PayrollPaymentsTableTableManager(
      _$AppDatabase db, $PayrollPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayrollPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayrollPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayrollPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> runId = const Value.absent(),
            Value<String> lineId = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<int> amountPaise = const Value.absent(),
            Value<DateTime> paidAt = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> recordedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollPaymentsCompanion(
            id: id,
            runId: runId,
            lineId: lineId,
            employeeId: employeeId,
            amountPaise: amountPaise,
            paidAt: paidAt,
            method: method,
            notes: notes,
            recordedBy: recordedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String runId,
            required String lineId,
            required String employeeId,
            required int amountPaise,
            required DateTime paidAt,
            required String method,
            Value<String?> notes = const Value.absent(),
            required String recordedBy,
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollPaymentsCompanion.insert(
            id: id,
            runId: runId,
            lineId: lineId,
            employeeId: employeeId,
            amountPaise: amountPaise,
            paidAt: paidAt,
            method: method,
            notes: notes,
            recordedBy: recordedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PayrollPaymentsTable, PayrollPaymentRow>(
                        table),
                    $$PayrollPaymentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({runId = false, lineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (runId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.runId,
                    referencedTable:
                        $$PayrollPaymentsTableReferences._runIdTable(db),
                    referencedColumn:
                        $$PayrollPaymentsTableReferences._runIdTable(db).id,
                  ) as T;
                }
                if (lineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lineId,
                    referencedTable:
                        $$PayrollPaymentsTableReferences._lineIdTable(db),
                    referencedColumn:
                        $$PayrollPaymentsTableReferences._lineIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PayrollPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PayrollPaymentsTable,
    PayrollPaymentRow,
    $$PayrollPaymentsTableFilterComposer,
    $$PayrollPaymentsTableOrderingComposer,
    $$PayrollPaymentsTableAnnotationComposer,
    $$PayrollPaymentsTableCreateCompanionBuilder,
    $$PayrollPaymentsTableUpdateCompanionBuilder,
    (PayrollPaymentRow, $$PayrollPaymentsTableReferences),
    PayrollPaymentRow,
    PrefetchHooks Function({bool runId, bool lineId})>;
typedef $$PayrollAuditEventsTableCreateCompanionBuilder
    = PayrollAuditEventsCompanion Function({
  Value<int> id,
  required String runId,
  required String type,
  required String actor,
  Value<String?> detail,
  required DateTime createdAt,
});
typedef $$PayrollAuditEventsTableUpdateCompanionBuilder
    = PayrollAuditEventsCompanion Function({
  Value<int> id,
  Value<String> runId,
  Value<String> type,
  Value<String> actor,
  Value<String?> detail,
  Value<DateTime> createdAt,
});

class $$PayrollAuditEventsTableFilterComposer
    extends Composer<_$AppDatabase, $PayrollAuditEventsTable> {
  $$PayrollAuditEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get runId => $composableBuilder(
      column: $table.runId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actor => $composableBuilder(
      column: $table.actor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detail => $composableBuilder(
      column: $table.detail, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PayrollAuditEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $PayrollAuditEventsTable> {
  $$PayrollAuditEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get runId => $composableBuilder(
      column: $table.runId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actor => $composableBuilder(
      column: $table.actor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detail => $composableBuilder(
      column: $table.detail, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PayrollAuditEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayrollAuditEventsTable> {
  $$PayrollAuditEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get runId =>
      $composableBuilder(column: $table.runId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PayrollAuditEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PayrollAuditEventsTable,
    PayrollAuditRow,
    $$PayrollAuditEventsTableFilterComposer,
    $$PayrollAuditEventsTableOrderingComposer,
    $$PayrollAuditEventsTableAnnotationComposer,
    $$PayrollAuditEventsTableCreateCompanionBuilder,
    $$PayrollAuditEventsTableUpdateCompanionBuilder,
    (
      PayrollAuditRow,
      BaseReferences<_$AppDatabase, $PayrollAuditEventsTable, PayrollAuditRow>
    ),
    PayrollAuditRow,
    PrefetchHooks Function()> {
  $$PayrollAuditEventsTableTableManager(
      _$AppDatabase db, $PayrollAuditEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayrollAuditEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayrollAuditEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayrollAuditEventsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> runId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> actor = const Value.absent(),
            Value<String?> detail = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PayrollAuditEventsCompanion(
            id: id,
            runId: runId,
            type: type,
            actor: actor,
            detail: detail,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String runId,
            required String type,
            required String actor,
            Value<String?> detail = const Value.absent(),
            required DateTime createdAt,
          }) =>
              PayrollAuditEventsCompanion.insert(
            id: id,
            runId: runId,
            type: type,
            actor: actor,
            detail: detail,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PayrollAuditEventsTable, PayrollAuditRow>(
                        table),
                    BaseReferences<_$AppDatabase, $PayrollAuditEventsTable,
                        PayrollAuditRow>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PayrollAuditEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PayrollAuditEventsTable,
    PayrollAuditRow,
    $$PayrollAuditEventsTableFilterComposer,
    $$PayrollAuditEventsTableOrderingComposer,
    $$PayrollAuditEventsTableAnnotationComposer,
    $$PayrollAuditEventsTableCreateCompanionBuilder,
    $$PayrollAuditEventsTableUpdateCompanionBuilder,
    (
      PayrollAuditRow,
      BaseReferences<_$AppDatabase, $PayrollAuditEventsTable, PayrollAuditRow>
    ),
    PayrollAuditRow,
    PrefetchHooks Function()>;
typedef $$PayrollAdvanceLinksTableCreateCompanionBuilder
    = PayrollAdvanceLinksCompanion Function({
  required String advanceId,
  required String runId,
  required String lineId,
  required DateTime linkedAt,
  Value<int> rowid,
});
typedef $$PayrollAdvanceLinksTableUpdateCompanionBuilder
    = PayrollAdvanceLinksCompanion Function({
  Value<String> advanceId,
  Value<String> runId,
  Value<String> lineId,
  Value<DateTime> linkedAt,
  Value<int> rowid,
});

final class $$PayrollAdvanceLinksTableReferences extends BaseReferences<
    _$AppDatabase, $PayrollAdvanceLinksTable, PayrollAdvanceLinkRow> {
  $$PayrollAdvanceLinksTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PayrollRunsTable _runIdTable(_$AppDatabase db) => db.payrollRuns
      .createAlias('payroll_advance_links__run_id__payroll_runs__id');

  $$PayrollRunsTableProcessedTableManager get runId {
    final $_column = $_itemColumn<String>('run_id')!;

    final manager = $$PayrollRunsTableTableManager($_db, $_db.payrollRuns)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_runIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PayrollLinesTable _lineIdTable(_$AppDatabase db) => db.payrollLines
      .createAlias('payroll_advance_links__line_id__payroll_lines__id');

  $$PayrollLinesTableProcessedTableManager get lineId {
    final $_column = $_itemColumn<String>('line_id')!;

    final manager = $$PayrollLinesTableTableManager($_db, $_db.payrollLines)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PayrollAdvanceLinksTableFilterComposer
    extends Composer<_$AppDatabase, $PayrollAdvanceLinksTable> {
  $$PayrollAdvanceLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get advanceId => $composableBuilder(
      column: $table.advanceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get linkedAt => $composableBuilder(
      column: $table.linkedAt, builder: (column) => ColumnFilters(column));

  $$PayrollRunsTableFilterComposer get runId {
    final $$PayrollRunsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableFilterComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PayrollLinesTableFilterComposer get lineId {
    final $$PayrollLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lineId,
        referencedTable: $db.payrollLines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollLinesTableFilterComposer(
              $db: $db,
              $table: $db.payrollLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PayrollAdvanceLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $PayrollAdvanceLinksTable> {
  $$PayrollAdvanceLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get advanceId => $composableBuilder(
      column: $table.advanceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get linkedAt => $composableBuilder(
      column: $table.linkedAt, builder: (column) => ColumnOrderings(column));

  $$PayrollRunsTableOrderingComposer get runId {
    final $$PayrollRunsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableOrderingComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PayrollLinesTableOrderingComposer get lineId {
    final $$PayrollLinesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lineId,
        referencedTable: $db.payrollLines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollLinesTableOrderingComposer(
              $db: $db,
              $table: $db.payrollLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PayrollAdvanceLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayrollAdvanceLinksTable> {
  $$PayrollAdvanceLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get advanceId =>
      $composableBuilder(column: $table.advanceId, builder: (column) => column);

  GeneratedColumn<DateTime> get linkedAt =>
      $composableBuilder(column: $table.linkedAt, builder: (column) => column);

  $$PayrollRunsTableAnnotationComposer get runId {
    final $$PayrollRunsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.runId,
        referencedTable: $db.payrollRuns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollRunsTableAnnotationComposer(
              $db: $db,
              $table: $db.payrollRuns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PayrollLinesTableAnnotationComposer get lineId {
    final $$PayrollLinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lineId,
        referencedTable: $db.payrollLines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PayrollLinesTableAnnotationComposer(
              $db: $db,
              $table: $db.payrollLines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PayrollAdvanceLinksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PayrollAdvanceLinksTable,
    PayrollAdvanceLinkRow,
    $$PayrollAdvanceLinksTableFilterComposer,
    $$PayrollAdvanceLinksTableOrderingComposer,
    $$PayrollAdvanceLinksTableAnnotationComposer,
    $$PayrollAdvanceLinksTableCreateCompanionBuilder,
    $$PayrollAdvanceLinksTableUpdateCompanionBuilder,
    (PayrollAdvanceLinkRow, $$PayrollAdvanceLinksTableReferences),
    PayrollAdvanceLinkRow,
    PrefetchHooks Function({bool runId, bool lineId})> {
  $$PayrollAdvanceLinksTableTableManager(
      _$AppDatabase db, $PayrollAdvanceLinksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayrollAdvanceLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayrollAdvanceLinksTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayrollAdvanceLinksTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> advanceId = const Value.absent(),
            Value<String> runId = const Value.absent(),
            Value<String> lineId = const Value.absent(),
            Value<DateTime> linkedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollAdvanceLinksCompanion(
            advanceId: advanceId,
            runId: runId,
            lineId: lineId,
            linkedAt: linkedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String advanceId,
            required String runId,
            required String lineId,
            required DateTime linkedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollAdvanceLinksCompanion.insert(
            advanceId: advanceId,
            runId: runId,
            lineId: lineId,
            linkedAt: linkedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PayrollAdvanceLinksTable,
                        PayrollAdvanceLinkRow>(table),
                    $$PayrollAdvanceLinksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({runId = false, lineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (runId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.runId,
                    referencedTable:
                        $$PayrollAdvanceLinksTableReferences._runIdTable(db),
                    referencedColumn:
                        $$PayrollAdvanceLinksTableReferences._runIdTable(db).id,
                  ) as T;
                }
                if (lineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lineId,
                    referencedTable:
                        $$PayrollAdvanceLinksTableReferences._lineIdTable(db),
                    referencedColumn: $$PayrollAdvanceLinksTableReferences
                        ._lineIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PayrollAdvanceLinksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PayrollAdvanceLinksTable,
    PayrollAdvanceLinkRow,
    $$PayrollAdvanceLinksTableFilterComposer,
    $$PayrollAdvanceLinksTableOrderingComposer,
    $$PayrollAdvanceLinksTableAnnotationComposer,
    $$PayrollAdvanceLinksTableCreateCompanionBuilder,
    $$PayrollAdvanceLinksTableUpdateCompanionBuilder,
    (PayrollAdvanceLinkRow, $$PayrollAdvanceLinksTableReferences),
    PayrollAdvanceLinkRow,
    PrefetchHooks Function({bool runId, bool lineId})>;
typedef $$SyncMetadataTableCreateCompanionBuilder = SyncMetadataCompanion
    Function({
  required String key,
  required String value,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SyncMetadataTableUpdateCompanionBuilder = SyncMetadataCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncMetadataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadataData,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadataData,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>
    ),
    SyncMetadataData,
    PrefetchHooks Function()> {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SyncMetadataTable, SyncMetadataData>(table),
                    BaseReferences<_$AppDatabase, $SyncMetadataTable,
                        SyncMetadataData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetadataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncMetadataTable,
    SyncMetadataData,
    $$SyncMetadataTableFilterComposer,
    $$SyncMetadataTableOrderingComposer,
    $$SyncMetadataTableAnnotationComposer,
    $$SyncMetadataTableCreateCompanionBuilder,
    $$SyncMetadataTableUpdateCompanionBuilder,
    (
      SyncMetadataData,
      BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>
    ),
    SyncMetadataData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudioProfilesTableTableManager get studioProfiles =>
      $$StudioProfilesTableTableManager(_db, _db.studioProfiles);
  $$ServiceCategoriesTableTableManager get serviceCategories =>
      $$ServiceCategoriesTableTableManager(_db, _db.serviceCategories);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$BillDraftsTableTableManager get billDrafts =>
      $$BillDraftsTableTableManager(_db, _db.billDrafts);
  $$DraftLinesTableTableManager get draftLines =>
      $$DraftLinesTableTableManager(_db, _db.draftLines);
  $$BillsTableTableManager get bills =>
      $$BillsTableTableManager(_db, _db.bills);
  $$BillLinesTableTableManager get billLines =>
      $$BillLinesTableTableManager(_db, _db.billLines);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$InvoiceCountersTableTableManager get invoiceCounters =>
      $$InvoiceCountersTableTableManager(_db, _db.invoiceCounters);
  $$BillingAuditEventsTableTableManager get billingAuditEvents =>
      $$BillingAuditEventsTableTableManager(_db, _db.billingAuditEvents);
  $$AttendanceRecordsTableTableManager get attendanceRecords =>
      $$AttendanceRecordsTableTableManager(_db, _db.attendanceRecords);
  $$AttendanceAuditEventsTableTableManager get attendanceAuditEvents =>
      $$AttendanceAuditEventsTableTableManager(_db, _db.attendanceAuditEvents);
  $$SalaryAdvancesTableTableManager get salaryAdvances =>
      $$SalaryAdvancesTableTableManager(_db, _db.salaryAdvances);
  $$PayrollSettingsTableTableManager get payrollSettings =>
      $$PayrollSettingsTableTableManager(_db, _db.payrollSettings);
  $$PayrollRunsTableTableManager get payrollRuns =>
      $$PayrollRunsTableTableManager(_db, _db.payrollRuns);
  $$PayrollLinesTableTableManager get payrollLines =>
      $$PayrollLinesTableTableManager(_db, _db.payrollLines);
  $$PayrollAdjustmentsTableTableManager get payrollAdjustments =>
      $$PayrollAdjustmentsTableTableManager(_db, _db.payrollAdjustments);
  $$PayrollPaymentsTableTableManager get payrollPayments =>
      $$PayrollPaymentsTableTableManager(_db, _db.payrollPayments);
  $$PayrollAuditEventsTableTableManager get payrollAuditEvents =>
      $$PayrollAuditEventsTableTableManager(_db, _db.payrollAuditEvents);
  $$PayrollAdvanceLinksTableTableManager get payrollAdvanceLinks =>
      $$PayrollAdvanceLinksTableTableManager(_db, _db.payrollAdvanceLinks);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
}
