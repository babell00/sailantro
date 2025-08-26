import 'question.dart';

class Challenge {
  final String id;
  final String title;         // "Distress Signals · Basics"
  final int order;
  final bool isLocked;
  final int? xpReward;
  final List<Question> questions;

  const Challenge({
    required this.id,
    required this.title,
    required this.order,
    required this.questions,
    this.isLocked = false,
    this.xpReward,
  });
}