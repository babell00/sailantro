enum QuestionType {
  mcqSingle,
  mcqMulti,
  matchPairs,
  ordering,
}

class Question {
  final String id;
  final QuestionType type;
  final int order;
  final String stem;
  final String? imageUrl;
  final Map<String, dynamic> payload;

  const Question({
    required this.id,
    required this.type,
    required this.order,
    required this.stem,
    this.imageUrl,
    this.payload = const {},
  });
}