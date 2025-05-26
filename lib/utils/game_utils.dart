import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:galaxy_bird/setting/setting.dart';
import 'package:galaxy_bird/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:flutter/services.dart' show rootBundle;

const primary_color = Color(0xff92e010);
const white = Color(0xFFFFFFFF);
const athens_gray = Color(0xFFF4F5F7);
const lightening_yellow = Color(0xFFFFBD12);
const flamingo = Color(0xFFF95A2C);
const black = Color(0xFF000000);
const wood_smoke = Color(0xFF18191F);
const selago = Color(0xFFE9E7FC);

class GameUtils {
  static Future<ui.Image> loadImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final list = Uint8List.view(data.buffer);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, completer.complete);
    return completer.future;
  }

  static Future<ui.Image> loadImageFitSize(
      String imageAssetPath, int width, int height) async {
    final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
    im.Image? baseSizeImage =
        im.decodeImage(assetImageByteData.buffer.asUint8List());
    im.Image resizeImage =
        im.copyResize(baseSizeImage!, width: width, height: height);
    ui.Codec codec = await ui
        .instantiateImageCodec(Uint8List.fromList(im.encodePng(resizeImage)));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  static void showSuccessDialog(
    BuildContext context, {
    bool showTitle = false,
    String title = "Congratulations",
    Duration? autoHide,
    Function(double width, double height)? bodyBuilder,
  }) {
    late Timer _timer;
    showDialog(
      context: context,
      builder: (_) {
        _timer = Timer(autoHide ?? const Duration(milliseconds: 2500),
            () => Navigator.of(context).pop());
        return SuccessDialog(
          showTitle: showTitle,
          title: title,
          bodyBuilder: bodyBuilder,
          onPressed: () {
            if (_timer.isActive) {
              _timer.cancel();
            }
          },
        );
      },
    ).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  static void showSnackBar(BuildContext context,
      {Duration? autoHide,
      String content = "    Please check your internet connection"}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 75,
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(24),
                decoration: ShapeDecoration(
                  shadows: [
                    BoxShadow(color: wood_smoke, offset: Offset(0, 6)),
                  ],
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: wood_smoke),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  color: white,
                ),
              ),
              CustomText(
                content,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          duration: autoHide ?? const Duration(seconds: 1),
        ),
      );
  }
}
