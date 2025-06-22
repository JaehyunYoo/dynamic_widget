import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';

class GestureDetectorParser extends WidgetParser {
  @override
  String get widgetName => 'GestureDetector';

  @override
  Type get widgetType => GestureDetector;

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    // JSON으로부터 클릭 시 전달할 이벤트(여기서는 URL)를 받습니다.
    String? onTapEvent = map['onTapEvent'];

    return GestureDetector(
      onTap: () {
        // 클릭 리스너가 존재하고, onTapEvent가 null이 아닐 때
        if (listener != null && onTapEvent != null) {
          // 리스너의 onClicked 메서드를 호출하여 이벤트를 전달합니다.
          listener.onClicked(onTapEvent);
        }
      },
      // 자식 위젯은 재귀적으로 파싱합니다.
      child: DynamicWidgetBuilder.buildFromMap(
        map['child'],
        buildContext,
        listener,
      ),
    );
  }

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    final realWidget = widget as GestureDetector;
    return <String, dynamic>{
      "type": widgetName,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext),
    };
  }
}
