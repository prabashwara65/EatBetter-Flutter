import 'package:flutter/material.dart';
import 'package:animations/animations.dart'; // Import the animations package

class BannerView extends StatelessWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.55; // 70% of the screen height

    return Container(
      height: screenHeight, // Full height for the gradient background
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(126, 248, 100, 37),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          // Slide-in animated title
          const SlideInTitle(),
          const SizedBox(height: 20), // Spacing after the slide-in title

          // White container with the animated map
          Container(
            height: containerHeight,
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color to white
              borderRadius: BorderRadius.circular(16), // Optional: Add some border radius
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12, // Increased blur radius for a softer shadow
                  offset: Offset(0, 4), // Shadow offset
                  spreadRadius: 2, // Add spread radius for larger shadow effect
                ),
              ],
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  AnimatedMapView(), // Call the animated map widget
                  SizedBox(height: 20),
                  Text(
                    "Find restaurants near you",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Get distance to your favorite restaurants",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Filter based on your food preferences",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Top-rated restaurants",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Interactive Map View",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Explore restaurant photos",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/location_view');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 249, 93, 26),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "View Map",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Slide-in title animation widget
class SlideInTitle extends StatefulWidget {
  const SlideInTitle({Key? key}) : super(key: key);

  @override
  _SlideInTitleState createState() => _SlideInTitleState();
}

class _SlideInTitleState extends State<SlideInTitle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animation
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0.0, -1.0), // Start off-screen above
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 30, left:20),
        child: const Text(
          "Explore Your Favorite Restaurants",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

// AnimatedMapView widget remains unchanged
class AnimatedMapView extends StatefulWidget {
  const AnimatedMapView({Key? key}) : super(key: key);

  @override
  _AnimatedMapViewState createState() => _AnimatedMapViewState();
}

class _AnimatedMapViewState extends State<AnimatedMapView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duration of the fade-in effect
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation, // Apply fade-in effect
      child: Container(
        height: 150, // Set height for the map view
        width: double.infinity, // Full width
        decoration: BoxDecoration(
          color: Colors.white24, // Placeholder color for map
          borderRadius: BorderRadius.circular(16), // Optional: Add some border radius
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Placeholder for the map
            const Icon(
              Icons.map, // Placeholder icon for map
              color: Color.fromARGB(255, 7, 124, 220),
              size: 120, // Set the size of the icon
            ),
            Positioned(
              bottom: 20,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeIn,
                )),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.deepOrange,
                  size: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
