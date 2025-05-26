import 'dart:math';
import 'dart:ui' as ui;
import 'package:equatable/equatable.dart';
import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galaxy_bird/game_manager.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> with GameSound {
  SettingCubit() : super(const SettingState());

  // late RewardedAd _rewardedAd;
  // late InterstitialAd _interstitialAd;

  void initSetting() async {
    emit(state.copyWith(status: SettingStatus.initSetting));

    List<Component> components = await GameManager.initComponents();
    List<BirdModel> birds =
        GameConstant.birdSource.values
            .map((json) => BirdModel.fromJson(json))
            .toList();
    List<MapModel> maps =
        GameConstant.mapSource.values
            .map((json) => MapModel.fromJson(json))
            .toList();

    final prefs = await SharedPreferences.getInstance();

    /// Config bird
    List<BirdModel> myBirds = [];
    String myBirdsBinary = (prefs.getInt(GameConstant.myBirds) ?? 0)
        .toRadixString(2);

    for (int i = myBirdsBinary.length - 1; i >= 0; i--) {
      if (myBirdsBinary[i] == '1') {
        myBirds.add(birds[myBirdsBinary.length - 1 - i]);
      }
    }

    int curBird = prefs.getInt(GameConstant.currentBird) ?? -1;
    BirdModel currentBird =
        curBird == -1
            ? BirdModel.empty
            : BirdModel.fromJson(GameConstant.birdSource[curBird + 1]);
    if (myBirds.isEmpty ||
        !myBirds.any((element) => element.name == "Bashford")) {
      myBirds.add(BirdModel.empty);
    }
    await updateBirdSprites(currentBird, components);

    /// Config map
    List<MapModel> myMaps = [];
    String myMapsBinary = (prefs.getInt(GameConstant.myMaps) ?? 0)
        .toRadixString(2);

    for (int i = myMapsBinary.length - 1; i >= 0; i--) {
      if (myMapsBinary[i] == '1') {
        myMaps.add(maps[myMapsBinary.length - 1 - i]);
      }
    }

    int curMap = prefs.getInt(GameConstant.currentMap) ?? -1;
    MapModel currentMap =
        curMap == -1
            ? MapModel.empty
            : MapModel.fromJson(GameConstant.mapSource[curMap + 1]);
    if (myMaps.isEmpty ||
        !myMaps.any((element) => element.name == "The Sunset")) {
      myMaps.add(MapModel.empty);
    }

    await updateMapSprites(currentMap, components);

    int? coin = prefs.getInt(GameConstant.coin);
    int? fruit = prefs.getInt(GameConstant.fruit);

    emit(
      state.copyWith(
        components: components,
        birds: birds,
        myBirds: myBirds,
        maps: maps,
        myMaps: myMaps,
        currentBird: currentBird,
        currentMap: currentMap,
        coin: coin,
        fruit: fruit,
        status: SettingStatus.initSettingDone,
      ),
    );
  }

  Future<void> updateBirdSprites(
    BirdModel bird,
    List<Component> components,
  ) async {
    int bWN = 34;
    int bHN = bWN ~/ bird.spriteRatio;
    List<ui.Image> normalBird = [];

    int bWS = 20;
    int bHS = bWS ~/ bird.spriteRatio;
    List<ui.Image> smallBird = [];
    for (String sprite in bird.sprites) {
      normalBird.add(await GameUtils.loadImageFitSize(sprite, bWN, bHN));
      smallBird.add(await GameUtils.loadImageFitSize(sprite, bWS, bHS));
    }
    (components[4] as Bird).sprites = [
      Sprite(path: normalBird),
      Sprite(path: smallBird),
    ];
  }

  Future<void> updateMapSprites(
    MapModel map,
    List<Component> components,
  ) async {
    ui.Image bgSprite = await GameUtils.loadImage(map.sprites.first);
    (components[0] as Background).sprite = Sprite(path: [bgSprite]);
    ui.Image crateSprite = await GameUtils.loadImage(map.crateImage);
    (components[1] as Crate).sprite = Sprite(path: [crateSprite]);
    ui.Image gndSprite = await GameUtils.loadImage(map.groundImage);
    (components[2] as Ground).sprite = Sprite(path: [gndSprite]);
  }

  Future<void> birdChanged({
    required BirdModel bird,
    required int index,
    Function? onSuccess,
    Function(SettingStatus status)? onFailure,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (state.myBirds.contains(bird)) {
      updateBirdSprites(bird, state.components);
      await prefs.setInt(GameConstant.currentBird, index);
      emit(state.copyWith(currentBird: bird));
      playSound(path: 'bird_collect');
    } else if (bird.type == ItemType.needBuyByCoin && state.coin >= bird.cost) {
      int myBirdsMemory = prefs.getInt(GameConstant.myBirds) ?? 0;
      myBirdsMemory += pow(2, index).toInt();
      await prefs.setInt(GameConstant.myBirds, myBirdsMemory);
      await prefs.setInt(GameConstant.coin, state.coin - bird.cost);
      List<BirdModel> myBirds = [...state.myBirds];
      myBirds.add(bird);
      emit(state.copyWith(coin: state.coin - bird.cost, myBirds: myBirds));
      playSound(path: 'unlock');
      onSuccess?.call();
    } else if (bird.type == ItemType.needBuyByCoin && state.coin < bird.cost) {
      onFailure?.call(SettingStatus.needMoreCoin);
    } else if (bird.type == ItemType.needBuyByFruit &&
        state.fruit >= bird.cost) {
      int myBirdsMemory = prefs.getInt(GameConstant.myBirds) ?? 0;
      myBirdsMemory += pow(2, index).toInt();
      await prefs.setInt(GameConstant.myBirds, myBirdsMemory);
      await prefs.setInt(GameConstant.fruit, state.fruit - bird.cost);
      List<BirdModel> myBirds = [...state.myBirds];
      myBirds.add(bird);
      emit(state.copyWith(fruit: state.fruit - bird.cost, myBirds: myBirds));
      playSound(path: 'unlock');
      onSuccess?.call();
    } else if (bird.type == ItemType.needBuyByFruit &&
        state.fruit < bird.cost) {
      onFailure?.call(SettingStatus.needMoreFruit);
    } else {
      onFailure?.call(SettingStatus.unknown);
    }
  }

  Future<void> unlockBird({
    required BirdModel bird,
    required int index,
    Function? onSuccess,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    int myBirdsMemory = prefs.getInt(GameConstant.myBirds) ?? 0;
    myBirdsMemory += pow(2, index).toInt();
    await prefs.setInt(GameConstant.myBirds, myBirdsMemory);
    List<BirdModel> myBirds = [...state.myBirds];
    myBirds.add(bird);
    emit(state.copyWith(myBirds: myBirds));
    playSound(path: 'unlock');
    onSuccess?.call();
  }

  Future<void> getReward({
    Function? onSuccess,
    int value = 20,
    bool isCoin = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    int availableValue =
        prefs.getInt(isCoin ? GameConstant.coin : GameConstant.fruit) ?? 0;
    await prefs.setInt(
      isCoin ? GameConstant.coin : GameConstant.fruit,
      availableValue + value,
    );
    if (isCoin) {
      emit(state.copyWith(coin: availableValue + value));
    } else {
      emit(state.copyWith(fruit: availableValue + value));
    }
    playSound(path: 'unlock');
    onSuccess?.call();
  }

  Future<void> mapChanged({
    required MapModel map,
    required int index,
    Function? onSuccess,
    Function(SettingStatus status)? onFailure,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (state.myMaps.contains(map)) {
      updateMapSprites(map, state.components);
      await prefs.setInt(GameConstant.currentMap, index);
      emit(state.copyWith(currentMap: map));
      playSound(path: 'bird_collect');
    } else if (map.type == ItemType.needBuyByCoin && state.coin >= map.cost) {
      int myMapsMemory = prefs.getInt(GameConstant.myMaps) ?? 0;
      myMapsMemory += pow(2, index).toInt();
      await prefs.setInt(GameConstant.myMaps, myMapsMemory);
      await prefs.setInt(GameConstant.coin, state.coin - map.cost);
      List<MapModel> myMaps = [...state.myMaps];
      myMaps.add(map);
      emit(state.copyWith(coin: state.coin - map.cost, myMaps: myMaps));
      playSound(path: 'unlock');
      onSuccess?.call();
    } else if (map.type == ItemType.needBuyByCoin && state.coin < map.cost) {
      onFailure?.call(SettingStatus.needMoreCoin);
    } else if (map.type == ItemType.needBuyByFruit && state.fruit >= map.cost) {
      int myMapsMemory = prefs.getInt(GameConstant.myMaps) ?? 0;
      myMapsMemory += pow(2, index).toInt();
      await prefs.setInt(GameConstant.myMaps, myMapsMemory);
      await prefs.setInt(GameConstant.fruit, state.fruit - map.cost);
      List<MapModel> myMaps = [...state.myMaps];
      myMaps.add(map);
      emit(state.copyWith(fruit: state.fruit - map.cost, myMaps: myMaps));
      playSound(path: 'unlock');
      onSuccess?.call();
    } else if (map.type == ItemType.needBuyByFruit && state.fruit < map.cost) {
      onFailure?.call(SettingStatus.needMoreFruit);
    } else {
      onFailure?.call(SettingStatus.unknown);
    }
  }

  Future<void> unlockMap({
    required MapModel map,
    required int index,
    Function? onSuccess,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    int myMapsMemory = prefs.getInt(GameConstant.myMaps) ?? 0;
    myMapsMemory += pow(2, index).toInt();
    await prefs.setInt(GameConstant.myMaps, myMapsMemory);
    List<MapModel> myMaps = [...state.myMaps];
    myMaps.add(map);
    emit(state.copyWith(myMaps: myMaps));
    playSound(path: 'unlock');
    onSuccess?.call();
  }

  void playButtonSound() => playSound(path: 'select');

  Future<void> updateCoinAndFruit({int coin = 0, int fruit = 0}) async {
    if (coin + fruit == 0) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(GameConstant.coin, state.coin + coin);
    await prefs.setInt(GameConstant.fruit, state.fruit + fruit);
    emit(state.copyWith(coin: state.coin + coin, fruit: state.fruit + fruit));
  }
}
