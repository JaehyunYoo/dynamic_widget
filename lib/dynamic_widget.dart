// ignore_for_file: use_key_in_widget_constructors, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, body_might_complete_normally_nullable

library dynamic_widget;

import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:jsf/jsf.dart';
import 'dynamic_widget/export_package.dart';

class DynamicWidgetBuilder {
  static final Logger log = Logger('DynamicWidget');

  static final _parsers = [
    OverflowBoxWidgetParser(),
    ClickableParser(),
    CarouselSliderParser(),
    GestureDetectorParser(),
    CachedNetworkImageParser(),
    ContainerWidgetParser(),
    TextWidgetParser(),
    SelectableTextWidgetParser(),
    RowWidgetParser(),
    ColumnWidgetParser(),
    AssetImageWidgetParser(),
    NetworkImageWidgetParser(),
    PlaceholderWidgetParser(),
    GridViewWidgetParser(),
    ListViewWidgetParser(),
    PageViewWidgetParser(),
    ExpandedWidgetParser(),
    PaddingWidgetParser(),
    CenterWidgetParser(),
    AlignWidgetParser(),
    AspectRatioWidgetParser(),
    FittedBoxWidgetParser(),
    BaselineWidgetParser(),
    StackWidgetParser(),
    PositionedWidgetParser(),
    IndexedStackWidgetParser(),
    ExpandedSizedBoxWidgetParser(),
    SizedBoxWidgetParser(),
    OpacityWidgetParser(),
    WrapWidgetParser(),
    DropCapTextParser(),
    IconWidgetParser(),
    ClipRRectWidgetParser(),
    SafeAreaWidgetParser(),
    ListTileWidgetParser(),
    ScaffoldWidgetParser(),
    AppBarWidgetParser(),
    LimitedBoxWidgetParser(),
    OffstageWidgetParser(),
    OverflowBoxWidgetParser(),
    ElevatedButtonParser(),
    DividerWidgetParser(),
    TextButtonParser(),
    RotatedBoxWidgetParser(),
    CardParser(),
    SingleChildScrollViewParser(),
    ColoredBoxWidgetParser(),
    RepaintBoundaryWidgetParser(),
    SvgPictureWidgetParser(),
    NetworkSvgPictureWidgetParser(),
  ];

  static final _widgetNameParserMap = <String, WidgetParser>{};

  static bool _defaultParserInited = false;

  // use this method for adding your custom widget parser
  static void addParser(WidgetParser parser) {
    log.info("add custom widget parser, make sure you don't overwirte the widget type.");
    _parsers.add(parser);
    _widgetNameParserMap[parser.widgetName] = parser;
  }

  static void _findAndupdatePopupCount(Map<String, dynamic> data, String newText) {
    if (data['type'] == 'Text') {
      String? textData = data['data'];
      if (textData != null && textData.contains('popupCount')) {
        data['data'] = newText;
        return;
      }
    }

    data.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        _findAndupdatePopupCount(value, newText);
      } else if (value is List) {
        for (var element in value) {
          if (element is Map<String, dynamic>) {
            _findAndupdatePopupCount(element, newText);
          }
        }
      }
    });
  }

  static void initDefaultParsersIfNess() {
    if (!_defaultParserInited) {
      for (var parser in _parsers) {
        _widgetNameParserMap[parser.widgetName] = parser;
      }
      _defaultParserInited = true;
    }
  }

  static Widget? build(
    String json,
    BuildContext buildContext,
    ClickListener listener,
    dynamic param3, {
    bool? isRandom = false,
    Function(dynamic)? onLoad,
  }) {
    try {
      initDefaultParsersIfNess();
      final map = jsonDecode(json);

      if (map['items'] is List) {
        var items = map['items'] as List<dynamic>;
        if (isRandom == true) {
          items.shuffle();
        }
        if (onLoad != null) {
          onLoad.call(items.first["onTapEvent"]);
        }
      }

      ClickListener _listener = listener;
      var widget = buildFromMap(map, buildContext, _listener);

      return widget;
    } catch (error) {
      log.severe("Error parsing JSON: $error");
    }
  }

  static Widget? buildPremium(
    String json,
    BuildContext buildContext,
    ClickListener listener,
    dynamic param3, {
    bool? isRandom = false,
    Function(dynamic)? onLoad,
    bool? isUserPremium = false,
  }) {
    try {
      initDefaultParsersIfNess();
      final map = jsonDecode(json);

      if (map['items'] is List) {
        var items = map['items'] as List<dynamic>;
        if (isUserPremium == true) {
          items.removeWhere((item) {
            if (item is Map<String, dynamic> && item.containsKey('onTapEvent')) {
              final onTapEvent = item['onTapEvent'];
              if (onTapEvent is Map<String, dynamic> && onTapEvent.containsKey('isPremium')) {
                return onTapEvent['isPremium'] == 'true';
              }
            }
            return false;
          });
        }
        if (isRandom == true) {
          items.shuffle();
        }
        if (items.any((element) => element.toString().contains("popupCount"))) {
          for (var i = 0; i < items.length; i++) {
            var item = items[i];
            if (item is Map<String, dynamic>) {
              var itemJsonString = jsonEncode(item);
              if (itemJsonString.contains('popupCount')) {
                var newText = '${i + 1}/${items.length}';
                var updatedItemJsonString = itemJsonString.replaceAll('popupCount', newText);

                items[i] = jsonDecode(updatedItemJsonString);
              }
            }
          }
        }
        if (onLoad != null) {
          onLoad.call(items.first["onTapEvent"]);
        }
      }

      ClickListener _listener = listener;
      var widget = buildFromMap(map, buildContext, _listener);

      return widget;
    } catch (error) {
      log.severe("Error parsing JSON: $error");
    }
  }

  static Widget? build2(
    String json,
    BuildContext buildContext,
    ClickListener listener,
    dynamic param3, {
    bool? isRandom = false,
    Function(dynamic)? onLoad,
  }) {
    try {
      initDefaultParsersIfNess();
      final map = jsonDecode(json);

      if (map['items'] is List) {
        var items = map['items'] as List<dynamic>;
        if (isRandom == true) {
          items.shuffle();
          if (items.any((element) => element.toString().contains("popupCount"))) {
            for (var i = 0; i < items.length; i++) {
              var item = items[i];
              if (item is Map<String, dynamic>) {
                var itemJsonString = jsonEncode(item);
                if (itemJsonString.contains('popupCount')) {
                  var newText = '${i + 1}/${items.length}';
                  var updatedItemJsonString = itemJsonString.replaceAll('popupCount', newText);

                  items[i] = jsonDecode(updatedItemJsonString);
                }
              }
            }
          }
        }
        if (onLoad != null) {
          onLoad.call(items.first["onTapEvent"]);
        }
      }

      ClickListener _listener = listener;
      var widget = buildFromMap(map, buildContext, _listener);

      return widget;
    } catch (error) {
      log.severe("Error parsing JSON: $error");
    }
  }

  static Widget? buildFromMap(Map<String, dynamic>? map, BuildContext buildContext, ClickListener? listener) {
    initDefaultParsersIfNess();
    if (map == null) {
      return null;
    }
    String? widgetName = map['type'];
    if (widgetName == null) {
      return null;
    }
    var parser = _widgetNameParserMap[widgetName];
    if (parser != null) {
      return parser.parse(map, buildContext, listener);
    }
    log.warning("Not support parser type: $widgetName");
    if (kDebugMode) {
      throw UnimplementedError("Not support parser type: $widgetName");
    }
    return null;
  }

  static List<Widget> buildWidgets(List<dynamic> values, BuildContext buildContext, ClickListener? listener) {
    initDefaultParsersIfNess();
    List<Widget> rt = [];
    for (var value in values) {
      var buildFromMap2 = buildFromMap(value, buildContext, listener);
      if (buildFromMap2 != null) {
        rt.add(buildFromMap2);
      }
    }
    return rt;
  }

  static Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    initDefaultParsersIfNess();
    var parser = _findMatchedWidgetParserForExport(widget);
    if (parser != null) {
      return parser.export(widget, buildContext);
    }
    return null;
  }

  static List<Map<String, dynamic>?> exportWidgets(List<Widget?> widgets, BuildContext? buildContext) {
    initDefaultParsersIfNess();
    List<Map<String, dynamic>?> rt = [];
    for (var widget in widgets) {
      rt.add(export(widget, buildContext));
    }
    return rt;
  }

  static WidgetParser? _findMatchedWidgetParserForExport(Widget? widget) {
    for (var parser in _parsers) {
      if (parser.matchWidgetForExport(widget)) {
        return parser;
      }
    }
    return null;
  }
}

/// extends this class to make a Flutter widget parser.
abstract class WidgetParser {
  /// parse the json map into a flutter widget.
  ///
  ///
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, ClickListener? listener);

  /// the widget type name for example:
  /// {"type" : "Text", "data" : "Denny"}
  /// if you want to make a flutter Text widget, you should implement this
  /// method return "Text", for more details, please see
  /// @TextWidgetParser
  String get widgetName;

  /// export the runtime widget to json
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext);

  /// match current widget
  Type get widgetType;

  bool matchWidgetForExport(Widget? widget) => widget.runtimeType == widgetType;
}

abstract class CustomWidgetParser {
  /// parse the json map into a flutter widget.
  ///
  ///
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, WidgetClickListener? listener);

  /// the widget type name for example:
  /// {"type" : "Text", "data" : "Denny"}
  /// if you want to make a flutter Text widget, you should implement this
  /// method return "Text", for more details, please see
  /// @TextWidgetParser
  String get widgetName;

  /// export the runtime widget to json
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext);

  /// match current widget
  Type get widgetType;

  bool matchWidgetForExport(Widget? widget) => widget.runtimeType == widgetType;
}

abstract class ClickListener {
  Future<void> onClicked(String? event);
}

class NonResponseWidgetClickListener implements ClickListener {
  static final Logger log = Logger('NonResponseWidgetClickListener');

  @override
  Future<void> onClicked(String? event) async {
    log.info("receiver click event: " + event!);
    print("receiver click event: " + event);
  }
}

abstract class WidgetClickListener {
  Future<void> onClicked(Map<String, dynamic>? event);
}

class TestWidgetClickListener implements WidgetClickListener {
  static final Logger log = Logger('NonResponseWidgetClickListener');

  @override
  Future<void> onClicked(Map<String, dynamic>? event) async {
    log.info("receiver click event: " + event.toString());
  }
}

class DynamicWidget extends StatefulWidget {
  final String jsCode;

  const DynamicWidget(this.jsCode);

  @override
  DynamicWidgetState createState() => DynamicWidgetState();
}

class DynamicWidgetState extends State<DynamicWidget> {
  late JsRuntime _js;
  late String jsCode;
  late String jsonCode;

  @override
  void initState() {
    super.initState();
    _js = JsRuntime();
    jsCode = widget.jsCode;
    jsonCode = _js.eval("var App;$jsCode;JSON.stringify(App)");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget?>(
      future: _buildWidget(context),
      builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
        return snapshot.hasData ? DynamicWidgetJsonExportor(child: snapshot.data) : SizedBox();
      },
    );
  }

  Future<Widget?> _buildWidget(BuildContext context) async {
    return DynamicWidgetBuilder.build(
      jsonCode,
      context,
      DefaultClickListener(onClick: _onClick),
      null,
    );
  }

  void _onClick(String? event) {
    setState(() {
      _js.eval(event!);
      jsonCode = _js.eval("JSON.stringify(App)");
    });
  }
}

class DefaultClickListener implements ClickListener {
  final Function(String?) onClick;

  DefaultClickListener({required this.onClick});

  @override
  Future<void> onClicked(String? event) async {
    await onClick(event);
  }
}
