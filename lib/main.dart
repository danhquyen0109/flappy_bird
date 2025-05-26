import 'dart:async';
import 'package:galaxy_bird/my_game/my_game.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_page.dart';
import 'package:galaxy_bird/setting/cubit/purchase_cubit.dart';
import 'package:galaxy_bird/setting/setting.dart';
import 'package:galaxy_bird/splash_screen.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'game_manager.dart';

late ui.Image fruitImg;

int gameTurn = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();

  // Initialize items used for birds to eat these items
  fruitImg = await GameUtils.loadImage("assets/images/objects/fruit.png");
  GameManager.gameItems = await GameManager.getGameItems();
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingCubit>(
          lazy: false,
          create: (_) => SettingCubit()..initSetting(),
        ),
        BlocProvider<MyGameCubit>(
          lazy: false,
          create: (_) => MyGameCubit()..init(),
        ),
        BlocProvider<PurchaseCubit>(
          create:
              (context) =>
                  PurchaseCubit(settingCubit: context.read<SettingCubit>()),
        ),
      ],
      child: FlipFlop(),
    );
  }
}

class FlipFlop extends StatefulWidget {
  const FlipFlop({super.key});

  @override
  State<FlipFlop> createState() => _FlipFlopState();
}

class _FlipFlopState extends State<FlipFlop> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: DSColors.primary500),
      initialRoute: SplashScreen.routeName,
      onGenerateRoute:
          (settings) => PageRouteBuilder(
            pageBuilder: (context, _, __) {
              if (settings.name == SettingPage.routeName ||
                  settings.name == GamePage.routeName) {
                final args = settings.arguments as List<Component>;
                return gameRoutes[settings.name]!(context, args);
              }
              return gameRoutes[settings.name]!(context, null);
            },
            settings: settings,
            transitionsBuilder:
                (_, anim, __, child) =>
                    FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          ),
    );
  }
}
