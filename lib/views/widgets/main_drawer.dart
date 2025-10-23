import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/data/local/local_data.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/views/pages/about/about_page.dart';
import 'package:goodealz/views/pages/contact_us/contact_us_page.dart';
import 'package:goodealz/views/pages/coupons/coupons_page.dart';
import 'package:goodealz/views/pages/faq/faq_page.dart';
import 'package:goodealz/views/pages/favorites/favorites_page.dart';
import 'package:goodealz/views/pages/home/home_page.dart';
import 'package:goodealz/views/pages/languages/languages_page.dart';
import 'package:goodealz/views/pages/my_account/my_account_page.dart';
import 'package:goodealz/views/pages/my_orders/my_orders_page.dart';
import 'package:goodealz/views/pages/privacy/privacy_page.dart';
import 'package:goodealz/views/pages/profile/profile_page.dart';
import 'package:goodealz/views/pages/terms/terms_page.dart';
import 'package:goodealz/views/pages/tickets/tickets_page.dart';
import 'package:goodealz/views/pages/wallets/wallets_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/rounded_square.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/auth/login/login_page.dart';
import '../pages/how it works/how_it_works_page.dart';
import '../pages/live_draws/live_draws_page.dart';
import '../pages/purchase_code/purchase_code_page.dart';
import '../pages/winners_video_page.dart';
import 'dialog/confirmation_dialog.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<AuthProvider>(context, listen: false).currentUser;
    final isGuest = Provider.of<AuthProvider>(context, listen: false).isGuest;
    return Drawer(
      width: context.width * 0.75,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Container(
          padding: 16.aEdge,
          child: Column(
            children: [
              16.sSize,
              GestureDetector(
                onTap: () {
                  AppRoutes.routeRemoveAllTo(context, const ProfilePage());
                },
                child: Row(
                  children: [
                    ClipOval(
                      child: FancyShimmerImage(
                        imageUrl: currentUser?.avatar ?? "",
                        height: 100,
                        width: 100,
                        boxFit: BoxFit.cover,
                        errorWidget: Image.asset(
                          getPngAsset('person'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    16.sSize,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText(
                          currentUser?.fullName == null ||
                                  currentUser?.fullName == ''
                              ? currentUser?.name ?? ''
                              : currentUser?.fullName ?? "",
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        // MainText(
                        //   'Flutter Developer',
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 2,
                        //   fontSize: 14,
                        //   color: Colors.black.withOpacity(0.6),
                        //   fontWeight: FontWeight.w400,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              32.sSize,
              Expanded(
                child: ListView.builder(
                  itemCount: drawer(context, isGuest!).length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: drawer(context, isGuest)[i].onTap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RoundedSquare(
                            size: 35,
                            padding: 8.aEdge,
                            child: SvgPicture.asset(
                              getSvgAsset(drawer(context, isGuest)[i].icon),
                              color: drawer(context, isGuest)[i].icon ==
                                      'deleteAccount'
                                  ? AppColors.yPrimaryColor
                                  : AppColors.yDarkColor,
                            ),
                          ),
                          8.sSize,
                          MainText(
                            drawer(context, isGuest)[i].title,
                            color: drawer(context, isGuest)[i].icon ==
                                'deleteAccount'
                                ? AppColors.yPrimaryColor : Colors.black.withOpacity(i == 0 ? 1 : 0.9),
                            fontWeight: i == 0 ? FontWeight.w600 : null,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              16.sSize,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () async {
                        if (await canLaunchUrl(
                            Uri.parse('https://www.facebook.com/share/1B9WXVQANj/'))) {
                          await launchUrl(
                              Uri.parse('https://www.facebook.com/share/1B9WXVQANj/'));
                        } else {
                          showSnackbar('Could not launch Facebook page',
                              error: true);
                        }
                      },
                      child: SvgPicture.asset(
                          getSvgAsset('mingcute_facebook-line'), colorFilter: const ColorFilter.mode(AppColors.yDarkColor, BlendMode.srcIn),)),
                  GestureDetector(
                      onTap: () async {
                        if (await canLaunchUrl(
                            Uri.parse('https://www.instagram.com/gooddeals.eg?igsh=MXVtM202dWh3eGlqaQ=='))) {
                          await launchUrl(
                            Uri.parse('https://www.instagram.com/gooddeals.eg?igsh=MXVtM202dWh3eGlqaQ=='),
                          );
                        } else {
                          showSnackbar('Could not launch instagram page',
                              error: true);
                        }
                      },
                      child:
                          SvgPicture.asset(getSvgAsset('iconoir_instagram'), colorFilter: const ColorFilter.mode(AppColors.yDarkColor, BlendMode.srcIn))),
                  GestureDetector(
                      onTap: () async {
                        if (await canLaunchUrl(
                            Uri.parse('https://x.com/GoodealzE72535?t=_z1SAAb711UB93J7F6n_-A&s=09'))) {
                          await launchUrl(
                              Uri.parse('https://x.com/GoodealzE72535?t=_z1SAAb711UB93J7F6n_-A&s=09'));
                        } else {
                          showSnackbar('Could not launch twitter page',
                              error: true);
                        }
                      },
                      child: SvgPicture.asset(
                          getSvgAsset('teenyicons_twitter-outline'), colorFilter: const ColorFilter.mode(AppColors.yDarkColor, BlendMode.srcIn),)),
                ],
              ),
              // 6.sSize,
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem {
  final String icon;
  final String title;
  final void Function() onTap;
  DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

List<DrawerItem> drawer(BuildContext context, bool isGuest) => [
      DrawerItem(
        icon: 'Home',
        title: 'home'.tr,
        onTap: () {
          AppRoutes.routeRemoveAllTo(context, const HomePage());
        },
      ),
      if (!isGuest)
        DrawerItem(
          icon: 'Profile-f',
          title: 'my_account'.tr,
          onTap: () {
            AppRoutes.routeTo(context, const MyAccountPage());
          },
        ),
      DrawerItem(
        icon: 'ic_round-language',
        title: 'languages'.tr,
        onTap: () {
          AppRoutes.routeTo(context, const LanguagesPage());
        },
      ),
      DrawerItem(
        icon: 'live',
        title: 'live_draws'.tr,
        onTap: () {
          AppRoutes.routeTo(context, const LiveDrawsPage());
        },
      ),
      if (!isGuest)
        DrawerItem(
          icon: 'ep_ticket',
          title: 'purchase_codes'.tr,
          onTap: () {
            AppRoutes.routeTo(context, const PurchaseCodePage());
          },
        ),
      if (!isGuest)
        DrawerItem(
          icon: 'Discount',
          title: 'coupons'.tr,
          onTap: () {
            AppRoutes.routeTo(context, const CouponsPage());
          },
        ),
      if (!isGuest)
        DrawerItem(
          icon: 'File_dock_duotone_2x',
          title: 'tickets'.tr,
          onTap: () {
            AppRoutes.routeTo(context, const TicketsPage());
          },
        ),
      if (!isGuest)
        DrawerItem(
          icon: 'Wallet',
          title: 'wallets'.tr,
          onTap: () {
            AppRoutes.routeTo(context, const WalletsPage());
          },
        ),
      if (!isGuest)
        DrawerItem(
          icon: 'Bag',
          title: 'my_orders'.tr,
          onTap: () {
            AppRoutes.routeTo(context, const MyOrdersPage());
          },
        ),
      DrawerItem(
        icon: 'Calling-f',
        title: 'contact_us'.tr,
        onTap: () {
          AppRoutes.routeTo(context, const ContactUsPage());
        },
      ),
      DrawerItem(
        icon: 'Document',
        title: 'about_us'.tr,
        onTap: () {
          AppRoutes.routeTo(context, const AboutPage());
        },
      ),
      DrawerItem(
        icon: 'Lock-f',
        title: 'privacy_policy'.tr,
        onTap: () {
          AppRoutes.routeTo(context, const PrivacyPage());
        },
      ),
      DrawerItem(
        icon: 'Password',
        title: 'terms_and_conditions'.tr,
        onTap: () {
          AppRoutes.routeTo(context, const TermsPage());
        },
      ),
      DrawerItem(
        icon: 'Info Square',
        title: 'faq'.tr,
        onTap: () {
          AppRoutes.routeTo(context, const FAQPage());
        },
      ),
      DrawerItem(
        icon: 'Video_fill_3x',
        title: 'how_it_works'.tr,
        onTap: () {
          AppRoutes.routeTo(context, const HowItWorksPage());
        },
      ),
      // DrawerItem(
      //       icon: 'Video_fill_3x',
      //       title: 'winners'.tr,
      //       onTap: () {
      //         AppRoutes.routeTo(context, const WinnersVideoPage());
      //       },
      //     ),
      isGuest
          ? DrawerItem(
              icon: 'login',
              title: 'login'.tr,
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).notGuest();
                AppRoutes.routeRemoveAllTo(context, const LoginPage());
              },
            )
          : DrawerItem(
              icon: 'Logout',
              title: Provider.of<AuthProvider>(context).logoutLoader
                  ? 'wait'.tr
                  : 'logout'.tr,
              onTap: Provider.of<AuthProvider>(context).logoutLoader
                  ? () {}
                  : () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout(context);
                    },
            ),
      if (!isGuest)
        DrawerItem(
          icon: 'deleteAccount',
          title: 'delete_account'.tr,
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => ConfirmationDialog(
                    icon: 'deleteAccount',
                    description: 'delete_account_desc'.tr,
                    isLogOut: true,
                    onYesPressed: () =>
                        Provider.of<AuthProvider>(context, listen: false)
                            .deleteAccount(context)));
          },
        ),
    ];
