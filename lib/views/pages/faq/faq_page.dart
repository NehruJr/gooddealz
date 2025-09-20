import 'package:flutter/material.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/no_data_widget.dart';

import '../../../providers/settings/settings_provider.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SettingsProvider>(context, listen: false).getFaqs(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: 'faq'.tr,
      body: Column(
        children: [
          Expanded(
            child: Consumer<SettingsProvider>(builder: (context, settings, _) {
              if (settings.faqsLoader) {
                return const Center(
                      child: CircularProgressIndicator(),
                    );
              } else {
                return settings.faqs.isNotEmpty ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: settings.faqs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          surfaceTintColor: Colors.white,
                          elevation: 3,
                          shape: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () {
                              setState(() {
                                for (var item in settings.faqs) {
                                  item.isExpanded = item == settings.faqs[index]
                                      ? !settings.faqs[index].isExpanded
                                      : false;
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MainText(
                                      settings.faqs[index].question ?? '',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                      color: Colors.black,
                                    ),
                                    Icon(
                                      settings.faqs[index].isExpanded
                                          ? Icons.keyboard_arrow_down_rounded
                                          : Icons.arrow_forward_ios_rounded,
                                      size: settings.faqs[index].isExpanded
                                          ? 30
                                          : 20,
                                    ),
                                  ],
                                ),
                                subtitle: settings.faqs[index].isExpanded
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24),
                                        child: MainText(
                                          settings.faqs[index].answer ?? '',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          textAlign: TextAlign.start,
                                          color: Colors.black54,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ) : const NoDataWidget();
              }
            }),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String title;
  final String text;
  bool isExpanded;

  FAQItem({
    required this.title,
    required this.text,
    this.isExpanded = false,
  });
}

List<FAQItem> faqItems = [
  FAQItem(
      title: 'Question 1',
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatu\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.'),
  FAQItem(
      title: 'Question 2',
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatu\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.'),
  FAQItem(
      title: 'Question 3',
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatu\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.'),
  FAQItem(
      title: 'Question 4',
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatu\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.'),
  FAQItem(
      title: 'Question 5',
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatu\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.'),
  FAQItem(
      title: 'Question 6',
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatu\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.'),
];
