import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/game_manager.dart';
import 'package:galaxy_bird/setting/cubit/setting_cubit.dart';
import 'package:galaxy_bird/setting/widgets/shop_app_bar_widget.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/widgets/custom_text.dart';

class UpgradeItemPage extends StatelessWidget {
  static const routeName = "app/upgrade-item";

  const UpgradeItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final item = GameManager.gameItems;
    return Scaffold(
      appBar: shopAppBarWidget(context, title: 'Upgrade'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children:
              item
                  .where((ele) => ele.isSpell)
                  .map((e) => _buildSpellUpgradeItem(context, e, 5))
                  .toList(),
        ),
      ),
    );
  }

  String _description(Item item) {
    if (item is Magnet) {
      return 'Increase attraction range';
    } else if (item is Shield) {
      return 'Increase duration';
    } else if (item is BottlePotion) {
      return 'Increase size boost';
    } else if (item is Ghost) {
      return 'Increase duration';
    }
    return '';
  }

  String _itemName(Item item) {
    if (item is Magnet) {
      return 'Magnet';
    } else if (item is Shield) {
      return 'Shield';
    } else if (item is BottlePotion) {
      return 'Power Potion';
    } else if (item is Ghost) {
      return 'Ghost';
    }
    return '';
  }

  String _itemPath(Item item) {
    if (item is Magnet) {
      return 'assets/images/objects/magnet.png';
    } else if (item is Shield) {
      return 'assets/images/shield.png';
    } else if (item is BottlePotion) {
      return 'assets/images/bottle.png';
    } else if (item is Ghost) {
      return 'assets/images/ghost.png';
    }
    return '';
  }

  Widget _buildSpellUpgradeItem(BuildContext context, Item item, int maxLevel) {
    int currentLevel = 1;
    return InkWell(
      onTap: () {
        context.read<SettingCubit>().playButtonSound();
        final coins = context.read<SettingCubit>().state.coin;
        if (coins >= 500 * currentLevel) {
          context.read<SettingCubit>().updateCoinAndFruit(
            coin: coins - 500 * currentLevel,
          );
          currentLevel++;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: DSColors.primaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: DSColors.woodSmoke, width: 2),
        ),
        child: Row(
          children: [
            Image.asset(_itemPath(item), height: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    _itemName(item),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  CustomText(_description(item), fontSize: 14),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(
                        maxLevel,
                        (index) => Container(
                          width: 20,
                          height: 8,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color:
                                index < currentLevel
                                    ? DSColors.woodSmoke
                                    : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (currentLevel < maxLevel)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/objects/gold.png', height: 20),
                  const SizedBox(width: 4),
                  CustomText('${500 * currentLevel}', fontSize: 16),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
