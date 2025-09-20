import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';

import '../../core/constants/app_endpoints.dart';
import '../../data/remote/http_api.dart';
import '../data/models/purchase_code_model.dart';

class PurchaseProvider extends ChangeNotifier {

  // order status:
  // pending
  // processing
  // completed
  // decline

  bool PurchaseLoader = false;

  List<PurchaseCode> _purchaseCodes = [];
  List<PurchaseCode> get purchaseCodes => _purchaseCodes;

  Future<void> getPurchaseCodes(context) async {
    try{
     
      PurchaseLoader = true;
      notifyListeners();
      final response = await CallApi.get( AppEndpoints.productPurchaseCodes,);

      print('=======response======');
      print(response.statusCode);

      if(response.statusCode == 200){
        PurchaseLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        PurchaseCodeModel purchaseCodeModel = PurchaseCodeModel.fromJson(jsonRes);

        _purchaseCodes = purchaseCodeModel.data ?? [];        
        // _completedOrders.addAll(_orders.where((e) => e.status == 'completed').toList());
        // _canceledOrders.addAll(_orders.where((e) => e.status == 'decline').toList());

      }else{

        PurchaseLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar( error, error: true);
      }

    }catch(e){
      print(e);
      PurchaseLoader = false;
      notifyListeners();
      showSnackbar( e.toString(), error: true);
    }
  }

}