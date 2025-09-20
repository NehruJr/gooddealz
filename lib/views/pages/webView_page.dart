

import 'package:flutter/material.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/models/order/order_model.dart';
import 'package:goodealz/providers/checkout/checkout_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/ys_localizations/ys_localizations_provider.dart';
import '../../providers/settings/settings_provider.dart';
import '../widgets/main_page.dart';

class WebViewPage extends StatelessWidget {
  final String? paymentUrl;
  final Orders? order;
  final bool isFromCheckout;

  WebViewPage(this.paymentUrl, {Key? key, this.isFromCheckout = false, this.order}) : super(key: key);

  WebViewController? _webViewController;

  bool payed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: MainPage(
        title: !isFromCheckout ? 'wallets'.tr : '',
        onBack: isFromCheckout ? (){
          Navigator.pop(context);
          Navigator.pop(context);
        } : null,
        body: Column(
          children: [
            Expanded(
              child: WebView(
                initialUrl: paymentUrl,
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                allowsInlineMediaPlayback: true,
                debuggingEnabled: true,
                navigationDelegate: (NavigationRequest request) {
                  Uri url = Uri.parse(request.url);

                  print('request url =====> ${request.url}');
                  print('param sofcoRefNumber =====> ${url.queryParameters['sofcoRefNumber']}');
                  print('param status =====> ${url.queryParameters['status']}');
                  print('param message =====> ${url.queryParameters['statusDescription']}');
                  print('param statusCode =====> ${url.queryParameters['statusCode']}');
                  print('param statusCode =====> ${url.queryParameters['statusCode'].runtimeType}');
                  print('param orderAmount =====> ${url.queryParameters['orderAmount']}');
                  print('param merchantRefNumber =====> ${url.queryParameters['merchantRefNumber']}');

                  if (url.queryParameters['statusCode'] != null &&
                      url.queryParameters['statusCode']! == "200") {
                    // url.queryParameters['message']!.contains('Succeeded!')) {
                    // goTo(() => const AppointmentSuccessScreen());
                    print('sucsessssssssssssss 😂 ${url.queryParameters['statusCode'].runtimeType}');
                    if(isFromCheckout){
                      if(!payed){
                        payed = true;

                          print('This message will be printed after 3 seconds');
                          // Your function call here

                          Provider.of<CheckoutProvider>(context, listen: false)
                              .updateTransaction(
                                  context,
                                  order!,
                                  url.queryParameters['merchantRefNumber'] ??
                                      '');

                      }
                    }
                    else{
                      if (!payed) {
                        payed = true;
                        Provider.of<SettingsProvider>(context, listen: false)
                            .chargeWallet(
                                context,
                                balance: double.parse(
                                    url.queryParameters['orderAmount']!), referenceNumber: url.queryParameters['merchantRefNumber'] ??
                            '');
                      }
                    }
                    return NavigationDecision.navigate;
                  } else if (url.queryParameters['status'] != null &&
                      url.queryParameters['status']!.contains('paid') == false) {
                    // url.queryParameters['message']!.contains('Succeeded!') == false) {
                    // Get.back();
                    // DialogHelper.showError(
                    //     context: context, message: 'faild_to_pay'.tr);
                    return NavigationDecision.prevent;
                  } else {
                    return NavigationDecision.navigate;
                  }
                },
                onWebViewCreated: (WebViewController controller) {
                  _webViewController = controller;
                },
                onPageFinished: (val) {
                  // WebViewRepository.getWebViewResponse(val, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
