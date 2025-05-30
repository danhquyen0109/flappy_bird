import 'dart:ui';

import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_manager.dart';

enum ItemType {
  unknown,
  free,
  needWatchAd,
  needShareSocial,
  needBuyByCoin,
  needBuyByFruit,
}

abstract class Item extends Component {
  Item({
    required super.sprite,
    required this.effect,
    super.x,
    super.y,
    this.iat = 0,
    this.netWorth = 0,
    this.isCollected = false,
  });

  List<Image> effect;

  int iat;

  int netWorth;

  bool isCollected;

  @override
  void draw(Canvas canvas, Size size);

  @override
  void update(GameManager gameManager, int frames);

  void setCollect();

  bool get isExpired => iat < 0;

  Item copyWith({
    Sprite? sprite,
    List<Image>? effect,
    double? x,
    double? y,
    int? iat,
    int? netWorth,
    bool? isCollected,
  });
}

extension ExtensionItem on Item {
  bool get isSpell =>
      this is Magnet || this is BottlePotion || this is Shield || this is Ghost;

  bool get isFruit {
    if (this is Magnet) return false;
    if (this is BottlePotion) return false;
    if (this is Gold) return false;
    return true;
  }
}
