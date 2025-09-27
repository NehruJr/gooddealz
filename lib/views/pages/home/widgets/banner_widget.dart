import 'dart:async';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/data/models/banner_model.dart';
import 'package:goodealz/views/widgets/main_text.dart';

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

enum IndicatorStyle {
  dotted,
  line,
  circle,
  number,
}

class _BannerWidgetState extends State<BannerWidget> {
  late PageController _pageController;
  int currentIndex = 0;
  Timer? _autoPlayTimer;
  bool _isUserSwiping = false;
  double _dragDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.viewportFraction);
    if (widget.autoPlay && widget.bannerModels.isNotEmpty) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (mounted && widget.bannerModels.isNotEmpty && !_isUserSwiping) {
        final nextPage = (currentIndex + 1) % widget.bannerModels.length;
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
    if (widget.autoPlay && widget.bannerModels.isNotEmpty) {
      _startAutoPlay();
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
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
    if (widget.bannerModels.isEmpty) return;

    final nextIndex = (currentIndex + 1) % widget.bannerModels.length;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    if (widget.bannerModels.isEmpty) return;

    final previousIndex = (currentIndex - 1) % widget.bannerModels.length;
    _pageController.animateToPage(
      previousIndex >= 0 ? previousIndex : widget.bannerModels.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bannerModels.isEmpty) {
      return _buildPlaceholder();
    }

    return Container(
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
                  itemCount: widget.bannerModels.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final bannerModel = widget.bannerModels[index];
                    return _buildBannerItem(
                      context,
                      bannerModel: bannerModel,
                      isActive: index == currentIndex,
                    );
                  },
                ),
                if (widget.showGradient)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildGradientOverlay()),
                if (widget.showIndicator && widget.bannerModels.length > 1)
                  _buildIndicatorWithText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerItem(BuildContext context,
      {required BannerModel bannerModel, required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.all(isActive ? 0 : 4),
      curve: Curves.easeInOut,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          children: [
            Positioned.fill(
              child: FancyShimmerImage(
                imageUrl:
                    bannerModel.data?.banner?.mainSliderBackgroundImage ?? '',
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
                imageUrl: bannerModel.data?.banner?.mainSliderImage ?? '',
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
        ),
      ),
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
            _buildTextContent(),
            8.hSize,
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
        children: List.generate(widget.bannerModels.length, (index) {
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
                      color: AppColors.yPrimaryColor..withValues(alpha: 0.5),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: MainText(
        widget.bannerModels[currentIndex].data?.banner?.mainSliderText ?? '',
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
      child: DecoratedBox(
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
          -1.0 + (2.0 * currentIndex / (widget.bannerModels.length - 1)),
          0,
        ),
        child: Container(
          width: 100 / widget.bannerModels.length,
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
        '${currentIndex + 1}/${widget.bannerModels.length}',
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
        '${currentIndex + 1} / ${widget.bannerModels.length}',
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
    super.dispose();
  }
}
