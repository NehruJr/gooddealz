import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/data/models/teckets/purchase_code_model.dart';

import '../../../../core/constants/app_colors.dart';


class PurchaseCodeDropDown extends StatelessWidget {

  PurchaseCodeDropDown(
      {required this.list,
        required this.onChange,
        required this.validator,
        this.item,
        this.enabled,
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
        Key? key}) :
        super(key: key);

  List<PurchaseCode> list; Function onChange;
  PurchaseCode ? item; String hint;
  bool? enabled;
  final FontWeight? fontWeight;
  final Color? colorText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
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
  final String? Function(PurchaseCode? value)? validator;

  @override
  Widget build(BuildContext context) {
    return  DropdownSearch<PurchaseCode>(
      popupProps: const PopupProps.menu(
          fit: FlexFit.loose,
          showSearchBox: true
      ),
      dropdownButtonProps: const DropdownButtonProps(
          color: AppColors.yGreyColor
      ),
      items: list,
      itemAsString: (PurchaseCode p) => p.code!,
      validator: validator,
      enabled: enabled ?? true,
      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: const TextStyle(fontSize: 14,
          fontWeight: FontWeight.w500,),
        dropdownSearchDecoration: InputDecoration(
          isDense: isDense,
          prefixIcon: SizedBox(height: 60, child: prefixIcon),
          prefixIconColor: AppColors.yPrimaryColor,
          suffix: suffix,
          contentPadding: contentPadding,
          hintText: hint.isNotEmpty ? hint : null,
          hintStyle: const TextStyle(
            fontSize: 13,
            color: AppColors.yGreyColor,
            fontWeight: FontWeight.w400,
          ),
          border: _border(color: borderColor ?? AppColors.yWhiteColor),
          disabledBorder:
          _border(color: borderColor ?? AppColors.yWhiteColor),
          enabledBorder:
          _border(color: borderColor ?? AppColors.yWhiteColor),
          focusedBorder: _border(color: AppColors.yPrimaryColor),
          errorBorder: _errorBorder(color: AppColors.yRedColor),
          fillColor: filledColor ?? AppColors.yWhiteColor,
          filled: true,
          suffixIcon: suffixIcon,
        ),
      ),
      onChanged:(value)=> onChange(value),
      selectedItem: item,
    );
  }

  OutlineInputBorder _border({required Color color}) {
    return border == null
        ? OutlineInputBorder(
      borderRadius: 12.cBorder,
      borderSide: BorderSide(color: color),
    )
        : border!.copyWith(borderSide: BorderSide(color: color));
  }

  OutlineInputBorder _errorBorder({required Color color}) {
    return border == null
        ? OutlineInputBorder(
      borderRadius: 12.cBorder,
      borderSide: BorderSide(color: color),
    )
        : border!.copyWith(borderSide: BorderSide(color: color));
  }
}


