import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/providers/cart/cart_provider.dart';
import 'package:goodealz/views/pages/auth/login/login_page.dart';
import 'package:goodealz/views/pages/cart/cart_page.dart';
import 'package:goodealz/views/pages/favorites/favorites_page.dart';
import 'package:goodealz/views/pages/home/home_page.dart';
import 'package:goodealz/views/pages/profile/profile_page.dart';
import 'package:goodealz/views/pages/withdraw/withdraw_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../providers/auth/auth_provider.dart';

class MainNavBar extends StatelessWidget {
  const MainNavBar({
    super.key,
    required this.index,
  });

  final int? index;

  @override
  Widget build(BuildContext context) {
    bool isGuest = Provider.of<AuthProvider>(context, listen: false).isGuest!;

    return WillPopScope(
      onWillPop: ()async{
        if(index != 0){
          AppRoutes.routeRemoveAllTo(context, const HomePage());
          return false;
        }
        return true;
      },
      child: BottomNavigationBar(
        elevation: 0,
        currentIndex: index!,
        onTap: (value) {
          if (value == 0) {
            AppRoutes.routeRemoveAllTo(context, const HomePage());
          } else if (value == 1) {
            AppRoutes.routeRemoveAllTo(context, const WithdrawPage());
          } else if (value == 2) {
            isGuest ? AppRoutes.routeTo(context, const LoginPage()) : AppRoutes.routeRemoveAllTo(context, const CartPage());
          } else if (value == 3) {
            isGuest ? AppRoutes.routeTo(context, const LoginPage()) : AppRoutes.routeRemoveAllTo(context, const FavoritesPage());
          } else if (value == 4) {
            isGuest ? AppRoutes.routeTo(context, const LoginPage()) : AppRoutes.routeRemoveAllTo(context, const ProfilePage());
          }
        },
        selectedItemColor: AppColors.yPrimaryColor,
        unselectedItemColor: AppColors.yGreyColor,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              getSvgAsset(index == 0 ? 'Home-selected' : 'Home-unselected'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              getSvgAsset(
                  index == 1 ? 'Activity-selected' : 'Activity-unselected'),
            ),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                    getSvgAsset(index == 2 ? 'Buy-selected' : 'Buy-unselected')),
                if(Provider.of<CartProvider>(context).cartCount != 0) Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 12,
                  width: 12,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                  color: AppColors.yPrimaryColor,
                    shape: BoxShape.circle
                  ),
                  child: MainText(
                    Provider.of<CartProvider>(context).cartCount.toString(),
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ))
                // Positioned(
                //     top: -4,
                //     right: -4,
                //     child: CircleAvatar(
                //       radius: 7,
                //       backgroundColor: AppColors.yRedColor,
                //       child: FittedBox(
                //         child: MainText(
                //           '2',
                //           color: AppColors.yWhiteColor,
                //           fontSize: 10,
                //         ),
                //       ),
                //     ))
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
                getSvgAsset(index == 3 ? 'Heart-selected' : 'Heart-unselected')),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(getSvgAsset(
                index == 4 ? 'Profile-selected' : 'Profile-unselected')),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
