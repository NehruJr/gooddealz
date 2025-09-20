
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_button.dart';

import 'main_text.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: 16.vhEdge,
        child: SizedBox(
          width: 500,
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Icon(Icons.add_location_alt_rounded, color: Theme.of(context).primaryColor, size: 100),
            16.sSize,

            Text(
              'you_denied_location_permission'.tr, textAlign: TextAlign.center,
            ),
            16.sSize,

            Row(children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(width: 2, color: AppColors.yPrimaryColor)),
                    minimumSize: const Size(1, 50),
                  ),
                  child: Text('close'.tr),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              8.sSize,
              Expanded(child: MainButton(
                onPressed: () async{
                  await Geolocator.openAppSettings();
                  Navigator.pop(context);
                },
                color: AppColors.yPrimaryColor,
                width: 150,
                radius: 28,
                child: MainText(
                  'open_settings'.tr,
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ),
            ]),

          ]),
        ),
      ),
    );
  }
}