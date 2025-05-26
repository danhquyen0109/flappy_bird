import 'dart:ui' as ui;

class Sprite {
  const Sprite({this.path = const [], this.delegateFrame = 0});

  final List<ui.Image> path;

  final int delegateFrame;

  int get width => path[delegateFrame].width;

  int get height => path[delegateFrame].height;

  int get length => path.length;

  Sprite copyWith({List<ui.Image>? path, int? delegateFrame}) {
    return Sprite(
      path: path ?? this.path,
      delegateFrame: delegateFrame ?? this.delegateFrame,
    );
  }

  static const empty = Sprite(path: [], delegateFrame: 0);
}
