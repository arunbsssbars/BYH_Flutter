class Validators {
  static String? requiredText(String? v, {String field = 'Field'}) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone is required';
    final cleaned = v.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 10 || cleaned.length > 13) return 'Enter a valid phone';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(v.trim());
    if (!ok) return 'Enter a valid email';
    return null;
  }
}
