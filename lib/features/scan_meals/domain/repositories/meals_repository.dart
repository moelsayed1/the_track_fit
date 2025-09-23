import '../models/meals_response.dart';

abstract class MealsRepository {
  Future<MealsResponse> getMealsByDay(int dayId);
}
