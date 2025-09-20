import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/views/pages/coupons/coupons_page.dart';
import 'package:goodealz/views/pages/my_account/my_account_page.dart';
import 'package:goodealz/views/pages/my_orders/my_orders_page.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AuthProvider>(context, listen: false).getProfileData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).currentUser;

    return MainPage(
      isWhiteLayer: false,
      bottomNavigationBarIndex: 4,
      backgroundImage: SizedBox(
        width: context.width,
        height: 220,
        child: SvgPicture.asset(
          getSvgAsset('profile_bg'),
          fit: BoxFit.fill,
        ),
      ),
      title: 'profile'.tr,
      // actionWidgets: [
      //   InkWell(
      //     onTap: () {
      //       AppRoutes.routeTo(context, MyAccountPage());
      //     },
      //     child: SvgPicture.asset(getSvgAsset('points_menu')),
      //   )
      // ],
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              AppRoutes.routeTo(context, MyAccountPage(), then: (val){
                setState(() {});});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                50.sSize,
                ClipOval(
                  child: FancyShimmerImage(
                    imageUrl: currentUser?.avatar??"",
                    height: 100,
                    width: 100,
                    boxFit: BoxFit.cover,
                    errorWidget: Image.asset(
                      getPngAsset('person'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                8.sSize,
                MainText(
                  currentUser?.firstName == null || currentUser?.firstName == ''? currentUser?.name??'':
                  '${currentUser?.firstName??""} ${currentUser?.lastName??""}',
                  overflow: TextOverflow.ellipsis,
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                MainText(
                  currentUser?.email??"",
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          16.sSize,
          Expanded(
            child: Consumer<AuthProvider>(builder: (context, authProvider, _) {
              return authProvider.profileLoader
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      padding: 16.aEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ProfileInfoCard(
                                icon: 'Bag2',
                                color: const Color(0x19EF040D),
                                title: 'order_progress'.tr,
                                subTitle:
                                    '${authProvider.userProfile?.order?.length ?? ""}',
                                onTap: (){
                                  AppRoutes.routeTo(context, const MyOrdersPage(), then: (val){
                setState(() {});});
                                },
                              ),
                              12.sSize,
                              ProfileInfoCard(
                                icon: 'Ticket2',
                                color: const Color(0x110EA2F6),
                                title: 'promocodes'.tr,
                                subTitle:
                                    '${authProvider.userProfile?.couponsCount ?? ""}',
                                onTap: (){
                                  AppRoutes.routeTo(context, const CouponsPage(fromProfile: true,), then: (val){
                setState(() {});});
                                },
                              ),
                              // 12.sSize,
                              // const ProfileInfoCard(
                              //   icon: 'star 5',
                              //   color: Color(0x11FFC107),
                              //   title: 'Reviewes',
                              //   subTitle: '4.5K',
                              // ),
                            ],
                          ),
                          24.sSize,
                          MainText(
                            'personal_information'.tr,
                            color: const Color(0xFF231F20),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          16.sSize,
                          Container(
                            width: context.width,
                            padding: 16.aEdge,
                            decoration: BoxDecoration(
                              borderRadius: 12.cBorder,
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Column(
                              children: [
                                InfoRow(
                                  title: '${'name'.tr} :',
                                  subTitle:
                                      authProvider.userProfile?.firstName == null || authProvider.userProfile?.firstName == ''? authProvider.userProfile?.name??'':
                  '${authProvider.userProfile?.firstName??""} ${authProvider.userProfile?.lastName??""}',
                                ),
                                16.sSize,
                                InfoRow(
                                  title: '${'email'.tr} :',
                                  subTitle: authProvider.userProfile?.email ?? "",
                                ),
                                16.sSize,
                                InfoRow(
                                  title: '${'nationality'.tr} :',
                                  subTitle: authProvider.userProfile?.nationality ?? "",
                                ),
                                // 16.sSize,
                                // const InfoRow(
                                //   title: 'Zip Code :',
                                //   subTitle: '35758',
                                // ),
                                16.sSize,
                                InfoRow(
                                  title: '${'phone'.tr} :',
                                  subTitle: authProvider.userProfile?.phone ?? "",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
            }),
          ),
          32.sSize,
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MainText(
          title,
          fontSize: 14,
          color: Colors.black54,
        ),
        MainText(
          subTitle,
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  final String icon;
  final Color color;
  final String title;
  final String subTitle;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: ()=>onTap(),
        child: Card(
          surfaceTintColor: Colors.white,
          elevation: 3,
          margin: 0.aEdge,
          child: Padding(
            padding: 16.hvEdge,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: color,
                  child: SvgPicture.asset(getSvgAsset(icon)),
                ),
                16.sSize,
                FittedBox(
                  child: MainText(
                    title,
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                8.sSize,
                MainText(
                  subTitle,
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
