import 'dart:math';
import 'dart:ui' as ui;
import 'package:galaxy_bird/components/components.dart';
import 'package:flutter/material.dart';

const RAD = pi / 180;

class TestPainter extends CustomPainter {
  TestPainter({
    required this.sprite,
    required ValueNotifier<int> valueNotifier,
  }) : super(repaint: valueNotifier);

  Sprite sprite;
  int frame = 0;
  double dz = 0;
  bool roof = false;

  // @override
  // void paint(Canvas canvas, Size size) {
  //   // canvas.drawImage(
  //   //     this.sprites[this.frame], new ui.Offset(x, y), new ui.Paint());
  //   double width = this.sprite.width.toDouble();
  //   double height = this.sprite.height.toDouble();
  //   //canvas.save();
  //
  //   /// Add a translation to the current transform,
  //   /// shifting the coordinate space horizontally by the first argument
  //   /// and vertically by the second argument.
  //   canvas.translate(size.width / 2, size.height / 2);
  //
  //   double PI = pi;
  //   double alpha = RAD / 4;
  //
  //   /// The argument is in radians clockwise.
  //
  //   double speed = 0;
  //   double thrust = -3.6;
  //   double rotation = max(-25, -25 * speed / (-thrust));
  //   canvas.rotate(90 * pi / 180);
  //
  //   canvas.drawImage(this.sprite, new ui.Offset(0, 0), new ui.Paint());
  //   //canvas.restore();
  // }

  // @override
  // void paint(Canvas canvas, Size size) {
  //   double y = size.height - this.sprite.height;
  //   double width = size.width;
  //   double spiteW = this.sprite.width.toDouble();
  //   paintImage(
  //     canvas: canvas,
  //     rect: Rect.fromLTWH(
  //       -400,
  //       y,
  //       this.sprite.width.toDouble(),
  //       this.sprite.height.toDouble(),
  //     ),
  //     image: this.sprite,
  //     fit: BoxFit.fill,
  //   );
  // }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    frame++;
    if (dz >= (2 * sprite.width)) roof = true;
    if (dz <= 0) roof = false;
    roof ? dz-- : dz++;

    /// draw top crates
    double d = sqrt(2 * sprite.width * sprite.width);
    for (int i = 0; i < 3; i++) {
      final tCrate = Crate(sprite: sprite, quantity: 4);
      double temp = tCrate.x;
      double offset = size.width / 2 + (d * i);
      tCrate.x = offset;
      drawCrateTop(canvas, size, tCrate);

      double xBot = temp;
      double yBot = (tCrate.y + tCrate.height) + 200;
      final bCrate = Crate(sprite: sprite, quantity: 7)
        ..x = xBot + (d / 2) * i + (i > 0 ? dz : 0)
        ..y = yBot - (d / 2) * i + (i > 0 ? dz : 0);
      drawCrateBottom(canvas, size, bCrate);
    }
  }

  final rotation = 45 * RAD;

  void drawCrateTop(ui.Canvas canvas, ui.Size size, Crate crate) {
    double _x = crate.x;
    double _y = crate.y;
    double _dy = cos(rotation) * crate.width;
    canvas.save();
    canvas.translate(_x, _y - _dy);
    canvas.rotate(rotation);
    paintImage(
      canvas: canvas,
      rect: Rect.fromPoints(
        Offset(0, _y),
        Offset(
          0 + crate.width,
          _y + crate.height,
        ),
      ),
      alignment: Alignment.topCenter,
      image: crate.sprite.path.first,
      fit: BoxFit.scaleDown,
      repeat: ImageRepeat.repeatY,
    );
    canvas.restore();
  }

  void drawCrateBottom(ui.Canvas canvas, ui.Size size, Crate crate) {
    double _x = crate.x;
    double _y = crate.y;
    canvas.save();
    canvas.translate(_x, _y);
    canvas.rotate(-rotation);
    paintImage(
      canvas: canvas,
      rect: Rect.fromPoints(
        Offset(0, 0),
        Offset(
          0 + crate.width,
          0 + crate.height,
        ),
      ),
      alignment: Alignment.topCenter,
      image: crate.sprite.path.first,
      fit: BoxFit.scaleDown,
      repeat: ImageRepeat.repeatY,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
