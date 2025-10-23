import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';


class MainTextField extends StatefulWidget {
  final String hint;
  final FontWeight? fontWeight;
  final Color? colorText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final String? init;
  final bool isDense;
  final EdgeInsets? contentPadding;
  final TextStyle? style;
  final int? maxInputLength;
  final bool hideKeyboard;
  final OutlineInputBorder? border;
  final Color? filledColor;
  final Color? borderColor;
  final bool enable;
  final void Function(String value)? onSubmit;
  final bool unfocusWhenTapOutside;
  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String? value)? validator;
  final String? initialCode;
  final bool isPhone;
  final Function(CountryCode)? onCounteryCodeChange;
  final bool isPassword;

  const MainTextField({
    super.key,
    this.hint = '',
    this.fontWeight,
    this.colorText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.maxLines = 1,
    this.init,
    this.maxInputLength,
    this.border,
    this.isDense = true,
    this.contentPadding,
    this.filledColor = const Color(0xFFF5F5F5),
    this.suffix,
    this.onSubmit,
    this.enable = true,
    this.style,
    this.hideKeyboard = false,
    this.borderColor,
    this.suffixIcon,
    this.unfocusWhenTapOutside = false,
    this.onTap,
    this.onChanged,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onCounteryCodeChange,
    this.isPassword = false,
    this.isPhone = false,
    this.initialCode,
  });

  @override
  State<MainTextField> createState() => MainTextFieldState();
}

class MainTextFieldState extends State<MainTextField> {
  late TextEditingController controller;
  bool _obscureText = false;
  CountryCode _selectedCountry =
  CountryCode.fromCountryCode('EG'); // القيمة الافتراضية

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    controller = widget.controller ?? TextEditingController();
    if (widget.initialCode != null) {
      _selectedCountry = CountryCode.fromCountryCode(widget.initialCode!);
    }
  }

  void _openCountryPickerBottomSheet() async {
    // تحميل ملف الدول من JSON داخل assets
    final jsonString = await DefaultAssetBundle.of(context).loadString('assets/data/countries.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);

    // تحديد اللغة الحالية من الـ locale
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale == 'ar';

    // تحويل البيانات إلى كائنات CountryCode
    final countries = jsonData.map((e) {
      return CountryCode(
        code: e['code'],
        dialCode: e['dial_code'],
        name: isArabic ? e['name_ar'] : e['name_en'],
      );
    }).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final height = MediaQuery.of(context).size.height * 0.35;
        return SafeArea(
          child: SizedBox(
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 50,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    isArabic ? "اختر الدولة" : "Select Country/Region",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Directionality(
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    child: ListView.builder(
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        final country = countries[index];
                        return ListTile(
                          title: Text(country.name ?? ''),
                          trailing: Text(country.dialCode ?? ''),
                          onTap: () {
                            setState(() {
                              _selectedCountry = country;
                            });
                            widget.onCounteryCodeChange?.call(country);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: 1,
      textInputAction: widget.textInputAction,
      cursorHeight: 22.0,
      enabled: widget.enable,
      maxLines: widget.maxLines,
      maxLength: widget.maxInputLength,
      onFieldSubmitted: widget.onSubmit,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      validator: widget.validator,
      style: widget.style ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onTapOutside: (event) {
        if (widget.unfocusWhenTapOutside) {
          FocusScope.of(context).unfocus();
        }
      },
      decoration: InputDecoration(
        isDense: widget.isDense,
        prefixIcon: SizedBox(height: 60, child: widget.prefixIcon),
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: () {
            _obscureText = !_obscureText;
            setState(() {});
          },
          icon: _obscureText
              ? const Icon(CupertinoIcons.eye_slash)
              : const Icon(CupertinoIcons.eye),
        )
            : widget.isPhone
            ? GestureDetector(
          onTap: _openCountryPickerBottomSheet,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 6),
              // Text(
              //   _selectedCountry.flagEmoji ?? '',
              //   style: const TextStyle(fontSize: 18),
              // ),
              const SizedBox(width: 4),
              Text(
                _selectedCountry.dialCode ?? '+20',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
              const SizedBox(width: 8),
            ],
          ),
        )
            : widget.suffixIcon,
        contentPadding: widget.contentPadding,
        hintText: widget.hint.isNotEmpty ? widget.hint : null,
        hintStyle: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
        border: _border(color: widget.borderColor ?? Colors.white),
        disabledBorder: _border(color: widget.borderColor ?? Colors.white),
        enabledBorder: _border(color: widget.borderColor ?? Colors.white),
        focusedBorder: _border(color: Colors.blue),
        errorBorder: _errorBorder(color: Colors.red),
        fillColor: widget.filledColor ?? Colors.white,
        filled: true,
      ),
    );
  }

  OutlineInputBorder _border({required Color color}) {
    return widget.border == null
        ? OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    )
        : widget.border!.copyWith(borderSide: BorderSide(color: color));
  }

  OutlineInputBorder _errorBorder({required Color color}) {
    return widget.border == null
        ? OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    )
        : widget.border!.copyWith(borderSide: BorderSide(color: color));
  }
}


class MainMultiLinesTextField extends StatefulWidget {
  const MainMultiLinesTextField({
    super.key,
    this.hint = '',
    this.fontWeight,
    this.colorText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.init,
    this.maxInputLength,
    this.border,
    this.isDense = true,
    this.contentPadding,
    this.filledColor = const Color(0xFFFFFFFF),
    this.suffix,
    this.onSubmit,
    this.enable = true,
    this.style,
    this.hideKeyboard = false,
    this.borderColor,
    this.suffixIcon,
    this.unfocusWhenTapOutside = false,
    this.onTap,
    this.onChanged,
    this.controller,
    this.obscureText = false,
    this.validator,
  });
  final String hint;
  final FontWeight? fontWeight;
  final Color? colorText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final int? maxLines;
  final String? init;
  final bool isDense;
  final EdgeInsets? contentPadding;
  final TextStyle? style;
  final int? maxInputLength;
  final bool hideKeyboard;
  final OutlineInputBorder? border;
  final Color? filledColor;
  final Color? borderColor;
  final bool enable;
  final void Function(String value)? onSubmit;
  final bool unfocusWhenTapOutside;
  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String? value)? validator;
  @override
  State<MainMultiLinesTextField> createState() =>
      _MainMultiLinesTextFieldState();
}

class _MainMultiLinesTextFieldState extends State<MainMultiLinesTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorHeight: 22.0,
      enabled: widget.enable,
      maxLines: widget.maxLines,
      maxLength: widget.maxInputLength,
      onFieldSubmitted: widget.onSubmit,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      validator: widget.validator,
      style: widget.style ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onTapOutside: (event) {
        if (widget.unfocusWhenTapOutside) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
      decoration: InputDecoration(
        isDense: widget.isDense,
        prefixIcon: widget.prefixIcon,
        suffix: widget.suffix,
        contentPadding: widget.contentPadding,
        hintText: widget.hint.isNotEmpty ? widget.hint : null,
        hintStyle: const TextStyle(
          fontSize: 13,
          color: AppColors.yGreyColor,
          fontWeight: FontWeight.w400,
        ),

        border: _border(color: widget.borderColor ?? AppColors.yWhiteColor),
        disabledBorder:
            _border(color: widget.borderColor ?? AppColors.yWhiteColor),
        enabledBorder:
            _border(color: widget.borderColor ?? AppColors.yWhiteColor),
        focusedBorder: _border(color: AppColors.yPrimaryColor),
        fillColor: widget.filledColor ?? AppColors.yWhiteColor,
        filled: true,
        suffixIcon: widget.suffixIcon,
      ),
    );
  }

  OutlineInputBorder _border({required Color color}) {
    return OutlineInputBorder(
      borderRadius: 12.cBorder,
      borderSide: BorderSide(color: color),
    );
  }
}
