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
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _controller;
  bool _isFadingOut = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://drive.google.com/uc?export=download&id=18x7emeduv0jIMv-zD6cYjgf2gwOcaD9b'),
    )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          _controller.value.isInitialized) {
        _navigateNext();
      }
    });
  }

  void _navigateNext() {
    if (!LocalData.openedOnBoarding) {
      AppRoutes.routeRemoveAllTo(context, const OnboardingPage());
      return;
    }

    if (LocalData.isLogin) {
      Provider.of<AuthProvider>(context, listen: false).getUserData();
      Provider.of<AuthProvider>(context, listen: false).updateFCM();
      Provider.of<CartProvider>(context, listen: false).getCartCount(context);
      AppRoutes.routeRemoveAllTo(context, const HomePage());
    } else {
      AppRoutes.routeRemoveAllTo(context, const LoginPage());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? SizedBox.expand(
        child: InkWell(
          onTap: () async{
            if (_controller.value.isPlaying) {
              setState(() => _isFadingOut = true);
              await _controller.setVolume(0);
              await Future.delayed(const Duration(milliseconds: 250));
              await _controller.pause();
            }
            _navigateNext();
          },
          child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  static const METHOD_CHANNEL = MethodChannel('com.map_api_key.flutter');

  Future<void> _setGoogleMapApiKey(String mapKey) async {
    Map<String, dynamic> requestData = {"mapKey": mapKey};
    METHOD_CHANNEL.invokeMethod('setGoogleMapKey', requestData);
  }
}
