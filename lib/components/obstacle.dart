import 'dart:ui' as ui;
import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_manager.dart';

class Obstacle extends Component {
  Obstacle({required super.sprite});

  List<Obstacle> obstacles = [];

  @override
  void draw(ui.Canvas canvas, ui.Size size) {
    // TODO: implement draw
  }

  @override
  void update(GameManager gameManager, int frames) {
    // TODO: implement update
  }

  void reset() => obstacles.clear();

  bool get isEmpty => obstacles.isEmpty;

  bool get isNotEmpty => obstacles.isNotEmpty;

  @override
  double get height => throw UnimplementedError();

  @override
  double get width => throw UnimplementedError();
}
