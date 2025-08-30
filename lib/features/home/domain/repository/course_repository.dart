import '../entities/course.dart';

abstract class CourseRepository {
  Future<Course> getCourse(String courseId);
}