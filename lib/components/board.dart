import 'dart:math';
import 'dart:ui' as ui;
import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_manager.dart';
import 'package:flutter/material.dart';

class Board extends Component {
  Board({super.sprite, super.x, super.y});

  int score = 0;

  List<Item> items = [];

  GameState gameState = GameState.ready;

  @override
  void draw(ui.Canvas canvas, ui.Size size) {
    // draw frame
    final paint =
        Paint()
          ..strokeWidth = 2
          ..style = ui.PaintingStyle.stroke
          ..color = Colors.black;
    canvas.drawRect(
      Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
      paint,
    );
    // draw score
    switch (gameState) {
      case GameState.play:
        for (var item in items) {
          item.draw(canvas, size);
        }
        break;
      default:
        break;
    }
  }

  @override
  void update(GameManager gameManager, int frames) {
    gameState = gameManager.getGameState();
    if (gameState == GameState.gameOver || gameState == GameState.ready) return;
    score = gameManager.readScore();
    items.removeWhere((item) => !item.shouldPaint);
    for (var item in items) {
      item.update(gameManager, frames);
    }

    if (frames % 180 == 0 && frames % 120 != 0) {
      int itemsPerFrame = Random().nextInt(5) + 1;
      int itemType =
          itemsPerFrame == 1 ? Random().nextInt(4) + ItemName.magnet.index : 0;

      if (itemsPerFrame == 1) {
        Item item = GameManager.gameItems[itemType].copyWith();
        item.x = gameManager.getScreenSize().width + item.width / 2;
        item.y = gameManager.getScreenSize().height / 2 - 100;
        items.add(item);
      } else {
        double x = gameManager.getScreenSize().width;
        double y = gameManager.getScreenSize().height / 3;
        for (int i = 0; i < itemsPerFrame; i++) {
          Item item = GameManager.gameItems[itemType].copyWith();
          item.x = x + item.width / 2;
          item.y = y + (item.height + GameManager.itemPaddingSmall) * i;
          items.add(item);
        }
      }
    }

    for (int i = 0; i < items.length; i++) {
      Item item = items[i];
      item.x -= GameManager.gameSpeed;
    }
    if (items.isNotEmpty && items[0].x < -50) {
      items.removeAt(0);
    }
  }

  void drawItems(ui.Canvas canvas, ui.Size size) {}

  @override
  double get height => sprite.height.toDouble();

  @override
  double get width => sprite.width.toDouble();

  void reset() => items.clear();
}
