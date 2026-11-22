/// Mobile-number validation for the Customer Details screen (Task 5.1).
///
/// Indian mobile numbers: 10 digits starting 6–9, optionally prefixed
/// with +91 / 91 / 0. Returns the NORMALIZED 10-digit number when valid,
/// or null when it is not — the UI stores the normalized form so the
/// invoice snapshot is consistent however the number was typed.
String? normalizeIndianMobile(String raw) {
  var digits = raw.replaceAll(RegExp(r'[\s\-()]'), '');
  if (digits.startsWith('+')) digits = digits.substring(1);
  if (!RegExp(r'^\d+$').hasMatch(digits)) return null;
  if (digits.length == 12 && digits.startsWith('91')) {
    digits = digits.substring(2);
  } else if (digits.length == 11 && digits.startsWith('0')) {
    digits = digits.substring(1);
  }
  if (digits.length != 10) return null;
  if (!RegExp(r'^[6-9]').hasMatch(digits)) return null;
  return digits;
}

bool isValidIndianMobile(String raw) => normalizeIndianMobile(raw) != null;
