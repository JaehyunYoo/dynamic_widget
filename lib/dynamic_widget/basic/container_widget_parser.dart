import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/extension/color_extension.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContainerWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    var alignment = parseAlignment(map['alignment']);
    var color = parseHexColor(map['color']);
    var decoration = parseBoxDecoration(map['decoration']);
    var constraints = parseBoxConstraints(map['constraints']);
    var margin = parseEdgeInsetsGeometry(map['margin']);
    var padding = parseEdgeInsetsGeometry(map['padding']);
    var child = DynamicWidgetBuilder.buildFromMap(map['child'], buildContext, listener);

    return Container(
      alignment: alignment,
      padding: padding,
      color: decoration == null ? color : null,
      decoration: decoration,
      width: parseDouble(map['width']),
      height: parseDouble(map['height']),
      constraints: constraints,
      margin: margin,
      child: child,
    );
  }

  @override
  String get widgetName => "Container";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Container;
    var alignment = realWidget.alignment as Alignment?;
    var decoration = realWidget.decoration as BoxDecoration?;
    var constraints = realWidget.constraints;
    var margin = realWidget.margin as EdgeInsets?;
    var padding = realWidget.padding as EdgeInsets?;
    debugPrint("decoration: ${exportBoxDecoration(decoration)}");
    return <String, dynamic>{
      "type": widgetName,
      "alignment": alignment != null ? exportAlignment(alignment) : null,
      "padding": padding != null ? "${padding.left},${padding.top},${padding.right},${padding.bottom}" : null,
      "color": realWidget.color?.toHexColor(),
      "decoration": decoration != null ? exportBoxDecoration(decoration) : null,
      "width": realWidget.constraints?.maxWidth,
      "height": realWidget.constraints?.maxHeight,
      "margin": margin != null ? "${margin.left},${margin.top},${margin.right},${margin.bottom}" : null,
      "constraints": constraints != null ? exportConstraints(constraints) : null,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext),
    };
  }

  @override
  Type get widgetType => Container;
}
