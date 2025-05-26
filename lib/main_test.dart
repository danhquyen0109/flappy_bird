import 'dart:async';
import 'dart:ui' as ui;
import 'package:galaxy_bird/utils/game_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ui.Image _sprite =
      await GameUtils.loadImage("assets/images/objects/crate1.png");
  runApp(FlipFlop(sprite: _sprite));
}

class FlipFlop extends StatelessWidget {
  FlipFlop({Key? key, required this.sprite}) : super(key: key);

  final ui.Image sprite;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      home: MyGamePage(sprite: sprite),
    );
  }
}

class MyGamePage extends StatefulWidget {
  MyGamePage({Key? key, required this.sprite}) : super(key: key);

  final ui.Image sprite;

  @override
  _MyGamePageState createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage>
    with SingleTickerProviderStateMixin {
  /// FPS
  int _frames = 0;
  late final Ticker _ticker;
  ValueNotifier<int> _frameNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _initAssets();
  }

  Future<void> _initAssets() async {
    _ticker = this.createTicker((elapsed) {
      _frames++;
      _frameNotifier.value = _frames;
    });
    _ticker.start();
  }

  // @override
  // Widget build(BuildContext context) {
  //   final appBar = AppBar(title: Text(""));
  //   return Scaffold(
  //     appBar: appBar,
  //     body: Container(
  //       decoration: BoxDecoration(
  //         color: const Color(0x30c0df),
  //         border: Border.all(
  //           color: Colors.black,
  //           width: 2,
  //         ),
  //       ),
  //       width: MediaQuery.of(context).size.width,
  //       height:
  //           MediaQuery.of(context).size.height - appBar.preferredSize.height,
  //       child: CustomPaint(
  //         painter: TestPainter(
  //           sprite: Sprite(path: [widget.sprite]),
  //           valueNotifier: _frameNotifier,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: Text(""));
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Positioned(
              //   right: 2.5,
              //   child: TriangleAnimatedButton(
              //     color: Colors.white,
              //     width: width,
              //     height: height,
              //     key: Key('123'),
              //     shape: TriangleShape.bottomHalfSquare,
              //     onTap: () {
              //       print('bottomHalfSquare');
              //     },
              //     animatedProgress:
              //         width + height + sqrt(width * width + height * height),
              //     path: TriangleShape.bottomHalfSquare.path(width, height),
              //     child: Container(
              //       decoration: BoxDecoration(
              //         image: DecorationImage(
              //           image: AssetImage(
              //               "assets/images/background/graveyardBg.png"),
              //           fit: BoxFit.fill,
              //         ),
              //         color: Colors.red,
              //         borderRadius: BorderRadius.all(Radius.circular(4.0)),
              //       ),
              //       width: width,
              //       height: height,
              //       child: Center(
              //         child: Container(
              //           margin: EdgeInsets.only(right: width / 2),
              //           child: Text('Map', style: buttonFont),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              ///
              // Positioned(
              //   left: 2.5,
              //   child: TriangleAnimatedButton(
              //     color: Colors.yellow,
              //     width: width,
              //     height: height,
              //     shape: TriangleShape.upperHalfSquare,
              //     onTap: () {
              //       print('upperHalfSquare');
              //     },
              //     animatedProgress:
              //         width + height + sqrt(width * width + height * height),
              //     path: TriangleShape.upperHalfSquare.path(width, height),
              //     child: Container(
              //       decoration: BoxDecoration(
              //         image: DecorationImage(
              //           image:
              //               AssetImage("assets/images/background/springBg.png"),
              //           fit: BoxFit.fill,
              //         ),
              //         color: Colors.green,
              //         borderRadius: BorderRadius.all(Radius.circular(4.0)),
              //       ),
              //       width: width,
              //       height: height,
              //       child: Center(
              //         child: Container(
              //           margin: EdgeInsets.only(left: width / 2),
              //           child: Text('Bird', style: buttonFont),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
