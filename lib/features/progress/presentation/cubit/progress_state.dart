import 'package:sailantro/features/progress/domain/entities/section_progress.dart';

class ProgressState {
  final String? courseId;
  final Map<String, SectionProgress> sections;
  final Set<String> completedChallengeIds;
  final double coursePercent;
  final bool loading;

  const ProgressState({
    required this.courseId,
    required this.sections,
    required this.completedChallengeIds,
    required this.coursePercent,
    required this.loading,
  });

  const ProgressState.loading()
      : courseId = null,
        sections = const {},
        completedChallengeIds = const {},
        coursePercent = 0.0,
        loading = true;

  factory ProgressState.loaded({
    required String courseId,
    required Map<String, SectionProgress> sections,
    required Set<String> completedChallengeIds,
    required double coursePercent,
  }) {
    return ProgressState(
      courseId: courseId,
      sections: sections,
      completedChallengeIds: completedChallengeIds,
      coursePercent: coursePercent,
      loading: false,
    );
  }
}
