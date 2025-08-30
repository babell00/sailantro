import '../entities/section_progress.dart';
import '../entities/progress_types.dart';

class ProgressSnapshot {
  final String courseId;
  final Map<String, SectionProgress> sections; // sectionId -> progress
  final Set<String> completedChallengeIds;     // challengeIds
  final double coursePercent;                  // 0..1

  const ProgressSnapshot({
    required this.courseId,
    required this.sections,
    required this.completedChallengeIds,
    required this.coursePercent,
  });
}

abstract class ProgressRepository {
  Stream<ProgressSnapshot> watchCourse(String courseId);

  Future<void> recordAnswer({
    required String courseId,
    required String sectionId,
    required String challengeId,
    required String questionId,
    required bool correct,
  });

  QuestionStatus statusOf(String questionId);
}
