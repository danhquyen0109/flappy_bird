import 'dart:ui';

import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_manager.dart';

class Fruit extends Item {
  Fruit({
    required super.sprite,
    super.effect = const [],
    super.x,
    super.y,
    this.frame = 0,
  });

  int frame;

  @override
  void draw(Canvas canvas, Size size) {
    if (!shouldPaint) return;
    if (isCollected) {
      canvas.drawImage(effect[frame], Offset(x, y), Paint());
    } else {
      canvas.drawImage(sprite.path[frame], Offset(x, y), Paint());
      if (frame == effect.length - 1) shouldPaint = false;
    }
  }

  @override
  void update(GameManager gameManager, int frames) {
    if (!shouldPaint) return;
    switch (gameManager.getGameState()) {
      case GameState.play:
        frame += (frames % 5 == 0) ? 1 : 0;
        break;
      case GameState.gameOver:
        shouldPaint = false;
        break;
      default:
        break;
    }

    if (isCollected) {
      frame = frame % effect.length;
    } else {
      frame = frame % sprite.path.length;
    }
  }

  @override
  Fruit copyWith({
    Sprite? sprite,
    List<Item>? items,
    List<Image>? effect,
    double? x,
    double? y,
    int? iat = 0,
    int? netWorth = 0,
    bool? isCollected,
  }) {
    return Fruit(
      sprite: sprite ?? this.sprite,
      effect: effect ?? this.effect,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  double get height => sprite.height.toDouble();

  @override
  double get width => sprite.width.toDouble();

  @override
  void setCollect() {
    frame = 0;
    isCollected = true;
  }
}
