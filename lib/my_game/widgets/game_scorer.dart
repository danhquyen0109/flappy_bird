import 'package:galaxy_bird/game_manager.dart';
import 'package:galaxy_bird/my_game/my_game.dart';
import 'package:galaxy_bird/setting/setting.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/widgets/widgets.dart';
import 'package:galaxy_bird/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScorer extends StatelessWidget {
  const GameScorer({super.key, this.onRestart, this.onPaused});

  final Function? onRestart;
  final Function(bool isPaused, VoidCallback onStart)? onPaused;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyGameCubit, MyGameState>(
      listenWhen: (pre, cur) => pre.gameState != cur.gameState,
      listener: (context, state) {
        if (state.gameState == GameState.firstTime) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => UserGuide(),
          );
        } else if (state.gameState == GameState.gameOver) {
          final TextEditingController textEditingController =
              TextEditingController();
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              double height = MediaQuery.of(context).size.height;
              return Center(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: height / 3,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Image.asset(
                              'assets/images/go.png',
                              fit: BoxFit.fill,
                              // color: DSColors.primary300,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Container(
                          //   width: 200,
                          //   height: 100,
                          //   decoration: BoxDecoration(
                          //     color: DSColors.primary300,
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(8.0),
                          //     ),
                          //   ),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       const SizedBox(width: 12),
                          //       SizedBox(
                          //         width: 35,
                          //         child: Image.asset(
                          //           'assets/images/reward.png',
                          //           fit: BoxFit.cover,
                          //         ),
                          //       ),
                          //       const SizedBox(width: 16),
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CustomText(
                          //             'SCORE  ${state.score}',
                          //             fontSize: 22,
                          //             strokeWidth: 1.0,
                          //           ),
                          //           const SizedBox(height: 4),
                          //           CustomText(
                          //             'BEST   ${state.best}',
                          //             fontSize: 22,
                          //             strokeWidth: 1.0,
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: height / 3 + 143 + 108,
                      child: PlainShadowButton(
                        borderColor: DSColors.woodSmoke,
                        color: DSColors.primary300,
                        bodyBuilder: (isTapped) {
                          return CustomText(
                            "SAVE SCORE",
                            fontSize: isTapped ? 16 : 21,
                            fontWeight: FontWeight.w800,
                            strokeWidth: 1.0,
                          );
                        },
                        height: 60,
                        size: 200,
                        callback: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: CustomText(
                                  'YOUR NAME',
                                  fontSize: 18,
                                  strokeWidth: 1.0,
                                ),
                                content: TextField(
                                  controller: textEditingController,
                                  style: TextStyle(fontFamily: "Chainwhacks"),
                                  decoration: InputDecoration(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: CustomText(
                                      'CANCEL',
                                      fontSize: 16,
                                      strokeWidth: 1.0,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (textEditingController.text
                                          .trim()
                                          .isEmpty) {
                                        GameUtils.showSnackBar(
                                          context,
                                          content:
                                              "Your name is not allow to empty",
                                        );
                                      } else {
                                        context.read<MyGameCubit>().saveScore(
                                          textEditingController.text,
                                        );
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: CustomText(
                                      'OK',
                                      fontSize: 16,
                                      strokeWidth: 1.0,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        shadowColor: DSColors.woodSmoke,
                      ),
                    ),
                    Positioned(
                      top: height / 3 + 143 + 108 + 68,
                      child: PlainShadowButton(
                        borderColor: DSColors.woodSmoke,
                        color: DSColors.primary300,
                        bodyBuilder: (isTapped) {
                          return CustomText(
                            "Try Again",
                            fontSize: isTapped ? 16 : 21,
                            fontWeight: FontWeight.w800,
                            strokeWidth: 1.0,
                          );
                        },
                        height: 60,
                        size: 200,
                        callback: () {
                          Navigator.pop(context);
                          onRestart?.call();
                        },
                        shadowColor: DSColors.woodSmoke,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              context.read<MyGameCubit>().playButtonSound();
              Navigator.of(context).pop();
            },
            child: Icon(
              const IconData(
                0xf3cf,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage,
              ),
              size: 30,
            ),
          ),
          Spacer(),
          _ScoreBuilder(),
          // Image.asset(
          //   'assets/images/objects/fruit.png',
          //   fit: BoxFit.cover,
          //   height: 30,
          // ),
          // const SizedBox(width: 8),
          // _FruitBuilder(),
          // const SizedBox(width: 20),
          // Image.asset(
          //   'assets/images/objects/gold.png',
          //   fit: BoxFit.cover,
          //   height: 30,
          // ),
          // const SizedBox(width: 8),
          // _CoinBuilder(),
          Spacer(),
          PauseButton(onPaused: onPaused),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _ScoreBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyGameCubit, MyGameState>(
      buildWhen: (pre, cur) => pre.score != cur.score,
      builder: (context, state) {
        return CustomText(
          'Score: ${state.score}',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          strokeWidth: 0.75,
        );
      },
    );
  }
}

class _FruitBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyGameCubit, MyGameState>(
      buildWhen: (pre, cur) => pre.fruit != cur.fruit,
      builder: (context, state) {
        return CustomText(
          'x${state.fruit}',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          strokeWidth: 0.75,
        );
      },
    );
  }
}

class _CoinBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyGameCubit, MyGameState>(
      buildWhen: (pre, cur) => pre.coin != cur.coin,
      builder: (context, state) {
        return CustomText(
          '${state.coin}',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          strokeWidth: 0.75,
        );
      },
    );
  }
}
