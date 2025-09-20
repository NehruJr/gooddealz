import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/ongoing_actions/onoing_actions_provider.dart';
import '../../widgets/action_widget.dart';
import '../../widgets/no_data_widget.dart';

class LiveDrawsPage extends StatefulWidget {
  const LiveDrawsPage({super.key});

  @override
  State<LiveDrawsPage> createState() => _LiveDrawsPageState();
}

class _LiveDrawsPageState extends State<LiveDrawsPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<OngoingActionsProvider>(context, listen: false).getOngoingActions();
    });
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return MainPage(
  
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainText(
              'live_draws'.tr,
              fontSize: 26,
              color: Colors.black,
            ),
            16.sSize,
            // Container(
            //   width: context.width,
            //   height: 45,
            //   decoration: ShapeDecoration(
            //     color: Colors.white,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(6)),
            //     shadows: const [
            //       BoxShadow(
            //         color: Color(0x14870098),
            //         blurRadius: 50,
            //         offset: Offset(0, 10),
            //         spreadRadius: 0,
            //       )
            //     ],
            //   ),
            //   child: Padding(
            //     padding: 4.aEdge,
            //     child: Row(
            //       children: [
            //         Expanded(
            //           child: GestureDetector(
            //             onTap: () {
            //               setState(() {
            //                 index = 0;
            //               });
            //             },
            //             child: index == 0
            //                 ? const RedContainer(title: 'Winner')
            //                 : const WhiteContainer(title: 'Winner'),
            //           ),
            //         ),
            //         Expanded(
            //           child: GestureDetector(
            //             onTap: () {
            //               setState(() {
            //                 index = 1;
            //               });
            //             },
            //             child: index != 0
            //                 ? const RedContainer(title: 'Up coming Draw')
            //                 : const WhiteContainer(title: 'Up coming Draw'),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Consumer<OngoingActionsProvider>(builder: (context, provider, _) {
              return provider.actionsLoader
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : provider.actions.isNotEmpty ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.actions.length,
                  itemBuilder: (context, index) {
                    return ActionWidget(
                      action: provider.actions[index],
                    );
                  },
                ) : const NoDataWidget();
              }
            ),
            8.sSize,
          ],
        ),
      ),
    );
  }
}

class WhiteContainer extends StatelessWidget {
  const WhiteContainer({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: MainText(
        title,
        color: Colors.black.withOpacity(0.5),
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class RedContainer extends StatelessWidget {
  const RedContainer({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-1.00, 0.08),
          end: Alignment(1, -0.08),
          colors: [Color(0xFFFA4148), Color(0xFFEF040D)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: 6.cBorder,
        ),
      ),
      alignment: Alignment.center,
      child: MainText(
        title,
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
