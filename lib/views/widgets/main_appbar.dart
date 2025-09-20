import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/rounded_square.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    super.key,
    required this.title,
    required this.actionWidgets,
    this.titleWidget,
    this.appBarHeight = 85,
    this.onBack
  });

final double? appBarHeight;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actionWidgets;
  final Function? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appBarHeight,
      width: context.width,
      child: Padding(
        padding: 16.vhEdge,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                if (Navigator.canPop(context)) {
                  if(onBack != null){
                    onBack!();
                  }
                  else{
                    AppRoutes.pop(context);
                  }
                }
              },
              borderRadius: 12.cBorder,
              child: Navigator.canPop(context)
                  ? RoundedSquare(
                      bgColor: Colors.white,
                      padding: 12.aEdge,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                    )
                  : 16.wSize,
            ),
            titleWidget ??
                MainText(
                  title ?? '',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
            Row(
              children: actionWidgets ?? [32.wSize],
            ),
          ],
        ),
      ),
    );
  }
}
