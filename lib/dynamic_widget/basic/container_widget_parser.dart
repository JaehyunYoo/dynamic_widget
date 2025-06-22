import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/extension/color_extension.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/widgets.dart';

class ContainerWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    AlignmentGeometry? alignment = parseAlignmentGeometry(map['alignment']);
    BoxConstraints constraints = parseBoxConstraints(map['constraints']);
    Map<String, dynamic>? childMap = map['child'];
    Widget? child = childMap == null ? null : DynamicWidgetBuilder.buildFromMap(childMap, buildContext, listener);

    String? clickEvent = map.containsKey("click_event") ? map['click_event'] : null;

    var containerWidget = Container(
      alignment: alignment,
      padding: parseEdgeInsetsGeometry(map['padding']),
      decoration: parseBoxDecoration(map['decoration']),
      margin: parseEdgeInsetsGeometry(map['margin']),
      width: parseDouble(map['width']),
      height: parseDouble(map['height']),
      constraints: constraints,
      child: child,
    );

    return containerWidget;
  }

  @override
  String get widgetName => "Container";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Container;
    var padding = realWidget.padding as EdgeInsets?;
    var margin = realWidget.margin as EdgeInsets?;
    var constraints = realWidget.constraints;
    var decoration = realWidget.decoration as BoxDecoration?;

    return <String, dynamic>{
      "type": widgetName,
      "alignment": realWidget.alignment != null ? exportAlignment(realWidget.alignment) : null,
      "padding": padding != null ? "${padding.left},${padding.top},${padding.right},${padding.bottom}" : null,
      "decoration": exportBoxDecoration(decoration),
      "margin": margin != null ? "${margin.left},${margin.top},${margin.right},${margin.bottom}" : null,
      "constraints": constraints != null ? exportConstraints(constraints) : null,
      "width": realWidget.constraints?.maxWidth,
      "height": realWidget.constraints?.maxHeight,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  Type get widgetType => Container;
}
