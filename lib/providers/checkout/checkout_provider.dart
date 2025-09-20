import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/data/models/city_model.dart';
import 'package:goodealz/data/models/order/order_model.dart';
import 'package:goodealz/data/models/purchase_code_model.dart';
import 'package:goodealz/data/models/winner_model.dart';
import 'package:goodealz/providers/cart/cart_provider.dart';
import 'package:goodealz/providers/payment/payment_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/constants/app_endpoints.dart';
import '../../core/constants/app_routes.dart';
import '../../core/helper/functions/global_methods.dart';
import '../../core/helper/functions/navigation_service.dart';
import '../../data/remote/http_api.dart';
import '../../views/pages/payment_done/payment_done_page.dart';
import '../discount/discount_provider.dart';

class CheckoutProvider extends ChangeNotifier{

  bool _isLocationAvailable = false;
  bool get isLocationAvailable => _isLocationAvailable;
  
  bool _deliveryCostLoader = false;
  bool get deliveryCostLoader => _deliveryCostLoader;

  bool _cancelLoader = false;
  bool get cancelLoader => _cancelLoader;

  bool _cityLoader = false;
  bool get cityLoader => _cityLoader;
 
  bool _checkoutLoader = false;
  bool get checkoutLoader => _checkoutLoader;

  bool _repayLoader = false;
  bool get repayLoader => _repayLoader;

  double _deliveryCost = 0;
  double? get deliveryCost => _deliveryCost ;

  String? _address ;
  String? get address => _address ;

  String? _city ;
  String? get city => _city ;

  Position? _myPosition;
  Position? get myPosition => _myPosition;

  List<PurchaseCode> _purchaseCodes = [];

  List<City> _cities = [];
  List<City> get cities => _cities;


  Future<void> getCities() async {

    try{
      _cityLoader = true;
      notifyListeners();

      final response = await CallApi.get(AppEndpoints.cities,);
      print(response.statusCode);
      print(response.body);


      if(response.statusCode == 200){


        final jsonRes = jsonDecode(response.body);
        CityModel cityModel = CityModel.fromJson(jsonRes);

        _cities = cityModel.data?.cities??[];

        _cityLoader = false;
        notifyListeners();

      }else{
        _cityLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

      notifyListeners();

    }catch(e){

      _myPosition = Position(longitude: 89, latitude: 23, timestamp: DateTime.now(), accuracy: 1, altitude: 1, altitudeAccuracy: 1, heading: 1, headingAccuracy: 1, speed: 1, speedAccuracy: 1);
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation(context, Completer<GoogleMapController> controller) async {

    try{
      _address = null;
      _city = null;

      _myPosition = await Geolocator.getCurrentPosition();

      if(_myPosition != null){
        final GoogleMapController controller0 = await controller.future;
        controller0.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(_myPosition!.latitude, _myPosition!.longitude),
          zoom: 12,
        )));
      }

      print('===================++');
      print(_myPosition);
      notifyListeners();

    }catch(e){

      _myPosition = Position(longitude: 89, latitude: 23, timestamp: DateTime.now(), accuracy: 1, altitude: 1, altitudeAccuracy: 1, heading: 1, headingAccuracy: 1, speed: 1, speedAccuracy: 1);
      notifyListeners();
    }
  }

  setAddress({required String address, required String city}){
    _address  = address;
    _city  = city;
    notifyListeners();

  }


  Future<void> getDeliveryCost(context, {required String city}) async {
    try{
      _deliveryCostLoader = true;
      notifyListeners();

      final response = await CallApi.post(AppEndpoints.getDeliveryCost,
      // locale: 'ar',
          data: jsonEncode({
            'city_name': city,
            'locale': YsLocalizationsProvider.listenFalse(NavigationService.currentContext)
              .languageCode,
          }));
      print(response.statusCode);
      print(response.body);


      if(response.statusCode == 200){


        final jsonRes = jsonDecode(response.body);
        if(jsonRes['cost'] == null){
          _isLocationAvailable = false;
          notifyListeners();

          showSnackbar('locatio_not_available'.tr, error: true);
        }
        else{
          _isLocationAvailable = true;
          _deliveryCost = jsonRes['cost'].toDouble();
          notifyListeners();
        }
        _deliveryCostLoader = false;
        notifyListeners();
        // currentUser = userModel.data?.user;

      }else{
        _deliveryCostLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      _deliveryCostLoader = false;
      notifyListeners();

      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

   Future<void> checkout(context, {required String city, required String address, required String paymentMethod,
     required double lat, required double lng, }) async {
    try{
      _checkoutLoader = true;
      notifyListeners();

      final response = await CallApi.post(
        // locale: 'en',
        AppEndpoints.checkout,
          data: jsonEncode({
            'city_name': city,
            // 'city_name': 'cairo',
            // 'address': '_address',
            'payment_method': paymentMethod,
            'address': address,
            'discount_code': Provider.of<DiscountProvider>(context, listen: false).discountCoupon?.code,
            'lat': lat.toString(),
            'lng': lng.toString(),
          }));
      print(response.statusCode);
      print(response.body);
      log(response.body.toString());

      if(response.statusCode == 200){


        final jsonRes = jsonDecode(response.body);
        // Provider.of<CartProvider>(context, listen: false).zaroCartCount();

        Orders order = Orders.fromJson(jsonRes['data']['order']);
        final List<PurchaseCode> purchaseCodes = jsonRes['data']['order']['purchase_codes'].map<PurchaseCode>((e)=> PurchaseCode.fromJson(e)).toList();
        _purchaseCodes = purchaseCodes;

        if(order.status == 'Paid'){
          AppRoutes.routeTo(context, PaymentDonePage(orderNumber: jsonRes['data']['order']['order_number'],
              purchaseCodes: purchaseCodes));
        }
        else{
          if (paymentMethod == 'card') {
            Provider.of<PaymentProvider>(context, listen: false)
                .checkoutPay(context, order: order);
          } else {
            AppRoutes.routeTo(
                context,
                PaymentDonePage(
                    orderNumber: jsonRes['data']['order']['order_number'],
                    purchaseCodes: purchaseCodes));
          }
        }
        Provider.of<CartProvider>(context, listen: false).zaroCartCount();
        Provider.of<CartProvider>(context, listen: false).removeAll();
        _checkoutLoader = false;
        notifyListeners();


        // showSnackbar( YsLocalizationsProvider.listenFalse(NavigationService.currentContext).languageCode == 'en' ?
        //   jsonRes['message'] : 'تم انشاء الطلب بنجاح');

      }else{
        _checkoutLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e, s){
      _checkoutLoader = false;
      notifyListeners();
print('$e --- $s' );
      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

   Future<void> updateTransaction(context, Orders order, String referenceNumber) async {
    try{
      _checkoutLoader = true;
      notifyListeners();

      final response = await CallApi.post(
        locale: 'en',
        '${AppEndpoints.updateTransaction}/${order.orderNumber}',
          data: jsonEncode({
            'referenceNumber': referenceNumber,
          }));
      print(response.statusCode);
      print(response.body);
      log(response.body.toString());

      if(response.statusCode == 200){


        final jsonRes = jsonDecode(response.body);
        Provider.of<CartProvider>(context, listen: false).zaroCartCount();
        _checkoutLoader = false;
        notifyListeners();
        // Orders order = Orders.fromJson(jsonRes['data']['order']);

        // Provider.of<PaymentProvider>(context, listen: false).checkoutPay(context, order: order);
        Future.delayed(const Duration(seconds: 3), () {

        AppRoutes.routeRemoveTo(context, PaymentDonePage(orderNumber: jsonRes['data']['order']['order_number'],
        purchaseCodes: order.purchaseCodes??[]));
        });

        showSnackbar( YsLocalizationsProvider.listenFalse(NavigationService.currentContext).languageCode == 'en' ?
          jsonRes['message'] : 'تم الدفع بنجاح');

      }else{
        _checkoutLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      _checkoutLoader = false;
      notifyListeners();

      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

   Future<void> repayOrder(context, {required String paymentMethod, required Orders order, }) async {
    try{
      _repayLoader = true;
      notifyListeners();

      final response = await CallApi.post(
        locale: 'en',
        '${AppEndpoints.repayOrder}/${order.orderNumber}',
          data: jsonEncode({
            'payment_method': paymentMethod,
          }));
      print(response.statusCode);
      print(response.body);
      log(response.body.toString());

      if(response.statusCode == 200){


        final jsonRes = jsonDecode(response.body);
        // Provider.of<CartProvider>(context, listen: false).zaroCartCount();
        _repayLoader = false;
        notifyListeners();
        // Orders order = Orders.fromJson(jsonRes['data']['order']);

        // Provider.of<PaymentProvider>(context, listen: false).checkoutPay(context, order: order);
        Future.delayed(const Duration(seconds: 3), () {

        AppRoutes.routeRemoveTo(context, PaymentDonePage(orderNumber: jsonRes['data']['order']['order_number'],
        purchaseCodes: order.purchaseCodes??[]));
        });

        showSnackbar( YsLocalizationsProvider.listenFalse(NavigationService.currentContext).languageCode == 'en' ?
          jsonRes['message'] : 'تم الدفع بنجاح');

      }else{
        _repayLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      _repayLoader = false;
      notifyListeners();

      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> cancelOrder(context, {required String orderNumber}) async {
    try{
      _cancelLoader = true;
      notifyListeners();

      final response = await CallApi.get('${AppEndpoints.cancelOrder}$orderNumber');
      print(response.statusCode);
      print(response.body);

      if(response.statusCode == 200){

        final jsonRes = jsonDecode(response.body);

          showSnackbar(jsonRes['message'],);

        _cancelLoader = false;
        notifyListeners();

        Navigator.pop(context, "cancel");

      }else{
        _cancelLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      _cancelLoader = false;
      notifyListeners();

      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

  clearData(){
    _city = null;
    _address = null;
    _deliveryCost = 0;
  }

}