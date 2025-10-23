

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/extensions/validations.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/providers/settings/settings_provider.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../widgets/main_button.dart';
import '../../widgets/main_textfield.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _messageController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;

    return MainPage(
      title: 'contact_us'.tr,
      body: Column(
        children: [
          Expanded(

            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 32),
                ...List.generate(
                  contacts.length,
                  (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.yDarkColor,
                            child: SvgPicture.asset(
                              getSvgAsset(contacts[i].image),
                              height: 22,
                              width: 22,
                            ),
                          ),
                          const SizedBox(width: 18),
                          SizedBox(
                            width: context.width - 120,
                            child: MainText(
                               contacts[i].text,
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),
                Form(
                  key: formKey,
                  child: MainMultiLinesTextField(
                    hint: 'type_message'.tr,
                    maxLines: 5,
                    borderColor: AppColors.yDarkColor,
                    controller: _messageController,
                    validator: (value){
                      if(!(value ?? '').isValidName){
                        return 'type_message_validator'.tr;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.topRight,
                  child: Consumer<SettingsProvider>(
                      builder: (context, settingsProvider, _) {
                        return MainButton(
                          width: 100,
                          color: settingsProvider.contactLoader ? AppColors.ySecondryColor : AppColors.yPrimaryColor,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await settingsProvider.contactUs(context,
                                  name: user?.fullName == null || user?.fullName == ''? user?.name??'': '${user!.fullName}',
                                  email: user!.email??'',
                                  message: _messageController.text
                              );
                              _messageController.clear();
                            }

                          },
                          child: MainText(
                            settingsProvider.contactLoader ? 'wait'.tr : 'send'.tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactItem {
  final String image;
  final String text;
  ContactItem({
    required this.image,
    required this.text,
  });
}

List<ContactItem> contacts = [
  ContactItem(image: 'Message2', text: 'Example @ gmail.com'),
  ContactItem(image: 'Calling2', text: '+20 1032316164'),
  ContactItem(image: 'whatsapp', text: '+20 1032316164'),
  ContactItem(
      image: 'Location2', text: '1901 Thornridge Cir. Shiloh, Hawaii 81063'),
];
