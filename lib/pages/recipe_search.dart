import 'package:eat_better/services/food_api_service.dart';
import 'package:flutter/material.dart';
import 'package:eat_better/pages/widgets/recipe_card.dart';
import 'package:eat_better/pages/recipe_in_detail.dart'; // Import the new screen

class RecipeSearch extends StatefulWidget {
  const RecipeSearch({super.key});

  @override
  State<RecipeSearch> createState() => _RecipeSearchState();
}

class _RecipeSearchState extends State<RecipeSearch> {
  List<Map<String, dynamic>> recipes = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchRecipes('spaghetti'); // Default search query
  }

  Future<void> _searchRecipes(String query) async {
    setState(() {
      isLoading = true; // Show loading while fetching
    });
    recipes = await FoodService.getRecipeForCommons(query);
    setState(() {
      isLoading = false; // Hide loading after fetch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Text('Recipe Search'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(126, 248, 100, 37), // Orange
              Colors.white, // White
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for recipes...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _searchRecipes(_searchController.text);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onSubmitted: (query) {
                  _searchRecipes(query);
                },
              ),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Navigate to RecipeDetailScreen and pass the recipe ID or other data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetail(
                                  // recipe: {
                                  //   'id': '1',
                                  //   'title': recipes[index]['title'],
                                  //   'cookTime': '20 mins',
                                  //   'rating': '4.8',
                                  //   'image': recipes[index]['image'],
                                  // },
                                  recipeId: recipes[index]['id'],
                                  // recipeId: recipes[index],
                                  //     ['id'], // Pass the recipe ID
                                ),
                              ),
                            );
                          },
                          child: RecipeCard(
                            title: recipes[index]['title'],
                            cookTime: '30 mins',
                            rating: '4.5',
                            thumbnailUrl: recipes[index]['image'],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
