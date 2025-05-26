import 'package:flutter/services.dart';

mixin GameSound {
  static const platform = MethodChannel('com.tdev.flipflop/play_audio');

  void playSound({required String path}) =>
      platform.invokeMethod('playAudio', {'path': path});
}
