import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
import '../../terms/terms_page.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key, required this.countryCode, required this.nationality});

 CountryCode countryCode;
  String nationality;

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
  final formKey = GlobalKey<FormState>();
  bool isAccept = false;

  @override
  Widget build(BuildContext context) {
    return MainPage(
      noDrawer: true,
      body: Container(
        height: context.height,
        width: context.width,
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
                      controller: _fistNameController,
                      prefixIcon: const RoundedSquare(icon: 'Profile'),
                      validator: (value) =>
                      !(value ?? '').isValidName ? 'enter_first_name'.tr : null,
                    ),
                    12.sSize,
                    MainTextField(
                      hint: 'last_name'.tr,
                      controller: _lastNameController,
                      prefixIcon: const RoundedSquare(icon: 'Profile'),
                      validator: (value) =>
                      !(value ?? '').isValidName ? 'enter_last_name'.tr : null,
                    ),
                    12.sSize,
                    MainTextField(
                      hint: 'email'.tr,
                      controller: _emailController,
                      prefixIcon: const RoundedSquare(icon: 'Message'),
                      validator: (value) {
                        if (value!.isEmpty) return 'enter_email'.tr;
                        if (!value.isValidEmail) return 'invalid_email'.tr;
                        return null;
                      },
                    ),
                    12.sSize,
                    MainTextField(
                      hint: 'phone'.tr,
                      controller: _phoneController,
                      initialCode: widget.countryCode.code,
                      prefixIcon: const RoundedSquare(icon: 'Calling'),
                      keyboardType: TextInputType.phone,
                      isPhone: true,
                      onCounteryCodeChange: (code) {
                        widget.countryCode = code;
                        widget.nationality = code.name!;
                        Provider.of<AuthProvider>(context, listen: false)
                            .changeCountryCode(code.name!);
                      },
                      validator: (value) =>
                      (value ?? '').isEmpty ? 'invalid_phone'.tr : null,
                    ),
                    12.sSize,
                    MainTextField(
                      hint: 'password'.tr,
                      controller: _passwordController,
                      prefixIcon: const RoundedSquare(icon: 'Lock'),
                      obscureText: true,
                      isPassword: true,
                      validator: (value) {
                        if (value!.isEmpty) return 'enter_password'.tr;
                        if (!value.isValidPassword) return 'invalid_password'.tr;
                        return null;
                      },
                    ),
                    12.sSize,
                    MainTextField(
                      hint: 'confirm_password'.tr,
                      prefixIcon: const RoundedSquare(icon: 'Lock'),
                      obscureText: true,
                      isPassword: true,
                      validator: (value) {
                        if (value!.isEmpty) return 'enter_password'.tr;
                        if (value != _passwordController.text)
                          return 'doesnot_match'.tr;
                        return null;
                      },
                    ),
                    8.sSize,
                    Row(
                      children: [
                        Checkbox(
                          value: isAccept,
                          fillColor: WidgetStatePropertyAll(isAccept
                              ? AppColors.yPrimaryColor
                              : AppColors.yBGColor),
                          onChanged: (v) => setState(() => isAccept = v ?? false),
                        ),
                        MainText('accept_all'.tr,
                            fontSize: 12, color: Colors.black54),
                        GestureDetector(
                          onTap: () =>
                              AppRoutes.routeTo(context, const TermsPage()),
                          child: MainText(
                            'terms_conditions'.tr,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
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
                          onPressed: authProvider.signupLoader
                              ? null
                              : () async {
                            if (formKey.currentState!.validate()) {
                              if (!isAccept) {
                                GlobalMethods.errorDialog(
                                    title: '',
                                    subtitle: 'accept_terms'.tr,
                                    context: context);
                                return;
                              }
                              authProvider.signup(context,
                                  firstName: _fistNameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  gender: "male",
                                  nationality: widget.nationality,
                                  phone: getPhoneNumber,
                                  password: _passwordController.text);
                            }
                          },
                          child: MainText(
                            authProvider.signupLoader ? 'wait'.tr : 'signup'.tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              32.sSize,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MainText('have_account'.tr,
                      fontSize: 14, color: Colors.black45),
                  InkWell(
                    onTap: () =>
                        AppRoutes.routeRemoveAllTo(context, const LoginPage()),
                    child: MainText('login'.tr,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
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
    String code = widget.countryCode?.dialCode ?? "+20";
    String phone = _phoneController.text.trim();
    if (code == "+20" && phone.startsWith("0")) phone = phone.substring(1);
    return code + phone;
  }
}
