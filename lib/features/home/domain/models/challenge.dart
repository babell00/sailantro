import 'question.dart';

class Challenge {
  final String id;
  final String title;
  final int order;
  final bool isLocked;
  final int? xpReward;
  final String iconPath;
  final List<Question> questions;


  const Challenge({
    required this.id,
    required this.title,
    required this.order,
    required this.questions,
    required this.iconPath,
    this.isLocked = false,
    this.xpReward,
  });
}