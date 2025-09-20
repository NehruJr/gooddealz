import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';

class RoundedSquare extends StatelessWidget {
  const RoundedSquare({
    super.key,
    this.icon,
    this.bgColor,
    this.size,
    this.padding,
    this.child,
    this.onTap,
  });
  final String? icon;
  final Color? bgColor;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size ?? 40,
        height: size,
        margin: 8.aEdge,
        padding: padding ?? 10.aEdge,
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.yPrimaryColor.withOpacity(0.1),
          borderRadius: 8.cBorder,
          boxShadow: bgColor == Colors.white
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.07), blurRadius: 5)
                ]
              : null,
        ),
        child: child ??
            SvgPicture.asset(
              getSvgAsset(icon ?? ''),
              color: AppColors.yPrimaryColor
            ),
      ),
    );
  }
}
