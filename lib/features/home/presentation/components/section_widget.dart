import 'package:flutter/material.dart';
import 'package:sailantro/core/utils/color_ext.dart';
import 'package:sailantro/features/home/presentation/components/section_title_widget.dart';
import '../../domain/entities/section.dart';
import 'challenge_chip.dart';

class SectionWidget extends StatelessWidget {
  final Section section;

  /// Where the wave should start for this section.
  /// Pass a GLOBAL running index from the page.
  final int waveStartIndex;

  const SectionWidget({
    super.key,
    required this.section,
    required this.waveStartIndex,
  });

  @override
  Widget build(BuildContext context) {
    final color = section.colorArgb.toColor();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionTitleWidget(title: section.title),
        const SizedBox(height: 24.0),
        for (var i = 0; i < section.challenges.length; i++)
          ChallengeChip(
            challenge: section.challenges[i],
            section: section,
            visualIndex: waveStartIndex + i, // GLOBAL index
            bgColor: color,
          ),
      ],
    );
  }
}
