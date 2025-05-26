import 'package:flame_audio/flame_audio.dart';

mixin GameSound {
  static Future<void> loadAll() async {
    await FlameAudio.audioCache.loadAll([
      'bird_collect.mp3',
      'coin_collect.mp3',
      'die.mp3',
      'eat.mp3',
      'flap.mp3',
      'good.mp3',
      'metal_hit.mp3',
      'rank_up.mp3',
      'score.mp3',
      'select.mp3',
      'unlock.mp3',
    ]);
  }

  void playSound({required String path}) {
    FlameAudio.play('$path.mp3');
  }
}
