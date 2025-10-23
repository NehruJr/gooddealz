import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/extensions/validations.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/models/user_model.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/dialog/confirmation_dialog.dart';
import '../../widgets/rounded_square.dart';
import 'change_password_page.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final _nameController = TextEditingController();
  // final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  late String oldPhone;
  late String oldEmail;

  final formKey = GlobalKey<FormState>();

  User? user;
  File? _imageFile;

  CountryCode? _countryCode;
  String? _initialCode;

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false).currentUser;

    _nameController.text = user!.fullName ?? '';
    // _lastNameController.text = user!.lastName ?? '';
    _emailController.text = user!.email ?? '';
    // _phoneController.text =user?.phone != null && user!.phone!.contains('+') ? user!.phone!.substring(2) : user!.phone ?? '';

    _initialCode = getCountryCode(user!.phone ?? '');
    _phoneController.text = removeCountryCode(user!.phone ?? '');
    oldPhone = _phoneController.text;
    oldEmail = _emailController.text;
  }

  @override
  Widget build(BuildContext context) {

    return MainPage(
      title: 'my_account'.tr,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: 16.aEdge,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    32.sSize,
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // ClipRRect(
                        //   borderRadius: 12.cBorder,
                        //   child: Image.asset(
                        //     getPngAsset('person'),
                        //   ),
                        // ),
                        (_imageFile != null)
                            ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(_imageFile!),
                            ),
                          ),
                        )
                            : ClipOval(
                          child: FancyShimmerImage(
                            imageUrl: user!.avatar ?? "",
                            height: 100,
                            width: 100,
                            boxFit: BoxFit.cover,
                            errorWidget: Image.asset(
                              getPngAsset('person'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return bottomSheet();
                                });
                          },
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.yDarkColor,
                            child: SvgPicture.asset(getSvgAsset('Edit2'), colorFilter: const ColorFilter.mode(AppColors.yBGColor, BlendMode.srcIn),),
                          ),
                        )
                      ],
                    ),
                    64.sSize,
                    MainTextField(
                      hint: 'name'.tr,
                      unfocusWhenTapOutside: true,
                      controller: _nameController,
                      prefixIcon: Padding(
                        padding: 12.aEdge,
                        child: SvgPicture.asset(getSvgAsset('Profile_p'), colorFilter: const ColorFilter.mode(AppColors.yDarkColor, BlendMode.srcIn),),
                      ),
                      suffixIcon: Padding(
                        padding: 10.aEdge,
                        child: SvgPicture.asset(getSvgAsset('Edit Square2'), colorFilter: const ColorFilter.mode(AppColors.yDarkColor, BlendMode.srcIn),),
                      ),
                      validator: (value) {
                        if (!(value ?? '').isValidName) {
                          return '';
                        } else {
                          return null;
                        }
                      },
                    ),
                    16.sSize,
                    MainTextField(
                      hint: 'email'.tr,
                      unfocusWhenTapOutside: true,
                      controller: _emailController,
                      prefixIcon: Padding(
                        padding: 12.aEdge,
                        child: SvgPicture.asset(getSvgAsset('mail_p'), colorFilter: const ColorFilter.mode(AppColors.yDarkColor, BlendMode.srcIn),),
                      ),
                      suffixIcon: Padding(
                        padding: 10.aEdge,
                        child: SvgPicture.asset(getSvgAsset('Edit Square2'), colorFilter: const ColorFilter.mode(AppColors.yDarkColor, BlendMode.srcIn),),
                      ),
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
                    16.sSize,
                    MainTextField(
                      hint: 'phone'.tr,
                      unfocusWhenTapOutside: true,
                      controller: _phoneController,
                      prefixIcon: const RoundedSquare(icon: 'Calling'),
                      keyboardType: TextInputType.phone,
                      isPhone: true,
                      initialCode: _initialCode,
                      onCounteryCodeChange: (code){
                        _countryCode = code;
                      },
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
            ),
          ),
          Consumer<AuthProvider>(builder: (context, authProvider, _) {
            return MainButton(
              width: context.width - 100,
              color: authProvider.updateProfileLoader
                  ? AppColors.ySecondryColor
                  : AppColors.yPrimaryColor,
              onPressed: authProvider.updateProfileLoader
                  ? (){} : () async {
                if (formKey.currentState!.validate()) {
                  String? fullName = _nameController.text.isEmpty
                      ? null
                      : _nameController.text.trim();
                  // String? lastName = _lastNameController.text.isEmpty
                  //     ? null
                  //     : _lastNameController.text.trim();
                  String? email = _emailController.text.isEmpty
                      ? null
                      : _emailController.text.trim();
                  String? phone = _phoneController.text.isEmpty
                      ? null
                      : _phoneController.text.trim();
                  // String? password = _passwordController.text.isEmpty
                  //     ? null
                  //     : _passwordController.text;

                  if(oldPhone != phone && oldEmail != email){
                    showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                            icon: 'black_logo',
                            description: '${'change_phone'.tr} $getPhoneNumber \n${'and'.tr} ${'email'.tr} $email',
                            onYesPressed:()=>
                                authProvider.updateProfile(context,
                                    fullName: fullName,
                                    // lastName: lastName,
                                    email: email,
                                    avatar: _imageFile,
                                    phone: getPhoneNumber,
                                    password: null,
                                    newPhone: oldPhone != phone || oldEmail != email
                                )
                        ));
                  }
                  else if(oldPhone != phone){
                    showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                            icon: 'black_logo',
                            description: '${'change_phone'.tr} $getPhoneNumber',
                            onYesPressed:()=>
                                authProvider.updateProfile(context,
                                    fullName: fullName,
                                    // lastName: lastName,
                                    email: email,
                                    avatar: _imageFile,
                                    phone: getPhoneNumber,
                                    password: null,
                                    newPhone: oldPhone != phone || oldEmail != email
                                )
                        ));
                  }
                  else if(oldEmail != email){
                    showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                            icon: 'black_logo',
                            description: '${'change_email'.tr} $email',
                            onYesPressed:()=>
                                authProvider.updateProfile(context,
                                    fullName: fullName,
                                    // lastName: lastName,
                                    email: email,
                                    avatar: _imageFile,
                                    phone: phone,
                                    password: null,
                                    newPhone: oldPhone != phone || oldEmail != email
                                )
                        ));
                  }
                  else {
                    authProvider.updateProfile(context,
                        fullName: fullName,
                        // lastName: lastName,
                        email: email,
                        avatar: _imageFile,
                        phone: getPhoneNumber,
                        password: null,
                        newPhone: oldPhone != phone || oldEmail != email);
                  }
                }
              },
              child: MainText(
                authProvider.updateProfileLoader ? 'wait'.tr : 'save_edit'.tr,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            );
          }),

          16.sSize,
          Consumer<AuthProvider>(builder: (context, authProvider, _) {
            return MainButton(
              width: context.width - 100,
              color: AppColors.yBlackColor,
              onPressed: () async {
                AppRoutes.routeTo(context, ChangePasswordPage(phone: user!.phone!, ));
              },
              child: MainText('change_password'.tr,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            );
          }),
          16.sSize,
        ],
      ),
    );
  }

  bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'choose_photo'.tr,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              TextButton.icon(
                icon: const Icon(
                  Icons.camera,
                ),
                onPressed: () {
                  _getImage(ImageSource.camera);
                },
                label: Text('camera'.tr),
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.image,
                ),
                onPressed: () {
                  _getImage(ImageSource.gallery);
                },
                label: Text('gallery'.tr),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  String get getPhoneNumber {
    String code = _countryCode == null ? getCountryDialCode(_initialCode ?? "EG") : _countryCode!.dialCode!;
    String phone = _phoneController.text.trim();

    if(code == "+20" && phone.startsWith("0")){
      phone = phone.substring(1);
    }
    else if(phone.startsWith("+")){
      return phone;
    }
    return code + phone;
  }

  String removeCountryCode(String phoneNumber) {
    CountryCodePicker codePicker = const CountryCodePicker();

    for (var country in codePicker.countryList) {
      String dialCode = country['dial_code']!;
      if (phoneNumber.startsWith(dialCode)) {
        return phoneNumber.replaceFirst(dialCode, '').trim();
      }
    }
    return phoneNumber; // Return original if no matching dial code found
  }

  String getCountryCode(String phoneNumber) {
    CountryCodePicker codePicker = const CountryCodePicker();
    for (var country in codePicker.countryList) {
      String dialCode = country['dial_code']!;
      if (phoneNumber.startsWith(dialCode)) {
        return country['code']!; // Return country code (e.g., AF for Afghanistan)
      }
    }
    return 'Unknown'; // Return 'Unknown' if no matching dial code is found
  }

  String getCountryDialCode(String code) {
    CountryCodePicker codePicker = const CountryCodePicker();
    for (var country in codePicker.countryList) {
      if (country['code'] == code) {
        return country['dial_code']!; // Return country code (e.g., AF for Afghanistan)
      }
    }
    return 'Unknown'; // Return 'Unknown' if no matching dial code is found
  }

}
