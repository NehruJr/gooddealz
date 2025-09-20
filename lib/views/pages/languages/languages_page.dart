import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => LanguagesPageState();
}

class LanguagesPageState extends State<LanguagesPage> {
  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<YsLocalizationsProvider>(context);
    return MainPage(
      title: 'languages'.tr,
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const MainText(
                  'English',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                InkWell(
                  onTap: () async {
                    await locale.setSavedLanguageCode('en');
                  },
                  child: locale.languageCode == 'en'
                      ? CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.yPrimaryColor,
                          child: SvgPicture.asset(getSvgAsset('confirm')),
                        )
                      : SvgPicture.asset(getSvgAsset('circle')),
                ),
              ],
            ),
            24.sSize,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const MainText(
                  'Arabic',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                InkWell(
                  onTap: () async {
                    await locale.setSavedLanguageCode('ar');
                  },
                  child: locale.languageCode == 'ar'
                      ? CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.yPrimaryColor,
                          child: SvgPicture.asset(getSvgAsset('confirm')),
                        )
                      : SvgPicture.asset(getSvgAsset('circle')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
