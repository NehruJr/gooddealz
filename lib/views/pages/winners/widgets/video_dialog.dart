import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:video_player/video_player.dart';

class VideoDialog extends StatefulWidget {
  final String videoUrl;
  final String videoBrief;

  const VideoDialog(
      {Key? key, required this.videoUrl, required this.videoBrief})
      : super(key: key);

  @override
  _VideoDialogState createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    print(widget.videoUrl);
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl)),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (pop) {
        if (flickManager.flickControlManager!.isFullscreen) {
          flickManager.flickControlManager!.exitFullscreen();
        }
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: FlickVideoPlayer(flickManager: flickManager),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MainText(
                  widget.videoBrief,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16,
                  color: AppColors.yBlackColor,
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("close".tr),
          ),
        ],
        actionsPadding: EdgeInsets.zero,
      ),
    );
  }
}
