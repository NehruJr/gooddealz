import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/views/widgets/main_text.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: context.width,
      margin: 4.vEdge,
      child: Container(
        padding: 24.aEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.red
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MainText(
                  'Get 10 % Extra',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                const MainText(
                  'on Binance top_up',
                  color: Colors.white,
                  fontSize: 10,
                ),
                Container(
                  width: 125,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: 10.cBorder,
                  ),
                  child: const MainText(
                    'Top up',
                    color: Color(0xFFEF040D),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            32.wSize,
            Expanded(
              child: Image.asset(
                getPngAsset('laptop'),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
