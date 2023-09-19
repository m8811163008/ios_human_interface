import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:component_library/component_library.dart';
import 'package:ios_human_interface/cubit/app_cubit.dart';
import 'package:ios_human_interface/l10n/ios_human_interface_localizations.dart';
import 'package:ios_human_interface/theme_repository.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'stories.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final _lightTheme = LightModeAppThemeData();
  final _darkTheme = DarkModeAppThemeData();
  final _themeRepository = ThemeRepository();
  ScreenRecordStatus _screenRecordStatus = ScreenRecordStatus.stop;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(),
      child: Storybook(
        stories: stories,
        initialStory: StoriesRoutesNames.wellcome,
        wrapperBuilder: _wrapperBuilder,
        plugins: [
          ThemeModePlugin(
            initialTheme: ThemeMode.light,
            onThemeChanged: (value) {
              late Brightness brighness;
              switch (value) {
                case ThemeMode.system:
                  brighness = MediaQuery.platformBrightnessOf(context);
                  break;
                case ThemeMode.light:
                  brighness = Brightness.light;
                  break;
                case ThemeMode.dark:
                  brighness = Brightness.dark;
                  break;
              }
              _themeRepository.updateAppThemeBrightness(brighness);
            },
          ),
          Plugin(
            icon: (_) => AnimatedCrossFade(
              firstChild: AnimatedStopIcon(
                isAnimating: _screenRecordStatus.isRecording,
              ),
              secondChild: const Icon(
                CupertinoIcons.circle_fill,
              ),
              duration: const Duration(milliseconds: 500),
              crossFadeState: _screenRecordStatus.isRecording
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),
            onPressed: (context) {
              if (_screenRecordStatus.isRecording) {
                AppScreenRecorder.stopRecord();
              } else {
                final fileName = DateTime.now().toIso8601String();
                AppScreenRecorder.startRecorde(fileName);
              }
              setState(() {
                _screenRecordStatus = _screenRecordStatus.isRecording
                    ? ScreenRecordStatus.stop
                    : ScreenRecordStatus.record;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _wrapperBuilder(BuildContext context, Widget? child) {
    return StreamBuilder(
      stream: _themeRepository.currentTheme,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final theme =
              snapshot.data == Brightness.light ? _lightTheme : _darkTheme;
          return AppTheme(
            lightTheme: _lightTheme,
            darkTheme: _darkTheme,
            brightness: theme.cupertinoThemeData.brightness!,
            child: CupertinoApp(
              home: CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: BlocSelector<AppCubit, AppState, String>(
                    selector: (state) {
                      return state.appBarTitle;
                    },
                    builder: (context, appBarTitle) {
                      return Text(appBarTitle);
                    },
                  ),
                  leading: BlocSelector<AppCubit, AppState, Widget>(
                    selector: (state) {
                      return state.appBarActions;
                    },
                    builder: (context, appBarActions) => appBarActions,
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: child!,
                  ),
                ),
              ),
              theme: theme.cupertinoThemeData,
              localizationsDelegates:
                  IosHumanInterfaceLocalizations.localizationsDelegates,
              supportedLocales: IosHumanInterfaceLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
            ),
          );
        }
        return const CenteredActivityIndicator();
      },
    );
  }
}
