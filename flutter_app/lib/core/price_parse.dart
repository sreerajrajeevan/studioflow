import 'money.dart';

/// Parses a user-typed INR amount into integer paise — WITHOUT ever
/// using a double. Accepts "300", "300.5", "300.50", "₹300", "1,500",
/// " 300 " (trimmed). Rejects empty input, letters, more than two decimal
/// places, negatives, and amounts above the money engine's price cap.
/// Returns null when the input is invalid; the editor shows the error.
int? parseInrToPaise(String input) {
  var s = input.trim().replaceAll('₹', '').replaceAll(',', '').trim();
  if (s.isEmpty) return null;
  if (s.startsWith('-') || s.startsWith('+')) return null;
  final parts = s.split('.');
  if (parts.length > 2) return null;
  final rupeesPart = parts[0];
  if (rupeesPart.isEmpty || !RegExp(r'^\d+$').hasMatch(rupeesPart)) {
    return null;
  }
  var paisePart = 0;
  if (parts.length == 2) {
    final frac = parts[1];
    if (frac.isEmpty || frac.length > 2 || !RegExp(r'^\d+$').hasMatch(frac)) {
      return null;
    }
    paisePart = int.parse(frac.padRight(2, '0'));
  }
  final rupees = int.tryParse(rupeesPart);
  if (rupees == null) return null; // absurdly long digit string
  final paise = rupees * 100 + paisePart;
  if (paise > MoneyLimits.maxPricePaise) return null;
  return paise;
}

/// Formats paise for the price field when editing ("300.50").
String formatPaiseForInput(int paise) {
  final rupees = paise ~/ 100;
  final rem = paise % 100;
  return rem == 0 ? '$rupees' : '$rupees.${rem.toString().padLeft(2, '0')}';
}
