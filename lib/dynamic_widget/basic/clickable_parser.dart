import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';

class Clickable extends StatelessWidget {
  final Widget child;
  final String? onTapEvent;

  const Clickable({
    super.key,
    required this.child,
    this.onTapEvent,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Clickable 위젯을 해석하는 파서.
class ClickableParser extends WidgetParser {
  @override
  String get widgetName => "Clickable"; // JSON에서 사용할 위젯 타입 이름

  @override
  Type get widgetType => Clickable; // 이 파서가 처리할 실제 위젯 타입

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    var onTapEvent = map['onTapEvent'];

    return GestureDetector(
      onTap: () {
        // 클릭이 발생하면, ClickListener에게 '명령서'를 그대로 전달합니다.
        listener?.onClicked(onTapEvent?.toString());
      },
      // 자식 위젯은 재귀적으로 다시 파싱하여 생성합니다.
      child: DynamicWidgetBuilder.buildFromMap(
        map['child'],
        buildContext,
        listener,
      ),
    );
  }

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Clickable;

    return <String, dynamic>{
      "type": widgetName,
      "onTapEvent": realWidget.onTapEvent,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext),
    };
  }
}
