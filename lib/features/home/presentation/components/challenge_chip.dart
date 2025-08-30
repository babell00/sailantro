import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../domain/entities/challenge.dart';
import '../../domain/entities/section.dart';
import '../utils/path_layout.dart';

class ChallengeChip extends StatelessWidget {
  final Challenge challenge;
  final Section section;

  /// IMPORTANT: This must be a GLOBAL index (not 0..n per section).
  final int visualIndex;
  final Color bgColor;

  const ChallengeChip({
    super.key,
    required this.challenge,
    required this.section,
    required this.visualIndex,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final dx = PathLayout.dx(
      index: visualIndex,
      amplitude: 100.0,
      stepRads: math.pi / 2,
      phase: -math.pi / 2,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Transform.translate(
        offset: Offset(dx, 0),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white10, width: 6)),
            borderRadius: BorderRadius.all(Radius.circular(36)),
          ),
          child: MySvgIconWithEffects(
            assetPath: challenge.iconPath,
            isDisabled: challenge.isLocked,

          ),
        ),
      ),
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
