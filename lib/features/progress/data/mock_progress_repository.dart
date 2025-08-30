import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sailantro/features/home/domain/entities/challenge.dart';
import 'package:sailantro/features/home/domain/entities/course.dart';
import 'package:sailantro/features/home/domain/entities/section.dart';
import 'package:sailantro/features/home/domain/repository/course_repository.dart';
import 'package:sailantro/features/progress/domain/entities/progress_types.dart';
import 'package:sailantro/features/progress/domain/entities/section_progress.dart';
import 'package:sailantro/features/progress/domain/repositories/progress_repository.dart';



class MockProgressRepository implements ProgressRepository {
  final CourseRepository courseRepo;

  // In-memory: questionId -> status
  final Map<String, QuestionStatus> _qStatus;

  // per-course stream
  final Map<String, StreamController<ProgressSnapshot>> _controllers = {};

  MockProgressRepository({
    required this.courseRepo,
    Map<String, QuestionStatus>? initialStatuses,
  }) : _qStatus = {...?initialStatuses};

  @override
  QuestionStatus statusOf(String questionId) =>
      _qStatus[questionId] ?? QuestionStatus.notStarted;

  @override
  Stream<ProgressSnapshot> watchCourse(String courseId) async* {
    final ctrl = _controllers.putIfAbsent(
      courseId,
          () => StreamController<ProgressSnapshot>.broadcast(sync: true),
    );
    () async {
      try {
        final snap = await _buildSnapshot(courseId);
        ctrl.add(snap);
      } catch (e, st) {
        debugPrint('ProgressRepo _buildSnapshot failed: $e\n$st');
        ctrl.add(const ProgressSnapshot(
          courseId: 'unknown',
          sections: {},
          completedChallengeIds: {},
          coursePercent: 0.0,
        ));
      }
    }();
    yield* ctrl.stream;
  }

  @override
  Future<void> recordAnswer({
    required String courseId,
    required String sectionId,
    required String challengeId,
    required String questionId,
    required bool correct,
  }) async {
    final prev = statusOf(questionId);

    // First correct -> correct; next correct -> mastered; wrong -> started (never below started)
    final next = correct
        ? ((prev == QuestionStatus.correct || prev == QuestionStatus.mastered)
        ? QuestionStatus.mastered
        : QuestionStatus.correct)
        : (prev == QuestionStatus.notStarted ? QuestionStatus.started : prev);

    _qStatus[questionId] = next;

    final snap = await _buildSnapshot(courseId);
    _controllers[courseId]?.add(snap);
  }

  Future<ProgressSnapshot> _buildSnapshot(String courseId) async {
    final Course course = await courseRepo.getCourse(courseId);

    final sections = <String, SectionProgress>{};
    final completedChallengeIds = <String>{};
    int totalChallenges = 0, doneChallenges = 0;

    for (final Section s in course.sections) {
      int sectionDone = 0;
      for (final Challenge c in s.challenges) {
        final allDone = c.questions.every((q) => statusOf(q.id).isDone);
        if (allDone) {
          sectionDone++;
          completedChallengeIds.add(c.id);
        }
      }

      sections[s.id] = SectionProgress(
        sectionId: s.id,
        completedChallenges: sectionDone,
        totalChallenges: s.challenges.length,
      );

      totalChallenges += s.challenges.length;
      doneChallenges  += sectionDone;
    }

    final percent = totalChallenges == 0 ? 0.0 : doneChallenges / totalChallenges;

    return ProgressSnapshot(
      courseId: course.id,
      sections: sections,
      completedChallengeIds: completedChallengeIds,
      coursePercent: percent,
    );
  }


}
