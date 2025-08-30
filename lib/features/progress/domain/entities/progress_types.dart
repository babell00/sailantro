enum QuestionStatus { notStarted, started, correct, mastered }

extension QuestionStatusX on QuestionStatus {
  bool get isDone => index >= QuestionStatus.correct.index;
}
