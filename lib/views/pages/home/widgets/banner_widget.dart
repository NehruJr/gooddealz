import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/data/models/banner_model.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:scroll_page_view/pager/scroll_page_view.dart';

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
  BannerWidget({
    super.key,
    required this.bannerModels,
    this.textPosition = TextPosition.center,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  final List<BannerModel> bannerModels;
  final TextPosition textPosition;
  final bool autoPlay;
  final Duration autoPlayInterval;

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final ss = ScrollPageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay && widget.bannerModels.isNotEmpty) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    Future.delayed(widget.autoPlayInterval, () {
      if (mounted && widget.bannerModels.isNotEmpty) {
        setState(() {
          currentIndex = (currentIndex + 1) % widget.bannerModels.length;
        });
        ss.controller.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoPlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bannerModels.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: context.width,
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: ClipRRect(
          borderRadius: 22.cBorder,
          child: ScrollPageView(
            checkedIndicatorColor: AppColors.yPrimaryColor,
            controller: ss,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            children: widget.bannerModels.map((bannerModel) {
              return bannerContent(
                context,
                mainImage: bannerModel.data?.banner?.mainSliderImage ?? '',
                backgroundImage:
                    bannerModel.data?.banner?.mainSliderBackgroundImage ?? '',
                title: bannerModel.data?.banner?.mainSliderText ?? '',
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget bannerContent(
    BuildContext context, {
    required String title,
    required String mainImage,
    required String backgroundImage,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: 22.cBorder,
          child: FancyShimmerImage(
            imageUrl: backgroundImage,
            height: MediaQuery.of(context).size.width - 32,
            width: MediaQuery.of(context).size.width - 32,
            boxFit: BoxFit.cover,
            errorWidget: Image.asset(
              getPngAsset('product'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: 22.cBorder,
          child: FancyShimmerImage(
            imageUrl: mainImage,
            height: MediaQuery.of(context).size.width - 32,
            width: MediaQuery.of(context).size.width - 32,
            boxFit: BoxFit.cover,
            errorWidget: Image.asset(
              getPngAsset('product'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: 22.cBorder,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.yPrimaryColor.withOpacity(0.4),
                AppColors.yPrimaryColor.withOpacity(0.37),
                AppColors.yPrimaryColor.withOpacity(0.35),
                AppColors.yPrimaryColor.withOpacity(0.3),
                AppColors.yPrimaryColor.withOpacity(0.3),
                AppColors.yPrimaryColor.withOpacity(0.3),
                Colors.black.withOpacity(0.35),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.9),
              ],
            ),
          ),
        ),
        _buildPositionedText(title),
      ],
    );
  }

  Widget _buildPositionedText(String title) {
    Widget textWidget = Padding(
      padding: const EdgeInsets.all(16.0),
      child: MainText(
        title,
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        textAlign: _getTextAlign(),
      ),
    );

    switch (widget.textPosition) {
      case TextPosition.topLeft:
        return Positioned(
          top: 0,
          left: 0,
          child: textWidget,
        );
      case TextPosition.topCenter:
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: textWidget,
        );
      case TextPosition.topRight:
        return Positioned(
          top: 0,
          right: 0,
          child: textWidget,
        );
      case TextPosition.centerLeft:
        return Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: textWidget,
          ),
        );
      case TextPosition.center:
        return Positioned.fill(
          child: Center(child: textWidget),
        );
      case TextPosition.centerRight:
        return Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: Align(
            alignment: Alignment.centerRight,
            child: textWidget,
          ),
        );
      case TextPosition.bottomLeft:
        return Positioned(
          bottom: 0,
          left: 0,
          child: textWidget,
        );
      case TextPosition.bottomCenter:
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: textWidget,
        );
      case TextPosition.bottomRight:
        return Positioned(
          bottom: 0,
          right: 0,
          child: textWidget,
        );
    }
  }

  TextAlign _getTextAlign() {
    switch (widget.textPosition) {
      case TextPosition.topLeft:
      case TextPosition.centerLeft:
      case TextPosition.bottomLeft:
        return TextAlign.left;
      case TextPosition.topCenter:
      case TextPosition.center:
      case TextPosition.bottomCenter:
        return TextAlign.center;
      case TextPosition.topRight:
      case TextPosition.centerRight:
      case TextPosition.bottomRight:
        return TextAlign.right;
    }
  }

  @override
  void dispose() {
    ss.controller.dispose();
    super.dispose();
  }
}
