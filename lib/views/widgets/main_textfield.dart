import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';

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
  final String?  initialCode;
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
  TextEditingController controller = TextEditingController();

  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword ;
  }

  @override
  void didUpdateWidget(MainTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      print('ppoopp');
      controller = widget.controller!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
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
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },

      decoration: InputDecoration(
        isDense: widget.isDense,
        prefixIcon: SizedBox(height: 60, child: widget.prefixIcon),
        suffixIcon: widget.isPassword ? IconButton(onPressed: (){
          _obscureText = !_obscureText;
          setState(() {});
        }, icon: _obscureText ? const Icon(CupertinoIcons.eye_slash) : const Icon(CupertinoIcons.eye)) :
        widget.isPhone ?
        Directionality(
          textDirection: TextDirection.ltr,
          child: CountryCodePicker(
            // countryFilter: ["SA"],
            onChanged: widget.onCounteryCodeChange,
            initialSelection: widget.initialCode ?? 'EG',
            // flagWidth: 20,
            padding: EdgeInsets.zero,
            // flagDecoration: const BoxDecoration(
            //     shape: BoxShape.circle
            // ),
            textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400),
            // favorite: const ['+91', 'IN'],
            showCountryOnly: false,
            showFlag: false,
            showFlagDialog: false,
            showDropDownButton: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
          ),
        ) :
        widget.suffixIcon,
        contentPadding: widget.contentPadding,
        hintText: widget.hint.isNotEmpty ? widget.hint : null,
        hintStyle: const TextStyle(
          fontSize: 13,
          color: AppColors.yBlackColor,
          fontWeight: FontWeight.w400,
        ),
        border: _border(color: widget.borderColor ?? AppColors.yWhiteColor),
        disabledBorder:
            _border(color: widget.borderColor ?? AppColors.yWhiteColor),
        enabledBorder:
            _border(color: widget.borderColor ?? AppColors.yWhiteColor),
        focusedBorder: _border(color: AppColors.yPrimaryColor),
        errorBorder: _errorBorder(color: AppColors.yRedColor),
        fillColor: widget.filledColor ?? AppColors.yWhiteColor,
        filled: true,
        // suffixIcon: widget.suffixIcon,
      ),
    );
  }

  OutlineInputBorder _border({required Color color}) {
    return widget.border == null
        ? OutlineInputBorder(
            borderRadius: 12.cBorder,
            borderSide: BorderSide(color: color),
          )
        : widget.border!.copyWith(borderSide: BorderSide(color: color));
  }

  OutlineInputBorder _errorBorder({required Color color}) {
    return widget.border == null
        ? OutlineInputBorder(
            borderRadius: 12.cBorder,
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
