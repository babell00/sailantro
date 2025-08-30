import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sailantro/features/home/domain/entities/challenge.dart';
import 'package:sailantro/features/home/domain/entities/section.dart';
import 'package:sailantro/features/progress/domain/entities/progress_types.dart';
import 'package:sailantro/features/progress/domain/usecases/get_question_status.dart';
import 'package:sailantro/features/progress/domain/usecases/record_answer.dart';
import 'package:sailantro/features/progress/domain/usecases/watch_course_progress.dart';
import 'package:sailantro/features/progress/presentation/cubit/progress_state.dart';


// Presentation-level state for a whole challenge (aggregated from question statuses)
enum ChallengeStage { locked, notStarted, started, correct, mastered }

class ProgressCubit extends Cubit<ProgressState> {
  final WatchCourseProgress watchCourse;
  final RecordAnswer record;
  final GetQuestionStatus getStatus;
  final String courseId;

  StreamSubscription? _sub;

  ProgressCubit({
    required this.watchCourse,
    required this.record,
    required this.getStatus, // NEW
    required this.courseId,
  }) : super(const ProgressState.loading()) {
    _init();
  }

  void _init() {
    _sub?.cancel();
    _sub = watchCourse(courseId).listen((snap) {
      emit(ProgressState.loaded(
        courseId: snap.courseId,
        sections: snap.sections,
        completedChallengeIds: snap.completedChallengeIds,
        coursePercent: snap.coursePercent,
      ));
    });
  }

  Future<void> submitAnswer({
    required String sectionId,
    required String challengeId,
    required String questionId,
    required bool correct,
  }) {
    return record(
      courseId: courseId,
      sectionId: sectionId,
      challengeId: challengeId,
      questionId: questionId,
      correct: correct,
    );
  }

  // Aggregate % done for a challenge (questions with status.isDone)
  double challengePercent(Challenge ch) {
    final total = ch.questions.length;
    if (total == 0) return 0.0;
    final done = ch.questions.where((q) => getStatus(q.id).isDone).length;
    return done / total;
  }

  // Aggregate stage for a challenge
  ChallengeStage challengeStage(Section section, Challenge ch, Set<String> completedIds) {
    // Locked = previous challenges in the section must be completed
    if (!isUnlocked(section, ch, completedIds)) {
      return ChallengeStage.locked;
    }

    final total = ch.questions.length;
    if (total == 0) return ChallengeStage.notStarted;

    int done = 0, mastered = 0, touched = 0;
    for (final q in ch.questions) {
      final s = getStatus(q.id);
      if (s != QuestionStatus.notStarted) touched++;
      if (s.isDone) done++;
      if (s == QuestionStatus.mastered) mastered++;
    }

    if (done == 0 && touched == 0) return ChallengeStage.notStarted;
    if (done == total && mastered == total) return ChallengeStage.mastered;
    if (done == total) return ChallengeStage.correct;
    return ChallengeStage.started;
  }

  // Unlock rule: all lower 'order' challenges must be completed
  bool isUnlocked(Section section, Challenge challenge, Set<String> completed) {
    final prev = section.challenges.where((c) => c.order < challenge.order);
    if (prev.isEmpty) return true;
    return prev.every((c) => completed.contains(c.id));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
