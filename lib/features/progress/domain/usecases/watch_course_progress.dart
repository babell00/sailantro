import '../repositories/progress_repository.dart';

class WatchCourseProgress {
  final ProgressRepository repo;
  WatchCourseProgress(this.repo);

  Stream<ProgressSnapshot> call(String courseId) => repo.watchCourse(courseId);
}
