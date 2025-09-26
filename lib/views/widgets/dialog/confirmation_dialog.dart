

import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_text.dart';


class ConfirmationDialog extends StatefulWidget {
  final String icon;
  final double iconSize;
  final String? title;
  final String description;
  final Function onYesPressed;
  final bool isLogOut;
  final bool hasCancel;
  const ConfirmationDialog({
    Key? key,
    required this.icon,
    this.iconSize = 100,
    this.title,
    required this.description,
    required this.onYesPressed,
    this.isLogOut = false,
    this.hasCancel = true,
  }) : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset(getPngAsset(widget.icon), width: widget.iconSize, height: widget.iconSize),
          widget.title != null
              ? Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8),
            child: Text(
              widget.title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red),
            ),
          )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(widget.description,
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .disabledColor
                        .withOpacity(0.3),
                    minimumSize: const Size(1170, 40),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15)),
                  ),
                  child: MainText('no'.tr,
                    textAlign: TextAlign.center,

                  ),
                )),

            const SizedBox(
                width: 20),
            Expanded(
                child: _isLoading ? const Center(child: CircularProgressIndicator(),) : InkWell(
                  onTap: () async{
                    setState(() {
                      _isLoading = true;
                    });
                    await widget.onYesPressed();
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.pop(context);
                  } ,
                  child: Ink(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.yPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: MainText(
                        'yes'.tr,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
          ])


        ]),
      ),
    );
  }
}
