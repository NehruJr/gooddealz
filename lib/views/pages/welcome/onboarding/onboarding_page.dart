import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/local/local_data.dart';
import 'package:goodealz/views/pages/auth/login/login_page.dart';

import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return MainPage(
      isBackgroundImage: false,
      isAppBar: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: onboarding.length,
              itemBuilder: (context, i) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: SvgPicture.asset(
                      getSvgAsset(onboarding[i].image),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: 16.aEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText(
                          onboarding[i].title,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        16.sSize,
                        MainText(
                          onboarding[i].des,
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.5),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: 24.aEdge,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    LocalData.changeOpenedOnBoarding(true);
                    AppRoutes.routeRemoveAllTo(context, const LoginPage());
                  },
                  child: Padding(
                    padding: 8.vhEdge,
                    child: MainText(
                      'skip'.tr,
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if ((pageController.page?.toInt() ?? 0) <
                        onboarding.length - 1) {
                      pageController.animateToPage(
                        (pageController.page?.toInt() ?? 0) + 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linearToEaseOut,
                      );
                    } else {
                      LocalData.changeOpenedOnBoarding(true);
                      AppRoutes.routeRemoveAllTo(context, const LoginPage());
                    }
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    padding: 16.aEdge,
                    decoration: const BoxDecoration(
                      color: AppColors.yPrimaryColor,
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.yPrimaryColor,
                          AppColors.ySecondryColor,
                        ],
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        getSvgAsset('left_arrow'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OnboardingModel {
  final String image;
  final String title;
  final String des;
  OnboardingModel({
    required this.image,
    required this.title,
    required this.des,
  });
}

List<OnboardingModel> onboarding = [
  OnboardingModel(
    image: 'onboarding_1',
    title: 'Choose Product',
    des:
        '''A product is the item offered for sale. A product can be a service or an item. It can be physical or in virtual or cyber form''',
  ),
  OnboardingModel(
    image: 'onboarding_2',
    title: 'Make Payment',
    des:
        '''Payment is the transfer of money services in exchange product or Payments typically made terms agreed ''',
  ),
  OnboardingModel(
    image: 'onboarding_3',
    title: 'Get Your Order',
    des:
        '''Business or commerce an order is a stated intention either spoken to engage in a commercial transaction specific products ''',
  ),
];
