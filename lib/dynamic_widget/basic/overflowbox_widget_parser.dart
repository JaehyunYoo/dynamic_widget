import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/widgets.dart';

class OverflowBoxWidgetParser extends WidgetParser {
  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    OverflowBox realWidget = widget as OverflowBox;
    return <String, dynamic>{
      "type": widgetName,
      "alignment": exportAlignment(realWidget.alignment),
      "minWidth": realWidget.minWidth,
      "maxWidth": realWidget.maxWidth,
      "minHeight": realWidget.minHeight,
      "maxHeight": realWidget.maxHeight,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    return OverflowBox(
      alignment: map.containsKey("alignment")
          ? parseAlignmentGeometry(map["alignment"]) ?? Alignment.center
          : Alignment.center,
      minWidth: map.containsKey("minWidth") ? parseDouble(map['minWidth']) : null,
      maxWidth: map.containsKey("maxWidth") ? parseDouble(map['maxWidth']) : null,
      minHeight: map.containsKey("minHeight") ? parseDouble(map['minHeight']) : null,
      maxHeight: map.containsKey("maxHeight") ? parseDouble(map['maxHeight']) : null,
      child: DynamicWidgetBuilder.buildFromMap(map['child'], buildContext, listener),
    );
  }

  @override
  String get widgetName => "OverflowBox";

  @override
  Type get widgetType => OverflowBox;
}
