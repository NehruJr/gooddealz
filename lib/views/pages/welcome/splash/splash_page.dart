import 'dart:convert';
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
import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/helper/functions/show_snackbar.dart';
import '../../../../data/remote/http_api.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  VideoPlayerController? _controller;
  bool _isFadingOut = false;
  bool introLoader = false;
  String introVideoLink = '';

  Future<void> getIntroVideoLink(context) async {
    setState(() {
      introLoader = true;
    });

    final response = await CallApi.get(AppEndpoints.getIntroLink);

    if (response.statusCode == 200) {
      final jsonRes = jsonDecode(response.body);
      introVideoLink = jsonRes['data']['intro_video']['url'];
      setState(() {
        introLoader = false;
      });
    } else {
      setState(() {
        introLoader = false;
      });
      final error = jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['error'] ??
          'An error occurred';
      showSnackbar(error, error: true);
    }
  }

  void startIntroVideo() async {
    await getIntroVideoLink(context);
    if (!mounted || introVideoLink.isEmpty) return;

    _controller = VideoPlayerController.networkUrl(Uri.parse(introVideoLink))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller?.play();
      });

    _controller?.addListener(() {
      if (_controller!.value.isInitialized &&
          _controller!.value.position >= _controller!.value.duration) {
        _navigateNext();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startIntroVideo();
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
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      body: introLoader
          ? const Center(child: CircularProgressIndicator())
          : (controller != null && controller.value.isInitialized)
          ? SizedBox.expand(
        child: InkWell(
          onTap: () async {
            if (controller.value.isPlaying) {
              setState(() => _isFadingOut = true);
              await controller.setVolume(0);
              await Future.delayed(const Duration(milliseconds: 250));
              await controller.pause();
            }
            _navigateNext();
          },
          child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
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
