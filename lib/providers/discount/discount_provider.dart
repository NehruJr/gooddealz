import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/data/models/discount/coupon_model.dart';
import 'package:goodealz/providers/cart/cart_provider.dart';

import '../../core/constants/app_endpoints.dart';
import '../../core/helper/functions/date_converter.dart';
import '../../core/helper/functions/navigation_service.dart';
import '../../data/models/discount/user_coupon.dart';
import '../../data/remote/http_api.dart';

class DiscountProvider extends ChangeNotifier {


  bool couponLoader = false;
  bool getCouponLoader = false;

  Coupon? _discountCoupon;
  Coupon? get discountCoupon => _discountCoupon;

List<Coupon> _activeCoupons = [];
List<Coupon> get activeCoupons => _activeCoupons;

List<Coupon> _userCoupons = [];
List<Coupon> get userCoupons => _userCoupons;


  Future<void> applyCoupon(String coupon) async{

    try{
      couponLoader = true;
      notifyListeners();

      final response = await CallApi.post(AppEndpoints.getDiscount,
          data: jsonEncode({
            'code': coupon,
          }));
      print(response.statusCode);
      print(response.body);

      if(response.statusCode == 200){
        

        final jsonRes = jsonDecode(response.body);
        CouponModel couponModel = CouponModel.fromJson(jsonRes);
       
       if(DateConverter.isBeforeTime(couponModel.data?.coupon?.expiredAt)){
        showSnackbar('expire_coupon'.tr, error: true);
         _discountCoupon = null;
         }
       else if(DateConverter.isAfterTime(couponModel.data?.coupon?.startAt)){
         showSnackbar('not_start_coupon'.tr, error: true);
         _discountCoupon = null;
       }
         else if(couponModel.data?.coupon?.minimumOrder != null
          && couponModel.data!.coupon!.minimumOrder!.toDouble() > Provider.of<CartProvider>(NavigationService.currentContext, listen: false).totalPrice){
showSnackbar('cannot_use_coupon'.tr, error: true);
         _discountCoupon = null;
         }
         
         else{
          print('000000000000000000');
          _discountCoupon = couponModel.data?.coupon;
          print(_discountCoupon);
         }


        couponLoader = false;
        notifyListeners();
      }else{
        _discountCoupon = null;

        couponLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      couponLoader = false;
      notifyListeners();
print('ppppp');
      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getActiveCoupons(context) async {
    try{


      getCouponLoader = true;
      notifyListeners();
      final response = await CallApi.get( AppEndpoints.getAllCoupons,);

      print('=======response======');
      print(response.statusCode);

      if(response.statusCode == 200){
        getCouponLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        CouponModel couponModel = CouponModel.fromJson(jsonRes);
        _activeCoupons = couponModel.data?.coupons?? [];
        print(_activeCoupons);


      }else{

        getCouponLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error);
      }

    }catch(e){
      print(e);
      getCouponLoader = false;
      notifyListeners();
      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getUserCoupons(context) async {
    try{


      getCouponLoader = true;
      notifyListeners();
      final response = await CallApi.get( AppEndpoints.userCoupon,);

      print('=======response======');
      print(response.statusCode);

      if(response.statusCode == 200){
        getCouponLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        UserCouponModel couponModel = UserCouponModel.fromJson(jsonRes);
        _userCoupons = couponModel.data?.coupons?? [];
print(jsonRes);
print(_userCoupons);

      }else{

        getCouponLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error);
      }

    }catch(e){
      print(e);
      getCouponLoader = false;
      notifyListeners();
      showSnackbar(e.toString(), error: true);
    }
  }


clearCoupon(){
  _discountCoupon = null;
}
}