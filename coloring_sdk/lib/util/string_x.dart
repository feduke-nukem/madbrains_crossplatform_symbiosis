import 'dart:ui';

extension StringX on String {
  Color toColor() {
    final formattedHex = replaceAll('#', '');

    var intValue = int.parse(formattedHex, radix: 16);

    if (formattedHex.length == 6) intValue = intValue + 0xFF000000;

    return Color(intValue);
  }
}
