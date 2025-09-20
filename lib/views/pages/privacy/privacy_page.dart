import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/no_data_widget.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/settings/settings_provider.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool isAgree = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SettingsProvider>(context, listen: false).getPrivacyPolicy(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: 'privacy_policy'.tr,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Consumer<SettingsProvider>(builder: (context, settings, _) {
                return settings.privacyLoader
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : settings.privacyModel?.data?.privacyPolicy != null ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      Html(
                        data: settings.privacyModel?.data?.privacyPolicy??'' ,
                      ),
                      const SizedBox(height: 20),
                    
                    
                    ],
                  ) : const NoDataWidget();
                }
              ),
            ),
          ),
          // LocalData.isPrivacyAgree
          //     ? const SizedBox()
          //     : Padding(
          //         padding: const EdgeInsets.all(16),
          //         child: MainButton(
          //           title: 'Agree',
          //           withIcon: true,
          //           iconPath: 'button_arrow',
          //           onPressed: () async {
          //             if (isAgree) {
          //               await LocalData.setBool(LocalKeys.isPrivacyAgree, true);
          //               setState(() {});
          //               showSnackbar('I have agreed to the privacy policies');
          //             } else {
          //               showSnackbar('Please agree to privacy first.',
          //                   error: true);
          //             }
          //           },
          //         ),
          //       ),
        ],
      ),
    );
  }
}
