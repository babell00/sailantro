import '../repositories/progress_repository.dart';

class RecordAnswer {
  final ProgressRepository repo;
  RecordAnswer(this.repo);

  Future<void> call({
    required String courseId,
    required String sectionId,
    required String challengeId,
    required String questionId,
    required bool correct,
  }) {
    return repo.recordAnswer(
      courseId: courseId,
      sectionId: sectionId,
      challengeId: challengeId,
      questionId: questionId,
      correct: correct,
    );
  }
}
