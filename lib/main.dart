import 'package:eat_better/authFile/widget_tree.dart';
import 'package:eat_better/pages/hasara/BannerView.dart';
import 'package:eat_better/pages/prabashwara/SuggestionsPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eat_better/pages/prabashwara/consts.dart';
import 'package:eat_better/pages/prabashwara/Image_To_Text.dart';
import 'package:eat_better/pages/home_page.dart';
import 'package:eat_better/pages/food_analysis.dart';
import 'package:eat_better/pages/recipe_search.dart';
import 'package:eat_better/pages/hasara/location_view.dart';
import 'package:eat_better/pages/saved_recipes.dart';
import 'package:eat_better/navigation_menu.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:eat_better/splash_screen.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized(); // Ensures that all bindings are initialized

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: '//api key',
      appId: '1:575093771566:android:dd600c74ae2b6198493ebf',
      messagingSenderId: 'sendid',
      projectId: 'eatbetter-45ca5',
    ),
  ); 

  Gemini.init(apiKey: GEMINI_API_KEY); //  initialization of Gemini

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/navigation': (context) => const NavigationMenu(),
        '/home': (context) => const HomePage(),
        '/recipe_search': (context) => const RecipeSearch(),
        '/food_analysis': (context) => const FoodAnalysis(),
        '/location_view': (context) => const LocationView(),
        './banner_view' : (context) => const BannerView(),
        '/saved_recipes': (context) => const SavedRecipes(),
        '/image_to_text': (context) => const ImageToText(),
        '/suggestions_page': (context) =>  const SuggestionsPage(extractedText: '',),
        '/widget_tree': (context) => const WidgetTree(), // Add WidgetTree route as login
      },
    ),
  );
}
