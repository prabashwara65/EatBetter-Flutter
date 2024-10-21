import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Reusable VideoCard Widget
class VideoCard extends StatelessWidget {
  final String thumbnailUrl; // URL of the video thumbnail
  final String title; // Title of the video
  final String description; // Description of the video (optional)
  final String videoUrl; // YouTube video URL

  // Constructor to accept values
  const VideoCard({
    super.key,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.videoUrl, // Accept video URL as a parameter
  });

  // Function to launch the YouTube URL
  Future<void> _launchURL() async {
    Uri url = Uri.parse(videoUrl); // Parse the video URL

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $videoUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adds shadow for a card-like effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              width: double.infinity, // Full width of the card
              height: 150, // Fixed height for the thumbnail
            ),
          ),
          // Video Title and Description (if needed)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          // Displaying the clickable link
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: _launchURL, // Launch the video URL when tapped
              child: Text(
                videoUrl,
                style: const TextStyle(
                  color: Colors.blue, // Blue color to indicate it's a link
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
