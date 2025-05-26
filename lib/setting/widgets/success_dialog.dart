import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:galaxy_bird/theme.dart';
import 'package:galaxy_bird/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({
    Key? key,
    this.title = "",
    this.showTitle = false,
    this.onPressed,
    this.bodyBuilder,
  }) : super(key: key);

  final String title;
  final bool showTitle;
  final VoidCallback? onPressed;
  final Function(double width, double height)? bodyBuilder;

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> {
  final confettiController = ConfettiController();

  @override
  void initState() {
    confettiController.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 1.5;
    double h = MediaQuery.of(context).size.height / 2.3;
    return CustomDialog(
      width: w,
      height: h,
      showCloseButton: false,
      showSecondaryButton: false,
      showPrimaryButton: true,
      primaryText: "OK",
      title: widget.title,
      showTitle: widget.showTitle,
      secondaryButtonPressed: () => Navigator.pop(context),
      primaryButtonPressed: () {
        widget.onPressed?.call();
        Navigator.pop(context);
      },
      bodyWidget: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Text(
                    "Congratulations",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DiloWorld',
                    ),
                  ),
                  Text("Congratulations", style: buttonDarkStyle)
                ],
              ),
              if (widget.bodyBuilder != null) ...[
                const SizedBox(height: 12),
                widget.bodyBuilder?.call(w, h),
              ],
            ],
          ),
          ConfettiWidget(
            confettiController: confettiController,
            shouldLoop: false,
            blastDirection: -pi / 2,
          ),
          // if (widget.bodyBuilder != null) widget.bodyBuilder?.call(w, h),
        ],
      ),
    );
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }
}
