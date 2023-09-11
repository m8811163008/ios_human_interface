import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class ThemeRepository {
  ThemeRepository() : _appThemeSubject = BehaviorSubject();
  final BehaviorSubject<Brightness> _appThemeSubject;

  Stream<Brightness> get currentTheme async* {
    if (!_appThemeSubject.hasValue) {
      yield Brightness.light;
    }
    yield* _appThemeSubject.stream;
  }

  void updateAppThemeBrightness(Brightness brightness) {
    _appThemeSubject.add(
      brightness,
    );
  }
}
