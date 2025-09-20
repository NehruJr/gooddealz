import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/data/models/product_model.dart';

import '../../core/constants/app_endpoints.dart';
import '../../data/remote/http_api.dart';

class ProductProvider extends ChangeNotifier{

  bool productLoader = false;
  bool favoriteLoader = false;
  bool toggleLoader = false;

  int toggleId = -1;

  String _searchText ='';
  String get searchText => _searchText;

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;
  
  List<ProductDetails> _withDrawProducts = [];
  List<ProductDetails> get withDrawProducts => _withDrawProducts;

  List<ProductDetails> _favoriteProducts = [];
  List<ProductDetails> get favoriteProducts => _favoriteProducts;

  List<ProductDetails> _searchProducts = [];
  List<ProductDetails> get searchProducts => _searchProducts;

  List<ProductDetails> _searchWithdraw = [];
  List<ProductDetails> get searchWithdraw => _searchWithdraw;
  
  List<ProductDetails> _searchFavorites = [];
  List<ProductDetails> get searchFavorites => _searchFavorites;


  Future<void> getProducts(context) async {
    try{

      productLoader = true;
      notifyListeners();
      final response = await CallApi.get( AppEndpoints.products,);

      if(response.statusCode == 200){

        final jsonRes = jsonDecode(response.body);
        ProductModel productModel = ProductModel.fromJson(jsonRes);
        _products = productModel.data?.products?? [];

        _products.removeWhere((element) => element.salesPercentage == "100");
        
        productLoader = false;
        notifyListeners();

      }else{

        productLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){

      productLoader = false;
      notifyListeners();
      // showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getPossibleProducts(context) async {
    try{

      productLoader = true;
      notifyListeners();
      final response = await CallApi.get( AppEndpoints.possibleProducts,);

      if(response.statusCode == 200){

        final jsonRes = jsonDecode(response.body);
        ProductModel productModel = ProductModel.fromJson(jsonRes);
        _products = productModel.data?.products?? [];


        productLoader = false;
        notifyListeners();

      }else{

        productLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){

      productLoader = false;
      notifyListeners();
      // showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getWithdrawProducts(context) async {
    try{

      productLoader = true;
      notifyListeners();
      final response = await CallApi.get( AppEndpoints.possibleProducts,);

      if(response.statusCode == 200){

        final jsonRes = jsonDecode(response.body);
        print('==-===----===--==--=-=-');
        print(jsonRes);
        ProductModel productModel = ProductModel.fromJson(jsonRes);
        _withDrawProducts = productModel.data?.products?? [];
        print('==-===----===--==--=-=-');
        print(_withDrawProducts);
        productLoader = false;
        notifyListeners();

      }else{

        productLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){

      productLoader = false;
      notifyListeners();
      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getFavoriteProducts(context) async {
    try{

      favoriteLoader = true;
      notifyListeners();
      final response = await CallApi.get( AppEndpoints.favoriteProducts,);

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        favoriteLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        ProductModel productModel = ProductModel.fromJson(jsonRes);
        _favoriteProducts = productModel.data?.products?? [];

      }else{

        favoriteLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
print(e);
      favoriteLoader = false;
      notifyListeners();
// showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> toggleFavorite(context, ProductDetails productDetails) async {
    try{

      toggleLoader = true;
      toggleId = productDetails.id!;
      notifyListeners();
      final response = await CallApi.post('${AppEndpoints.toggleFavorite}/${productDetails.id}',);

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        final jsonRes = jsonDecode(response.body);
        if(!isInFavorite(productDetails)){
          favoriteProducts.add(productDetails);
        } else{
          favoriteProducts.remove(productDetails);
        }

        toggleLoader = false;
        notifyListeners();
      }else{

        toggleLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){

      toggleLoader = false;
      notifyListeners();
      showSnackbar(e.toString(), error: true);
    }
  }

  bool isInFavorite(ProductDetails productDetails){
    if(favoriteProducts.contains(productDetails)){
      return true;
    }
    return false;
  }

  void searchForProducts(String title){
    _searchText = title;
    notifyListeners();

    List<ProductDetails> list = [];
    if(searchText.isNotEmpty) {
      for (var product in _products) {
        if (product.title != null && product.title!.toLowerCase().contains(title.toLowerCase())) {
          list.add(product);
        }
      }
    }
    
    _searchProducts = list;

    notifyListeners();
  }
  void searchForWithDraw(String title){
    _searchText = title;
    notifyListeners();

    List<ProductDetails> list = [];
    if(searchText.isNotEmpty) {
      for (var product in _withDrawProducts) {
        if (product.title != null && product.title!.toLowerCase().contains(title.toLowerCase())) {
          list.add(product);
        }
      }
    }
    
      _searchWithdraw = list;
  

    notifyListeners();
  }

void searchForFavorites(String title){
    _searchText = title;
    notifyListeners();

    List<ProductDetails> list = [];
    if(searchText.isNotEmpty) {
      for (var product in _favoriteProducts) {
        if (product.title != null && product.title!.toLowerCase().contains(title.toLowerCase())) {
          list.add(product);
        }
      }
    }
    
    _searchFavorites = list;

    notifyListeners();
  }
void clearSearch(){
    _searchText = '';
    notifyListeners();
}

}