import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/data/models/discount/coupon_model.dart';

import '../../core/constants/app_endpoints.dart';
import '../../data/models/ongoing_actions.dart';
import '../../data/remote/http_api.dart';

class OngoingActionsProvider extends ChangeNotifier {


  bool actionsLoader = false;
  bool getCouponLoader = false;

  Coupon? _discountCoupon;
  Coupon? get discountCoupon => _discountCoupon;

  List<Auctions> _actions = [];
  List<Auctions> get actions => _actions;


  Future<void> getOngoingActions() async{

    try{
      actionsLoader = true;
      notifyListeners();

      final response = await CallApi.get(AppEndpoints.ongoingActions,);
      print(response.statusCode);
      print(response.body);

      if(response.statusCode == 200){
        actionsLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        OngoingActions ongoingActions = OngoingActions.fromJson(jsonRes);
        _actions = ongoingActions.data?.auctions ?? [];

      }else{
        actionsLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      actionsLoader = false;
      notifyListeners();

      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

}