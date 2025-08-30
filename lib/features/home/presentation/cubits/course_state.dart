import '../../domain/entities/course.dart';

abstract class CourseState {}
class CourseInitial extends CourseState {}
class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final Course course;
  CourseLoaded(this.course);
}

class CourseError extends CourseState {
  final String message;
  CourseError(this.message);
}

