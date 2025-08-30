import 'package:flutter/material.dart';
import 'package:sailantro/features/home/domain/entities/challenge.dart';
import 'package:sailantro/features/home/domain/entities/section.dart';
import 'package:sailantro/features/home/presentation/components/challenge_chip.dart';
import 'package:sailantro/features/home/presentation/components/section_title_widget.dart';
import 'package:sailantro/features/progress/presentation/cubit/progress_cubit.dart';

class SectionWidget extends StatelessWidget {
  final Section section;
  final int waveStartIndex;

  final double? sectionProgressPercent;

  final ChallengeStage Function(Challenge challenge)? challengeStageOf;
  final double Function(Challenge challenge)? challengePercentOf;

  const SectionWidget({
    super.key,
    required this.section,
    required this.waveStartIndex,
    this.sectionProgressPercent,
    this.challengeStageOf,
    this.challengePercentOf,
  });

  @override
  Widget build(BuildContext context) {
    final pct = sectionProgressPercent ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionTitleWidget(title: section.title),
        const SizedBox(height: 24.0),
        for (var i = 0; i < section.challenges.length; i++)
          Builder(
            builder: (BuildContext context) {
              final ch = section.challenges[i];
              final stage =
                  challengeStageOf?.call(ch) ?? ChallengeStage.notStarted;
              final p = challengePercentOf?.call(ch) ?? 0.0;

              return ChallengeChip(
                challenge: section.challenges[i],
                section: section,
                visualIndex: waveStartIndex + i,
                stage: stage,
                percent: p,
              );
            },
          ),
      ],
    );
  }
}
