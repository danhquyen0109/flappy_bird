import 'dart:ui' as ui;
import 'package:galaxy_bird/components/components.dart';
import 'package:flutter/painting.dart';
import 'package:galaxy_bird/game_manager.dart';

class Background extends Component {
  Background({required super.sprite, super.x, super.y, this.frame = 0});

  int frame;

  @override
  void draw(ui.Canvas canvas, ui.Size size) {
    y = size.height - 500;
    Offset a = Offset(0, 0);
    Offset b = Offset(size.width, size.height);
    paintImage(
      canvas: canvas,
      rect: Rect.fromPoints(a, b),
      image: sprite.path[frame],
      fit: BoxFit.cover,
    );
  }

  @override
  void update(GameManager gameManager, int frames) {
    switch (gameManager.getGameState()) {
      case GameState.ready:
        frame += (frames % 10 == 0) ? 1 : 0;
        break;
      case GameState.play:
        frame += (frames % 5 == 0) ? 1 : 0;
        break;
      case GameState.gameOver:
        frame = 0;
        break;
      default:
        break;
    }
    frame = frame % sprite.length;
  }

  @override
  double get height => sprite.height.toDouble();

  @override
  double get width => sprite.width.toDouble();
}
