import '../model/meal_block.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Meal>> fetchMealsByCategory(String category) async {
  final response = await http.get(Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final meals = (data['meals'] as List)
        .map((mealData) => Meal.fromJson(mealData))
        .toList();
    return meals;
  } else {
    throw Exception('Failed to load meals');
  }
}
