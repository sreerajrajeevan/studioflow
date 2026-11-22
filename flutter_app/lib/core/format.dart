/// Money formatting. All money in StudioFlow is integer paise — never double.
library;

/// Formats paise as INR with Indian digit grouping, e.g. 1245000 -> ₹12,450.
/// Whole rupees show no decimals; paise remainder shows two decimals.
String inr(int paise) {
  final negative = paise < 0;
  final absPaise = paise.abs();
  final rupees = absPaise ~/ 100;
  final remainder = absPaise % 100;
  final grouped = _indianGrouping(rupees.toString());
  final base = remainder == 0
      ? grouped
      : '$grouped.${remainder.toString().padLeft(2, '0')}';
  return '${negative ? '-' : ''}₹$base';
}

/// Indian grouping: last 3 digits, then pairs. 1234567 -> 12,34,567.
String _indianGrouping(String digits) {
  if (digits.length <= 3) return digits;
  final head = digits.substring(0, digits.length - 3);
  final tail = digits.substring(digits.length - 3);
  final buffer = StringBuffer();
  for (var i = 0; i < head.length; i++) {
    buffer.write(head[i]);
    final remaining = head.length - i - 1;
    if (remaining > 0 && remaining % 2 == 0) buffer.write(',');
  }
  return '$buffer,$tail';
}
