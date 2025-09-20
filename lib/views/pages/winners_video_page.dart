import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../widgets/main_page.dart';

class WinnersVideoPage extends StatefulWidget {
  const WinnersVideoPage({super.key});

  @override
  State<WinnersVideoPage> createState() => _WinnersVideoPageState();
}

class _WinnersVideoPageState extends State<WinnersVideoPage> {

  final List<Map<String, String>> winners = [
    {
      'name': 'Ahmed Ashraf',
      'videoUrl': 'https://www.example.com/videos/winner1.mp4',
    },
    {
      'name': 'Sara Mohamed',
      'videoUrl': 'https://www.example.com/videos/winner2.mp4',
    },
    {
      'name': 'Ali Gamal',
      'videoUrl': 'https://www.example.com/videos/winner3.mp4',
    },
  ];

  final List<FlickManager> _flickManagers = [];

  @override
  void initState() {
    super.initState();

    for (var winner in winners) {
      _flickManagers.add(
        FlickManager(
          videoPlayerController: VideoPlayerController.networkUrl(
            Uri.parse(winner['videoUrl']!),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {




    return MainPage(
      title: 'Winners Videos',
      actionWidgets: const [
        Icon(Icons.emoji_events)
      ],
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: winners.length,
        itemBuilder: (context, index) {
          final winner = winners[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: FlickVideoPlayer(flickManager: _flickManagers[index]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.grey.shade100,
                  child: Text(
                    winner['name']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}