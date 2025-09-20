import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/no_data_widget.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/settings/settings_provider.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SettingsProvider>(context, listen: false).getAboutUs(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: 'about_us'.tr,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<SettingsProvider>(builder: (context, settings, _) {
                return settings.aboutUsLoader
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : settings.aboutUsModel?.data != null ? ListView(
                    children: [
                      Html(
                        data: settings.aboutUsModel?.data?? '',
                      )
                      // SizedBox(height: 32),
                      // AboutUsItem(
                      //   title: '2. Use of Your Personal Data',
                      //   text:
                      //       'Magna etiam tempor orci eu lobortis elementum nibh. Vulputate enim nulla aliquet porttitor lacus. Orci sagittis eu volutpat odio. Cras semper auctor neque vitae tempus quam pellentesque nec. Non quam lacus suspendisse faucibus interdum posuere lorem ipsum dolor. Commodo elit at imperdiet dui. Nisi vitae suscipit tellus mauris a diam. Erat pellentesque adipiscing commodo elit at imperdiet dui. Mi ipsum faucibus vitae aliquet nec ullamcorper. Pellentesque pulvinar pellentesque habitant morbi tristique senectus et.',
                      // ),
                      // SizedBox(height: 32),
                      // AboutUsItem(
                      //   title: '3. Disclosure of Your Personal Data',
                      //   text:
                      //       'Consequat id porta nibh venenatis cras sed. Ipsum nunc aliquet bibendum enim facilisis gravida neque. Nibh tellus molestie nunc non blandit massa. Quam pellentesque nec nam aliquam sem et tortor consequat id. Faucibus vitae aliquet nec ullamcorper sit amet risus. Nunc consequat interdum varius sit amet. Eget magna fermentum iaculis eu non diam phasellus vestibulum. Pulvinar pellentesque habitant morbi tristique senectus et. Lorem donec massa sapien faucibus et molestie. Massa tempor nec feugiat nisl pretium fusce id. Lacinia at quis risus sed vulputate odio. Integer vitae justo eget magna fermentum iaculis. Eget gravida cum sociis natoque penatibus et magnis.',
                      // ),
                    ],
                  ) : const NoDataWidget();
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutUsItem extends StatelessWidget {
  const AboutUsItem({
    super.key,
    required this.title,
    required this.text,
  });
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainText(
          title,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
          color: Colors.black,
        ),
        const SizedBox(height: 32),
        MainText(
          text,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.start,
          color: Colors.black54,
        ),
      ],
    );
  }
}
