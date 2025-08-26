import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/course_repository.dart';
import 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository repository;
  CourseCubit({required this.repository}) : super(CourseInitial());

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