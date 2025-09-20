import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/enums.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/data/models/cart/cart_model.dart';
import 'package:goodealz/data/models/discount/coupon_model.dart';

import '../../core/constants/app_endpoints.dart';
import '../../data/remote/http_api.dart';

class CartProvider extends ChangeNotifier {

  bool addProductLoader = false;
  bool updateLoader = false;
  bool cartLoader = false;
  bool couponLoader = false;
  bool deleteLoader = false;

  int addProductId = -1;
  int updateCartId = -1;
  UpdateType updateType = UpdateType.plus;

  List<Cart> carts = [];

  double _totalPrice = 0;
  double _subTotalPrice = 0;
  double _discount = 0;
  double _deliveryCost = 0;

  double get totalPrice => _totalPrice;
  double get subTotalPrice => _subTotalPrice;
  double get discount => _discount;
  double get deliveryCost => _deliveryCost;

  int _cartCount = 0;
  int get cartCount => _cartCount;

  String? _currency;
  String? get currency => _currency;

  Coupon? _currentCoupon;

  Future<void> addProduct(context, {required int prizeId, required int productId, }) async {
    try{
      addProductLoader = true;
      addProductId = productId;
      notifyListeners();

      final response = await CallApi.post(AppEndpoints.addPrizeToCart,
          data: jsonEncode({
            'prize_id': prizeId,
            'product_id': productId,
          }));
      print(response.statusCode);
      print(response.body);

      if(response.statusCode == 200){
        _cartCount++;
        print(_cartCount);

showSnackbar(jsonDecode(response.body)['message']);
        addProductLoader = false;
        notifyListeners();
      }else{
        addProductLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      addProductLoader = false;
      notifyListeners();

      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> deleteCart(context, {required int cartId, required int index, }) async {
    try{
      deleteLoader = true;
      notifyListeners();

      final response = await CallApi.post(AppEndpoints.deleteCartProduct,
          data: jsonEncode({
            'cart_id': cartId,
          }));
      print(response.statusCode);

      if(response.statusCode == 200){
        deleteLoader = false;
        notifyListeners();

        carts.removeAt(index);
        if(_cartCount != 0) {
          _cartCount--;
        }
      }else{
        deleteLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      deleteLoader = false;
      notifyListeners();

      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

  void removeAll(){
    carts.clear();

    notifyListeners();
  }

  Future<void> updateCartQuantity(context, {required int index, required Cart cart, required UpdateType updateType}) async {
    try{
      updateLoader = true;
      updateCartId = cart.id!;
      this.updateType = updateType;
      notifyListeners();

      final response = await CallApi.post( AppEndpoints.updateCartQuantity,
          data: jsonEncode({
            'product_id': cart.product!.id!,
            'quantity': updateType == UpdateType.plus ? carts[index].quantity! + 1 : carts[index].quantity! - 1,
          }));
      print(response.statusCode);

      if(response.statusCode == 200){
        updateLoader = false;
        notifyListeners();

        if(updateType == UpdateType.plus) {
          carts[index].quantity = carts[index].quantity! + 1;
        }else if(carts[index].quantity! > 1){
          carts[index].quantity = carts[index].quantity! - 1;
        }

        getTotalPrice();
      }else{
        updateLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      updateLoader = false;
      notifyListeners();

      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getCartProducts(context) async {
    try{

      _totalPrice = 0;
      _subTotalPrice = 0;
      _deliveryCost = 0;
      _discount = 0;
      cartLoader = true;
      notifyListeners();
      final response = await CallApi.get( AppEndpoints.getCartProducts,);

      print('=======response======');
      print(response.statusCode);

      if(response.statusCode == 200){
        cartLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        CartModel cartModel = CartModel.fromJson(jsonRes);
        carts = cartModel.data?.carts?? [];
        _cartCount = carts.length;
        if(carts.isNotEmpty){
          _currency = carts[0].product?.currency??'';
        }

        getTotalPrice();

      }else{

        cartLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      print(e);
      cartLoader = false;
      notifyListeners();
      // showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getCartCount(context) async {
    try{

      final response = await CallApi.get( AppEndpoints.cartCount,);

      print('=======response======');
      print(response.statusCode);
      print('cart count: ${response.body}');

      if(response.statusCode == 200){

        final jsonRes = jsonDecode(response.body);
        _cartCount = jsonRes['data']['Products Count'];
        notifyListeners();

      }else{

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      print(e);
      print('------------------');
      showSnackbar( e.toString(), error: true);
    }
  }


  getTotalPrice(){
    _totalPrice = 0;
    double sum = 0;
    for(int i = 0; i < carts.length; i++){
      sum += carts[i].quantity! * double.parse(carts[i].price!);
    }
    _totalPrice = sum;
    _subTotalPrice = sum;


    if(_currentCoupon == null){
    _discount = 0;
    }
    else{
      if(_currentCoupon!.discountType == 'percentage'){
        
        if(totalPrice * (_currentCoupon!.percent! / 100) > _currentCoupon!.maxAmount!){
          
        _totalPrice -= _currentCoupon!.maxAmount!;
        _discount = _currentCoupon!.maxAmount!.toDouble();
        }
        else{
        _discount = totalPrice * (_currentCoupon!.percent! / 100);
        _totalPrice -= totalPrice * (_currentCoupon!.percent! / 100);
       
        }
      }
      else{
        if(_currentCoupon!.amount! < _totalPrice){
        _totalPrice -= _currentCoupon!.amount!;
        _discount = _currentCoupon!.amount!;}
      }
    }

    _totalPrice += _deliveryCost;
    // if(deliveryCost != null){
    //   _totalPrice += deliveryCost;
    //   _deliveryCost = deliveryCost;
    // }
    notifyListeners();
  }

zaroCartCount(){
  _cartCount = 0;
  notifyListeners();
}

setDeliveryCost(double deliveryCost){
  _deliveryCost = deliveryCost;
  getTotalPrice();
}

setCoupon(Coupon? coupon){
  _currentCoupon = coupon;
  getTotalPrice();
}

clearData(){
    _deliveryCost = 0;
    _discount = 0;
    _currentCoupon = null;
    getTotalPrice();
  }
}