import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/extensions/validations.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/views/pages/auth/login/login_page.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';
import 'package:goodealz/views/widgets/rounded_square.dart';

import '../../../../core/helper/functions/global_methods.dart';
import '../../../widgets/dropdown/custom_dropdown.dart';
import '../../terms/terms_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final _fistNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? gender;
  String? nationality;

  CountryCode? _countryCode;


  final formKey = GlobalKey<FormState>();
  bool isAccept = false;
  @override
  Widget build(BuildContext context) {
    return MainPage(
      noDrawer: true,
      body: Container(
        height: context.height,
        width: context.width,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       Colors.white.withOpacity(0.1),
        //       Colors.white,
        //       Colors.white,
        //     ],
        //   ),
        // ),
        child: SingleChildScrollView(
          padding: 16.aEdge,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                width: 200,
                child: Image.asset(
                  getPngAsset('black_logo'),
                  fit: BoxFit.cover,
                ),
              ),
              32.sSize,
              MainText(
                'signup'.tr,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              32.sSize,
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MainTextField(
                      hint: 'first_name'.tr,
                      unfocusWhenTapOutside: true,
                      controller: _fistNameController,
                      prefixIcon: const RoundedSquare(icon: 'Profile'),
                      validator: (value) {
                        if (!(value ?? '').isValidName) {
                          return 'enter_first_name'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    12.sSize,
                    MainTextField(
                      hint: 'last_name'.tr,
                      unfocusWhenTapOutside: true,
                      controller: _lastNameController,
                      prefixIcon: const RoundedSquare(icon: 'Profile'),
                      validator: (value) {
                        if (!(value ?? '').isValidName) {
                          return 'enter_last_name'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    12.sSize,
                    MainTextField(
                      hint: 'email'.tr,
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
                      list: ['male'.tr, 'female'.tr],
                      item: gender,
                      unfocusWhenTapOutside: true,
                      // controller: _phoneController,
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
                    CustomDropDown(
                      hint: 'nationality'.tr,
                      list: Provider.of<AuthProvider>(context).nationalities.map((e) => e.name!).toList(),
                      item: nationality,
                      unfocusWhenTapOutside: true,
                      prefixIcon: const RoundedSquare(icon: 'nationality'),

                      onChange: (value){
                        nationality = value;
                        Provider.of<AuthProvider>(context, listen: false).changeCountryCode(value);
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
                        print(_countryCode?.dialCode);
                      },
                      // suffixIcon: Padding(
                      //   padding: 18.vhEdge,
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       VerticalDivider(
                      //           thickness: 1.1,
                      //           color: Colors.black.withOpacity(0.7)),
                      //       MainText(Provider.of<AuthProvider>(context).countryCode??'', color: Colors.black54)
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
                    12.sSize,
                    MainTextField(
                      hint: 'password'.tr,
                      unfocusWhenTapOutside: true,
                      controller: _passwordController,
                      prefixIcon: const RoundedSquare(icon: 'Lock'),
                      obscureText: true,
                       isPassword: true,
                       validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter_password'.tr;
                              } else if(!(value ?? '').isValidPassword) {
                                return 'invalid_password'.tr;
                              }
                              else {
                                return null;
                              }
                            },
                    ),
                    12.sSize,
                    MainTextField(
                      hint: 'confirm_password'.tr,
                      unfocusWhenTapOutside: true,
                      prefixIcon: const RoundedSquare(icon: 'Lock'),
                      obscureText: true,
                      isPassword: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                                return 'enter_password'.tr;
                              } else if (value != _passwordController.text) {
                          return 'doesnot_match'.tr;
                        }
                        else {
                          return null;
                        }
                      },
                    ),
                    8.sSize,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isAccept = isAccept ? false : true;
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: isAccept,
                                fillColor: WidgetStatePropertyAll(isAccept? AppColors.yPrimaryColor : AppColors.yBGColor),
                                onChanged: (value) {
                                  setState(() {
                                    isAccept = value ?? false;
                                  });
                                },
                              ),
                              MainText(
                                'accept_all'.tr,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              GestureDetector(
                                onTap: (){
                                  AppRoutes.routeTo(context, const TermsPage());
                                },
                                child: MainText(
                                  'terms_conditions'.tr,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    32.sSize,
                    Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                        return MainButton(
                          width: 170,
                          radius: 28,
                        color: authProvider.signupLoader
                            ? AppColors.ySecondryColor
                            : AppColors.yPrimaryColor,
                        onPressed: authProvider.signupLoader ? (){} : () async {
                            if (formKey.currentState!.validate()) {
                              if(isAccept != true){
                                GlobalMethods.errorDialog(title:'', subtitle: 'accept_terms'.tr, context: context);
                                return;
                              }

                              authProvider.signup(context,
                                  firstName: _fistNameController.text.trim(),
                                  lastName: _lastNameController.text.trim(),
                                  email: _emailController.text.trim(),
                                gender: gender!,
                                nationality: nationality!,
                                phone: getPhoneNumber,
                                password: _passwordController.text
                              );
                            }
                          },
                          child: MainText(
                            authProvider.signupLoader ? 'wait'.tr : 'signup'.tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
              32.sSize,
              // SizedBox(
              //   width: 220,
              //   child: Row(
              //     children: [
              //       Expanded(
              //           child: Divider(
              //         color: Colors.black.withOpacity(0.6),
              //       )),
              //       Padding(
              //         padding: 12.aEdge,
              //         child: MainText(
              //           'or'.tr,
              //           fontSize: 13,
              //           fontWeight: FontWeight.w500,
              //           color: Colors.black,
              //         ),
              //       ),
              //       Expanded(
              //           child: Divider(
              //         color: Colors.black.withOpacity(0.6),
              //       )),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   width: 220,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       GestureDetector(
              //         onTap: () {},
              //         child: Container(
              //           height: 60,
              //           width: 60,
              //           padding: 16.aEdge,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             shape: BoxShape.circle,
              //             boxShadow: [
              //               BoxShadow(
              //                 blurRadius: 5,
              //                 offset: const Offset(2, 2),
              //                 color: Colors.black.withOpacity(0.12),
              //               ),
              //             ],
              //           ),
              //           child: SvgPicture.asset(getSvgAsset('facebook')),
              //         ),
              //       ),
              //       GestureDetector(
              //         onTap: () {},
              //         child: Container(
              //           height: 60,
              //           width: 60,
              //           padding: 16.aEdge,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             shape: BoxShape.circle,
              //             boxShadow: [
              //               BoxShadow(
              //                 blurRadius: 5,
              //                 offset: const Offset(2, 2),
              //                 color: Colors.black.withOpacity(0.12),
              //               ),
              //             ],
              //           ),
              //           child: SvgPicture.asset(getSvgAsset('google')),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              16.sSize,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MainText(
                    'have_account'.tr,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  InkWell(
                    onTap: () {
                      AppRoutes.routeRemoveAllTo(context, const LoginPage());
                    },
                    child: MainText(
                      'login'.tr,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
