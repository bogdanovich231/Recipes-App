class Meal {
  final String name;
  final String imageUrl;

  Meal({required this.name, required this.imageUrl});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['strMeal'] ?? 'Unknown',
      imageUrl: json['strMealThumb'] ?? '',
    );
  }
}
