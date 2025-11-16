import 'dart:async';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/data/models/banner_model.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:video_player/video_player.dart';

enum TextPosition {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

enum IndicatorStyle {
  dotted,
  line,
  circle,
  number,
}

class BannerMediaItem {
  final String url;
  final bool isVideo;
  final String? thumbnailUrl;
  final String? text;
  final String? backgroundImage;

  BannerMediaItem({
    required this.url,
    required this.isVideo,
    this.thumbnailUrl,
    this.text,
    this.backgroundImage,
  });
}

class BannerWidget extends StatefulWidget {
  const BannerWidget({
    super.key,
    required this.bannerModels,
    this.textPosition = TextPosition.bottomLeft,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.showIndicator = true,
    this.indicatorPosition = Alignment.bottomCenter,
    this.borderRadius = 22,
    this.elevation = 4.0,
    this.showGradient = true,
    this.indicatorStyle = IndicatorStyle.dotted,
    this.viewportFraction = 0.95,
  });

  final List<BannerModel> bannerModels;
  final TextPosition textPosition;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final bool showIndicator;
  final Alignment indicatorPosition;
  final double borderRadius;
  final double elevation;
  final bool showGradient;
  final IndicatorStyle indicatorStyle;
  final double viewportFraction;

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late PageController _pageController;
  int currentIndex = 0;
  Timer? _autoPlayTimer;
  bool _isUserSwiping = false;
  double _dragDistance = 0.0;
  final Map<int, VideoPlayerController> _videoControllers = {};
  final List<BannerMediaItem> _bannerMedia = [];

  @override
  void initState() {
    super.initState();
    _initializeBannerMedia();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
    _initializeVideoControllers();
    if (widget.autoPlay && _bannerMedia.isNotEmpty) {
      _startAutoPlay();
    }
  }

  void _initializeBannerMedia() {
    // Convert banner models to media items
    for (var banner in widget.bannerModels) {
      final bannerData = banner.data?.banner;
      if (bannerData != null) {
        final isVideo = bannerData.isVideo ?? false;
        _bannerMedia.add(BannerMediaItem(
          url: isVideo 
              ? (bannerData.mainSliderVideo ?? '') 
              : (bannerData.mainSliderImage ?? ''),
          isVideo: isVideo,
          text: bannerData.mainSliderText,
          backgroundImage: bannerData.mainSliderBackgroundImage,
          thumbnailUrl: bannerData.videoThumbnail,
        ));
      }
    }

    // Add test video (you can remove this in production)
    _bannerMedia.add(BannerMediaItem(
      url: 'https://www.w3schools.com/tags/mov_bbb.mp4',
      isVideo: true,
      text: 'Sample Video Banner',
      thumbnailUrl: null,
    ));
  }

  void _initializeVideoControllers() {
    for (int i = 0; i < _bannerMedia.length; i++) {
      if (_bannerMedia[i].isVideo) {
        try {
          final controller = VideoPlayerController.networkUrl(
            Uri.parse(_bannerMedia[i].url),
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
              allowBackgroundPlayback: false,
            ),
          );
          _videoControllers[i] = controller;

          controller.setLooping(true);
          controller.setVolume(0); // Mute banner videos

          controller.initialize().then((_) {
            if (mounted && i == currentIndex) {
              setState(() {});
              controller.play();
            }
          }).catchError((error) {
            print('Error initializing banner video at index $i: $error');
            if (mounted) {
              setState(() {
                _videoControllers.remove(i);
              });
            }
          });
        } catch (e) {
          print('Error creating banner video controller at index $i: $e');
        }
      }
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (mounted && _bannerMedia.isNotEmpty && !_isUserSwiping) {
        final nextPage = (currentIndex + 1) % _bannerMedia.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  void _restartAutoPlay() {
    if (widget.autoPlay && _bannerMedia.isNotEmpty) {
      _startAutoPlay();
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      // Pause previous video
      if (_videoControllers.containsKey(currentIndex)) {
        _videoControllers[currentIndex]?.pause();
      }

      currentIndex = index;

      // Play current video
      if (_videoControllers.containsKey(index)) {
        _videoControllers[index]?.play();
      }
    });
    _restartAutoPlay();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _isUserSwiping = true;
    _dragDistance = 0.0;
    _stopAutoPlay();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragDistance += details.primaryDelta ?? 0.0;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _isUserSwiping = false;

    const double swipeThreshold = 50.0;
    const double velocityThreshold = 100.0;

    final double velocity = details.primaryVelocity ?? 0.0;
    final double dragDistance = _dragDistance.abs();

    if (dragDistance > swipeThreshold || velocity.abs() > velocityThreshold) {
      if (_dragDistance > 0) {
        _goToPreviousPage();
      } else {
        _goToNextPage();
      }
    }

    _restartAutoPlay();
  }

  void _goToNextPage() {
    if (_bannerMedia.isEmpty) return;

    final nextIndex = (currentIndex + 1) % _bannerMedia.length;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    if (_bannerMedia.isEmpty) return;

    final previousIndex = (currentIndex - 1) % _bannerMedia.length;
    _pageController.animateToPage(
      previousIndex >= 0 ? previousIndex : _bannerMedia.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerMedia.isEmpty) {
      return _buildPlaceholder();
    }

    return Container(
      height: 250,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: widget.elevation,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: GestureDetector(
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _bannerMedia.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final mediaItem = _bannerMedia[index];
                    return _buildBannerItem(
                      context,
                      mediaItem: mediaItem,
                      index: index,
                      isActive: index == currentIndex,
                    );
                  },
                ),
                if (widget.showGradient) _buildGradientOverlay(),
                if (widget.showIndicator && _bannerMedia.length > 1)
                  _buildIndicatorWithText(),
                // Video icon indicator
                if (_bannerMedia[currentIndex].isVideo)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerItem(
    BuildContext context, {
    required BannerMediaItem mediaItem,
    required int index,
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.all(isActive ? 0 : 4),
      curve: Curves.easeInOut,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: mediaItem.isVideo
            ? _buildVideoItem(index, mediaItem, isActive)
            : _buildImageItem(mediaItem, isActive),
      ),
    );
  }

  Widget _buildVideoItem(int index, BannerMediaItem mediaItem, bool isActive) {
    final controller = _videoControllers[index];

    if (controller == null || !controller.value.isInitialized) {
      return Stack(
        children: [
          if (mediaItem.thumbnailUrl != null)
            FancyShimmerImage(
              imageUrl: mediaItem.thumbnailUrl!,
              width: double.infinity,
              height: double.infinity,
              boxFit: BoxFit.cover,
            )
          else
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      );
    }

    if (controller.value.hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                'Video unavailable',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AnimatedScale(
      scale: isActive ? 1.0 : 0.95,
      duration: const Duration(milliseconds: 400),
      child: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }

  Widget _buildImageItem(BannerMediaItem mediaItem, bool isActive) {
    return Stack(
      children: [
        if (mediaItem.backgroundImage != null)
          Positioned.fill(
            child: FancyShimmerImage(
              imageUrl: mediaItem.backgroundImage!,
              width: double.infinity,
              height: double.infinity,
              boxFit: BoxFit.cover,
              errorWidget: Image.asset(
                getPngAsset('product'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        AnimatedScale(
          scale: isActive ? 1.0 : 0.95,
          duration: const Duration(milliseconds: 400),
          child: FancyShimmerImage(
            imageUrl: mediaItem.url,
            width: double.infinity,
            height: double.infinity,
            boxFit: BoxFit.cover,
            errorWidget: Image.asset(
              getPngAsset('product'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorWithText() {
    return Align(
      alignment: widget.indicatorPosition,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_bannerMedia[currentIndex].text != null) _buildTextContent(),
            if (_bannerMedia[currentIndex].text != null) 8.hSize,
            _buildSelectedIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedIndicator() {
    switch (widget.indicatorStyle) {
      case IndicatorStyle.dotted:
        return _buildDottedIndicator();
      case IndicatorStyle.line:
        return _buildLineIndicator();
      case IndicatorStyle.circle:
        return _buildCircleIndicator();
      case IndicatorStyle.number:
        return _buildNumberIndicator();
    }
  }

  Widget _buildDottedIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_bannerMedia.length, (index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentIndex == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? AppColors.yPrimaryColor
                    : Colors.white.withValues(alpha: .7),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  if (currentIndex == index)
                    BoxShadow(
                      color: AppColors.yPrimaryColor.withValues(alpha: 0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTextContent() {
    final text = _bannerMedia[currentIndex].text;
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: MainText(
        text,
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.black.withValues(alpha: .1),
              Colors.black.withValues(alpha: 0.2),
              Colors.black.withValues(alpha: 0.4),
              Colors.black.withValues(alpha: 0.5),
            ],
            stops: const [0.0, 0.3, 0.5, 0.7, 0.85, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildLineIndicator() {
    return Container(
      width: 100,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment(
          -1.0 + (2.0 * currentIndex / (_bannerMedia.length - 1)),
          0,
        ),
        child: Container(
          width: 100 / _bannerMedia.length,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.yPrimaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${currentIndex + 1}/${_bannerMedia.length}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildNumberIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${currentIndex + 1} / ${_bannerMedia.length}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  'No banners available',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}