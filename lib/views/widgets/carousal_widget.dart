import 'package:carousel_custom_slider/carousel_custom_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CarousalWidget extends StatelessWidget {
  const CarousalWidget({super.key, required this.images});

  final List<String>? images;

  @override
  Widget build(BuildContext context) {
    return CarouselCustomSlider(
      autoPlay: true,
      isVerticalIndicator: true,
      dragStartBehavior: DragStartBehavior.down,
      scrollDirection: Axis.vertical,
      alignmentPositionIndicator: Alignment.bottomCenter,
      viewportFraction: 1,
      height: 100,
      width: 200,
      // viewportFractionPadingvertical: 0,
      sliderList: images == null || images!.isEmpty ? [''] : images! ,
      fitPic: BoxFit.contain,
      alignmentVerticalPositionIndicator: Alignment.centerRight,
      isDisplayIndicator: images != null && images!.isNotEmpty && images!.length > 1,
      paddingVerticalPositionIndicator: const EdgeInsets.symmetric(horizontal: 0),
      // childrenStackBuilder: (index) {
      //   return Text(
      //     'sliderTitlePost[index]',
      //     style: const TextStyle(
      //         fontSize: 30,
      //         fontWeight: FontWeight.bold,
      //         color: Colors.white),
      //   );
      // },

      effect: SwapEffect(
        dotHeight: 12.0,
        dotWidth: 12.0,
        paintStyle: PaintingStyle.fill,
        type: SwapType.yRotation,
        activeDotColor: Theme.of(context).primaryColor,
        dotColor: Theme.of(context).colorScheme.inversePrimary,

      ),
    );
  }
}
