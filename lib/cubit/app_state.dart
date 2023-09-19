// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_cubit.dart';

class AppState {
  final String appBarTitle;
  final Widget appBarActions;
  AppState({
    this.appBarTitle = '',
    this.appBarActions = const SizedBox(),
  });

  AppState copyWith({String? appBarTitle, Widget? appBarActions}) {
    return AppState(
      appBarTitle: appBarTitle ?? this.appBarTitle,
      appBarActions: appBarActions ?? this.appBarActions,
    );
  }

  @override
  bool operator ==(covariant AppState other) {
    if (identical(this, other)) return true;

    return other.appBarTitle == appBarTitle &&
        other.appBarActions == appBarActions;
  }

  @override
  int get hashCode => appBarTitle.hashCode ^ appBarActions.hashCode;
}
