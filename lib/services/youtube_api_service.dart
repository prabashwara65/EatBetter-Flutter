// youtube_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  final String _apiKey =
      '//api key'; // Replace with your actual YouTube API key
  final String _baseUrl = 'https://www.googleapis.com/youtube/v3/search';

  // This method fetches video data based on a search query.
  Future<List<YouTubeVideo>> fetchVideos(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?part=snippet&maxResults=10&q=$query&type=video&key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> items = jsonResponse['items'];

        List<YouTubeVideo> videos = items.map((item) {
          return YouTubeVideo.fromJson(item['id']['videoId'], item['snippet']);
        }).toList();

        return videos;
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (error) {
      print('Error fetching videos: $error');
      throw Exception('Error fetching videos');
    }
  }
}

// A model class to hold video data.
class YouTubeVideo {
  final String videoId;
  final String title;
  final String description;
  final String thumbnailUrl;

  YouTubeVideo({
    required this.videoId,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
  });

  // A method to create a YouTubeVideo object from JSON.
  factory YouTubeVideo.fromJson(String videoId, Map<String, dynamic> snippet) {
    return YouTubeVideo(
      videoId: videoId,
      title: snippet['title'],
      description: snippet['description'],
      thumbnailUrl: snippet['thumbnails']['high']
          ['url'], // Use high-quality thumbnail
    );
  }
}
