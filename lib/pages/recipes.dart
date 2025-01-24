import 'package:flutter/material.dart';
import '../api/fetch_meals.dart';
import '../api/fetch_mealbyname.dart';
import '../model/meal_block.dart';
import 'package:recipes/widgets/search_bar.dart' as custom;

import 'recipe_detail.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  String query = '';
  Future<List<Meal>>? searchResults;

  void handleSearch(String value) {
    setState(() {
      query = value;
      if (query.isNotEmpty) {
        searchResults = fetchMealsByName(query);
      } else {
        searchResults = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Recipes',
          style: TextStyle(color: Colors.black),
        ),
        leading: SizedBox.shrink(),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            custom.SearchBar(
              onSearch: handleSearch,
            ),
            query.isNotEmpty
                ? buildSearchResults()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRecipeSection(context, 'Pasta', 'Pastes', query),
                      buildRecipeSection(
                          context, 'Seafood', 'Seafood Delights', query),
                      buildRecipeSection(
                          context, 'Chicken', 'Chicken Recipes', query),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget MealCard(Meal meal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailPage(mealId: meal.idMeal),
          ),
        );
      },
      child: Container(
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearchResults() {
    return FutureBuilder<List<Meal>>(
      future: searchResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No results for "$query".',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final meals = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Search Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: meals.map((meal) {
                    return MealCard(meal);
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildRecipeSection(
      BuildContext context, String category, String title, String query) {
    return FutureBuilder<List<Meal>>(
      future: fetchMealsByCategory(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No recipes found for $category'));
        }

        final meals = snapshot.data!
            .where(
                (meal) => meal.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (meals.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No results for "$query" in $title.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: meals.map((meal) {
                  return MealCard(meal);
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
