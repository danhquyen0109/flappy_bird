import 'dart:math';
import 'dart:ui' as ui;
import 'package:galaxy_bird/components/components.dart';
import 'package:flutter/painting.dart';

import '../game_manager.dart';

enum CrateStatus { idle, movingUp, movingDown, openClose }

class Crate extends Obstacle {
  Crate({required super.sprite, this.quantity = 0, this.gap = 130.0});

  int quantity;
  double gap;
  final double _dx = 2;
  final double _dy = 1;
  final double _do = 1;
  Item? ark;

  @override
  void draw(ui.Canvas canvas, ui.Size size) {
    for (int i = 0; i < obstacles.length; i++) {
      Crate topCrate = obstacles[i] as Crate;
      double offset = topCrate.crateStatus.hasOffset ? topCrate.threshold : 0;

      /// draw top crates
      drawCrates(canvas, size, topCrate, offset);

      /// draw ark
      if (topCrate.ark != null) {
        topCrate.ark!.draw(canvas, size);
      }

      /// draw bottom crates
      double xBot = topCrate.x;
      double yBot = (topCrate.y + topCrate.height) + topCrate.gap;
      Crate botCrate =
          Crate(sprite: sprite, quantity: topCrate.quantity)
            ..x = xBot
            ..y = yBot;
      drawCrates(canvas, size, botCrate, -offset);
    }
  }

  @override
  void update(GameManager gameManager, int frames) {
    if (gameManager.getGameState() != GameState.play) return;
    if (frames % 120 == 0) {
      CrateStatus crateStatus = CrateStatus.idle;
      int score = gameManager.readScore();
      if (score > 20) {
        crateStatus =
            frames % 480 == 0
                ? CrateStatus.values[Random().nextInt(2) + 1]
                : CrateStatus.idle;
      } else if (score > 60) {
        crateStatus =
            frames % 480 == 0
                ? CrateStatus.values[Random().nextInt(3) + 1]
                : CrateStatus.idle;
      }
      int maxBox = 6;
      double x = gameManager.getScreenSize().width;
      double y = -150 * min(Random().nextDouble() + 1, 1.8);
      Crate newCrate =
          Crate(sprite: sprite, gap: gap, quantity: maxBox)
            ..x = x
            ..y = y
            ..crateStatus = crateStatus;
      if (crateStatus == CrateStatus.idle) {
        Item ark = GameManager.gameItems[ItemName.gold.index].copyWith();
        ark.x = newCrate.x + (newCrate.width - ark.sprite.width) / 2;
        ark.y = y + newCrate.height + (gap - ark.sprite.height) / 2;
        newCrate.ark = ark;
      }
      obstacles.add(newCrate);
    }
    for (int i = 0; i < obstacles.length; i++) {
      Crate obstacle = obstacles[i] as Crate;
      obstacle.x -= _dx;
      obstacle.ark?.x -= _dx;
      obstacle.attackByMove();
      obstacle.attackBySqueeze();
      obstacle.ark?.update(gameManager, frames);
    }

    if (obstacles.isNotEmpty && obstacles[0].x < -sprite.width) {
      obstacles.removeAt(0);
      gameManager.setPipeStatus(true);
    }
  }

  void drawCrates(
    ui.Canvas canvas,
    ui.Size size,
    Crate crate, [
    double offset = 0,
  ]) {
    ui.Image crateSprite = sprite.path[0];
    paintImage(
      canvas: canvas,
      rect: Rect.fromPoints(
        Offset(crate.x, crate.y + offset),
        Offset(crate.x + crate.width, crate.y + offset + crate.height),
      ),
      alignment: Alignment.topCenter,
      image: crateSprite,
      fit: BoxFit.scaleDown,
      repeat: ImageRepeat.repeatY,
    );
  }

  @override
  double get width => sprite.width.toDouble();

  @override
  double get height => sprite.height.toDouble() * quantity;

  CrateStatus crateStatus = CrateStatus.idle;

  double threshold = 0;

  void attackByMove() {
    if (crateStatus == CrateStatus.idle ||
        crateStatus == CrateStatus.openClose) {
      return;
    }
    if (crateStatus == CrateStatus.movingDown) {
      if (threshold == 150) {
        crateStatus = CrateStatus.movingUp;
      } else {
        threshold++;
        y += _dy;
      }
    }
    if (crateStatus == CrateStatus.movingUp) {
      if (threshold == 0) {
        crateStatus = CrateStatus.movingDown;
      } else {
        threshold--;
        y -= _dy;
      }
    }
  }

  int vector = -1;

  void attackBySqueeze() {
    if (crateStatus != CrateStatus.openClose) return;
    if (threshold <= -50 || (threshold - 1 >= gap ~/ 2)) {
      vector = -vector;
    }
    vector > 0 ? threshold += _do : threshold -= (_do * 2);
  }
}

extension ExtensionCrate on Crate {
  Crate move(Vector2 v) {
    return Crate(sprite: sprite, quantity: quantity, gap: gap)
      ..x = x + v.a
      ..y = y + v.b;
  }
}

extension ExtensionCrateStatus on CrateStatus {
  bool get hasOffset {
    switch (this) {
      case CrateStatus.idle:
        return false;
      case CrateStatus.movingUp:
      case CrateStatus.movingDown:
        return false;
      case CrateStatus.openClose:
        return true;
    }
  }
}
