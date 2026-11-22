/// Studio-local dates (Task 4). The studio timezone is initially
/// Asia/Kolkata — a FIXED UTC+05:30 offset (India has no daylight
/// saving), so conversion is exact without a timezone database.
/// Attendance and advance business dates are keyed by these local
/// dates ('yyyy-MM-dd'), never by device-local or UTC dates.
class StudioTime {
  StudioTime._();

  /// Asia/Kolkata offset from UTC.
  static const Duration kolkataOffset = Duration(hours: 5, minutes: 30);

  static String _two(int v) => v.toString().padLeft(2, '0');

  /// The studio-local calendar date containing [instant], as
  /// 'yyyy-MM-dd'.
  static String dateKeyOf(DateTime instant) {
    final local = instant.toUtc().add(kolkataOffset);
    return '${local.year}-${_two(local.month)}-${_two(local.day)}';
  }

  /// Today's studio-local date key.
  static String todayKey([DateTime? now]) => dateKeyOf(now ?? DateTime.now());

  /// 'yyyy-MM' prefix of a date key (or of any instant's month).
  static String monthKeyOf(DateTime instant) => dateKeyOf(instant).substring(0, 7);

  static int daysInMonth(int year, int month) =>
      DateTime.utc(year, month + 1, 0).day;

  /// All date keys of a month, in order.
  static List<String> dateKeysOfMonth(int year, int month) => [
        for (var day = 1; day <= daysInMonth(year, month); day++)
          '$year-${_two(month)}-${_two(day)}',
      ];

  /// Parses a 'yyyy-MM-dd' key into (year, month, day).
  static (int, int, int) parseKey(String key) {
    final parts = key.split('-');
    return (
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
