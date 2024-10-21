import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:eat_better/services/food_api_service.dart';
import 'package:eat_better/pages/nutri_details.dart';

class CommonTab extends StatelessWidget {
  const CommonTab({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: w * .09,
            child: TabBar(
              unselectedLabelColor: Color.fromARGB(248, 0, 0, 0),
              labelColor: Color.fromARGB(248, 255, 255, 255),
              dividerColor: Color.fromARGB(
                  0, 184, 184, 184), //making the divider transparent
              indicator: BoxDecoration(
                color: const Color.fromARGB(248, 246, 106, 46),
                borderRadius: BorderRadius.circular(10),
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: w * .012),
              tabs: const [
                TabItem(title: 'Rices'),
                TabItem(title: 'Pastas'),
                TabItem(title: 'Breads'),
                TabItem(title: 'Cereals'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // TabBarView
          SizedBox(
            height: h * .3,
            child: const TabBarView(
              children: [
                HomeTabBarView(recipe: 'rice'),
                HomeTabBarView(recipe: 'pasta'),
                HomeTabBarView(recipe: 'bread'),
                HomeTabBarView(recipe: 'cereal'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String title;
  const TabItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 9.8),
            ),
          )),
    );
  }
}

class HomeTabBarView extends StatelessWidget {
  final String recipe;
  const HomeTabBarView({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return SizedBox(
      height: h * 0.35, // height for the list view
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: FoodService.getRecipeForCommons(recipe),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No data available'),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              Map<String, dynamic> snap = snapshot.data![index];
              String title = snap['title'];
              int id = snap[
                  'id']; // Assuming you have an 'id' field in your snapshot data
              String imageUrl = snap['image'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NutriDetails(
                        id: id,
                        imageUrl: imageUrl, // Pass the imageUrl here
                      ),
                    ),
                  );
                },
                child: Container(
                  width: w * 0.35, // Adjusted the width to avoid overflow
                  margin: EdgeInsets.only(right: w * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: w * 0.33, // Adjust the width to fit properly
                        height: h * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit
                                .cover, // cover to maintain image aspect ratio
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      Text(
                        title,
                        softWrap: true, // Enable text wrapping
                        maxLines:
                            2, // Set the maximum number of lines for wrapping
                        overflow: TextOverflow
                            .visible, // Text will wrap instead of overflowing
                        style: TextStyle(
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                    ],
                  ),
                ),
              );
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}
