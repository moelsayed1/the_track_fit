import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/features/workout/data/cubit/exercise_cubit.dart';
import 'package:the_track_fit/features/workout/data/repositories/exercise_repository.dart';
import 'package:the_track_fit/features/workout/presentation/screens/workout_screen.dart';

class WorkoutScreenWrapper extends StatelessWidget {
  const WorkoutScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseCubit(
        exerciseRepository: ExerciseRepository(
          apiService: ApiService(),
        ),
      ),
      child: const WorkoutScreen(),
    );
  }
}
