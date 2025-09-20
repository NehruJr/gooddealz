import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/providers/settings/settings_provider.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/no_data_widget.dart';

class HowItWorksPage extends StatefulWidget {
  const HowItWorksPage({Key? key}) : super(key: key);

  @override
  State<HowItWorksPage> createState() => _HowItWorksPageState();
}

FlickManager? flickManager;

class _HowItWorksPageState extends State<HowItWorksPage> {
  final videoPlayerController = VideoPlayerController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SettingsProvider>(context, listen: false)
          .getHowItWorks(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
   if(flickManager != null) flickManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;

    return MainPage(
      title: 'how_it_works'.tr,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, _) {
              if (settingsProvider.howItWorkLoader) {
                return const Center(child: CircularProgressIndicator(),);
              } else if(settingsProvider.howItWorksModel?.data?.video != null){
                flickManager = FlickManager(
                    videoPlayerController:
                    VideoPlayerController.networkUrl(
                      Uri.parse(settingsProvider.howItWorksModel?.data?.video??''),
                    ));
                return  FlickVideoPlayer(
                  flickManager: flickManager!) ;
              }else{
                return const NoDataWidget();
              }
            }
          )
        ],
      ),
    );
  }
}