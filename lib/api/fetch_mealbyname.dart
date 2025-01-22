import '../model/meal_block.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Meal>> fetchMealsByName(String query) async {
  final response = await http.get(
    Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body)['meals'];
    return data.map((meal) => Meal.fromJson(meal)).toList();
  } else {
    throw Exception('Failed to load meals');
  }
}
