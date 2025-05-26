import 'package:galaxy_bird/game_page.dart';
import 'package:galaxy_bird/setting/setting.dart';
import 'package:galaxy_bird/setting/view/how_to_play_page.dart';
import 'package:galaxy_bird/setting/view/purchase_coin_page.dart';
import 'package:galaxy_bird/setting/view/upgrade_item_page.dart';
import 'package:galaxy_bird/splash_screen.dart';
import 'package:flutter/material.dart';

typedef CustomWidgetBuilder = Widget Function(
    BuildContext context, dynamic value);

final gameRoutes = <String, CustomWidgetBuilder>{
  SplashScreen.routeName: (_, components) => SplashScreen(),
  SettingPage.routeName: (_, components) => SettingPage(components: components),
  GamePage.routeName: (_, components) => GamePage(components: components),
  // BirdSelector.routeName: (_, components) => BirdSelector(),
  // MapSelector.routeName: (_, components) => MapSelector(),
  BirdShop.routeName: (_, components) => BirdShop(),
  MapShop.routeName: (_, components) => MapShop(),
  ShopPage.routeName: (_, components) => ShopPage(),
  HowToPlayPage.routeName: (_, components) => HowToPlayPage(),
  PurchaseCoinPage.routeName: (_, components) => PurchaseCoinPage(),
  UpgradeItemPage.routeName: (_, components) => UpgradeItemPage(),
};
