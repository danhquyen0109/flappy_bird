import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy_bird/setting/cubit/purchase_cubit.dart';
import 'package:galaxy_bird/setting/cubit/purchase_state.dart';
import 'package:galaxy_bird/setting/cubit/setting_cubit.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/utils/game_utils.dart';
import 'package:galaxy_bird/widgets/custom_text.dart';
import 'package:galaxy_bird/widgets/plain_shadow_button.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseCoinPage extends StatelessWidget {
  static const routeName = "app/purchase_coins";

  const PurchaseCoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurchaseCubit, PurchaseState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(color: DSColors.primaryColor),
            ),
            backgroundColor: Colors.transparent,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            leading: CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                context.read<SettingCubit>().playButtonSound();
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
            title: CustomText('Purchase Coins', fontSize: 30),
            centerTitle: true,
            elevation: 0,
          ),
          body: BlocConsumer<PurchaseCubit, PurchaseState>(
            listener: (context, state) {
              if (state.status == AppPurchaseStatus.error &&
                  state.error != null) {
                GameUtils.showSnackBar(
                  context,
                  content: state.error ?? '',
                  type: SnackBarType.error,
                );
              } else if (state.status == AppPurchaseStatus.purchased) {
                GameUtils.showSnackBar(
                  context,
                  content: 'Purchase successful!',
                  type: SnackBarType.success,
                );
              }
            },
            builder: (context, state) {
              if (state.status == AppPurchaseStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == AppPurchaseStatus.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        state.error ?? 'An error occurred',
                        fontSize: 18,
                        color: DSColors.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      PlainShadowButton(
                        borderColor: DSColors.woodSmoke,
                        color: DSColors.primaryColor,
                        bodyBuilder: (isTapped) {
                          return CustomText(
                            'Retry',
                            fontSize: isTapped ? 16 : 21,
                            fontWeight: FontWeight.w800,
                            strokeWidth: 1.0,
                          );
                        },
                        height: 65,
                        size: 200,
                        callback: () {
                          context.read<SettingCubit>().playButtonSound();
                          context.read<PurchaseCubit>().loadProducts();
                        },
                        shadowColor: DSColors.woodSmoke,
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  padding: EdgeInsets.all(12.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: (1 / 1),
                  ),
                  controller: ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return _CoinPackage(
                      product: product,
                      onTap: () async {
                        await context.read<PurchaseCubit>().buyProduct(product);
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _CoinPackage extends StatelessWidget {
  const _CoinPackage({this.onTap, required this.product});

  final double width = 70;
  final void Function()? onTap;
  final ProductDetails product;

  @override
  Widget build(BuildContext context) {
    final coinAmount = switch (product.id) {
      'coin_pack_100' => '100',
      'coin_pack_250' => '250',
      'coin_pack_500' => '500',
      'coin_pack_1000' => '1,000',
      'coin_pack_2500' => '2,500',
      'coin_pack_5000' => '5,000',
      'coin_pack_10000' => '10,000',
      _ => '0',
    };
    double w = (MediaQuery.of(context).size.width - 48) / 2;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: w,
            height: w,
            decoration: ShapeDecoration(
              color: DSColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                side: BorderSide(color: DSColors.woodSmoke, width: 2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/objects/gold.png', height: 24),
                const SizedBox(width: 8),
                CustomText(coinAmount, fontSize: 20),
              ],
            ),
          ),
          Positioned(bottom: 0, child: selectButton),
        ],
      ),
    );
  }

  Widget get selectButton {
    return PlainShadowButton(
      borderColor: DSColors.woodSmoke,
      color: DSColors.lighteningYellow,
      bodyBuilder: (isTapped) {
        return CustomText(
          product.price,
          textAlign: TextAlign.center,
          fontSize: isTapped ? 12 : 16,
          fontWeight: FontWeight.bold,
        );
      },
      height: 40,
      size: 120,
      shadowColor: DSColors.athensGray,
      callback: () => onTap?.call(),
    );
  }
}
