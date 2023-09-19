import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState());

  void updateAppbarTitle(String title) {
    emit(state.copyWith(appBarTitle: title));
  }

  void updateAppbarActions(Widget actions) {
    emit(state.copyWith(appBarActions: actions));
  }
}
