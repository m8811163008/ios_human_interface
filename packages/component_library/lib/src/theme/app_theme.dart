// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:component_library/src/theme/app_theme_data.dart';
import 'package:component_library/component_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme extends InheritedWidget {
  final AppThemeData lightTheme;
  final AppThemeData darkTheme;
  final Brightness brightness;

  const AppTheme({
    super.key,
    required this.lightTheme,
    required this.darkTheme,
    required this.brightness,
    required super.child,
  });

  @override
  bool updateShouldNotify(AppTheme oldWidget) =>
      brightness != oldWidget.brightness;

  static AppThemeData of(BuildContext context) {
    final appTheme = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    assert(appTheme != null, "current context doesn't have AppTheme");
    final currentThemeBrighness = CupertinoTheme.of(context).brightness;
    return currentThemeBrighness == Brightness.light
        ? appTheme!.lightTheme
        : appTheme!.darkTheme;
  }
}
