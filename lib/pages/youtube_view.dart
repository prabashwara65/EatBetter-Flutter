import 'package:eat_better/pages/widgets/youtube_thumbnail_card.dart';
import 'package:flutter/material.dart';
import 'package:eat_better/services/youtube_api_service.dart'; // Import the YouTubeService to fetch data
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VideoThumbnailScreen extends StatefulWidget {
  final int id;
  final String name;

  const VideoThumbnailScreen({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  _VideoThumbnailScreenState createState() => _VideoThumbnailScreenState();
}

class _VideoThumbnailScreenState extends State<VideoThumbnailScreen> {
  late YouTubeService _youtubeService;
  late Future<List<YouTubeVideo>> _videoList;

  @override
  void initState() {
    super.initState();
    _youtubeService = YouTubeService();
    _videoList =
        _youtubeService.fetchVideos(widget.name); // Sample search query
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Youtube Videos Suggestions')),
        backgroundColor: Color.fromARGB(126, 248, 100, 37),
        leading: IconButton(
          iconSize: 30,
          icon: Image.asset('assets/icons/BackButton.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
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
        child: FutureBuilder<List<YouTubeVideo>>(
          future: _videoList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitFadingCircle(
                  color: Color.fromARGB(192, 187, 5, 5),
                  size: 50.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No videos found'));
            } else {
              final videos = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return Column(
                    children: [
                      VideoCard(
                        videoUrl:
                            'https://www.youtube.com/watch?v=${video.videoId}',
                        thumbnailUrl: video.thumbnailUrl,
                        title: video.title,
                        description: video.description,
                      ),
                      SizedBox(height: 16), // Add space between cards
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
