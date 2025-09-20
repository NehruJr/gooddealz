import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/no_data_widget.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/settings/settings_provider.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SettingsProvider>(context, listen: false).getTerms(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: 'terms_and_conditions'.tr,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Consumer<SettingsProvider>(builder: (context, settings, _) {
                return settings.termsLoader
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : settings.termsModel?.data?.termsAndConditions != null ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Html(
                        data: settings.termsModel?.data?.termsAndConditions??'',
                      ),
                      const SizedBox(height: 20),
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
