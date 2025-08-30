import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sailantro/features/home/presentation/components/home_view.dart';
import 'package:sailantro/features/home/presentation/cubits/course_cubit.dart';
import 'package:sailantro/features/home/presentation/cubits/course_state.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: const HomeBottomNav(),
      body: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading || state is CourseInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourseError) {
            return Center(child: Text(state.message));
          } else if (state is CourseLoaded) {
            return HomeView(course: state.course);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
