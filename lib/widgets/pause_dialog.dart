import 'package:galaxy_bird/components/components.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_bird/my_game/my_game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy_bird/theme.dart';

class PauseDialog extends StatelessWidget {
  const PauseDialog({
    this.onHome,
    this.onContinue,
  });

  final VoidCallback? onHome;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2 + 16;
    return Scaffold(
      backgroundColor: const Color(0xff92e010).withOpacity(0.15),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: width,
              child: AspectRatio(
                aspectRatio: 555 / 754,
                child: Image.asset(
                  'assets/images/objects/window.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  onPressed: () {
                    context.read<MyGameCubit>().playButtonSound();
                    onHome?.call();
                  },
                  builder: (isTap) =>
                      Text('Home', style: isTap ? buttonSmallFont : buttonFont),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    context.read<MyGameCubit>().playButtonSound();
                    onContinue?.call();
                  },
                  builder: (isTap) => Text('Continue',
                      style: isTap ? buttonSmallFont : buttonFont),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
