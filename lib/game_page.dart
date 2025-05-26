import 'dart:async';
import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_painter.dart';
import 'package:galaxy_bird/main.dart';
import 'package:galaxy_bird/my_game/my_game.dart';
// import 'package:galaxy_bird/utils/utils.dart';
import 'package:galaxy_bird/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:galaxy_bird/setting/setting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_manager.dart';

class GamePage extends StatefulWidget {
  static const routeName = "app/game";

  const GamePage({super.key, required this.components});

  final List<Component> components;

  @override
  // ignore: library_private_types_in_public_api
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin
    implements GameManager {
  /// FPS
  int _frames = 0;
  bool _isInitial = false;
  bool _isPipeRemoved = true;
  bool _isPlayed = false;
  double canvasWidth = 0;
  double canvasHeight = 0;

  late final Ticker _ticker;
  late GameState _gameState;

  // late BannerAd myBanner;

  late Widget gameScorer;

  ValueNotifier<int> frameNotifier = ValueNotifier(0);
  ValueNotifier<int> scoreNotifier = ValueNotifier(0);

  late MyGameCubit _myGameCubit;
  late SettingCubit _settingCubit;

  @override
  void initState() {
    super.initState();
    _myGameCubit = context.read<MyGameCubit>();
    _settingCubit = context.read<SettingCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initAssets();
  }

  Future<bool> _initAssets() async {
    if (_isInitial) return true;
    _initGame();
    gameScorer = GameScorer(
      onRestart: _initGame,
      onPaused: (isPaused, onStart) {
        if (isPaused) {
          _ticker.stop();
        } else {
          _ticker.start();
        }
      },
    );
    _ticker = createTicker((elapsed) {
      _frames++;
      for (var element in widget.components) {
        element.update(this, _frames);
      }
      frameNotifier.value = _frames;
    });
    _ticker.start();
    _gameState = GameState.ready;
    _isInitial = true;
    return _isInitial;
  }

  @override
  Widget build(BuildContext context) {
    // final AdWidget adWidget = AdWidget(ad: myBanner);
    final appBar = gameAppBar(context: context, title: gameScorer);

    canvasWidth = MediaQuery.of(context).size.width;
    canvasHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          FutureBuilder(
            future: _initAssets(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return GestureDetector(
                onTap: () {
                  switch (_gameState) {
                    case GameState.ready:
                      _gameState = GameState.play;
                      GetReady getReady = widget.components.last as GetReady;
                      getReady.shouldPaint = false;
                      _myGameCubit.start();
                      break;
                    case GameState.play:
                      Bird bird = widget.components[4] as Bird;
                      bird.flap();
                      break;
                    default:
                      break;
                  }
                },
                child: SizedBox(
                  width: canvasWidth,
                  height: canvasHeight,
                  child: CustomPaint(
                    painter: GamePainter(
                      components: widget.components,
                      valueNotifier: frameNotifier,
                    ),
                  ),
                ),
              );
            },
          ),
          // Uncomment to show ads
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: SizedBox(
          //     child: adWidget,
          //     width: myBanner.size.width.toDouble(),
          //     height: myBanner.size.height.toDouble(),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _initGame() {
    gameTurn++;
    _gameState = GameState.ready;
    GetReady getReady = widget.components.last as GetReady;
    getReady.shouldPaint = true;
    Bird bird = widget.components[4] as Bird;
    bird.reset();
    Board board = widget.components[3] as Board;
    board.reset();
    Obstacle obstacle = widget.components[1] as Obstacle;
    obstacle.reset();
    _frames = 0;
    _isPlayed = false;
  }

  @override
  void dispose() {
    _ticker.dispose();
    // myBanner.dispose();
    super.dispose();
  }

  @override
  void gameOver() {
    _gameState = GameState.gameOver;
    _myGameCubit.gameOver();
    _settingCubit.updateCoinAndFruit(
      coin: _myGameCubit.state.coin,
      fruit: _myGameCubit.state.fruit,
    );
  }

  @override
  void gameReady() => _gameState = GameState.ready;

  @override
  GameState getGameState() => _gameState;

  @override
  Size getScreenSize() => Size(canvasWidth, canvasHeight);

  @override
  Component getGround() => widget.components[2] as Ground;

  @override
  Component getObstacle() => widget.components[1] as Obstacle;

  @override
  int readScore() => _myGameCubit.state.score;

  @override
  void writeScore(RewardType rewardType) =>
      _myGameCubit.updateReward(rewardType: rewardType);

  @override
  void setPipeStatus(bool status) => _isPipeRemoved = status;

  @override
  bool isPipeRemoved() => _isPipeRemoved;

  @override
  bool isPlayed() => _isPlayed;

  @override
  void setPlayed(bool status) => _isPlayed = status;

  @override
  List<Item> getAvailableItems() => (widget.components[3] as Board).items;
}
