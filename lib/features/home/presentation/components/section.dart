import 'package:flutter/material.dart';
import 'package:sailantro/features/home/presentation/components/section_title.dart';

import '../../domain/models/section_data.dart';
import 'exercise.dart';


class Section extends StatelessWidget {
  final SectionData data;

  const Section({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionTitle(title: data.title),
        const SizedBox(height: 24.0),
        ...List.generate(data.exercise, (i) => Exercise(index: i, data: data,)),
      ],
    );
  }
}



