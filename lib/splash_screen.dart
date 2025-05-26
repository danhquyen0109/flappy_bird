import 'package:galaxy_bird/setting/setting.dart';
import 'package:galaxy_bird/themes/colors.dart';
import 'package:galaxy_bird/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "app/splash";

  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.slowMiddle,
      ),
    );
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        final components = context.read<SettingCubit>().state.components;
        Navigator.pushNamedAndRemoveUntil(
          context,
          SettingPage.routeName,
          (route) => false,
          arguments: components,
        );
      }
    });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/second_splash.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              bottom: 48,
              left: 16,
              right: 16,
              child: _ProgressAnimatedWidget(
                controller: _animationController,
                animation: _animation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressAnimatedWidget extends AnimatedWidget {
  const _ProgressAnimatedWidget({
    required AnimationController controller,
    required this.animation,
  }) : super(listenable: controller);
  final Animation<double> animation;

  String get loadingText {
    if (animation.value <= 2.5 / 6) {
      return "Welcome to Super Bird Flying game";
    } else if (animation.value <= 3.5 / 6) {
      return "Overcome obstacles to get points";
    } else if (animation.value <= 5 / 6) {
      return "Move smartly to collect items";
    }
    return "Let's play...";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            loadingText,
            style: TextStyle(
              fontFamily: 'DiloWorld',
              fontWeight: FontWeight.w400,
              color: DSColors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        const SizedBox(height: 14),
        LinearPercentIndicator(
          barRadius: Radius.circular(12.0),
          width: MediaQuery.of(context).size.width - 50,
          animation: false,
          lineHeight: 25.0,
          animationDuration: 0,
          percent: animation.value,
          progressColor: DSColors.primary300,
          curve: Curves.slowMiddle,
          center: CustomText(
            '${(animation.value * 100).round()}%',
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
