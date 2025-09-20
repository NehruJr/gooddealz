import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../data/models/winner_model.dart';

class WinnerCard extends StatelessWidget {
  const WinnerCard({
    super.key,
  required this.winner
  });

  final Winner winner;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 3,
      child: ListTile(
        minVerticalPadding: 16,
        leading: CircleAvatar(
          child: FancyShimmerImage(
            imageUrl: winner.avatar??'',
            // height: size.width * 0.21,
            // width: size.width * 0.2,
            boxFit: BoxFit.fill,
            errorWidget: Image.asset(
              getPngAsset('person'),
            ),
          ),
        ),
        title: MainText(
          winner.firstName == null || winner.firstName == ''? winner.name??'':
                  '${winner.firstName??""} ${winner.lastName??""}',
          // '${winner.lastName} ${winner.lastName}',
          overflow: TextOverflow.ellipsis,
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        subtitle: MainText(
          '${'winner'.tr} : # ${winner.id}',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          fontSize: 14,
          color: Colors.black.withOpacity(0.6),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
