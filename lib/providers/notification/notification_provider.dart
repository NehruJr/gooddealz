import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/models/notification/notification_model.dart';

import '../../core/constants/app_endpoints.dart';
import '../../data/remote/http_api.dart';

class NotificationProvider extends ChangeNotifier {

  bool notificationLoader = false;
  bool markLoader = false;
  bool clearLoader = false;

  // bool updateLoader = false;
  // bool cartLoader = false;
  // bool couponLoader = false;
  bool _isUnRead = false;
  bool get isUnRead => _isUnRead;


  List<Notifications> _notifications = [];
  List<Notifications> get notifications => _notifications;

  Future<void> getNotifications(context) async {
    try{

      notificationLoader = true;
      notifyListeners();
      final response = await CallApi.get( AppEndpoints.getNotifications,);

      print('=======notiiiiiiiiii======');
      print(response.statusCode);
      print(response.body);

      if(response.statusCode == 200){
        notificationLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        NotificationModel notificationModel = NotificationModel.fromJson(jsonRes);
        _notifications = notificationModel.data?.notifications?? [];

        getUnReadNotifications();

      }else{

        notificationLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        print(error);
        print(jsonDecode(response.body)['error']);
        showSnackbar(error, error: true);
      }

    }catch(e){
      print(e);
      notificationLoader = false;
      notifyListeners();
      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    }
  }

  Future<void> markAsRead(String notificationId, int index) async{

    try{
      markLoader = true;
      notifyListeners();

      final response = await CallApi.post(AppEndpoints.markAsRead,
          data: jsonEncode({
            'notification_id': notificationId,
          }));
      print(response.statusCode);

      if(response.statusCode == 200){

        notifications[index].readAt = DateTime.now().toString();

        markLoader = false;

        getUnReadNotifications();
        notifyListeners();
      }else{
        markLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      markLoader = false;
      notifyListeners();

      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> clearNotification() async{

    try{
      clearLoader = true;
      notifyListeners();

      final response = await CallApi.post(AppEndpoints.clearNotification,);
      print(response.statusCode);
      print(response.body);

      if(response.statusCode == 200){
      _notifications.clear();

        clearLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);

        showSnackbar('notification_clear'.tr, error: true);

      }else{
        clearLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      clearLoader = false;
      notifyListeners();

      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
      showSnackbar(e.toString(), error: true);
    }
  }

  getUnReadNotifications(){
   _isUnRead = _notifications.any((n) => n.readAt == null);
    notifyListeners();
  }
}