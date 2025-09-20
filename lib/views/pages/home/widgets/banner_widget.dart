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

class BannerWidget extends StatefulWidget {
  BannerWidget({
    super.key,
    required this.bannerModel
  });

  BannerModel? bannerModel;

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final ss = ScrollPageController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // AppRoutes.routeTo(context, const OffersPage());
      },
      child: SizedBox(
        width: context.width,
        child: AspectRatio(
          aspectRatio: 3 / 2, // Or try 3 / 1 or 2 / 1 based on your design
          child: ClipRRect(
            borderRadius: 22.cBorder,
            child: ScrollPageView(
              checkedIndicatorColor: Colors.red,
              controller: ss,
              children: [
                bannerContent(context, mainImage: widget.bannerModel?.data?.banner?.mainSliderImage ??'', backgroundImage: widget.bannerModel?.data?.banner?.mainSliderBackgroundImage ??'', title: widget.bannerModel?.data?.banner?.mainSliderText??''),
                // bannerContent(context, title: 'Join To Our\nWinners Today!'),
                // bannerContent(context, title: 'Join To Our\nWinners Today!'),
              ],
            ),
          ),
        ),


      ),
    );
  }

  Widget bannerContent(context, {required String title, required String mainImage, required String backgroundImage}){
    return Stack(
      children: [

        ClipRRect(
          borderRadius: 22.cBorder,
          // child: Image.asset(
          //   getPngAsset('product'),
          //   height: MediaQuery.of(context).size.width - 32,
          //   width: MediaQuery.of(context).size.width - 32,
          //   fit: BoxFit.cover,
          // ),
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
          // child: Image.asset(
          //   getPngAsset('product'),
          //   height: MediaQuery.of(context).size.width - 32,
          //   width: MediaQuery.of(context).size.width - 32,
          //   fit: BoxFit.cover,
          // ),
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
        0.sSize,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: MainText(
              title,
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
