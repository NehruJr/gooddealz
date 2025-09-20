import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConectivityProvider with ChangeNotifier{

bool _isOffline = false;
bool get isOffline => _isOffline;

ConectivityProvider(){
  Connectivity connectivity = Connectivity();

  connectivity.onConnectivityChanged.listen((event) {
    print(event);
    print(event.contains(ConnectivityResult.wifi) );
    if(event.contains(ConnectivityResult.none)){
      _isOffline = true;
      print('-----------------------------------------');
      notifyListeners();
    }else{
_isOffline = false;
      notifyListeners();
    }
  });
}

}