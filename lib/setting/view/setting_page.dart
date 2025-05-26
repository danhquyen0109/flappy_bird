import 'dart:io';
import 'dart:ui';

import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_page.dart';
import 'package:galaxy_bird/my_game/my_game.dart';
import 'package:galaxy_bird/setting/setting.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          _Background(),
          _DialogBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              _ShopButton(),
              const SizedBox(height: 20),
              _PlayButton(),
              const SizedBox(height: 20),
              _ScoreButton(),
              const SizedBox(height: 20),
              _PrivacyButton(),
              if (Platform.isAndroid) ...[
                const SizedBox(height: 20),
                _ExitButton(),
              ],
              const SizedBox(height: 25),
            ],
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
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

class _DialogBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1.5;
    double height = MediaQuery.of(context).size.height / 1.7;
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.all(24),
          padding: EdgeInsets.all(24),
          decoration: ShapeDecoration(
            shadows: [
              BoxShadow(color: DSColors.woodSmoke, offset: Offset(0, 6)),
            ],
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2, color: DSColors.woodSmoke),
              borderRadius: BorderRadius.circular(16),
            ),
            color: DSColors.primaryColor.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}

class _PrivacyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainShadowButton(
      borderColor: DSColors.woodSmoke,
      color: DSColors.lighteningYellow,
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
          builder: (_) => CustomDialog(
            showSecondaryButton: false,
            showPrimaryButton: true,
            primaryText: "OK",
            primaryButtonPressed: () => Navigator.pop(context),
            bodyMarginBottom: 100,
            bodyWidget: PrivacyWidget(),
          ),
        );
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
      color: DSColors.lighteningYellow,
      bodyBuilder: (isTapped) {
        return CustomText(
          "Store",
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
      color: DSColors.lighteningYellow,
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
      color: DSColors.lighteningYellow,
      bodyBuilder: (isTapped) {
        return CustomText(
          "Leaderboard",
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
          builder: (_) => CustomDialog(
            height: MediaQuery.of(context).size.height / 1.5,
            showSecondaryButton: false,
            showPrimaryButton: true,
            primaryText: "OK",
            title: "Leaderboard",
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

class _ExitButton extends StatelessWidget {
  const _ExitButton();

  final double height = 75;

  @override
  Widget build(BuildContext context) {
    return PlainShadowButton(
      borderColor: DSColors.woodSmoke,
      color: DSColors.lighteningYellow,
      bodyBuilder: (isTapped) {
        return CustomText(
          "Exit",
          fontSize: isTapped ? 16 : 21,
          fontWeight: FontWeight.w800,
          strokeWidth: 1.0,
        );
      },
      height: height,
      size: 200,
      callback: () {
        context.read<SettingCubit>().playButtonSound();
        showDialog(
          context: context,
          builder: (_) {
            double height = MediaQuery.of(context).size.height / 4;
            return CustomDialog(
              height: height,
              showCloseButton: false,
              showSecondaryButton: true,
              showPrimaryButton: true,
              secondaryText: "No",
              primaryText: "Yes",
              secondaryButtonPressed: () => Navigator.pop(context),
              primaryButtonPressed: () => SystemNavigator.pop(),
              bodyMargin: height / 2 - 16,
              bodyWidget: CustomText(
                'Do you want to exit?',
                fontSize: 18,
                strokeWidth: 0.15,
                color: DSColors.woodSmoke,
                borderColor: DSColors.white,
              ),
            );
          },
        );
      },
      shadowColor: DSColors.woodSmoke,
    );
  }
}
