import 'package:flutter/material.dart';
import '../api/fetch_meals.dart';
import '../model/meal_block.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Recipes'),
        leading: SizedBox.shrink(),
      ),
      body: FutureBuilder<List<Meal>>(
        future: fetchMealsByCategory('Pasta'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recipes found'));
          }

          final meals = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: meals.map((meal) {
                return Container(
                  width: 200,
                  height: 250,
                  margin: EdgeInsets.all(8),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.network(
                              meal.imageUrl,
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              meal.name,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
