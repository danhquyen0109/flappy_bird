import 'package:galaxy_bird/components/components.dart';
import 'package:galaxy_bird/setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/widgets/widgets.dart';

class MapShop extends StatelessWidget {
  static const routeName = "app/map_shop";

  const MapShop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: shopAppBarWidget(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<SettingCubit, SettingState>(
          builder: (context, state) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              reverse: false,
              itemCount: state.maps.length,
              itemBuilder:
                  (_, index) => _MapCard(
                    isSelected: state.currentMap == state.maps[index],
                    isBought: state.myMaps.contains(state.maps[index]),
                    mapModel: state.maps[index],
                    onTap: () {
                      final settingCubit = context.read<SettingCubit>();
                      settingCubit.mapChanged(
                        map: state.maps[index],
                        index: index,
                      );
                    },
                  ),
            );
          },
        ),
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  final MapModel mapModel;
  final bool isSelected;
  final bool isBought;
  final Function? onTap;

  const _MapCard({
    required this.mapModel,
    this.isSelected = false,
    this.isBought = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double w = (MediaQuery.of(context).size.width - 24) / 2;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(left: 4, right: 4, bottom: 16),
      decoration: ShapeDecoration(
        color: isSelected ? DSColors.lighteningYellow : DSColors.primaryColor,
        shadows: [
          BoxShadow(
            color: DSColors.woodSmoke,
            offset: Offset(
              0.0, // Move to right 10  horizontally
              2.0, // Move to bottom 5 Vertically
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          side: BorderSide(
            color: isSelected ? DSColors.flamingo : DSColors.woodSmoke,
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: w,
              height: w,
              decoration: BoxDecoration(
                color: DSColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                image: DecorationImage(
                  image: AssetImage(mapModel.sprites.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                CustomText(
                  mapModel.name,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: selectButton,
                ),
              ],
            ),
          ),
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
    if ((mapModel.type == ItemType.needWatchAd ||
            mapModel.type == ItemType.needShareSocial) &&
        !isBought) {
      return CustomText(
        mapModel.type == ItemType.needWatchAd ? "Watch Ad" : "Share",
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
            mapModel.type == ItemType.needBuyByCoin
                ? 'assets/images/objects/gold.png'
                : 'assets/images/objects/multiFruit.png',
            fit: BoxFit.cover,
            height: isTapped ? 16 : 20,
          ),
          SizedBox(width: isTapped ? 2 : 4),
          CustomText(
            '${mapModel.cost}',
            textAlign: TextAlign.center,
            fontSize: isTapped ? 12 : 16,
            fontWeight: FontWeight.bold,
          ),
        ],
      );
    }
  }
}
