import 'package:sailantro/features/progress/domain/entities/progress_types.dart';

final mockProgressSeed = <String, QuestionStatus>{
  'q_lifejackets_required': QuestionStatus.mastered,
  'q_liferaft_check': QuestionStatus.mastered,
  'q_ppe_match': QuestionStatus.mastered,
  'q_safety_multi': QuestionStatus.notStarted,

  'q_distress_flare': QuestionStatus.mastered,
  'q_mayday_order': QuestionStatus.notStarted,
};
