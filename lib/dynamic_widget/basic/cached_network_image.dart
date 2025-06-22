// BoxFit enum을 문자열로, 또는 그 반대로 변환하기 위한 헬퍼 함수들
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';

import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:dynamic_widget/dynamic_widget/extension/color_extension.dart';

BoxFit? stringToBoxFit(String? fit) {
  switch (fit) {
    case 'fill':
      return BoxFit.fill;
    case 'contain':
      return BoxFit.contain;
    case 'cover':
      return BoxFit.cover;
    case 'fitWidth':
      return BoxFit.fitWidth;
    case 'fitHeight':
      return BoxFit.fitHeight;
    case 'none':
      return BoxFit.none;
    case 'scaleDown':
      return BoxFit.scaleDown;
    default:
      return null;
  }
}

String? boxFitToString(BoxFit? fit) {
  return fit?.toString().split('.').last;
}

class CachedNetworkImageParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    final imageUrl = map['imageUrl'];
    final placeholderMap = map['placeholder'];
    final errorWidgetMap = map['errorWidget'];
    final fadeInDuration = Duration(milliseconds: parseInt(map['fadeInDuration']) ?? 500);
    final fadeOutDuration = Duration(milliseconds: parseInt(map['fadeOutDuration']) ?? 500);

    final placeholder =
        placeholderMap != null ? DynamicWidgetBuilder.buildFromMap(placeholderMap, buildContext, listener) : null;
    final errorWidget =
        errorWidgetMap != null ? DynamicWidgetBuilder.buildFromMap(errorWidgetMap, buildContext, listener) : null;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => placeholder ?? const SizedBox.shrink(),
      errorWidget: (context, url, error) => errorWidget ?? const SizedBox.shrink(),
      fit: stringToBoxFit(map['fit']),
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      height: parseDouble(map['height']),
      width: parseDouble(map['width']),
      color: parseHexColor(map['color']),
    );
  }

  @override
  String get widgetName => 'CachedNetworkImage';

  @override
  Type get widgetType => CachedNetworkImage;

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    final realWidget = widget as CachedNetworkImage;
    debugPrint("realWidget.width: ${realWidget.height}");
    return <String, dynamic>{
      "type": widgetName,
      "imageUrl": realWidget.imageUrl,
      "width": realWidget.width,
      "height": realWidget.height,
      "fit": boxFitToString(realWidget.fit),
      "color": realWidget.color?.toHexColor(),
      "fadeInDuration": realWidget.fadeInDuration.inMilliseconds,
      "fadeOutDuration": realWidget.fadeOutDuration?.inMilliseconds,
      "placeholder":
          DynamicWidgetBuilder.export(realWidget.placeholder?.call(buildContext!, realWidget.imageUrl), buildContext),
      "errorWidget": DynamicWidgetBuilder.export(
          realWidget.errorWidget?.call(buildContext!, realWidget.imageUrl, Exception()), buildContext),
    };
  }
}
