import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sailantro/core/router/app_router.dart';
import 'package:sailantro/features/auth/data/firebase_auth_repository.dart';
import 'package:sailantro/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:sailantro/features/home/data/mock_course_repository.dart';
import 'package:sailantro/features/home/presentation/cubits/course_cubit.dart';
import 'package:sailantro/features/progress/data/test_data.dart';
import 'package:sailantro/features/progress/domain/usecases/get_question_status.dart';
import 'package:sailantro/features/progress/presentation/cubit/progress_cubit.dart';
import 'package:sailantro/features/progress/data/mock_progress_repository.dart';
import 'package:sailantro/features/progress/domain/usecases/record_answer.dart';
import 'package:sailantro/features/progress/domain/usecases/watch_course_progress.dart';
import 'package:sailantro/firebase_options.dart';
import 'package:sailantro/themes/dark_mode.dart';
import 'package:sailantro/themes/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  late final firebaseAuthRepo = FirebaseAuthRepository();
  late final courseRepo = MockCourseRepository();
  late final progressRepo = MockProgressRepository(courseRepo: courseRepo, initialStatuses: mockProgressSeed);
  late final watchProgress = WatchCourseProgress(progressRepo);
  late final recordAnswer = RecordAnswer(progressRepo);
  late final getQuestionStatus = GetQuestionStatus(progressRepo);

  final courseId = 'ray_day_skipper_theory';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepository: firebaseAuthRepo),
        ),
        BlocProvider<CourseCubit>(
          create: (_) =>
              CourseCubit(repository: courseRepo, courseId: courseId),
        ),
        BlocProvider<ProgressCubit>(
          create: (_) => ProgressCubit(
            watchCourse: watchProgress,
            record: recordAnswer,
            courseId: courseId,
            getStatus: getQuestionStatus,
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final authCubit = context.read<AuthCubit>();
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router(authCubit),
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: ThemeMode.light,
          );
        },
      ),
    );
  }
}
