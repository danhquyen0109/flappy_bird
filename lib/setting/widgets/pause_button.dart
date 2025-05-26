import 'package:galaxy_bird/my_game/my_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PauseButton extends StatefulWidget {
  const PauseButton({super.key, this.onPaused, this.width = 40});

  final Function(bool isPaused, VoidCallback onStart)? onPaused;
  final double width;

  @override
  // ignore: library_private_types_in_public_api
  _PauseButtonState createState() => _PauseButtonState();
}

class _PauseButtonState extends State<PauseButton> {
  bool _isPaused = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        setState(() => _isPaused = !_isPaused);
        context.read<MyGameCubit>().playButtonSound();
        widget.onPaused?.call(_isPaused, onStart);
      },
      child: Icon(
        _isPaused
            ? const IconData(
              0xf487,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage,
            )
            : const IconData(
              0xf736,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage,
            ),
        size: 30,
      ),
    );
  }

  void onStart() => setState(() => _isPaused = !_isPaused);
}
