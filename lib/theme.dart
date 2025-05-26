import 'package:galaxy_bird/themes/colors.dart';
import 'package:flutter/material.dart';

const fontFamily = "Chainwhacks";

const buttonSmallFont = TextStyle(
  fontSize: 12,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Chainwhacks',
);

const buttonFont = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Chainwhacks',
);

const buttonMediumFont = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Chainwhacks',
);

const buttonLargeFont = TextStyle(
  fontSize: 22,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Chainwhacks',
);

final buttonDarkStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  fontFamily: 'Chainwhacks',
  foreground:
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = DSColors.woodSmoke,
);

final roundedButtonRedStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  fontFamily: 'Chainwhacks',
  foreground:
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = DSColors.woodSmoke,
);

final roundedButtonSmokeMediumStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  fontFamily: 'Chainwhacks',
  foreground:
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.75
        ..color = DSColors.woodSmoke,
);

final roundedButtonSmokeStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  fontFamily: 'Chainwhacks',
  foreground:
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.75
        ..color = DSColors.woodSmoke,
);
