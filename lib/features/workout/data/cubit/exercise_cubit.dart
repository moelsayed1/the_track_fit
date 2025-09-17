import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/features/workout/domain/models/exercise.dart';
import 'package:the_track_fit/features/workout/domain/models/workout_type.dart';
import 'package:the_track_fit/features/workout/data/repositories/exercise_repository.dart';
import 'package:the_track_fit/features/store/data/services/favorites_service.dart';
import 'package:the_track_fit/core/services/api_service.dart';

// State class to hold exercises data
class ExerciseState {
  final List<Exercise> allExercises;
  final List<Exercise> favouriteExercises;
  final bool isLoading;
  final String? error;
  final String? selectedCategoryName;
  final String? selectedCategoryId;

  const ExerciseState({
    required this.allExercises,
    required this.favouriteExercises,
    this.isLoading = false,
    this.error,
    this.selectedCategoryName,
    this.selectedCategoryId,
  });

  ExerciseState copyWith({
    List<Exercise>? allExercises,
    List<Exercise>? favouriteExercises,
    bool? isLoading,
    String? error,
    String? selectedCategoryName,
    String? selectedCategoryId,
  }) {
    return ExerciseState(
      allExercises: allExercises ?? this.allExercises,
      favouriteExercises: favouriteExercises ?? this.favouriteExercises,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategoryName: selectedCategoryName ?? this.selectedCategoryName,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

// Cubit to manage exercises state
class ExerciseCubit extends Cubit<ExerciseState> {
  final ExerciseRepository _exerciseRepository;
  final FavoritesService _favoritesService;

  ExerciseCubit({required ExerciseRepository exerciseRepository})
      : _exerciseRepository = exerciseRepository,
        _favoritesService = FavoritesService(apiService: ApiService()),
        super(const ExerciseState(
          allExercises: [],
          favouriteExercises: [],
          isLoading: false,
        ));

  // Load all exercises from API
  Future<void> loadAllExercises() async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final exercises = await _exerciseRepository.getAllExercises();
      final favourites = exercises.where((exercise) => exercise.isFavorite).toList();
      
      emit(state.copyWith(
        allExercises: exercises,
        favouriteExercises: favourites,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  // Search exercises
  Future<void> searchExercises(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(allExercises: state.allExercises));
      return;
    }

    try {
      final searchResults = await _exerciseRepository.searchExercises(query);
      emit(state.copyWith(allExercises: searchResults));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Filter exercises by type
  Future<void> filterByType(String type) async {
    try {
      final filteredExercises = await _exerciseRepository.getExercisesByType(type);
      emit(state.copyWith(allExercises: filteredExercises));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Filter exercises by location
  Future<void> filterByLocation(String location) async {
    try {
      final filteredExercises = await _exerciseRepository.getExercisesByLocation(location);
      emit(state.copyWith(allExercises: filteredExercises));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Filter exercises by equipment
  Future<void> filterByEquipment(String equipment) async {
    try {
      final filteredExercises = await _exerciseRepository.getExercisesByEquipment(equipment);
      emit(state.copyWith(allExercises: filteredExercises));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Initialize with mock data - filter for favourite exercises
  void initializeFavourites(List<Exercise> allExercises) {
    final favourites = allExercises.where((exercise) => exercise.isFavorite).toList();
    emit(state.copyWith(favouriteExercises: favourites));
  }

  // Remove exercise from favourites
  void removeFromFavourites(String exerciseId) {
    final updatedFavourites = state.favouriteExercises
        .where((exercise) => exercise.id != exerciseId)
        .toList();
    emit(state.copyWith(favouriteExercises: updatedFavourites));
  }

  // Add exercise to favourites
  void addToFavourites(Exercise exercise) {
    if (!state.favouriteExercises.any((e) => e.id == exercise.id)) {
      final updatedFavourites = [...state.favouriteExercises, exercise];
      emit(state.copyWith(favouriteExercises: updatedFavourites));
    }
  }

  // Toggle favourite status
  Future<void> toggleFavourite(Exercise exercise) async {
    try {
      // Call the API to toggle favorite
      final wasAdded = await _favoritesService.toggleExerciseFavorite(int.parse(exercise.id));
      
      // Update local state based on API response
      if (wasAdded) {
        addToFavourites(exercise);
      } else {
        removeFromFavourites(exercise.id);
      }
    } catch (e) {
      // If API call fails, show error but don't update local state
      emit(state.copyWith(error: 'Failed to update favorite: $e'));
    }
  }

  // Check if exercise is favourite
  bool isFavourite(String exerciseId) {
    return state.favouriteExercises.any((exercise) => exercise.id == exerciseId);
  }

  // Get all favourite exercises
  List<Exercise> get favouriteExercises => state.favouriteExercises;

  // Get all exercises
  List<Exercise> get allExercises => state.allExercises;

  // Get exercise categories
  Future<List<WorkoutType>> getExerciseCategories() async {
    return await _exerciseRepository.getExerciseCategories();
  }

  // Filter exercises by category
  void filterByCategory(String categoryId, String categoryName) async {
    try {
      emit(state.copyWith(isLoading: true));
      
      // Get categories with exercises from API
      final categories = await _exerciseRepository.getExerciseCategories();
      
      // Find the selected category
      final selectedCategory = categories.firstWhere(
        (category) => category.id == categoryId,
        orElse: () => categories.first,
      );
      
      // Get exercises from the selected category
      final categoryExercises = selectedCategory.exercises ?? [];
      
      emit(state.copyWith(
        allExercises: categoryExercises,
        selectedCategoryId: categoryId,
        selectedCategoryName: categoryName,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  // Clear category filter
  void clearCategoryFilter() {
    emit(state.copyWith(
      selectedCategoryId: null,
      selectedCategoryName: null,
    ));
  }
}
