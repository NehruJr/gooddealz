import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/extensions/validations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/pages/auth/otp_code/otp_code_page.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';
import 'package:goodealz/views/widgets/rounded_square.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../../providers/auth/auth_provider.dart';
import '../../../widgets/dropdown/custom_dropdown.dart';

class SocialRegisterPage extends StatefulWidget {
  const SocialRegisterPage({super.key, required this.name, required this.email, required this.photoUrl});

  final String name;
  final String email;
  final String photoUrl;

  @override
  State<SocialRegisterPage> createState() => _SocialRegisterPageState();
}

class _SocialRegisterPageState extends State<SocialRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final _fistNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? gender;

  CountryCode? _countryCode;

  @override
  void initState() {
    super.initState();

    _emailController.text = widget.email;
  }

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
              child: ListView(
                padding: 16.aEdge,
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
                              'signup'.tr,
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
                              widget.name,
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
                  //       MainTextField(
                  //   hint: 'first_name'.tr,
                  //   unfocusWhenTapOutside: true,
                  //   controller: _fistNameController,
                  //   prefixIcon: const RoundedSquare(icon: 'Profile'),
                  //   validator: (value) {
                  //     if (!(value ?? '').isValidName) {
                  //       return 'enter_first_name'.tr;
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  // ),
                  // 12.sSize,
                  // MainTextField(
                  //   hint: 'last_name'.tr,
                  //   unfocusWhenTapOutside: true,
                  //   controller: _lastNameController,
                  //   prefixIcon: const RoundedSquare(icon: 'Profile'),
                  //   validator: (value) {
                  //     if (!(value ?? '').isValidName) {
                  //       return 'enter_last_name'.tr;
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  // ),
                  // 12.sSize,
                  MainTextField(
                    hint: 'email'.tr,
                    enable: false,
                    unfocusWhenTapOutside: true,
                    controller: _emailController,
                    prefixIcon: const RoundedSquare(icon: 'Message'),
                   validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter_email'.tr;
                            } 
                            else if (!(value ?? '').isValidEmail) {
                              return 'invalid_email'.tr;
                            } 
                            else {
                              return null;
                            }
                          },
                  ),
                  12.sSize,
                  CustomDropDown(
                    hint: 'gender'.tr,
                    list: const ['male', 'female'],
                    item: gender,
                    unfocusWhenTapOutside: true,
                    controller: _phoneController,
                    prefixIcon: const RoundedSquare(icon: 'gender'),
                    onChange: (value){
                      gender = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return '';
                      } else {
                        return null;
                      }
                    },
                  ),
                  12.sSize,
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
                            if (value!.isEmpty) {
                              return 'enter_phone'.tr;
                            } 
                            else if (!(value ?? '').isValidPhone) {
                              return 'invalid_phone'.tr;
                            } 
                            else {
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
            Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return MainButton(
                    width: 170,
                    radius: 28,
                    color: authProvider.socialRegisterLoader ? AppColors.ySecondryColor : AppColors.yPrimaryColor,
                    onPressed: () async {
                      // AppRoutes.routeTo(context, const OTPCodePage());
                      if (formKey.currentState!.validate()) {
                        authProvider.socialRegister(context,
                         phone: getPhoneNumber,
                          name: widget.name,
                           email: widget.email,
                           firstName: _fistNameController.text,
                           lastName: _lastNameController.text,
                           gender: gender!,
                           photoUrl: widget.photoUrl,
                           );

                      }
                    },
                    child: MainText(
                      authProvider.socialRegisterLoader ? 'wait'.tr : 'send'.tr,
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
