// helper.dart
T? cast<T>(dynamic v) => v is T ? v : null;

DateTime? toDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}

bool? toBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  final s = v.toString().toLowerCase();
  return s == 'true' || s == '1';
}

num? toNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  return num.tryParse(v.toString());
}

