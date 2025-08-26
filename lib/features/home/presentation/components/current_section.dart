import 'package:flutter/material.dart';

import '../../domain/models/section_data.dart';

class CurrentSection extends StatelessWidget {
  final SectionData data;

  const CurrentSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(16.0),
        border: Border(bottom: BorderSide(color: data.color, width: 4.0)),
      ),
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
                    Text(
                      'Unit ${data.unit}, Section ${data.section}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      data.title,
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: data.color, width: 2.0),
                ),
              ),
              child: Container(
                width: 20.0,
                height: 20.0,
                color: Colors.yellow, // A visual indicator
              )
            ),
          ],
        ),
      ),
    );
  }
}
