import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/data/models/winner_model.dart';

import '../../core/constants/app_endpoints.dart';
import '../../core/helper/functions/global_methods.dart';
import '../../data/models/product_model.dart';
import '../../data/models/prize/prize_details.dart';
import '../../data/remote/http_api.dart';

class PrizesProvider extends ChangeNotifier {
  bool winnersLoader = false;
  bool sellingFastLoader = false;
  bool soldOutLoader = false;
  bool sellingDetailsLoader = false;

  PrizeDetails? _prizeDetails;
  PrizeDetails? get prizeDetails => _prizeDetails;

  List<Prize> _winners = [];
  List<Prize> get winners => _winners;
  
  final List<Prize> _searchWinners = [];
  List<Prize> get searchWinners => _searchWinners;

  List<Prize> _sellingFastPrizes = [];
  List<Prize> get sellingFastPrizes => _sellingFastPrizes;

  List<Prize> _soldOutPrizes = [];
  List<Prize> get soldOutPrizes => _soldOutPrizes;

  final String _searchText ='';
  String get searchText => _searchText;

  Future<void> getWinners(context) async {
    try {
      winnersLoader = true;
      notifyListeners();
      final response = await CallApi.get(
        AppEndpoints.winners,
      );

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if (response.statusCode == 200) {
        winnersLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        PrizeModel prizeModel = PrizeModel.fromJson(jsonRes);
        _winners = prizeModel.data?.prizes ?? [];
      } else {
        winnersLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      winnersLoader = false;
      notifyListeners();
    //  showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getSellingFastPrizes(context) async {
    try {
      sellingFastLoader = true;
      notifyListeners();
      final response = await CallApi.get(
        AppEndpoints.sellingFastPrizes,
      );

      print('=======selling fast======');
      print(response.statusCode);
      print(response.body.toString());

      if (response.statusCode == 200) {
        sellingFastLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        PrizeModel prizeModel = PrizeModel.fromJson(jsonRes);
        _sellingFastPrizes = prizeModel.data?.prizes ?? [];
      } else {
        sellingFastLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      sellingFastLoader = false;
      notifyListeners();
      // showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getPrizeDetails(context, String prizeSlug) async {
    try {
      sellingDetailsLoader = true;
      notifyListeners();
      final response = await CallApi.get(
        AppEndpoints.sellingFastDetails + prizeSlug,
      );

      print('=======selling fast ======');
      print(response.statusCode);
      print(response.body.toString());

      if (response.statusCode == 200) {

        final jsonRes = jsonDecode(response.body);
        PrizeDetailsModel prizeDetailsModel = PrizeDetailsModel.fromJson(jsonRes);
        _prizeDetails = prizeDetailsModel.data?.prize;

        sellingDetailsLoader = false;
        notifyListeners();
      } else {
        sellingDetailsLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      sellingDetailsLoader = false;
      notifyListeners();
      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getSoldOutPrizes(context) async {
    try {
      soldOutLoader = true;
      notifyListeners();
      final response = await CallApi.get(
        AppEndpoints.soldOutPrizes,
      );

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if (response.statusCode == 200) {
        soldOutLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        PrizeModel prizeModel = PrizeModel.fromJson(jsonRes);
        _soldOutPrizes = prizeModel.data?.prizes ?? [];
      } else {
        soldOutLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      soldOutLoader = false;
      notifyListeners();
      // showSnackbar(e.toString(), error: true);
    }
  }

  // void searchForWinners(String title){
  //   _searchText = title;
  //   notifyListeners();

  //   List<Prize> list = [];
  //   if(searchText.isNotEmpty) {
  //     for (var winner in _winners) {
  //       if (winner.title != null && winner.title!.toLowerCase().contains(title.toLowerCase())) {
  //         list.add(product);
  //       }
  //     }
  //   }
    
  //   _searchFavorites = list;

  //   notifyListeners();
  // }
}
