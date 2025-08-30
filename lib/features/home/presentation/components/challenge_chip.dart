// lib/features/home/presentation/components/challenge_chip.dart
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/entities/section.dart';
import '../utils/path_layout.dart';
import 'package:sailantro/features/progress/presentation/cubit/progress_cubit.dart'; // for ChallengeStage

class ChallengeChip extends StatelessWidget {
  final Challenge challenge;
  final Section section;

  final int visualIndex;

  // NEW:
  final ChallengeStage stage;
  final double percent; // 0..1

  const ChallengeChip({
    super.key,
    required this.challenge,
    required this.section,
    required this.visualIndex,
    required this.stage,     // NEW
    required this.percent,   // NEW
  });

  @override
  Widget build(BuildContext context) {
    final dx = PathLayout.dx(
      index: visualIndex,
      amplitude: 100.0,
      stepRads: math.pi / 2,
      phase: -math.pi / 2,
    );

    final style = _chipStyleForStage(context, stage);
    final isLocked = stage == ChallengeStage.locked;

    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Transform.translate(
        offset: Offset(dx, 0),
        child: InkWell(
          onTap: isLocked ? null : () { /* navigate to challenge */ },
          borderRadius: const BorderRadius.all(Radius.circular(36)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: style.bg, // <- color the chip itself
              border: Border(
                bottom: BorderSide(color: style.border, width: 6),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(36)),
            ),
            child: Stack(
              children: [
                // Optional inline progress fill when "started"
                if (stage == ChallengeStage.started)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: percent.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: style.fg.withOpacity(0.10),
                            borderRadius: const BorderRadius.all(Radius.circular(36)),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Icon (blurred/greyscale if locked)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: MySvgIconWithEffects(
                    assetPath: challenge.iconPath,
                    isDisabled: isLocked,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipStyle {
  final Color bg;
  final Color fg;
  final Color border;
  const _ChipStyle({required this.bg, required this.fg, required this.border});
}

_ChipStyle _chipStyleForStage(BuildContext ctx, ChallengeStage stage) {
  final cs = Theme.of(ctx).colorScheme;
  final outline = Theme.of(ctx).dividerColor.withOpacity(0.22);

  switch (stage) {
    case ChallengeStage.locked:
      return _ChipStyle(
        bg: cs.surfaceVariant,
        fg: cs.onSurfaceVariant,
        border: outline,
      );
    case ChallengeStage.notStarted:
      return _ChipStyle(
        bg: cs.surface,
        fg: cs.onSurface,
        border: outline,
      );
    case ChallengeStage.started:
      return _ChipStyle(
        bg: cs.secondaryContainer,
        fg: cs.onSecondaryContainer,
        border: outline,
      );
    case ChallengeStage.correct:
      return _ChipStyle(
        bg: cs.primaryContainer,
        fg: cs.onPrimaryContainer,
        border: outline,
      );
    case ChallengeStage.mastered:
      return _ChipStyle(
        bg: cs.tertiaryContainer,
        fg: cs.onTertiaryContainer,
        border: outline,
      );
  }
}


class MySvgIconWithEffects extends StatelessWidget {
  final bool isDisabled;
  final String assetPath;

  const MySvgIconWithEffects({
    super.key,
    this.isDisabled = false,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    if (isDisabled) {
      return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: SvgPicture.asset(assetPath, width: 64, height: 64),
        ),
      );
    } else {
      return SvgPicture.asset(assetPath, width: 64, height: 64);
    }
  }
}
