import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';
import 'package:goodealz/views/widgets/rounded_square.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../providers/auth/auth_provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  CountryCode? _countryCode;

  @override
  Widget build(BuildContext context) {
    return MainPage(
      noDrawer: true,
      body: Container(
        height: context.height,
        width: context.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: 16.aEdge,
                child: Column(
                  children: [
                    16.sSize,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 200,
                              child: MainText(
                                'recovery_password'.tr,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                maxLines: 2,
                              ),
                            ),
                            32.sSize,
                            SizedBox(
                              width: context.width - 150,
                              child: MainText(
                                'enter_phone_get_otp'.tr,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.5),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    32.sSize,
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          MainTextField(
                            hint: 'phone'.tr,
                            unfocusWhenTapOutside: true,
                            controller: _phoneController,
                            prefixIcon: const RoundedSquare(icon: 'Calling'),
                            keyboardType: TextInputType.phone,
                            isPhone: true,
                            onCounteryCodeChange: (code){
                              _countryCode = code;
                            },
                            // suffixIcon: Padding(
                            //   padding: 18.vhEdge,
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       VerticalDivider(
                            //           thickness: 1.1,
                            //           color: Colors.black.withOpacity(0.7)),
                            //       const MainText('+20', color: Colors.black54)
                            //     ],
                            //   ),
                            // ),
                            validator: (value) {
                              // if (!('${Provider.of<AuthProvider>(context, listen: false).countryCode??''}$value' ?? '').isValidPhone) {
                              if ((value ?? '').isEmpty) {
                                return 'invalid_phone'.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                return MainButton(
                  width: 170,
                  radius: 28,
                  color: authProvider.forgetPasswordLoader ? AppColors.ySecondryColor : AppColors.yPrimaryColor,
                  onPressed: () async {
                    // AppRoutes.routeTo(context, const OTPCodePage());
                    if (formKey.currentState!.validate()) {
                      authProvider.forgetPassword(context, phone: getPhoneNumber);

                    }
                  },
                  child: MainText(
                    authProvider.forgetPasswordLoader ? 'wait'.tr : 'send'.tr,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                );
              }
            ),
            32.sSize
          ],
        ),
      ),
    );
  }

  String get getPhoneNumber {
    String code = _countryCode == null ? "+20" : _countryCode!.dialCode!;
    String phone = _phoneController.text.trim();
    if(code == "+20" && phone.startsWith("0")){
      phone = phone.substring(1);
    }
    return code + phone;
  }
}
