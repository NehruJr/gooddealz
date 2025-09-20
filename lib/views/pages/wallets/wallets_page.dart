import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/remote/remote_data.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/payment/payment_provider.dart';
import '../../../providers/settings/settings_provider.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({super.key});

  @override
  State<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SettingsProvider>(context, listen: false).getMyWallet(context);
    });
  }

  final _balanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: 'wallets'.tr,
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          children: [
            Consumer<SettingsProvider>(builder: (context, settings, _) {
              return settings.walletLoader
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : Card(
                  surfaceTintColor: Colors.white,
                  child: Padding(
                    padding: 32.hvEdge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MainText(
                          'my_balance'.tr,
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        MainText(
                          '${settings.walletModel?.data?.myWallet?.balance??''}',
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
            16.sSize,
            Card(
              surfaceTintColor: Colors.white,
              child: Padding(
                padding: 16.aEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    12.sSize,
                    MainButton(
                          onPressed: () {
                            // AppRoutes.routeTo(context, const PaymentDonePage());
                            // Provider.of<PaymentProvider>(context, listen: false).walletPay(context, price: 1);
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return _bottomSheet();
                                });
                            // Provider.of<SettingsProvider>(context, listen: false).chargeWallet(context, 100);
                          },

                          color: AppColors.yPrimaryColor,
                          width: 100,
                          verticalPadding: 8,
                          radius: 8,
                          child: FittedBox(
                            child: MainText(
                              'charge'.tr,
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheet() {
    return Container(
      // height: 100.0,
      width: MediaQuery.of(context).size.width,
      padding: MediaQuery.of(context).viewInsets,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'add_balance'.tr,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 20,
            ),

            MainTextField(
              controller: _balanceController,
              hint: '0.0',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (!(value ?? '').isNotEmpty) {
                  return 'enter_balance'.tr;
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer<PaymentProvider>(
                builder: (context, paymentProvider, _) {
                  return MainButton(
                    onPressed: paymentProvider.payLoader ? (){} : () {
                      // AppRoutes.routeTo(context, const PaymentDonePage());
                      if(_formKey.currentState!.validate()){
                        print(_balanceController.text);
                          // Provider.of<PaymentProvider>(context, listen: false)
                          //     .walletPay(context, balance: double.parse(_balanceController.text));
                        Provider.of<PaymentProvider>(context, listen: false)
                              .walletPay(context, balance: double.parse(_balanceController.text));
                        }
                      },

                    color: paymentProvider.payLoader ? AppColors.ySecondryColor :   AppColors.yPrimaryColor,
                    width: 100,
                    verticalPadding: 8,
                    radius: 8,
                    child: FittedBox(
                      child: MainText(
                        paymentProvider.payLoader ? 'wait'.tr : 'charge'.tr,
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
