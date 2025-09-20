import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/models/winner_model.dart';
import 'package:goodealz/views/widgets/main_text.dart';


class SoldOutWidget extends StatelessWidget {
  const SoldOutWidget({
    super.key,
    this.isDone = false,
    this.isLive = false,
    required this.prize,
  });

  final bool isDone;
  final bool isLive;
  final Prize prize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // AppRoutes.routeTo(
        //     context,
        //     ProductDetailsPage(
        //       productDetails: productDetails,
        //     ));
      },
      child: Container(
        padding: 4.aEdge,
        margin: 8.vEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: 22.cBorder,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [

            SizedBox(
              height: 240,
              width: context.width,
              child: Stack(
                children: [
            
                  ClipRRect(
                    borderRadius: 22.cBorder,
                    child: FancyShimmerImage(
                      imageUrl: prize.cover ?? '',
                      height: 240,
                      width: context.width - 32,
                      boxFit: BoxFit.fill,
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
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: 24.aEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MainText(
                          'win'.tr,
                          fontSize: 32,
                          color: AppColors.yPrimaryColor,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                        MainText(
                          prize.title ?? '',
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        32.sSize,
                      ],
                    ),
                  ),
                  isLive
                      ? Center(
                    child: SvgPicture.asset(getSvgAsset('video_play')),
                  )
                      : 0.sSize,
                ],
              ),
            ),
            // Padding(
            //   padding: 16.aEdge,
            //   child: Column(
            //     children: [
            //       16.sSize,
            //       SizedBox(
            //         width: context.width,
            //         child: Row(
            //           children: [
            //             Expanded(
            //               flex: 3,
            //               child: Column(
            //                 children: [
            //                   MainText(
            //                     // 'Buy Unity tee for: AED351.00',
            //                     prize.product?.title ?? '',
            //                     maxLines: 2,
            //                     overflow: TextOverflow.ellipsis,
            //                     fontSize: 16,
            //                     color: Colors.black,
            //                     fontWeight: FontWeight.w700,
            //                   ),
            //                   8.sSize,
            //                   MainText(
            //                     // 'Draw date: 13 june, 2023 or earlier based on the time passed.',
            //                     prize.product?.description ?? '',
            //                     maxLines: 3,
            //                     overflow: TextOverflow.ellipsis,
            //                     fontSize: 12,
            //                     color: Colors.black.withOpacity(0.5),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             8.sSize,
            //             Expanded(
            //               flex: 2,
            //               child: FancyShimmerImage(
            //                 imageUrl: prize.product?.image ?? '',
            //                 height: 100,
            //                 // width: context.width - 32,
            //                 boxFit: BoxFit.fill,
            //                 errorWidget: Image.asset(
            //                   getPngAsset('product'),
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),

            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
