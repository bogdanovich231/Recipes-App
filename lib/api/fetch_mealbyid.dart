import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/meal_block.dart';

Future<Meal> fetchMealById(String idMeal) async {
  final response = await http.get(Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idMeal'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final mealData = data['meals'][0];
    return Meal.fromJson(mealData);
  } else {
    throw Exception('Failed to load meal');
  }
}
