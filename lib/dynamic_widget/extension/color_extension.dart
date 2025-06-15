// ignore_for_file: deprecated_member_use

import 'dart:ui';

extension ColorToHexExtension on Color {
  /// [leadingHashSign] true일 경우, 반환되는 문자열 앞에 '#' 기호를 붙입니다. (기본값: true)
  String toHexColor({bool leadingHashSign = true}) {
    final String hexR = red.toRadixString(16).padLeft(2, '0');
    final String hexG = green.toRadixString(16).padLeft(2, '0');
    final String hexB = blue.toRadixString(16).padLeft(2, '0');
    final String hexA = alpha.toRadixString(16).padLeft(2, '0');

    final String hexString = '$hexA$hexR$hexG$hexB'; // AARRGGBB 순서

    return hexString.toUpperCase();
  }
}
extension HexToColorExtension on String {
  /// 지원하는 형식:
  /// - 6자리: "RRGGBB" (알파는 FF로 간주)
  /// - 7자리: "#RRGGBB" (알파는 FF로 간주)
  /// - 8자리: "AARRGGBB"
  /// - 9자리: "#AARRGGBB"
  /// 잘못된 형식의 문자열이거나 변환에 실패하면 [fallbackColor]
  /// (기본 fallbackColor: 불투명 검은색)
  Color toColor({Color fallbackColor = const Color(0xFF000000)}) {
    String hex = toUpperCase().replaceFirst('#', '');
    String finalHex;

    if (hex.length == 6) {
      finalHex = 'FF$hex';
    } else if (hex.length == 8) {
      finalHex = hex;
    } else {
      return fallbackColor;
    }
    try {
      return Color(int.parse(finalHex, radix: 16));
    } catch (e) {
      return fallbackColor;
    }
  }
}