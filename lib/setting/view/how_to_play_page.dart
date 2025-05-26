import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/widgets/custom_text.dart';

class HowToPlayPage extends StatelessWidget {
  static const routeName = "app/how-to-play";

  const HowToPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: CustomText('How To Play', fontSize: 30),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText('Controls', fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DSColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: DSColors.woodSmoke, width: 2),
              ),
              child: CustomText(
                'Tap the screen to make the character fly up. Release to let it fall down.',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            CustomText('Items', fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 12),
            _buildSpellGuide(
              'assets/images/objects/magnet.png',
              'Magnet',
              'Attracts nearby coins towards the character.',
            ),
            _buildSpellGuide(
              'assets/images/shield.png',
              'Shield',
              'Protects the character from one collision with obstacles.',
            ),
            _buildSpellGuide(
              'assets/images/bottle.png',
              'Power Potion',
              'Increases character size, making it easier to collect items.',
            ),
            _buildSpellGuide(
              'assets/images/ghost.png',
              'Ghost',
              'Transforms the character into a ghost, allowing it to pass through obstacles.',
            ),
            const SizedBox(height: 24),
            CustomText('Objective', fontSize: 24, fontWeight: FontWeight.bold),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: DSColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: DSColors.woodSmoke, width: 2),
              ),
              child: CustomText(
                'Collect as many coins as possible while avoiding obstacles. Use special items to achieve the highest score!',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSpellGuide(String imagePath, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DSColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DSColors.woodSmoke, width: 2),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 60, height: 60),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(title, fontSize: 20, fontWeight: FontWeight.bold),
                const SizedBox(height: 4),
                CustomText(description, fontSize: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
