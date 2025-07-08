import 'package:carousel_slider/carousel_slider.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class CarouselSliderParser extends WidgetParser {
  @override
  String get widgetName => 'CarouselSlider';

  @override
  Type get widgetType => CarouselSlider;
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener) {
    final optionsMap = map['options'] as Map<String, dynamic>? ?? {};

    final CarouselOptions options = CarouselOptions(
      height: parseDouble(optionsMap['height']),
      aspectRatio: parseDouble(optionsMap['aspectRatio']) ?? 16 / 9,
      viewportFraction: parseDouble(optionsMap['viewportFraction']) ?? 0.8,
      initialPage: parseInt(optionsMap['initialPage']) ?? 0,
      enableInfiniteScroll: optionsMap['enableInfiniteScroll'] as bool? ?? true,
      reverse: optionsMap['reverse'] as bool? ?? false,
      autoPlay: optionsMap['autoPlay'] as bool? ?? false,
      autoPlayInterval: Duration(milliseconds: parseInt(optionsMap['autoPlayInterval']) ?? 4000),
      autoPlayAnimationDuration: Duration(milliseconds: parseInt(optionsMap['autoPlayAnimationDuration']) ?? 800),
      enlargeCenterPage: optionsMap['enlargeCenterPage'] as bool? ?? false,
      scrollDirection: (optionsMap['scrollDirection'] as String?) == 'vertical' ? Axis.vertical : Axis.horizontal,
      onPageChanged: (index, reason) {
        final event = '{"actionType": "carouselPageChanged", "index": $index}';
        listener?.onClicked(event);
      },
    );

    final items = DynamicWidgetBuilder.buildWidgets(
      map['items'],
      buildContext,
      listener,
    );

    return CarouselSlider(
      items: items,
      options: options.copyWith(
        enlargeCenterPage: items.length > 1 ? true : false,
        autoPlay: items.length > 1 ? true : false,
      ),
    );
  }

  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    if (widget is! CarouselSlider) {
      return null;
    }

    final realWidget = widget;
    final options = realWidget.options;

    return <String, dynamic>{
      'type': widgetName,
      'items': DynamicWidgetBuilder.exportWidgets(realWidget.items ?? [], buildContext),
      'options': <String, dynamic>{
        'height': options.height,
        'aspectRatio': options.aspectRatio,
        'viewportFraction': options.viewportFraction,
        'initialPage': options.initialPage,
        'enableInfiniteScroll': options.enableInfiniteScroll,
        'reverse': options.reverse,
        'autoPlay': options.autoPlay,
        'autoPlayInterval': options.autoPlayInterval.inMilliseconds,
        'autoPlayAnimationDuration': options.autoPlayAnimationDuration.inMilliseconds,
        'enlargeCenterPage': options.enlargeCenterPage,
        'scrollDirection': options.scrollDirection.toString().split('.').last,
      },
    };
  }
}
