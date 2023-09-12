import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState());

  void updateAppbarTitle(String title) {
    emit(state.copyWith(appBarTitle: title));
  }
}
