extension StringExt on String {
  String get removeNewLines => replaceAll(RegExp(r'\n'), '  ');

  String toFirstUpper() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
