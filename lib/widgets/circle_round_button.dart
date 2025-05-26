import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircleRoundButton extends StatefulWidget {
  final Color borderColor;
  final Color shadowColor;
  final Color color;
  final Color? iconColor;
  final String iconPath;
  final VoidCallback? onPressed;
  final double size;

  const CircleRoundButton({
    required this.borderColor,
    required this.shadowColor,
    required this.color,
    this.iconColor,
    required this.iconPath,
    this.size = 40,
    this.onPressed,
  });

  @override
  State<CircleRoundButton> createState() => _CircleRoundButtonState();
}

class _CircleRoundButtonState extends State<CircleRoundButton> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPressed?.call(),
      onTapDown: (event) {
        setState(() {
          isTapped = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapped = false;
        });
      },
      onTapUp: (event) {
        setState(() {
          isTapped = false;
        });
      },
      child: Container(
        height: widget.size,
        width: widget.size,
        padding: EdgeInsets.all(isTapped ? 16 : 8),
        decoration: ShapeDecoration(
          shadows: [
            BoxShadow(
              color: widget.shadowColor,
              offset: Offset(
                0.0, // Move to right 10  horizontally
                4.0, // Move to bottom 5 Vertically
              ),
            )
          ],
          color: widget.color,
          shape: CircleBorder(
            side: BorderSide(
              color: widget.shadowColor,
              width: 2,
            ),
          ),
        ),
        child: SvgPicture.asset(widget.iconPath),
      ),
    );
  }
}
