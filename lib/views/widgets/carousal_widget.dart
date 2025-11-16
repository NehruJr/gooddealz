import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MediaItem {
  final String url;
  final bool isVideo;
  final String? thumbnailUrl;

  MediaItem({
    required this.url,
    required this.isVideo,
    this.thumbnailUrl,
  });

  // Factory constructor to parse from API response
  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      url: json['url'] ?? '',
      isVideo: json['is_video'] == true,
      thumbnailUrl: json['thumbnail_url'],
    );
  }
}

class MediaCarouselWidget extends StatefulWidget {
  const MediaCarouselWidget({
    super.key,
    required this.mediaItems,
    this.height,
    this.width,
  });

  final List<MediaItem> mediaItems;
  final double? height;
  final double? width;

  @override
  State<MediaCarouselWidget> createState() => _MediaCarouselWidgetState();
}

class _MediaCarouselWidgetState extends State<MediaCarouselWidget> {
  late PageController _pageController;
  int _currentIndex = 0;
  final Map<int, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    for (int i = 0; i < widget.mediaItems.length; i++) {
      if (widget.mediaItems[i].isVideo) {
        try {
          final controller = VideoPlayerController.networkUrl(
            Uri.parse(widget.mediaItems[i].url),
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
              allowBackgroundPlayback: false,
            ),
          );
          _videoControllers[i] = controller;

          controller.initialize().then((_) {
            if (mounted && i == _currentIndex) {
              setState(() {});
            }
          }).catchError((error) {
            print('Error initializing video at index $i: $error');
            // Remove failed controller
            if (mounted) {
              setState(() {
                _videoControllers.remove(i);
              });
            }
          });
        } catch (e) {
          print('Error creating video controller at index $i: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      // Pause previous video if it exists
      if (_videoControllers.containsKey(_currentIndex)) {
        _videoControllers[_currentIndex]?.pause();
      }

      _currentIndex = index;

      // Auto-play current video if it exists
      if (_videoControllers.containsKey(index)) {
        _videoControllers[index]?.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaItems.isEmpty) {
      return Container(
        height: widget.height ?? 100,
        width: widget.width ?? 200,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: widget.height ?? 200,
      width: widget.width ?? double.infinity,
      child: Stack(
        children: [
          // PageView for media items
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: widget.mediaItems.length,
            itemBuilder: (context, index) {
              final mediaItem = widget.mediaItems[index];

              if (mediaItem.isVideo) {
                return _VideoPlayerWidget(
                  controller: _videoControllers[index],
                  thumbnailUrl: mediaItem.thumbnailUrl,
                );
              } else {
                return FancyShimmerImage(
                  imageUrl: mediaItem.url,
                  boxFit: BoxFit.cover,
                  errorWidget: Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                );
              }
            },
          ),

          // Media type indicator
          if (widget.mediaItems.length > 1)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.mediaItems[_currentIndex].isVideo
                          ? Icons.videocam
                          : Icons.image,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_currentIndex + 1}/${widget.mediaItems.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Page indicator dots
          if (widget.mediaItems.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.mediaItems.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Theme.of(context).primaryColor,
                    dotColor: Colors.white.withOpacity(0.5),
                    spacing: 8,
                  ),
                  onDotClicked: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VideoPlayerWidget extends StatefulWidget {
  const _VideoPlayerWidget({
    required this.controller,
    this.thumbnailUrl,
  });

  final VideoPlayerController? controller;
  final String? thumbnailUrl;

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  bool _isPlaying = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_videoListener);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_videoListener);
    super.dispose();
  }

  void _videoListener() {
    if (mounted) {
      final controller = widget.controller;
      if (controller != null) {
        if (controller.value.hasError) {
          setState(() {
            _hasError = true;
            _errorMessage = controller.value.errorDescription;
          });
        } else {
          setState(() {
            _isPlaying = controller.value.isPlaying;
          });
        }
      }
    }
  }

  void _togglePlayPause() {
    if (widget.controller == null || _hasError) return;

    setState(() {
      if (widget.controller!.value.isPlaying) {
        widget.controller!.pause();
      } else {
        widget.controller!.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show error state
    if (_hasError || (widget.controller?.value.hasError ?? false)) {
      return Stack(
        fit: StackFit.expand,
        children: [
          if (widget.thumbnailUrl != null)
            FancyShimmerImage(
              imageUrl: widget.thumbnailUrl!,
              boxFit: BoxFit.cover,
            )
          else
            Container(
              color: Colors.grey[900],
            ),
          Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Unable to load video',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Show loading state
    if (widget.controller == null || !widget.controller!.value.isInitialized) {
      return Stack(
        fit: StackFit.expand,
        children: [
          if (widget.thumbnailUrl != null)
            FancyShimmerImage(
              imageUrl: widget.thumbnailUrl!,
              boxFit: BoxFit.cover,
            )
          else
            Container(
              color: Colors.black,
            ),
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: widget.controller!.value.aspectRatio,
                child: VideoPlayer(widget.controller!),
              ),
            ),
          ),
          // Play/Pause overlay
          if (!_isPlaying)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          // Video progress indicator
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoProgressIndicator(
              widget.controller!,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Theme.of(context).primaryColor,
                bufferedColor: Colors.white.withOpacity(0.3),
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}
