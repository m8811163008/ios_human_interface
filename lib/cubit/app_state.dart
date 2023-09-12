// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_cubit.dart';

class AppState {
  final String appBarTitle;
  AppState({
    this.appBarTitle = '',
  });

  AppState copyWith({
    String? appBarTitle,
  }) {
    return AppState(
      appBarTitle: appBarTitle ?? this.appBarTitle,
    );
  }

  @override
  bool operator ==(covariant AppState other) {
    if (identical(this, other)) return true;

    return other.appBarTitle == appBarTitle;
  }

  @override
  int get hashCode => appBarTitle.hashCode;
}
