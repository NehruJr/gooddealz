import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/data/local/local_data.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/providers/cart/cart_provider.dart';
import 'package:goodealz/views/pages/auth/login/login_page.dart';
import 'package:goodealz/views/pages/home/home_page.dart';
import 'package:goodealz/views/pages/welcome/onboarding/onboarding_page.dart';
import 'package:goodealz/views/widgets/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () async {
      // _setGoogleMapApiKey("AIzaSyBLelj-m_yNs9NZTYfyo7aN7oVAJTugkHs");

      if(!LocalData.openedOnBoarding) {
        AppRoutes.routeRemoveAllTo(context, const OnboardingPage());
        return;
      }

      if(LocalData.isLogin){
        Provider.of<AuthProvider>(context, listen: false).getUserData();
        Provider.of<AuthProvider>(context, listen: false).updateFCM();
        Provider.of<CartProvider>(context, listen: false).getCartCount(context);
        AppRoutes.routeRemoveAllTo(context, const HomePage());
      }else{
        AppRoutes.routeRemoveAllTo(context, const LoginPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 70,
              child: SvgPicture.asset(
                getSvgAsset('logo'),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  static const METHOD_CHANNEL = MethodChannel('com.map_api_key.flutter');

  Future<void> _setGoogleMapApiKey(String mapKey) async {
    /// Map data for passing to native code
    Map<String, dynamic> requestData = {"mapKey": mapKey};

    METHOD_CHANNEL.invokeMethod('setGoogleMapKey', requestData).then((value) {
      /// You can receive result back from native code
    });
  }

}
