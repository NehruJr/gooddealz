import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/models/ongoing_actions.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:slide_countdown/slide_countdown.dart';


class ActionWidget extends StatelessWidget {
  const ActionWidget({
    super.key,
    this.isDone = false,
    this.isLive = false,
    required this.action,
  });

  final bool isDone;
  final bool isLive;
  final Auctions action;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(action.withdrawalStartTime ?? '')?.add(Duration(days: action.withdrawalStartDay??0, hours: action.withdrawalStartHour??0))
        .difference(DateTime.now());

    print(date);
    print(DateTime.tryParse(action.withdrawalStartTime??''));
    print(DateTime.tryParse(action.withdrawalStartTime??'')!.month);
    print(DateTime.tryParse(action.withdrawalStartTime??'')!.day);
    print(DateTime.tryParse(action.withdrawalStartTime??'')!.hour);
    print( DateTime.now()
        .difference(DateTime.tryParse(action.withdrawalStartTime ?? '')!).inHours);

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
            Directionality(
              textDirection: TextDirection.ltr,
              child: SlideCountdownSeparated(
                duration: date,
                style: const TextStyle(color: Colors.black),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(7)),
              ),
            ),
5.sSize,
            SizedBox(
              height: 240,
              width: context.width,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: 22.cBorder,
                    child: FancyShimmerImage(
                      imageUrl: action.image?? '',
                      height: 240,
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
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0),
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
                              action.title ?? '',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            32.sSize,
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
