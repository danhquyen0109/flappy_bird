
import 'package:flutter/material.dart';
import 'package:galaxy_bird/themes/colors.dart';

AppBar gameAppBar({required BuildContext context, required Widget title}) =>
    AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(color: DSColors.primary500),
      ),
      backgroundColor: Colors.transparent,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: title,
      elevation: 0,
    );
