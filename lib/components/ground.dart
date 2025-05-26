import 'dart:ui' as ui;
import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_manager.dart';
import 'package:flutter/painting.dart';

class Ground extends Component {
  Ground({required super.sprite, super.x, super.y, this.frame = 0});

  int frame;

  @override
  void draw(ui.Canvas canvas, ui.Size size) {
    y = size.height - height;
    canvas.drawImage(sprite.path.first, Offset(x, y), Paint());
  }

  @override
  void update(GameManager gameManager, int frames) {
    if (gameManager.getGameState() != GameState.play) return;
    x -= 2; // -2,-3,..
    x = x < -(width ~/ 2) ? 0 : x;
  }

  @override
  double get height => sprite.height.toDouble();

  @override
  double get width => sprite.width.toDouble();
}
