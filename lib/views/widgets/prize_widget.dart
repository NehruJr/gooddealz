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
                  boxFit: BoxFit.contain,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
        
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                      ],
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
