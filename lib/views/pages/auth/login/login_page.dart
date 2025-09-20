import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/extensions/validations.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/data/local/local_data.dart';
import 'package:goodealz/views/pages/auth/forget_password/forget_password_page.dart';
import 'package:goodealz/views/pages/auth/signup/signup_page.dart';
import 'package:goodealz/views/pages/home/home_page.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';
import 'package:goodealz/views/widgets/rounded_square.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../providers/auth/auth_provider.dart';
import '../../../widgets/custom_checkbox.dart';
import '../../../widgets/loading_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _emailController.text = LocalData.rememberedEmail??'';
  }


  @override
  Widget build(BuildContext context) {
    return Selector<AuthProvider, bool>(
        selector: (context, authProvider) =>
        authProvider.socialLoginLoader,
        builder: (context, socialLoginLoader, _) {
          return LoadingManager(
            isLoading: socialLoginLoader,
          child: MainPage(
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
              child: SingleChildScrollView(
                padding: 16.aEdge,
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                      child: SvgPicture.asset(
                        getSvgAsset('logo'),
                      ),
                    ),
                    32.sSize,
                    MainText(
                      'login'.tr,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    32.sSize,
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // MainTextField(
                          //   hint: 'phone'.tr,
                          //   unfocusWhenTapOutside: true,
                          //   prefixIcon: const RoundedSquare(icon: 'Calling'),
                          //   keyboardType: TextInputType.phone,
                          //   suffixIcon: Padding(
                          //     padding: 18.vhEdge,
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         VerticalDivider(
                          //             thickness: 1.1,
                          //             color: Colors.black.withOpacity(0.7)),
                          //         const MainText('+20', color: Colors.black54)
                          //       ],
                          //     ),
                          //   ),
                          //   validator: (value) {
                          //     if (!(value ?? '').isValidPhone) {
                          //       return '';
                          //     } else {
                          //       return null;
                          //     }
                          //   },
                          // ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  AppRoutes.routeTo(
                                      context, const ForgetPasswordPage());
                                },
                                child: MainText(
                                  'forget_password'.tr,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          32.sSize,
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, _) {
                              return MainButton(
                                width: 220,
                                color: authProvider.loginLoader ? AppColors.ySecondryColor : AppColors.yPrimaryColor,
                                onPressed: authProvider.loginLoader ? (){} : () async {
                                  if (formKey.currentState!.validate()) {
                                    authProvider.login(context,
                                        email: _emailController.text.trim(),
                                    password: _passwordController.text
                                    );
                                  }

                                },
                                child: MainText(
                                  authProvider.loginLoader ? 'wait'.tr : 'login'.tr,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              );
                            }
                          ),
                          16.sSize,
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, _) {
                              return MainButton(
                                width: 220,
                                color: AppColors.yLightGreyColor,
                                onPressed: authProvider.loginGuestLoader ? (){} : () async {

                                    authProvider.loginAsGuest(context,);

                                },
                                child: MainText(
                                  authProvider.loginGuestLoader ? 'wait'.tr : 'guest'.tr,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                    32.sSize,
                    SizedBox(
                      width: 220,
                      child: Row(
                        children: [
                          Expanded(
                              child: Divider(
                            color: Colors.black.withOpacity(0.6),
                          )),
                          Padding(
                            padding: 12.aEdge,
                            child: MainText(
                              'or'.tr,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            color: Colors.black.withOpacity(0.6),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<AuthProvider>(context, listen: false).loginWithFaceBook(context);
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              padding: 16.aEdge,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    offset: const Offset(2, 2),
                                    color: Colors.black.withOpacity(0.12),
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(getSvgAsset('facebook')),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Provider.of<AuthProvider>(context, listen: false).loginWithGoogle(context);
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              padding: 16.aEdge,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    offset: const Offset(2, 2),
                                    color: Colors.black.withOpacity(0.12),
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(getSvgAsset('google')),
                            ),
                          ),
                          if(Platform.isIOS)GestureDetector(
                            onTap: () {
                              Provider.of<AuthProvider>(context, listen: false).loginWithApple(context);
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              padding: 16.aEdge,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    offset: const Offset(2, 2),
                                    color: Colors.black.withOpacity(0.12),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.apple),
                            ),
                          ),
                        ],
                      ),
                    ),
                    32.sSize,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MainText(
                          'do_not_have_account'.tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        InkWell(
                          onTap: () {
                            AppRoutes.routeTo(context, const SignupPage());
                          },
                          child: MainText(
                            'signup'.tr,
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
          ),
        );
      }
    );
  }
}
