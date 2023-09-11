import 'package:flutter/cupertino.dart';

abstract class AppThemeData {
  CupertinoThemeData get cupertinoThemeData;
}

final class LightModeAppThemeData implements AppThemeData {
  @override
  CupertinoThemeData get cupertinoThemeData => const CupertinoThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: CupertinoColors.lightBackgroundGray,
      );
}

final class DarkModeAppThemeData implements AppThemeData {
  @override
  CupertinoThemeData get cupertinoThemeData => const CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: CupertinoColors.darkBackgroundGray,
      );
}
