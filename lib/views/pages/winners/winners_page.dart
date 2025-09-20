import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/pages/winners/widgets/winner_prize_widget.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/sub_widgets/notification_icon.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/prizes/prizes_provider.dart';

class WinnersPage extends StatefulWidget {
  const WinnersPage({super.key});

  @override
  State<WinnersPage> createState() => _WinnersPageState();
}

class _WinnersPageState extends State<WinnersPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PrizesProvider>(context, listen: false).getWinners(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      actionWidgets: const [NotificationIcon()],
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainText(
              'the_winners'.tr,
              fontSize: 26,
              color: Colors.black,
            ),
            8.sSize,
            // Consumer<PrizesProvider>(builder: (context, prizeProvider, _) {
            //     return MainTextField(
            //       unfocusWhenTapOutside: true,
            //       prefixIcon: Padding(
            //         padding: 20.aEdge,
            //         child: SvgPicture.asset(
            //           getSvgAsset('Search'),
            //           height: 22,
            //         ),
            //       ),
            //       suffixIcon: prizeProvider.searchText.isNotEmpty ? IconButton(
            //                     onPressed: () {
            //                       prizeProvider.clearSearch();
            //                       _searchController.clear();
            //                     },
            //                     icon: const Icon(Icons.close),
            //                   ) : null,
            //               onChanged: (value){
            //                 productProvider.searchForFavorites(value);
            //               },
            //       hint: 'search'.tr,
            //     );
            //   }
            // ),
            // 8.sSize,
            Consumer<PrizesProvider>(builder: (context, prizesProvider, _) {
              return prizesProvider.winnersLoader
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: prizesProvider.winners.length < 5
                    ? prizesProvider.winners.length
                    : 5,
                itemBuilder: (context, index) {
                  return WinnerPrizeWidget(prize: prizesProvider.winners[index]);
                },
              );
            }),
            8.sSize,
          ],
        ),
      ),
    );
  }
}
