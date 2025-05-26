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
    double width = MediaQuery.of(context).size.width - 16 + 3;
    double height =
        MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        16 -
        42;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: appBar,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            
          ],
        ),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Stack(
      //     alignment: Alignment.center,
      //     children: [
      //       Positioned(
      //         right: 2.5,
      //         child: TriangleButton(
      //           onTap: () {
      //             context.read<SettingCubit>().playSound(path: 'select');
      //             Navigator.of(context).pushNamed(MapShop.routeName);
      //           },
      //           path: TriangleShape.bottomHalfSquare.path(width, height),
      //           child: Container(
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                 image: AssetImage(
      //                     "assets/images/background/graveyardBg.png"),
      //                 fit: BoxFit.fill,
      //               ),
      //               color: Colors.red,
      //               borderRadius: BorderRadius.all(Radius.circular(4.0)),
      //             ),
      //             width: width,
      //             height: height,
      //             child: Center(
      //               child: Container(
      //                 margin: EdgeInsets.only(right: width / 2),
      //                 child: CustomText(
      //                   'Maps',
      //                   fontSize: 24,
      //                   strokeWidth: 1.0,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),

      //       ///
      //       Positioned(
      //         left: 2.5,
      //         child: TriangleButton(
      //           onTap: () {
      //             context.read<SettingCubit>().playSound(path: 'select');
      //             Navigator.of(context).pushNamed(BirdShop.routeName);
      //           },
      //           path: TriangleShape.upperHalfSquare.path(width, height),
      //           child: Container(
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                 image:
      //                     AssetImage("assets/images/background/springBg.png"),
      //                 fit: BoxFit.fill,
      //               ),
      //               color: DSColors.primary500,
      //               borderRadius: BorderRadius.all(Radius.circular(4.0)),
      //             ),
      //             width: width,
      //             height: height,
      //             child: Center(
      //               child: Container(
      //                 margin: EdgeInsets.only(left: width / 2),
      //                 child: CustomText(
      //                   'Birds',
      //                   fontSize: 24,
      //                   strokeWidth: 1.0,
      //                   color: DSColors.woodSmoke,
      //                   borderColor: DSColors.white,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
