import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/data/models/order/order_model.dart';
import 'package:goodealz/data/models/payment_item_model.dart';
import 'package:goodealz/data/models/purchase_code_model.dart';
import 'package:goodealz/data/models/user_model.dart';
import 'package:goodealz/data/models/winner_model.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/providers/cart/cart_provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_endpoints.dart';
import '../../core/constants/app_routes.dart';
import '../../core/helper/functions/global_methods.dart';
import '../../core/helper/functions/navigation_service.dart';
import '../../data/remote/http_api.dart';
import '../../views/pages/payment_done/payment_done_page.dart';
import '../../views/pages/webView_page.dart';
import '../discount/discount_provider.dart';
import 'package:crypto/crypto.dart';

class PaymentProvider extends ChangeNotifier {
  final bool _isLocationAvailable = false;

  bool get isLocationAvailable => _isLocationAvailable;

  final bool _deliveryCostLoader = false;

  bool get deliveryCostLoader => _deliveryCostLoader;

  bool _payLoader = false;

  bool get payLoader => _payLoader;

  final double _deliveryCost = 0;

  double? get deliveryCost => _deliveryCost;

  String? _address;

  String? get address => _address;

  String? _city;

  String? get city => _city;

  Position? _myPosition;

  Position? get myPosition => _myPosition;

  Future<void> walletPay(context, {required double balance}) async {
    // try {
    _payLoader = true;
    notifyListeners();

    String referenceNumber = '1';
    User? user = Provider
        .of<AuthProvider>(context, listen: false)
        .currentUser;

    final String signature =
        'SOfCOPay_${AppConstants.merchantCode}$referenceNumber${user?.id ??
        ""}11${balance.toStringAsFixed(2)}${balance.toStringAsFixed(
        2)}${AppConstants.accountKey1}_SOfCOPay';
    var bytes1 = utf8.encode(signature); // data being hashed
    var encryptedSignature = sha256.convert(bytes1);

    final body = {
      "pgwRefNum": "",
      "paymentURL": "",
      "statusCode": "",
      "statusDescription": "",
      "merchantId": AppConstants.merchantId,
      "merchantCode": AppConstants.merchantCode,
      "referenceNumber": referenceNumber,
      "customer": {
        "id": "${user?.id ?? ""}",
        "name": user?.name ?? "",
        "email": user?.email ?? "",
        "phone": user?.phone ?? ""
      },
      "expiryDate": DateTime.now().add(const Duration(hours: 1)).toString(),
      "items": [
        {
          "id": "1",
          "description": "",
          "price": balance,
          "quantity": 1,
          "imageUrl": "",
          "total": balance
        }
      ],
      "total": balance,
      // "shippingAddress":[
      //     {
      //         "governorate":"jghg",
      //         "city":"caaa",
      //         "area":"gjgfd",
      //         "address":"kjkj",
      //         "receiverName":"jhjg"
      //     }
      // ],
      "paymentMethod": 1,
      "status": 0,
      "returnUrl": "",
      "signature": encryptedSignature.toString()
    };

    final response = await CallApi.postPay('/Express',
        params: {"lang": 'en'}, data: jsonEncode(body));

    if (response.statusCode == 200) {
      _payLoader = false;
      notifyListeners();

      final jsonRes = jsonDecode(jsonDecode(response.body));
      log(jsonRes.toString(), name: 'payment😶😶');
      log(jsonRes.runtimeType.toString(), name: 'url');
      AppRoutes.routeTo(context, WebViewPage(jsonRes['url']));
    } else {
      _payLoader = false;
      notifyListeners();

      final error = jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['error'] ??
          'An error occurred';
      showSnackbar(error, error: true);
    }
    // } catch (e) {
    //   _patLoader = false;
    //   notifyListeners();
    //
    //   // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    //   showSnackbar(e.toString(), error: true);
    // }
  }

  Future<void> checkoutPay(context,
  {
    required Orders order
  }
      ) async {
    try {
    _payLoader = true;
    notifyListeners();

    print('payyyyyyyyyy');
    print('payyyyyyyyyy');
    User? user = Provider
        .of<AuthProvider>(context, listen: false)
        .currentUser;
    List<PaymentItem> items = [];
    if (order.products != null) {
      for (var product in order.products!) {
        items.add(PaymentItem(
            id: product.id.toString(),
            description: "",
            quantity: product.quantityInOrder!,
            price: double.parse(product.price!),
            imageUrl: product.image ?? "",
            total: double.parse(product.price!) * product.quantityInOrder!));
      }
    }

    if(order.shippingFee != null && order.shippingFee! > 0){    // adding shipping fee
      items.add(PaymentItem(
          id: '22',
          description: "",
          quantity: 1,
          price: order.shippingFee!.toDouble(),
          imageUrl: "",
          total: order.shippingFee!.toDouble()));
    }

    if(order.discountAmount != null){  // subtract discount
      double disc = order.discountAmount!.toDouble();
      if(items.any((element) => element.total > order.discountAmount!.toDouble())) {
        for (var item in items) {
          print('----> ${item.total > order.discountAmount!.toDouble()}');
          if (item.total > order.discountAmount!.toDouble()) {
            item.price -= (order.discountAmount!.toDouble() / item.quantity.toDouble());
            break;
          }
        }
      }else{
        for (var item in items) {
          if (disc > item.price * item.quantity) {
            disc -= (item.price * item.quantity * 0.99);
            item.price -= (item.price * 0.99) / item.quantity;
          }else{
            item.price -= (disc / item.quantity);
            break;
          }
        }
      }
    }

    String signature =
        'SOfCOPay_${AppConstants.merchantCode}${order.id}${user?.id ?? ""}';
    for (var item in items) {
      signature += '${item.id}${item.quantity}${item.price.toStringAsFixed(2)}';
    }

    signature +=
    '${order.total!.toStringAsFixed(2)}${AppConstants.accountKey1}_SOfCOPay';

    var bytes1 = utf8.encode(signature); // data being hashed
    var encryptedSignature = sha256.convert(bytes1);

    final body = {
      "pgwRefNum": "",
      "paymentURL": "",
      "statusCode": "",
      "statusDescription": "",
      "merchantId": AppConstants.merchantId,
      "merchantCode": AppConstants.merchantCode,
      "referenceNumber": order.id.toString(),
      "customer": {
        "id": "${user?.id ?? ""}",
        "name": user?.name ?? "",
        "email": user?.email ?? "",
        "phone": user?.phone ?? ""
      },
      "expiryDate": DateTime.now().add(const Duration(hours: 1)).toString(),
      "items": items,
      "total": order.total,
      // "shippingAddress":[
      //     {
      //         "governorate":"jghg",
      //         "city":"caaa",
      //         "area":"gjgfd",
      //         "address":"kjkj",
      //         "receiverName":"jhjg"
      //     }
      // ],
      "paymentMethod": 1,
      "status": 0,
      "returnUrl": "",
      "signature": encryptedSignature.toString()
    };
    log(signature, name: 'signature');
    log(jsonEncode(body), name: 'body');

    final response = await CallApi.postPay('/Express',
        params: {"lang": 'en'}, data: jsonEncode(body));

    log(response.body.toString(), name: 'payment😉');

    if (response.statusCode == 200) {
      final jsonRes = jsonDecode(jsonDecode(response.body));
      log(jsonRes.toString(), name: 'payment😶😶');
      log(jsonRes.runtimeType.toString(), name: 'url');
      _payLoader = false;
      notifyListeners();
      AppRoutes.routeTo(context, WebViewPage(jsonRes['url'], isFromCheckout: true, order: order,));
    } else {
      _payLoader = false;
      notifyListeners();

      final error = jsonDecode(response.body)??
          'An error occurred';
      showSnackbar(error, error: true);
    }
    } catch (e) {
      _payLoader = false;
      notifyListeners();
print(e);
      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }
}
