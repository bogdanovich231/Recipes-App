class Meal {
  final String idMeal;
  final String name;
  final String strCategory;
  final String strInstructions;
  final String strMealThumb;
  final String strYoutube;
  final String imageUrl;

  Meal(
      {required this.idMeal,
      required this.name,
      required this.strCategory,
      required this.strInstructions,
      required this.strMealThumb,
      required this.strYoutube,
      required this.imageUrl});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      idMeal: json['idMeal'],
      name: json['strMeal'],
      strCategory: json['strCategory'] ?? 'Unknown',
      strInstructions: json['strInstructions'] ?? 'No instructions available',
      strMealThumb: json['strMealThumb'] ?? '',
      strYoutube: json['strYoutube'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
    );
  }
}
