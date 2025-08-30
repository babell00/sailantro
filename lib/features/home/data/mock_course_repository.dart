import 'package:sailantro/features/home/data/test_data.dart';

import '../domain/entities/course.dart';
import '../domain/repository/course_repository.dart';

class MockCourseRepository implements CourseRepository {
  @override
  Future<Course> getCourse(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return testCourse;
  }
}