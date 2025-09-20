import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/extensions/validations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';
import 'package:goodealz/views/widgets/rounded_square.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../providers/auth/auth_provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key, required this.phone,});

  final String phone;


  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainPage(
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
                                'change_password'.tr,
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
                                'contact_use_rest_password'.tr,
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
                            hint: 'password'.tr,
                            unfocusWhenTapOutside: true,
                            controller: _passwordController,
                            prefixIcon: const RoundedSquare(icon: 'Lock'),
                            obscureText: true,
                            validator: (value) {
                              if (!(value ?? '').isValidPassword) {
                                return 'enter_password'.tr;
                              } else {
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
                            validator: (value) {
                              if (!(value ?? '').isValidPassword) {
                                return 'enter_password'.tr;
                              } else if (value != _passwordController.text) {
                                return 'doesnot_match'.tr;
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
            Consumer<AuthProvider>(builder: (context, authProvider, _) {
              return MainButton(
                width: 190,
                radius: 28,
                color: authProvider.resetPasswordLoader
                    ? AppColors.ySecondryColor
                    : AppColors.yPrimaryColor,
                onPressed: authProvider.resetPasswordLoader
                    ? (){} : () async {
                  // AppRoutes.routeRemoveAllTo(context, const LoginPage());
                  if (formKey.currentState!.validate()) {
                    authProvider.resetPassword(context,
                        phone: widget.phone,
                        password: _passwordController.text,
                      isFromProfile: true
                    );
                  }
                },
                child: MainText(
                  authProvider.resetPasswordLoader
                      ? 'wait'.tr
                      : 'save_edit'.tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              );
            }),
            32.sSize
          ],
        ),
      ),
    );
  }
}
