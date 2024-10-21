import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodService {
  // API key for Spoonacular API, rapid api. for limit the calls i have add an extra number to the end of the key
  //to get this fetch function to work. remove the last integer from the api key
  static String apiKey = '//api key';

  // Cache to store fetched recipes by name
  static Map<String, List<Map<String, dynamic>>> _cache = {};

  //this function is used to get the recipe for the food item.
  //when call this function have to pass the name of the food. it will fetch upto 3 items for the food item.
  //tochange the number of items to fetch change the number in the apiEndpointUrl
  //if the data is already cached it will return the cached data. if not it will fetch the data from the api and store it in the cache.
  //if the api call fails it will return an empty list.
  //the fetched data will be returned as a list of maps.
  //each map will contain the details of the recipe.
  //the details will contain the id, title, image, imageType;
  //the id is the id of the recipe.
  //the title is the title of the recipe.
  //the image is the image of the recipe.
  //the imageType is the type of the image.
  //to use this function call FoodService.getRecipeForCommons('food item name');
  //it will return a future of list of maps.
  //to get the data from the future use snapshot.data.
  //to et the data from the snapshot, use snapshot.data[index],
  //Map<String, dynamic> snap = snapshot.data![index];
  //String title = snap['title'];
  //int id = snap['id'];
  //String image = snap['image'];
  //String imageType = snap['imageType'];
  //see the example in the HomeTabBarView class in the common_tab.dart file.
  static Future<List<Map<String, dynamic>>> getRecipeForCommons(
      String name) async {
    // Convert the name to lowercase to standardize cache keys.
    String formattedName = name.toLowerCase();

    // Check if the data for the recipe name is already cached.
    if (_cache.containsKey(formattedName)) {
      print('Returning cached data for $name');
      // Return cached data if available.
      return _cache[formattedName]!;
    }

    // If data is not cached, proceed with the API call.
    String apiEndpointUrl =
        'https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?query=$name&number=5';
    List<Map<String, dynamic>> recipes = [];

    // Make the API request.
    final response = await http.get(
      Uri.parse(apiEndpointUrl),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host':
            'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
      },
    );

    // Check if the response is successful.
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Parse the results and store them in the recipes list.
      if (data['results'] != null) {
        for (var result in data['results']) {
          recipes.add(result);
        }
      }

      // Store the fetched data in the cache for future use.
      _cache[formattedName] = recipes;

      print('Fetched data from API for $name and cached it.');
      // Return the fetched data.
      return recipes;
    }

    // If the API call fails, return an empty list.
    print('Failed to fetch data from API for $name.');
    return recipes;
  }

  // New Function: Fetch Nutrition Data for a specific recipe ID
  static Future<Map<String, dynamic>> getNutritionData(int recipeId) async {
    String apiEndpointUrl =
        'https://api.spoonacular.com/recipes/$recipeId/nutritionWidget.json';

    // Send the GET request to the API
    final response = await http.get(
      Uri.parse(apiEndpointUrl),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host':
            'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
      },
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Log the response body for debugging
      print('Response body: ${response.body}');

      // Parse the response
      final data = jsonDecode(response.body);

      // Return the full fetched nutritional data as is
      print('Fetched nutrition data for recipe ID: $data');
      return data;
    } else {
      // Handle failure by logging the error and returning empty data
      print('Failed to fetch nutrition data for recipe ID: $recipeId');
      print('Error: ${response.statusCode} - ${response.reasonPhrase}');

      // Return a map with 'N/A' values to indicate no data
      return {
        'calories': 'N/A',
        'carbs': 'N/A',
        'fat': 'N/A',
        'protein': 'N/A',
        'bad': [], // Include 'bad' key as well
      };
    }
  }

  // Fetch Ingredient Data for a specific recipe ID
  // Fetch recipe information details with caching
  static Future<Map<String, dynamic>> getRecipeDetails(int recipeId) async {
    Map<int, Map<String, dynamic>> _recipeDetailsCache = {};
    // Check if the recipe details are already cached
    if (_recipeDetailsCache.containsKey(recipeId)) {
      print('Returning cached recipe details for recipe ID: $recipeId');
      return _recipeDetailsCache[recipeId]!;
    }

    // If not cached, proceed with API call
    String apiEndpointUrl =
        'https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/$recipeId/information';

    final response = await http.get(
      Uri.parse(apiEndpointUrl),
      headers: {
        'x-rapidapi-key': apiKey,
        'x-rapidapi-host':
            'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Cache the fetched recipe details
      _recipeDetailsCache[recipeId] = data;

      print('Fetched and cached recipe details for recipe ID: $recipeId');
      return data;
    } else {
      print('Failed to fetch recipe details for recipe ID: $recipeId');
      print('Error: ${response.statusCode} - ${response.reasonPhrase}');

      // Return fallback data if the API call fails
      return {
        'title': 'N/A',
        'summary': 'N/A',
        'instructions': 'N/A',
        'image': 'N/A',
      };
    }
  }
}
