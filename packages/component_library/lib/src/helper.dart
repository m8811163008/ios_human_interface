import 'package:component_library/component_library.dart';
import 'package:flutter/cupertino.dart';

extension TextThemeX on BuildContext {
  TextStyle get textStyle =>
      AppTheme.of(this).cupertinoThemeData.textTheme.textStyle;
}
