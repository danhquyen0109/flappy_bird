
import 'package:equatable/equatable.dart';
import 'package:galaxy_bird/game_manager.dart';
import 'package:galaxy_bird/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'my_game_state.dart';

class MyGameCubit extends Cubit<MyGameState> with GameSound {
  MyGameCubit() : super(const MyGameState());

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bestScore = (prefs.getStringList(GameConstant.bestScore) ??
        [
          "0@@@@0",
          "0@@@@0",
          "0@@@@0",
          "0@@@@0",
          "0@@@@0",
          "0@@@@0",
          "0@@@@0",
          "0@@@@0",
          "0@@@@0",
          "0@@@@0",
        ]);
    emit(state.copyWith(bestScore: bestScore));
  }

  Future<void> getTurn() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool(GameConstant.isFirstTime) ?? true;
    await prefs.setBool(GameConstant.isFirstTime, false);
    emit(state.copyWith(
        gameState: isFirstTime ? GameState.firstTime : GameState.ready));
  }

  void start() => emit(
      state.copyWith(score: 0, fruit: 0, coin: 0, gameState: GameState.play));

  void updateReward({required RewardType rewardType}) {
    switch (rewardType) {
      case RewardType.score:
        emit(state.copyWith(score: state.score + 1));
        break;
      case RewardType.fruit:
        emit(state.copyWith(fruit: state.fruit + 1));
        break;
      case RewardType.coin:
        emit(state.copyWith(coin: state.coin + 1));
        break;
    }
  }

  Future<void> gameOver() async {
    emit(state.copyWith(
      gameState: GameState.gameOver,
      bestScore: state.bestScore,
    ));
  }

  Future<void> saveScore(String username) async {
    final prefs = await SharedPreferences.getInstance();
    state.bestScore.sort((a, b) {
      int aT = int.parse(a.split("@@@@")[1]);
      int bT = int.parse(b.split("@@@@")[1]);
      if (aT < bT) {
        return -1;
      } else if (aT > bT) {
        return 1;
      } else {
        return 0;
      }
    });
    for (int i = 0; i < state.bestScore.length; i++) {
      int best = int.parse(state.bestScore[i].split("@@@@")[1]);
      if (state.score > best) {
        state.bestScore[i] = '$username@@@@${state.score}';
        await prefs.setStringList(GameConstant.bestScore,
            state.bestScore.map((i) => i.toString()).toList());
        break;
      }
    }
  }

  void playButtonSound() => playSound(path: 'select');
}
