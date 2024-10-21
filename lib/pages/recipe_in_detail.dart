import 'package:eat_better/pages/widgets/circle_button.dart';
import 'package:eat_better/pages/widgets/custom_clip_path.dart';
import 'package:eat_better/pages/widgets/ingredient_item.dart';
import 'package:eat_better/pages/youtube_view.dart';
import 'package:eat_better/services/food_api_service.dart';
import 'package:flutter/material.dart';
import 'dart:core';

Map<String, dynamic> details = {}; // Store the recipe details

class RecipeDetail extends StatefulWidget {
  final int recipeId;
  const RecipeDetail({super.key, required this.recipeId});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchRecipeDetail(widget.recipeId);
  }

  Future<void> fetchRecipeDetail(int id) async {
    try {
      details = await FoodService.getRecipeDetails(id);
      setState(() {
        isLoading = false; // Set isLoading to false after data is loaded
      });
    } catch (error) {
      // Handle errors here
      print('Error fetching recipe details: $error');
      setState(() {
        isLoading = false; // Even if there's an error, stop the loading state
      });
    }
  }

  // Utility function to remove HTML tags from the instructions
  String removeHtmlTags(String htmlString) {
    RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey.shade300,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading spinner
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: h * .44,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(details['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * .04),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: h * .45,
                            ),
                            Text(
                              details['title'] ?? 'Recipe Title',
                              style: TextStyle(
                                  fontSize: w * 0.06,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${details['preparationMinutes'].toString()} minutes",
                              style: TextStyle(
                                  fontSize: w * 0.045,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.8)),
                            ),
                            SizedBox(
                              height: h * .02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleButton(
                                  icon: Icons.analytics_outlined,
                                  label: 'Nutrition\nDetails',
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoThumbnailScreen(
                                                  id: widget.recipeId,
                                                  name: details['title'],
                                                )));
                                  },
                                  child: CircleButton(
                                    icon: Icons.video_library_outlined,
                                    label: 'Youtube\nTutorials',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: h * .02,
                            ),
                            Container(
                              height: h * .07,
                              width: w,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ClipPath(
                                      clipper: CustomClipPath(),
                                      child: Container(
                                        color: Colors.redAccent,
                                        child: Center(
                                          child: Text(
                                            'Ingredients Required',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: w * .05,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.white,
                                      child: Center(
                                        child: Text(
                                          details['extendedIngredients']
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: w * 0.045,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: h *
                                  0.3, // Constrain the height of the scrollable list
                              child: ListView.builder(
                                shrinkWrap:
                                    true, // Allows the list to be wrapped inside the Column
                                itemCount:
                                    details['extendedIngredients'].length,
                                itemBuilder: (context, index) {
                                  return IngredientItem(
                                    quantity: details['extendedIngredients']
                                            [index]['amount']
                                        .toStringAsFixed(
                                            2), // Keeps decimal precision
                                    measure: details['extendedIngredients']
                                            [index]['unit'] ??
                                        '',
                                    name: details['extendedIngredients'][index]
                                            ['name'] ??
                                        '',
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: h * .02,
                            ),
                            Container(
                              height: h * .07,
                              width: w,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: ClipPath(
                                      clipper: CustomClipPath(),
                                      child: Container(
                                        color: Colors.redAccent,
                                        child: Center(
                                          child: Text(
                                            'Instructions',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: w * .05,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Colors.white,
                                      child: Center(
                                        child: Text(
                                          details['extendedIngredients']
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: w * 0.045,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Displaying the instructions as a single paragraph
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                removeHtmlTags(details['instructions'] ??
                                    'No instructions found.'),
                                style: TextStyle(
                                  fontSize: w * 0.045,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: h * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Add more content below the image as needed
                ],
              ),
            ),
    );
  }
}
