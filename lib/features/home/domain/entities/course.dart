import 'package:sailantro/features/home/domain/entities/section.dart';

class Course {
  final String id;
  final String name;
  final List<Section> sections;


  const Course({
    required this.id,
    required this.name,
    required this.sections
  });
}