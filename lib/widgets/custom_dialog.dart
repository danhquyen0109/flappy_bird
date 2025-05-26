import 'package:flutter/cupertino.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/widgets/widgets.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    this.primaryButtonPressed,
    this.secondaryButtonPressed,
    this.showCloseButton = true,
    this.showPrimaryButton = false,
    this.showSecondaryButton = false,
    this.showTitle = false,
    this.title = "",
    this.primaryText = "",
    this.secondaryText = "",
    this.bodyWidget,
    this.bodyMargin = 50.0,
    this.bodyMarginBottom = 0,
    this.width,
    this.height,
    this.borderRadius = 16.0,
    this.actionButtonFontSize = 21,
  });

  final VoidCallback? primaryButtonPressed;
  final VoidCallback? secondaryButtonPressed;
  final bool showCloseButton;
  final bool showPrimaryButton;
  final bool showSecondaryButton;
  final bool showTitle;
  final String title;
  final String primaryText;
  final String secondaryText;
  final Widget? bodyWidget;
  final double bodyMargin;
  final double bodyMarginBottom;
  final double? width;
  final double? height;
  final double borderRadius;
  final double actionButtonFontSize;

  @override
  Widget build(BuildContext context) {
    double w = width ?? MediaQuery.of(context).size.width / 1.5;
    double h = height ?? MediaQuery.of(context).size.height / 2 + 30;
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: w,
            height: h,
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: ShapeDecoration(
              shadows: [BoxShadow(color: DSColors.woodSmoke, offset: Offset(0, 6))],
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: DSColors.woodSmoke),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              color: DSColors.white,
            ),
          ),
          if (!showCloseButton)
            Positioned(
              top: 12 - (50 / 4),
              left: 8,
              child: RibbonShape(
                showTitle: showTitle,
                title: title,
                color: DSColors.primary500,
                width: w * 2 / 3,
              ),
            ),
          if (bodyWidget != null)
            bodyMarginBottom > 0
                ? Positioned(
                  top: bodyMargin,
                  left: 20,
                  right: 20,
                  bottom: bodyMarginBottom,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: bodyWidget,
                  ),
                )
                : Positioned(
                  top: bodyMargin,
                  left: 20,
                  right: 20,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: bodyWidget,
                  ),
                ),
          if (showCloseButton)
            Positioned(
              top: 27,
              left: 27,
              child: CupertinoButton(
                padding: const EdgeInsets.all(0.0),
                child: Icon(
                  const IconData(
                    0xf3cf,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage,
                  ),
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          Positioned(bottom: 35, child: buildActionButtons(context, w)),
        ],
      ),
    );
  }

  Widget buildActionButtons(BuildContext context, double width) {
    double s =
        showPrimaryButton & showSecondaryButton ? (width - 30) / 2 : width / 2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showSecondaryButton)
          PlainShadowButton(
            borderColor: DSColors.woodSmoke,
            color: DSColors.primary300,
            bodyBuilder: (isTapped) {
              return CustomText(
                secondaryText,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w800,
                fontSize:
                    isTapped ? actionButtonFontSize - 5 : actionButtonFontSize,
              );
            },
            height: 65,
            size: s,
            callback: () => secondaryButtonPressed?.call(),
            shadowColor: DSColors.woodSmoke,
          ),
        if (showSecondaryButton & showPrimaryButton) const SizedBox(width: 10),
        if (showPrimaryButton)
          PlainShadowButton(
            borderColor: DSColors.woodSmoke,
            color: DSColors.primary300,
            bodyBuilder: (isTapped) {
              return CustomText(
                primaryText,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w800,
                fontSize:
                    isTapped ? actionButtonFontSize - 5 : actionButtonFontSize,
              );
            },
            height: 65,
            size: s,
            callback: () => primaryButtonPressed?.call(),
            shadowColor: DSColors.woodSmoke,
          ),
      ],
    );
  }
}
