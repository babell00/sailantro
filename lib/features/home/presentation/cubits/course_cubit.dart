import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/course_repository.dart';
import 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository repository;
  final String courseId;

  CourseCubit({
    required this.repository,
    required this.courseId,
  }) : super(CourseLoading()) {
    _init();
  }

  void _init() {
    loadCourse(courseId);
  }

  Future<void> loadCourse(String id) async {
    emit(CourseLoading());
    try {
      final course = await repository.getCourse(id);
      emit(CourseLoaded(course));
    } catch (e) {
      emit(CourseError("Failed to load course: $e"));
    }
  }
}