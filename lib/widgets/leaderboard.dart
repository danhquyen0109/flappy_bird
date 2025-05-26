import 'package:galaxy_bird/my_game/my_game.dart';
import 'package:galaxy_bird/utils/utils.dart';
import 'package:galaxy_bird/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Leaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> scoreList = context.read<MyGameCubit>().state.bestScore;
    scoreList.sort((a, b) {
      int aT = int.parse(a.split("@@@@")[1]);
      int bT = int.parse(b.split("@@@@")[1]);
      if (aT < bT) {
        return 1;
      } else if (aT > bT) {
        return -1;
      } else {
        return 0;
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          child: Image.asset(
            'assets/images/reward.png',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 10),
        ...scoreList
            .asMap()
            .entries
            .map((entry) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                          '${entry.key + 1}.',
                          fontSize: 23,
                          strokeWidth: 1.0,
                        ),
                        const SizedBox(width: 16),
                        CustomText(
                          '${entry.value.split("@@@@")[1] == "0" ? "--" : '${entry.value.split("@@@@")[0]}:${entry.value.split("@@@@")[1]}'}',
                          fontSize: 22,
                          strokeWidth: .15,
                          color: wood_smoke,
                          borderColor: white,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          'points',
                          fontSize: 14,
                          strokeWidth: .15,
                          color: wood_smoke,
                          borderColor: white,
                        ),
                      ],
                    ),
                    if (entry.key < 4) const SizedBox(height: 4),
                  ],
                ))
            .toList(),
      ],
    );
  }
}
