import 'package:flutter_screen_recording/flutter_screen_recording.dart';

class AppScreenRecorder {
  static void startRecorde(String fileName) {
    FlutterScreenRecording.startRecordScreen(fileName);
  }

  static void stopRecord() {
    FlutterScreenRecording.stopRecordScreen;
  }
}

enum ScreenRecordStatus {
  record,
  stop,
}

extension ScreenRecordStatusX on ScreenRecordStatus {
  bool get isRecording => this == ScreenRecordStatus.record;
}
