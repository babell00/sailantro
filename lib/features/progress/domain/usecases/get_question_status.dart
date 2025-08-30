import 'package:sailantro/features/progress/domain/entities/progress_types.dart';
import 'package:sailantro/features/progress/domain/repositories/progress_repository.dart';

class GetQuestionStatus {
  final ProgressRepository repo;
  GetQuestionStatus(this.repo);

  QuestionStatus call(String questionId) => repo.statusOf(questionId);
}
