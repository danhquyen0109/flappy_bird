import 'dart:ui';

import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_manager.dart';

class Magnet extends Item {
  Magnet({
    required super.sprite,
    super.effect = const [],
    super.x,
    super.y,
    super.iat = 300,
    this.frame = 0,
    this.affectRadius = 300,
  });

  int frame;

  double affectRadius;

  @override
  void draw(Canvas canvas, Size size) {
    if (!shouldPaint) return;
    if (!isCollected) {
      canvas.drawImage(sprite.path[frame], Offset(x, y), Paint());
    }
  }

  @override
  void update(GameManager gameManager, int frames) {
    if (!shouldPaint) return;
    switch (gameManager.getGameState()) {
      case GameState.gameOver:
        shouldPaint = false;
        break;
      default:
        break;
    }

    if (!isCollected) {
      frame = frame % sprite.path.length;
    }
  }

  @override
  Magnet copyWith({
    Sprite? sprite,
    List<Item>? items,
    List<Image>? effect,
    double? x,
    double? y,
    int? iat = 0,
    int? netWorth = 0,
    bool? isCollected,
  }) {
    return Magnet(
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
    shouldPaint = false;
  }
}
