import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../domain/models/challenge.dart';
import '../../domain/models/section.dart';
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
          child: ElevatedButton(
            onPressed: challenge.isLocked ? null : () {}, // no navigation yet
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              fixedSize: const Size(70, 70),
              elevation: 0,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
            ),
            // child: const Icon(Icons.star, color: Colors.white, size: 30,),
              child: SvgPicture.asset('assets/svg/anchor.svg', width: 50, height: 50),

          ),
        ),
      ),
    );
  }
}
