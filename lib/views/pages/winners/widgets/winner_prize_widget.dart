import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../../data/models/winner_model.dart';
import 'video_dialog.dart';

class WinnerPrizeWidget extends StatelessWidget {
  const WinnerPrizeWidget({super.key, required this.prize});

  final Prize prize;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.yBGColor,
      elevation: 5,
      shadowColor: AppColors.yBlackColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prize Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FancyShimmerImage(
              imageUrl: prize.image ?? '',
              // Replace with your actual prize object
              height: 150,
              width: double.infinity,
              boxFit: BoxFit.fill,
              errorWidget: Image.asset(
                getPngAsset('placeholder'), // your placeholder image
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Prize Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MainText(
              prize.title ?? '', // Replace with actual prize title
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.yBlackColor,
            ),
          ),

          const SizedBox(height: 8),
          ListTile(
            minVerticalPadding: 16,
            leading: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle
              ),
              width: 50,
              height: 50,
              clipBehavior: Clip.antiAlias,
              child: FancyShimmerImage(
                imageUrl: prize.winner!.avatar??'',
                // height: size.width * 0.21,
                // width: size.width * 0.2,
                boxFit: BoxFit.fill,
                errorWidget: Image.asset(
                  getPngAsset('person'),
                ),
              ),
            ),
            title: MainText(
              prize.winner!.firstName == null || prize.winner!.firstName == ''? prize.winner!.name??'':
              '${prize.winner!.firstName??""} ${prize.winner!.lastName??""}',
              // '${winner.lastName} ${winner.lastName}',
              overflow: TextOverflow.ellipsis,
              fontSize: 18,
              color: AppColors.yBlackColor,
              fontWeight: FontWeight.w700,
            ),
            subtitle: MainText(
              '${'winner'.tr} : # ${prize.winner!.id}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              fontSize: 14,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
          ),


          prize.video != null
              ? Center(
                  child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => VideoDialog(
                            videoUrl: prize.video ?? "",
                            videoBrief: prize.videoBrief ?? "",
                          ),
                        );
                      },
                      child: MainText(
                        'show_video'.tr,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        textAlign: TextAlign.center,
                      )),
                )
              : Center(
                  child: MainText(
                    'no_video'.tr,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    textAlign: TextAlign.center,
                  ),
                )
        ],
      ),
    );
  }
}
