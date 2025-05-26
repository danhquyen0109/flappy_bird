import 'package:galaxy_bird/components/custom_button.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/utils/utils.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coin Purchase Section
            _buildSectionTitle('Purchase Coins'),
            const SizedBox(height: 16),
            _buildCoinPackages(context),
            const SizedBox(height: 32),

            // Characters Section
            _buildSectionTitle('Characters'),
            const SizedBox(height: 16),
            _buildCharacterGrid(context),
            const SizedBox(height: 32),

            // Maps Section
            _buildSectionTitle('Maps'),
            const SizedBox(height: 16),
            _buildMapGrid(context),
            const SizedBox(height: 32),

            // Spell Upgrades Section
            _buildSectionTitle('Spell Upgrades'),
            const SizedBox(height: 16),
            _buildSpellUpgrades(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return CustomText(
      title,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: DSColors.woodSmoke,
    );
  }

  Widget _buildCoinPackages(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildCoinPackage(context, '1000', '\$0.99'),
        _buildCoinPackage(context, '2500', '\$1.99'),
        _buildCoinPackage(context, '5000', '\$3.99'),
        _buildCoinPackage(context, '10000', '\$7.99'),
      ],
    );
  }

  Widget _buildCoinPackage(BuildContext context, String coins, String price) {
    return Container(
      decoration: BoxDecoration(
        color: DSColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DSColors.woodSmoke, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handlePurchase(context, coins, price),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/objects/gold.png', height: 24),
                  const SizedBox(width: 8),
                  CustomText(coins, fontSize: 20),
                ],
              ),
              const SizedBox(height: 8),
              CustomText(price, fontSize: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: List.generate(
        6,
        (index) => _buildCharacterItem(context, index),
      ),
    );
  }

  Widget _buildCharacterItem(BuildContext context, int index) {
    bool isLocked = index > 0;
    return Container(
      decoration: BoxDecoration(
        color: DSColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DSColors.woodSmoke, width: 2),
      ),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/birds/bird_${index + 1}.png',
              height: 60,
            ),
          ),
          if (isLocked)
            Positioned(
              right: 8,
              bottom: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/objects/gold.png', height: 16),
                  const SizedBox(width: 4),
                  CustomText('1000', fontSize: 14),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMapItem(
          context,
          'Spring',
          'assets/images/background/springBg.png',
          false,
        ),
        _buildMapItem(
          context,
          'Desert',
          'assets/images/background/desertBg.png',
          true,
        ),
        _buildMapItem(
          context,
          'Night',
          'assets/images/background/nightBg.png',
          true,
        ),
        _buildMapItem(
          context,
          'Graveyard',
          'assets/images/background/graveyardBg.png',
          true,
        ),
      ],
    );
  }

  Widget _buildMapItem(
    BuildContext context,
    String name,
    String imagePath,
    bool isLocked,
  ) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          opacity: isLocked ? 0.5 : 1.0,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DSColors.woodSmoke, width: 2),
      ),
      child: Stack(
        children: [
          Center(
            child: CustomText(
              name,
              fontSize: 24,
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
          if (isLocked)
            Positioned(
              right: 8,
              bottom: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/objects/gold.png', height: 20),
                  const SizedBox(width: 4),
                  CustomText('2000', fontSize: 16, color: Colors.white),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpellUpgrades(BuildContext context) {
    return Column(
      children: [
        _buildSpellUpgradeItem(
          context,
          'Magnet',
          'assets/images/objects/magnet.png',
          'Increase attraction range',
          3,
        ),
        const SizedBox(height: 16),
        _buildSpellUpgradeItem(
          context,
          'Shield',
          'assets/images/shield.png',
          'Increase duration',
          3,
        ),
        const SizedBox(height: 16),
        _buildSpellUpgradeItem(
          context,
          'Power Potion',
          'assets/images/bottle.png',
          'Increase size boost',
          3,
        ),
        const SizedBox(height: 16),
        _buildSpellUpgradeItem(
          context,
          'Ghost',
          'assets/images/ghost.png',
          'Increase duration',
          3,
        ),
      ],
    );
  }

  Widget _buildSpellUpgradeItem(
    BuildContext context,
    String name,
    String imagePath,
    String description,
    int maxLevel,
  ) {
    int currentLevel = 1;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DSColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DSColors.woodSmoke, width: 2),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, height: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(name, fontSize: 18, fontWeight: FontWeight.bold),
                const SizedBox(height: 4),
                CustomText(description, fontSize: 14),
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
    );
  }

  void _handlePurchase(BuildContext context, String coins, String price) {
    // Implement purchase logic here
    context.read<SettingCubit>().playSound(path: 'select');
  }
}
