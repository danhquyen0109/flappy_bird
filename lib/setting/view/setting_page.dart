
import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_page.dart';
import 'package:galaxy_bird/my_game/my_game.dart';
import 'package:galaxy_bird/setting/setting.dart';
import 'package:galaxy_bird/setting/view/how_to_play_page.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  static const routeName = "app/setting";

  const SettingPage({super.key, this.components});

  final List<Component>? components;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Background(),
          // _DialogBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              _PlayButton(),
              const SizedBox(height: 20),
              _ShopButton(),
              const SizedBox(height: 20),
              _ScoreButton(),
              const SizedBox(height: 20),
              _HowToPlayButton(),
              const SizedBox(height: 20),
              _PrivacyButton(),
              // if (Platform.isAndroid) ...[
              //   const SizedBox(height: 20),
              //   _ExitButton(),
              // ],
              const SizedBox(height: 25),
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      buildWhen: (pre, cur) => pre.currentMap != cur.currentMap,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage(state.currentMap.sprites.first),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class _PrivacyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainShadowButton(
      borderColor: DSColors.woodSmoke,
      color: DSColors.primaryColor,
      bodyBuilder: (isTapped) {
        return CustomText(
          "Privacy Policy",
          fontSize: isTapped ? 16 : 21,
          fontWeight: FontWeight.w800,
          strokeWidth: 1.0,
          textAlign: TextAlign.center,
        );
      },
      height: 65,
      size: 200,
      callback: () {
        context.read<SettingCubit>().playButtonSound();
        showDialog(
          context: context,
          builder:
              (_) => CustomDialog(
                showSecondaryButton: false,
                showPrimaryButton: true,
                primaryText: "OK",
                primaryButtonPressed: () => Navigator.pop(context),
                bodyMarginBottom: 100,
                showTitle: true,
                showCloseButton: false,
                title: 'Privacy Policy',
                bodyWidget: PrivacyWidget(),
              ),
        );
      },
      shadowColor: DSColors.woodSmoke,
    );
  }
}

class _HowToPlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainShadowButton(
      borderColor: DSColors.woodSmoke,
      color: DSColors.primaryColor,
      bodyBuilder: (isTapped) {
        return CustomText(
          "HOW TO PLAY",
          fontSize: isTapped ? 16 : 21,
          fontWeight: FontWeight.w800,
          strokeWidth: 1.0,
        );
      },
      height: 65,
      size: 200,
      callback: () {
        context.read<SettingCubit>().playButtonSound();
        Navigator.of(context).pushNamed(HowToPlayPage.routeName);
      },
      shadowColor: DSColors.woodSmoke,
    );
  }
}

class _ShopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainShadowButton(
      borderColor: DSColors.woodSmoke,
      color: DSColors.primaryColor,
      bodyBuilder: (isTapped) {
        return CustomText(
          "Shop",
          fontSize: isTapped ? 16 : 21,
          fontWeight: FontWeight.w800,
          strokeWidth: 1.0,
        );
      },
      height: 65,
      size: 200,
      callback: () {
        context.read<SettingCubit>().playButtonSound();
        Navigator.of(context).pushNamed(ShopPage.routeName);
      },
      shadowColor: DSColors.woodSmoke,
    );
  }
}

class _PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainShadowButton(
      borderColor: DSColors.woodSmoke,
      color: DSColors.primaryColor,
      bodyBuilder: (isTapped) {
        return CustomText(
          "New Game",
          fontSize: isTapped ? 16 : 21,
          fontWeight: FontWeight.w800,
          strokeWidth: 1.0,
        );
      },
      height: 65,
      size: 200,
      callback: () {
        final settingCubit = context.read<SettingCubit>();
        final gameCubit = context.read<MyGameCubit>();
        settingCubit.playButtonSound();
        gameCubit.getTurn();
        Navigator.of(context).pushNamed(
          GamePage.routeName,
          arguments: settingCubit.state.components,
        );
      },
      shadowColor: DSColors.woodSmoke,
    );
  }
}

class _ScoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainShadowButton(
      borderColor: DSColors.woodSmoke,
      color: DSColors.primaryColor,
      bodyBuilder: (isTapped) {
        return CustomText(
          "High Scores",
          fontSize: isTapped ? 16 : 21,
          fontWeight: FontWeight.w800,
          strokeWidth: 1.0,
        );
      },
      height: 65,
      size: 200,
      callback: () {
        context.read<SettingCubit>().playButtonSound();
        showDialog(
          context: context,
          builder:
              (_) => CustomDialog(
                height: MediaQuery.of(context).size.height / 1.5,
                showSecondaryButton: false,
                showPrimaryButton: true,
                primaryText: "OK",
                title: "High Scores",
                showTitle: true,
                showCloseButton: false,
                primaryButtonPressed: () => Navigator.pop(context),
                bodyMarginBottom: 100,
                bodyWidget: Leaderboard(),
              ),
        );
      },
      shadowColor: DSColors.woodSmoke,
    );
  }
}
