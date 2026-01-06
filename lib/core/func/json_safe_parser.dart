// json_safe_parser.dart
// ملف شامل يحتوي على دوال مساعدة لتحليل الـ JSON بأمان

/// يحصل على قيمة String بأمان من الخريطة، أو يعيد قيمة افتراضية.
///
/// المعالجات:
/// 1. إذا كانت القيمة null أو مفقودة، يعيد defaultValue.
/// 2. إذا لم تكن من نوع String، يعيد defaultValue.
///
///
String? safeNullableString(Map<String, dynamic> json, String key) {
  final value = json[key];
  return (value is String) ? value : null;
}

/// يحصل على قيمة Int? بأمان. يعيد null إذا كانت القيمة null أو غير صالحة.
/// هذا مثالي للحقول التي تقبل int?، ويحافظ على منطق التحويل من String إلى Int.
int? safeNullableInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is String) {
    // tryParse يعيد null عند الفشل
    return int.tryParse(value);
  }
  return null;
}

/// يحصل على قيمة Double? بأمان. يعيد null إذا كانت القيمة null أو غير صالحة.
/// هذا مثالي للحقول التي تقبل double?
double? safeNullableDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

String safeString(
  Map<String, dynamic> json,
  String key, {
  String defaultValue = '',
}) {
  final value = json[key];
  return (value is String) ? value : defaultValue;
}

/// يحصل على قيمة Int بأمان من الخريطة، أو يعيد قيمة افتراضية.
///
/// المعالجات:
/// 1. إذا كانت القيمة int، يعيدها مباشرة.
/// 2. إذا كانت String، يحاول تحويلها إلى int.
/// 3. إذا كانت null أو غير صالحة، يعيد defaultValue (0 افتراضياً).
int safeInt(Map<String, dynamic> json, String key, {int defaultValue = 0}) {
  final value = json[key];
  if (value is int) {
    return value;
  }
  if (value is String) {
    // tryParse يعيد null في حالة الفشل
    return int.tryParse(value) ?? defaultValue;
  }
  return defaultValue;
}

/// يحصل على قيمة Double بأمان من الخريطة، أو يعيد قيمة افتراضية.
///
/// المعالجات:
/// 1. إذا كانت القيمة num (int أو double)، يحولها إلى double.
/// 2. إذا كانت String، يحاول تحويلها إلى double.
/// 3. إذا كانت null أو غير صالحة، يعيد defaultValue (0.0 افتراضياً).
double safeDouble(
  Map<String, dynamic> json,
  String key, {
  double defaultValue = 0.0,
}) {
  final value = json[key];
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? defaultValue;
  }
  return defaultValue;
}

/// يحصل على قيمة Boolean بأمان من الخريطة، أو يعيد قيمة افتراضية.
///
/// المعالجات:
/// 1. إذا كانت القيمة bool، يعيدها مباشرة.
/// 2. إذا كانت String (مثل 'true' أو '1') يحاول تحويلها منطقياً.
/// 3. إذا كانت null أو غير صالحة، يعيد defaultValue (false افتراضياً).
bool safeBool(
  Map<String, dynamic> json,
  String key, {
  bool defaultValue = false,
}) {
  final value = json[key];
  if (value is bool) {
    return value;
  }
  if (value is int) {
    return value == 1; // التعامل مع 1 كـ true
  }
  if (value is String) {
    // يعتبر 'true' أو '1' كقيمة صحيحة (True)
    return value.toLowerCase() == 'true' || value == '1';
  }
  return defaultValue;
}

/// يحصل على قائمة (List) بأمان من الخريطة، أو يعيد قائمة فارغة.
///
/// المعالجات:
/// 1. إذا كانت القيمة List، يعيدها مباشرة مع محاولة فلترة النوع T.
/// 2. إذا كانت null أو غير صالحة، يعيد قائمة فارغة [].
List<T> safeList<T>(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is List) {
    // محاولة فلترة العناصر للتأكد من أنها من النوع T
    return value.whereType<T>().toList();
  }
  return [];
}

/// يحصل على خريطة متداخلة (Nested Map) بأمان، أو يعيد خريطة فارغة.
///
/// المعالجات:

/// 2. إذا كانت null أو نوع آخر، يعيد خريطة فارغة {}.
Map<String, dynamic> safeMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  return (value is Map<String, dynamic>) ? value : {};
}
