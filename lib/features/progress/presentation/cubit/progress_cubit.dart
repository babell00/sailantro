import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sailantro/features/home/domain/entities/challenge.dart';
import 'package:sailantro/features/home/domain/entities/section.dart';
import 'package:sailantro/features/progress/domain/entities/progress_types.dart';
import 'package:sailantro/features/progress/domain/repositories/progress_repository.dart';
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

  StreamSubscription<ProgressSnapshot>? _sub;

  ProgressCubit({
    required this.watchCourse,
    required this.record,
    required this.getStatus,
    required this.courseId,
  }) : super(const ProgressState.loading()) {
    _init();
  }

  // ---- Lifecycle -----------------------------------------------------------

  void _init() => _subscribe();

  void _subscribe() {
    _unsubscribe();
    _sub = watchCourse(courseId).listen(_onSnapshot);
  }

  void _unsubscribe() {
    _sub?.cancel();
    _sub = null;
  }

  void _onSnapshot(ProgressSnapshot snap) {
    emit(ProgressState.loaded(
      courseId: snap.courseId,
      sections: snap.sections,
      completedChallengeIds: snap.completedChallengeIds,
      coursePercent: snap.coursePercent,
    ));
  }

  @override
  Future<void> close() async {
    _unsubscribe();
    return super.close();
  }

  // ---- Commands ------------------------------------------------------------

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

  // ---- Query helpers used by UI -------------------------------------------

  /// 0..1 progress for a challenge based on questions that are `isDone`.
  double challengePercent(Challenge ch) {
    final agg = _computeAgg(ch);
    return _percent(agg);
  }

  /// Aggregate stage for a challenge, considering unlock rule + question states.
  ChallengeStage challengeStage(
      Section section,
      Challenge ch,
      Set<String> completedIds,
      ) {
    final unlocked = _isUnlocked(section, ch, completedIds);
    if (!unlocked) return ChallengeStage.locked;

    final agg = _computeAgg(ch);
    return _stageFrom(agg, unlocked: true);
  }

  // ---- Private aggregation logic ------------------------------------------

  /// Roll-up of question statuses inside a challenge.
  _Agg _computeAgg(Challenge ch) {
    final total = ch.questions.length;
    if (total == 0) return const _Agg(total: 0);

    int touched = 0, done = 0, mastered = 0;
    for (final q in ch.questions) {
      final s = getStatus(q.id);
      if (s != QuestionStatus.notStarted) touched++;
      if (s.isDone) done++;
      if (s == QuestionStatus.mastered) mastered++;
    }
    return _Agg(total: total, touched: touched, done: done, mastered: mastered);
  }

  double _percent(_Agg a) =>
      a.total == 0 ? 0.0 : a.done / a.total;

  ChallengeStage _stageFrom(_Agg a, {required bool unlocked}) {
    if (!unlocked) return ChallengeStage.locked;
    if (a.total == 0) return ChallengeStage.notStarted;

    if (a.done == 0 && a.touched == 0) return ChallengeStage.notStarted;
    if (a.done == a.total && a.mastered == a.total) return ChallengeStage.mastered;
    if (a.done == a.total) return ChallengeStage.correct;
    return ChallengeStage.started;
  }

  /// Unlock rule: all previous (lower `order`) challenges must be completed.
  bool _isUnlocked(Section section, Challenge challenge, Set<String> completed) {
    final prev = section.challenges.where((c) => c.order < challenge.order);
    return prev.isEmpty || prev.every((c) => completed.contains(c.id));
  }
}

/// Tiny value object for aggregation results.
class _Agg {
  final int total;
  final int touched;
  final int done;
  final int mastered;
  const _Agg({
    required this.total,
    this.touched = 0,
    this.done = 0,
    this.mastered = 0,
  });
}
