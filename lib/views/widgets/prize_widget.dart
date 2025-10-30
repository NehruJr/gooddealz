import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../data/models/winner_model.dart';
import '../pages/selling_fast_details/selling_fast_details.dart';

class PrizeWidget extends StatelessWidget {
  const PrizeWidget({
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
      AppRoutes.routeTo(context, SellingFastDetailsPage(prizeSlug: prize.slug!,));
      },
      child: Container(
        // padding: 4.aEdge,
        margin: const EdgeInsetsDirectional.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: 22.cBorder,
          boxShadow: [
            BoxShadow(
              offset: const Offset(2, 2),
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
            ),
          ],
        ),
        child: SizedBox(
          height: 240,
          width: 300,
          child: Stack(
            children: [
            
              ClipRRect(
                borderRadius: 22.cBorder,
                child: FancyShimmerImage(
                  imageUrl: prize.image ?? '',
                  // height: 240,
                  width: context.width - 32,
                  boxFit: BoxFit.fill,
                  errorWidget: Image.asset(
                    getPngAsset('product'),
                    fit: BoxFit.fill,
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
                      AppColors.yBlackColor.withOpacity(0.0),
                      AppColors.yBlackColor.withOpacity(0.1),
                      AppColors.yBlackColor.withOpacity(0.3),
                      AppColors.yBlackColor.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: 8.aEdge,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFFD54F), Color(0xFFFF9800), Color(0xFFEF040D), Color(0xFFE91E63)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: Text(
                        'win'.tr,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                    Text(
                      prize.title ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.yBGColor,
                        shadows: [
                          Shadow(
                              color: Colors.black54,
                              offset: Offset(1, 1),
                              blurRadius: 2)
                        ],
                      ),
                    ),
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
      ),
    );
  }
}
