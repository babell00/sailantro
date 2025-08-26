import 'challenge.dart';

class Section {
  final String id;
  final int unit;
  final int index;
  final String title;
  final int colorArgb;

  final List<Challenge> challenges;

  const Section({
    required this.id,
    required this.unit,
    required this.index,
    required this.title,
    required this.colorArgb,
    required this.challenges,
  });
}