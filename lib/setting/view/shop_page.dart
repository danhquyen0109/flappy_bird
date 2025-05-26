import 'package:galaxy_bird/setting/view/purchase_coin_page.dart';
import 'package:galaxy_bird/setting/view/upgrade_item_page.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_bird/setting/setting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopPage extends StatelessWidget {
  static const routeName = "app/shop";

  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = shopAppBarWidget(context);
    return Stack(
      children: [
        const Background(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CustomButton(
                  title: 'Purchase Coins',
                  onTap: () {
                    Navigator.of(context).pushNamed(PurchaseCoinPage.routeName);
                  },
                ),
                const SizedBox(height: 20),
                _CustomButton(
                  title: 'Characters',
                  onTap: () {
                    Navigator.of(context).pushNamed(BirdShop.routeName);
                  },
                ),
                const SizedBox(height: 20),
                _CustomButton(
                  title: 'Maps',
                  onTap: () {
                    Navigator.of(context).pushNamed(MapShop.routeName);
                  },
                ),
                const SizedBox(height: 20),
                _CustomButton(
                  title: 'Upgrade Items',
                  onTap: () {
                    Navigator.of(context).pushNamed(UpgradeItemPage.routeName);
                  },
                ),
                // const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomButton extends StatelessWidget {
  final String title;
  final Function()? onTap;

  const _CustomButton({required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return PlainShadowButton(
      borderColor: DSColors.woodSmoke,
      color: DSColors.primaryColor,
      bodyBuilder: (isTapped) {
        return CustomText(
          title,
          fontSize: isTapped ? 16 : 21,
          fontWeight: FontWeight.w800,
          strokeWidth: 1.0,
        );
      },
      height: 65,
      size: 200,
      callback: () {
        context.read<SettingCubit>().playButtonSound();
        // Navigator.of(context).pushNamed(PurchaseCoinPage.routeName);
        onTap?.call();
      },
      shadowColor: DSColors.woodSmoke,
    );
  }
}
