/// Payroll calculation engine (Task 5) — pure, deterministic,
/// integer-paise only. No floating point anywhere: day-units are
/// tracked in basis points of a day (10000 = one full day) and every
/// division rounds HALF-UP exactly once, at the final step.
///
/// The engine knows nothing about databases or attendance tables; the
/// repository converts attendance records into [PayrollCounts] first.
library;

/// How a monthly salary converts into a per-day rate.
enum SalaryBasis {
  /// Per-day = salary / actual days in the month.
  calendarDays,

  /// Per-day = salary / 30, always.
  fixed30,

  /// Per-day = salary / (days in month − weekly-offs − holidays).
  workingDays,
}

/// Configurable studio payroll rules. These are the studio's choices —
/// the app ships example defaults (clearly labelled in the UI) and the
/// owner must review them before the first real payroll can be
/// approved. Nothing here assumes absence or leave is unpaid: each
/// category has an explicit paid/unpaid rule.
class PayrollRules {
  const PayrollRules({
    this.basis = SalaryBasis.calendarDays,
    this.halfDayMultiplierBp = 5000,
    this.leaveIsPaid = false,
    this.absentIsPaid = false,
    this.unmarkedIsPaid = false,
    this.weeklyOffWeekday = DateTime.sunday,
    this.weeklyOffIsPaid = true,
    this.holidayIsPaid = true,
    this.holidayDateKeys = const {},
    this.overtimeMultiplierBp = 15000,
  });

  final SalaryBasis basis;

  /// What a half day pays, in basis points of a full day (5000 = 50%).
  final int halfDayMultiplierBp;
  final bool leaveIsPaid;
  final bool absentIsPaid;
  final bool unmarkedIsPaid;

  /// 1 = Monday … 7 = Sunday; 0 = no weekly off.
  final int weeklyOffWeekday;
  final bool weeklyOffIsPaid;
  final bool holidayIsPaid;

  /// Studio holidays as studio-local date keys ('yyyy-MM-dd').
  final Set<String> holidayDateKeys;

  /// Overtime pay multiplier in basis points (15000 = 1.5×).
  final int overtimeMultiplierBp;

  PayrollRules copyWith({
    SalaryBasis? basis,
    int? halfDayMultiplierBp,
    bool? leaveIsPaid,
    bool? absentIsPaid,
    bool? unmarkedIsPaid,
    int? weeklyOffWeekday,
    bool? weeklyOffIsPaid,
    bool? holidayIsPaid,
    Set<String>? holidayDateKeys,
    int? overtimeMultiplierBp,
  }) =>
      PayrollRules(
        basis: basis ?? this.basis,
        halfDayMultiplierBp: halfDayMultiplierBp ?? this.halfDayMultiplierBp,
        leaveIsPaid: leaveIsPaid ?? this.leaveIsPaid,
        absentIsPaid: absentIsPaid ?? this.absentIsPaid,
        unmarkedIsPaid: unmarkedIsPaid ?? this.unmarkedIsPaid,
        weeklyOffWeekday: weeklyOffWeekday ?? this.weeklyOffWeekday,
        weeklyOffIsPaid: weeklyOffIsPaid ?? this.weeklyOffIsPaid,
        holidayIsPaid: holidayIsPaid ?? this.holidayIsPaid,
        holidayDateKeys: holidayDateKeys ?? this.holidayDateKeys,
        overtimeMultiplierBp:
            overtimeMultiplierBp ?? this.overtimeMultiplierBp,
      );

  Map<String, Object?> toJson() => {
        'basis': basis.name,
        'halfDayMultiplierBp': halfDayMultiplierBp,
        'leaveIsPaid': leaveIsPaid,
        'absentIsPaid': absentIsPaid,
        'unmarkedIsPaid': unmarkedIsPaid,
        'weeklyOffWeekday': weeklyOffWeekday,
        'weeklyOffIsPaid': weeklyOffIsPaid,
        'holidayIsPaid': holidayIsPaid,
        'holidayDateKeys': holidayDateKeys.toList()..sort(),
        'overtimeMultiplierBp': overtimeMultiplierBp,
      };

  factory PayrollRules.fromJson(Map<String, Object?> json) {
    return PayrollRules(
      basis: SalaryBasis.values.firstWhere(
        (b) => b.name == json['basis'],
        orElse: () => SalaryBasis.calendarDays,
      ),
      halfDayMultiplierBp: (json['halfDayMultiplierBp'] as num?)?.toInt() ?? 5000,
      leaveIsPaid: json['leaveIsPaid'] as bool? ?? false,
      absentIsPaid: json['absentIsPaid'] as bool? ?? false,
      unmarkedIsPaid: json['unmarkedIsPaid'] as bool? ?? false,
      weeklyOffWeekday: (json['weeklyOffWeekday'] as num?)?.toInt() ?? 7,
      weeklyOffIsPaid: json['weeklyOffIsPaid'] as bool? ?? true,
      holidayIsPaid: json['holidayIsPaid'] as bool? ?? true,
      holidayDateKeys: {
        for (final key in (json['holidayDateKeys'] as List? ?? const []))
          key.toString(),
      },
      overtimeMultiplierBp:
          (json['overtimeMultiplierBp'] as num?)?.toInt() ?? 15000,
    );
  }
}

/// Attendance tallies for one employee in one month, over ELAPSED
/// days only (see the repository for how weekly-off / holiday /
/// unmarked buckets are derived).
class PayrollCounts {
  const PayrollCounts({
    this.present = 0,
    this.halfDays = 0,
    this.leave = 0,
    this.absent = 0,
    this.unmarked = 0,
    this.weeklyOff = 0,
    this.holidays = 0,
  });

  final int present;
  final int halfDays;
  final int leave;
  final int absent;
  final int unmarked;
  final int weeklyOff;
  final int holidays;
}

/// The frozen result of one employee's payroll calculation.
class PayrollComputation {
  const PayrollComputation({
    required this.payableUnitsBp,
    required this.basisDays,
    required this.earningsPaise,
    required this.overtimePaise,
    required this.grossPaise,
    required this.netPaise,
    required this.carryForwardPaise,
  });

  /// Payable day-units in basis points (10000 = 1 day).
  final int payableUnitsBp;

  /// Divisor used for monthly salaries (1 for daily-wage employees).
  final int basisDays;

  /// Base earnings from attendance (before overtime/adjustments).
  final int earningsPaise;
  final int overtimePaise;

  /// earnings + overtime + bonuses/incentives.
  final int grossPaise;

  /// gross − advances − other deductions, floored at 0. Any excess
  /// deduction lands in [carryForwardPaise] — never a silent negative.
  final int netPaise;
  final int carryForwardPaise;
}

/// Half-up integer division for non-negative values.
int _halfUpDiv(int numerator, int denominator) {
  if (denominator <= 0) {
    throw ArgumentError('Denominator must be positive.');
  }
  if (numerator < 0) {
    throw ArgumentError('Payroll amounts must not be negative.');
  }
  return (2 * numerator + denominator) ~/ (2 * denominator);
}

class PayrollEngine {
  PayrollEngine._();

  /// Basis days for a monthly salary in a month with [daysInMonth]
  /// days, [weeklyOffDaysInMonth] weekly-offs and
  /// [holidaysInMonth] holidays (full-month figures).
  static int basisDays(
    PayrollRules rules, {
    required int daysInMonth,
    required int weeklyOffDaysInMonth,
    required int holidaysInMonth,
  }) =>
      switch (rules.basis) {
        SalaryBasis.calendarDays => daysInMonth,
        SalaryBasis.fixed30 => 30,
        SalaryBasis.workingDays =>
          daysInMonth - weeklyOffDaysInMonth - holidaysInMonth,
      };

  /// Payable day-units (basis points) implied by [counts] under
  /// [rules].
  static int payableUnitsBp(PayrollCounts counts, PayrollRules rules) {
    var units = 0;
    units += counts.present * 10000;
    units += counts.halfDays * rules.halfDayMultiplierBp;
    if (rules.leaveIsPaid) units += counts.leave * 10000;
    if (rules.absentIsPaid) units += counts.absent * 10000;
    if (rules.unmarkedIsPaid) units += counts.unmarked * 10000;
    if (rules.weeklyOffIsPaid) units += counts.weeklyOff * 10000;
    if (rules.holidayIsPaid) units += counts.holidays * 10000;
    return units;
  }

  /// Full line calculation.
  ///
  /// [ratePaise] is the monthly salary or the daily wage, by
  /// [isDaily]. [overtimeUnitsBp] is overtime worked in day-units.
  /// [bonusPaise] aggregates bonuses/incentives; [otherDeductionsPaise]
  /// aggregates non-advance deductions; [advancesPaise] is the net
  /// advances deducted this period (exactly once — enforced by the
  /// repository's advance links).
  static PayrollComputation compute({
    required bool isDaily,
    required int ratePaise,
    required PayrollRules rules,
    required PayrollCounts counts,
    required int basisDays,
    int overtimeUnitsBp = 0,
    int bonusPaise = 0,
    int otherDeductionsPaise = 0,
    int advancesPaise = 0,
  }) {
    if (ratePaise < 0 ||
        bonusPaise < 0 ||
        otherDeductionsPaise < 0 ||
        overtimeUnitsBp < 0) {
      throw ArgumentError('Payroll inputs must not be negative.');
    }
    // advancesPaise may legitimately be NEGATIVE: when an advance
    // that was already deducted in an earlier payroll is reversed in
    // this period, the signed advance total claws the amount back
    // into this period's pay. The net floor below still applies.
    final units = payableUnitsBp(counts, rules);
    final int earnings;
    final int overtime;
    if (isDaily) {
      earnings = _halfUpDiv(ratePaise * units, 10000);
      overtime = _halfUpDiv(
        ratePaise * overtimeUnitsBp * rules.overtimeMultiplierBp,
        10000 * 10000,
      );
    } else {
      if (basisDays <= 0) {
        throw ArgumentError('Basis days must be positive.');
      }
      earnings = _halfUpDiv(ratePaise * units, basisDays * 10000);
      overtime = _halfUpDiv(
        ratePaise * overtimeUnitsBp * rules.overtimeMultiplierBp,
        basisDays * 10000 * 10000,
      );
    }
    final gross = earnings + overtime + bonusPaise;
    final deductions = advancesPaise + otherDeductionsPaise;
    final net = gross - deductions;
    return PayrollComputation(
      payableUnitsBp: units,
      basisDays: isDaily ? 1 : basisDays,
      earningsPaise: earnings,
      overtimePaise: overtime,
      grossPaise: gross,
      netPaise: net < 0 ? 0 : net,
      carryForwardPaise: net < 0 ? -net : 0,
    );
  }
}
