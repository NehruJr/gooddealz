import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/models/order/order_model.dart';

import '../../core/constants/app_endpoints.dart';
import '../../data/remote/http_api.dart';

class OrderProvider extends ChangeNotifier {

  // order status:
  // pending
  // processing
  // completed
  // decline

  bool orderLoader = false;
  bool moreLoader = false;

  final List<Orders> _completedOrders = [];
  List<Orders> get completedOrders => _completedOrders;

  final List<Orders> _canceledOrders = [];
  List<Orders> get canceledOrders => _canceledOrders;

  List<Orders> _orders = [];
  List<Orders> get orders => _orders;

  Orders? _orderDetails;
  Orders? get orderDetails => _orderDetails;

  String? _status;

  int _page = 1;


  Future<void> getOrders(context, status) async {
    try{
      _page = 1;
      _status = status;
      orderLoader = true;
      notifyListeners();
      final response = await CallApi.get( '${AppEndpoints.getOrder}/$_status',);

      print('=======response======');
      print(response.statusCode);

      if(response.statusCode == 200){
        orderLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        OrderModel orderModel = OrderModel.fromJson(jsonRes);
        _orders = orderModel.data?.orders?? [];
        print(jsonRes);
        print(_orders);
        _page ++;
        // _completedOrders.addAll(_orders.where((e) => e.status == 'completed').toList());
        // _canceledOrders.addAll(_orders.where((e) => e.status == 'decline').toList());

      }else{

        orderLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar( error, error: true);
      }

    }catch(e){
      print(e);
      orderLoader = false;
      notifyListeners();
      showSnackbar( e.toString(), error: true);
    }
  }

  Future<void> getMoreOrders(context) async {
    try{

      moreLoader = true;
      notifyListeners();
      final response = await CallApi.get( '${AppEndpoints.getOrder}/$_status',
          params: {
        'page': _page.toString(),
        // 'status': _status!,
      });

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        moreLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        OrderModel orderModel = OrderModel.fromJson(jsonRes);

        if(orderModel.data != null && orderModel.data!.pagination!.lastPage! < _page){
          showSnackbar('no_more_orders'.tr, error: true);
        }
        else{
          _orders.addAll(orderModel.data?.orders ?? []);
          _page++;
          print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
          print(_page);
        }
        // _completedOrders.addAll(_orders.where((e) => e.status == 'completed').toList());
        // _canceledOrders.addAll(_orders.where((e) => e.status == 'decline').toList());

      }else{

        moreLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar( error, error: true);
      }

    }catch(e){
      print(e);
      moreLoader = false;
      notifyListeners();
      showSnackbar( e.toString(), error: true);
    }
  }

  Future<void> getOrderDetails(context, status) async {
    try{
      _page = 1;
      _status = status;
      orderLoader = true;
      notifyListeners();
      final response = await CallApi.get( '${AppEndpoints.getOrder}/$_status',);

      print('=======response======');
      print(response.statusCode);

      if(response.statusCode == 200){
        orderLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        OrderModel orderModel = OrderModel.fromJson(jsonRes);
        _orderDetails = orderModel.data?.orderDetails;

      }else{

        orderLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar( error, error: true);
      }

    }catch(e){
      print(e);
      orderLoader = false;
      notifyListeners();
      showSnackbar( e.toString(), error: true);
    }
  }

}