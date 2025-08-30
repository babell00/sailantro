import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sailantro/core/utils/color_ext.dart';

import '../../domain/entities/section.dart';

class CurrentSectionWidget extends StatelessWidget {
  final String courseName;
  final Section section;

  const CurrentSectionWidget({
    super.key,
    required this.courseName,
    required this.section
  });

  @override
  Widget build(BuildContext context) {
    final color = section.colorArgb.toColor();

    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
        border: Border(bottom: BorderSide(color: color, width: 4.0)),
      ),
      duration: Duration(milliseconds: 580),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(courseName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      section.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              // decoration: BoxDecoration(
              //   border: Border(left: BorderSide(color: color, width: 2.0)),
              // ),
              child: Center(
                child: SvgPicture.asset('assets/svg/theory.svg', width: 42, height: 42),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
