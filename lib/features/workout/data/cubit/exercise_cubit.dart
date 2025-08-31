import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/features/workout/domain/models/exercise.dart';

// State class to hold the favourite exercises
class ExerciseState {
  final List<Exercise> favouriteExercises;

  const ExerciseState({required this.favouriteExercises});

  ExerciseState copyWith({List<Exercise>? favouriteExercises}) {
    return ExerciseState(
      favouriteExercises: favouriteExercises ?? this.favouriteExercises,
    );
  }
}

// Cubit to manage favourite exercises state
class ExerciseCubit extends Cubit<ExerciseState> {
  ExerciseCubit() : super(const ExerciseState(favouriteExercises: []));

  // Initialize with mock data - filter for favourite exercises
  void initializeFavourites(List<Exercise> allExercises) {
    final favourites = allExercises.where((exercise) => exercise.isFavorite).toList();
    emit(ExerciseState(favouriteExercises: favourites));
  }

  // Remove exercise from favourites
  void removeFromFavourites(String exerciseId) {
    final updatedFavourites = state.favouriteExercises
        .where((exercise) => exercise.id != exerciseId)
        .toList();
    emit(ExerciseState(favouriteExercises: updatedFavourites));
  }

  // Add exercise to favourites
  void addToFavourites(Exercise exercise) {
    if (!state.favouriteExercises.any((e) => e.id == exercise.id)) {
      final updatedFavourites = [...state.favouriteExercises, exercise];
      emit(ExerciseState(favouriteExercises: updatedFavourites));
    }
  }

  // Toggle favourite status
  void toggleFavourite(Exercise exercise) {
    if (state.favouriteExercises.any((e) => e.id == exercise.id)) {
      removeFromFavourites(exercise.id);
    } else {
      addToFavourites(exercise);
    }
  }

  // Check if exercise is favourite
  bool isFavourite(String exerciseId) {
    return state.favouriteExercises.any((exercise) => exercise.id == exerciseId);
  }

  // Get all favourite exercises
  List<Exercise> get favouriteExercises => state.favouriteExercises;
}
