import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/views/widgets/main_appbar.dart';
import 'package:goodealz/views/widgets/main_drawer.dart';
import 'package:goodealz/views/widgets/main_nav_bar.dart';

import '../../core/ys_localizations/ys_localizations_provider.dart';
import '../../providers/conectivity_provider.dart';
import 'Connection_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    this.body,
    this.subAppBar,
    this.isAppBar = true,
    this.isBackgroundImage = true,
    this.title = '',
    this.actionWidgets,
    this.onRefresh,
    this.bottomNavigationBarIndex,
    this.isWhiteLayer = true,
    this.titleWidget,
    this.backgroundImage,
    this.appBarHeight,
    this.onBack,
    this.noDrawer = false,
  });

  final Widget? body;
  final Widget? titleWidget;
  final Widget? subAppBar;
  final bool isAppBar;
  final bool isBackgroundImage;
  final Widget? backgroundImage;
  final bool isWhiteLayer;
  final String? title;
  final List<Widget>? actionWidgets;
  final Future<void> Function()? onRefresh;
  final int? bottomNavigationBarIndex;
  final double? appBarHeight;
  final Function? onBack;
  final bool noDrawer;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? (() => Future.delayed(Duration.zero)),
      edgeOffset: onRefresh != null ? 0 : -300,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFD),
        body: Stack(
          children: [
            isBackgroundImage
                ? backgroundImage ??
                    SizedBox(
                      width: context.width,
                      height: context.height,
                      child: SvgPicture.asset(getSvgAsset('splash_bg')),
                    )
                : 0.sSize,
            isWhiteLayer
                ? Container(
                    height: context.height,
                    width: context.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.yBGColor.withOpacity(0.1),
                          AppColors.yBGColor,
                        ],
                      ),
                    ),
                  )
                : 0.sSize,
            SafeArea(
              child: Column(
                children: [
                  isAppBar
                      ? MainAppBar(
                          title: title,
                          titleWidget: titleWidget,
                          actionWidgets: actionWidgets,
                          appBarHeight: appBarHeight,
                    onBack: onBack
                        )
                      : 0.hSize,
                  subAppBar ?? 0.hSize,
                  Expanded(child: Consumer<ConectivityProvider>(
          builder: (context, connect, _) {
    if(connect.isOffline){
      return const NoConnectionWidget();
    }
                      return body ?? 0.hSize;
                    }
                  )),
                ],
              ),
            ),
          ],
        ),
        drawer: noDrawer ? null :  const MainDrawer(),
        bottomNavigationBar: bottomNavigationBarIndex != null
            ? MainNavBar(index: bottomNavigationBarIndex)
            : null,
      ),
    );
  }
}
