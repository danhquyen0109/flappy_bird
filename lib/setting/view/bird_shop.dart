import 'package:flutter/material.dart';
import 'package:galaxy_bird/setting/setting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/widgets/widgets.dart';

class BirdShop extends StatelessWidget {
  static const routeName = "app/bird_shop";

  const BirdShop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: shopAppBarWidget(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              BlocBuilder<SettingCubit, SettingState>(
                builder: (context, state) {
                  return GridView.builder(
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
                    itemCount: state.birds.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _BirdAvatar(
                        isSelected: state.currentBird == state.birds[index],
                        isBought: state.myBirds.contains(state.birds[index]),
                        onTap: () {
                          final settingCubit = context.read<SettingCubit>();
                          settingCubit.birdChanged(
                            bird: state.birds[index],
                            index: index,
                          );
                        },
                        birdModel: state.birds[index],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BirdAvatar extends StatelessWidget {
  const _BirdAvatar({
    this.width = 70,
    this.isSelected = false,
    this.isBought = false,
    this.onTap,
    required this.birdModel,
  });

  final double width;
  final bool isSelected;
  final bool isBought;
  final Function? onTap;
  final BirdModel birdModel;

  @override
  Widget build(BuildContext context) {
    double w = (MediaQuery.of(context).size.width - 48) / 2;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: w,
            height: w + 20,
            decoration: ShapeDecoration(
              color:
                  isSelected
                      ? DSColors.lighteningYellow
                      : DSColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                side: BorderSide(
                  color: isSelected ? DSColors.flamingo : DSColors.woodSmoke,
                  width: 2,
                ),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    birdModel.name,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: width,
                    child: BirdWidget(
                      key: Key('${birdModel.name}_$isSelected'),
                      startAnimation: isSelected,
                      sprites: birdModel.sprites,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isSelected)
                    Container(
                      width: width - 10,
                      height: (width - 10) / 5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.black, width: 0.0),
                        borderRadius: BorderRadius.all(
                          Radius.elliptical((width - 10), (width - 10) / 5),
                        ),
                      ),
                    ),
                ],
              ),
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
      color: buttonColor,
      bodyBuilder: bodyButton,
      height: 40,
      size: 120,
      shadowColor: isSelected ? DSColors.athensGray : DSColors.woodSmoke,
      callback: isSelected ? null : () => onTap?.call(),
    );
  }

  Color get buttonColor =>
      isSelected ? DSColors.athensGray : DSColors.lighteningYellow;

  Widget bodyButton(bool isTapped) {
    if ((birdModel.type == ItemType.needWatchAd ||
            birdModel.type == ItemType.needShareSocial) &&
        !isBought) {
      return CustomText(
        birdModel.type == ItemType.needWatchAd ? "Watch Ad" : "Share",
        textAlign: TextAlign.center,
        fontSize: isTapped ? 12 : 16,
        fontWeight: FontWeight.w800,
      );
    } else if (isBought || isSelected) {
      return CustomText(
        isSelected ? 'Selected' : 'Use',
        textAlign: TextAlign.center,
        fontSize: isTapped || isSelected ? 12 : 16,
        fontWeight: FontWeight.w800,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            birdModel.type == ItemType.needBuyByCoin
                ? 'assets/images/objects/gold.png'
                : 'assets/images/objects/multiFruit.png',
            fit: BoxFit.cover,
            height: isTapped ? 16 : 20,
          ),
          SizedBox(width: isTapped ? 2 : 4),
          CustomText(
            '${birdModel.cost}',
            textAlign: TextAlign.center,
            fontSize: isTapped ? 12 : 16,
            fontWeight: FontWeight.bold,
          ),
        ],
      );
    }
  }
}
