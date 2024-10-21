import 'package:eat_better/authFile/auth.dart';
import 'package:eat_better/authFile/login_register.dart';
import 'package:eat_better/authFile/widget_tree.dart';
import 'package:eat_better/pages/hasara/BannerView.dart';
import 'package:eat_better/pages/prabashwara/SuggestionsPage.dart';
import 'package:eat_better/pages/prabashwara/Preferences/preference_page.dart';
import 'package:eat_better/pages/recipe_search.dart';
import 'package:flutter/material.dart';
import 'prabashwara/Image_To_Text.dart';
import 'food_analysis.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Sign out method
  Future<void> signOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WidgetTree()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Auth().CurrentUser;
    String trimmedEmail = (user?.email ?? "User").split('@').first; // Trimmed email

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('EatBetter'),
        backgroundColor: const Color(0xFFF86A2E), // AppBar color
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Text(
                  trimmedEmail,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    signOut(context); // Sign out and navigate to login
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        // Apply gradient background
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Swappable View (showing 2 cards per page) with added margin
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Margin for the swap view container
                child: SizedBox(
                  height: 250, // Adjust height for the cards
                  child: PageView(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Expanded(child: _buildNavigationCard(
                              context,
                              'Text Scanner',
                              'Scan and extract text from images',
                              Icons.text_fields, // Updated icon
                              ImageToText(),
                              Colors.teal,
                              Color(0xFFF86A2E), // Border color
                              Colors.white, // Card background color
                            )),
                            Expanded(child: _buildNavigationCard(
                              context,
                              'Preferences',
                              'Explore and discover new recipes',
                              Icons.favorite, // Updated icon
                              UserPreferencePage(),
                              Colors.deepOrange,
                              Color(0xFF3498db), // Border color
                              Colors.white, // Card background color
                            )),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(child: _buildNavigationCard(
                              context,
                              'Recipe',
                              'Find Recipes',
                              Icons.receipt, // Updated icon
                              RecipeSearch(),
                              Colors.pinkAccent,
                              Color(0xFF27AE60), // Border color
                              Colors.white, // Card background color
                            )),
                            Expanded(child: _buildNavigationCard(
                              context,
                              'Map',
                              'Find Your restaurants',
                              Icons.map, // Updated icon
                              BannerView(),
                              Colors.grey,
                              Color(0xFF8E44AD), // Border color
                              Colors.white, // Card background color
                            )),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(child: _buildNavigationCard(
                              context,
                              'Food Analysis',
                              'Analyze the nutritional value of food',
                              Icons.analytics, // Existing icon
                              FoodAnalysis(),
                              Colors.blue,
                              Color(0xFFE67E22), // Border color
                              Colors.white, // Card background color
                            )),
                            Expanded(child: _buildNavigationCard(
                              context,
                              'Sample Card',
                              'Lorem ipsum',
                              Icons.help_outline, // Updated icon
                              FoodAnalysis(),
                              Colors.blue,
                              Color(0xFFE67E22), // Border color
                              Colors.white, // Card background color
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Image container displaying the personalized suggestions feature
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF90CAF9), // Creative background color
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.lightbulb_outline, // Suitable icon
                          size: 40, // Icon size
                          color: Colors.orange, // Icon color
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Personalized Suggestions',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8), // Space between title and description
                              Text(
                                'Get recommendations based on your preferences, helping you discover new foods and recipes you’ll love.',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // New Image container displaying the food analysis feature
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCC80), // Creative background color
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.food_bank, // Suitable icon for food analysis
                          size: 40, // Icon size
                          color: Colors.blue, // Icon color
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Food Analysis',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8), // Space between title and description
                              Text(
                                'Analyze the calories and nutritional values of the food you consume for a healthier lifestyle.',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card builder function
  Widget _buildNavigationCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Widget destination,
    Color iconColor,
    Color borderColor,
    Color backgroundColor, // Background color for the card
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2), // Custom card border color
        borderRadius: BorderRadius.circular(12.0), // Slightly rounded corners
      ),
      elevation: 8, // Card shadow
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0), // Matching border radius
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Container(
          // Set the background color for the card
          decoration: BoxDecoration(
            color: backgroundColor, // Card background color
            borderRadius: BorderRadius.circular(12.0), // Rounded corners for card background
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50, // Icon size
                  color: iconColor, // Icon color
                ),
                const SizedBox(height: 12), // Space between icon and title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16, // Title size
                    fontWeight: FontWeight.bold, // Title weight
                  ),
                ),
                const SizedBox(height: 4), // Space between title and subtitle
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14, // Subtitle size
                    color: Colors.black54, // Subtitle text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
