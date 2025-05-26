import 'dart:math';
import 'dart:ui' as ui;
import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_manager.dart';
import 'package:flutter/painting.dart';

class Pipe extends Obstacle {
  Pipe({required super.sprite, this.gap = 115});

  /// space between 2 pipes
  int gap;

  final double _dx = 2;

  @override
  void draw(ui.Canvas canvas, ui.Size size) {
    for (int i = 0; i < obstacles.length; i++) {
      final p = obstacles[i];
      ui.Image topSprite = sprite.path[0];
      ui.Image botSprite = sprite.path[1];

      double xTop = p.x;
      double yTop = p.y;

      /// draw top pipe
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(
          xTop,
          yTop,
          topSprite.width.toDouble(),
          topSprite.height.toDouble(),
        ),
        image: topSprite,
        fit: BoxFit.fill,
      );

      double xBot = p.x;
      double yBot = (p.y + topSprite.height) + gap;

      /// draw bot pipe
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(
          xBot,
          yBot,
          topSprite.width.toDouble(),
          topSprite.height.toDouble(),
        ),
        image: botSprite,
        fit: BoxFit.fill,
      );
    }
  }

  @override
  void update(GameManager gameManager, int frames) {
    if (gameManager.getGameState() != GameState.play) return;
    if (frames % 100 == 0) {
      double x = gameManager.getScreenSize().width;
      double y = -150 * min(Random().nextDouble() + 1, 1.8);
      obstacles.add(
        Pipe(sprite: sprite, gap: gap)
          ..x = x
          ..y = y,
      );
    }
    for (var p in obstacles) {
      p.x -= _dx;
    }
    if (obstacles.isNotEmpty && obstacles[0].x < -sprite.width) {
      obstacles.removeAt(0);
      gameManager.setPipeStatus(true);
    }
  }
}
