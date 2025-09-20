import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/data/models/settings/how_it_works_model.dart';
import 'package:goodealz/data/models/settings/faq_model.dart';
import 'package:goodealz/data/models/settings/terms_model.dart';
import 'package:goodealz/data/models/settings/wallet_model.dart';

import '../../core/constants/app_endpoints.dart';
import '../../core/helper/functions/global_methods.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/settings/aboutus_model.dart';
import '../../data/models/settings/privacy_model.dart';
import '../../data/remote/http_api.dart';

class SettingsProvider extends ChangeNotifier{

  bool faqsLoader = false;
  bool aboutUsLoader = false;
  bool contactLoader = false;
  bool howItWorkLoader = false;
  bool bannerLoader = false;
  bool privacyLoader = false;
  bool termsLoader = false;
  bool walletLoader = false;
  bool chargeLoader = false;

  List<Faq> _faqs = [];
  List<Faq> get faqs => _faqs;

  AboutUsModel? _aboutUsModel;
  AboutUsModel? get aboutUsModel => _aboutUsModel;

  TermsModel? _termsModel;
  TermsModel? get termsModel => _termsModel;

  PrivacyModel? _privacyModel;
  PrivacyModel? get privacyModel => _privacyModel;

  BannerModel? _bannerModel;
  BannerModel? get bannerModel => _bannerModel;

  HowItWorksModel? _howItWorksModel;
  HowItWorksModel? get howItWorksModel => _howItWorksModel;

  WalletModel? _walletModel;
  WalletModel? get walletModel => _walletModel;




  Future<void> getFaqs(context) async {
    try{

      faqsLoader = true;
      notifyListeners();
      final response = await CallApi.get(AppEndpoints.faqs,);

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        faqsLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        FaqsModel faqsModel = FaqsModel.fromJson(jsonRes);
        _faqs = faqsModel.faqs?? [];

      }else{

        faqsLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        GlobalMethods.errorDialog(subtitle: error, context: context);
      }

    }catch(e){

      faqsLoader = false;
      notifyListeners();
      GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    }
  }

  Future<void> getAboutUs(context) async {
    try{

      aboutUsLoader = true;
      notifyListeners();
      final response = await CallApi.get(AppEndpoints.aboutUs,);

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        aboutUsLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        _aboutUsModel = AboutUsModel.fromJson(jsonRes);

      }else{

        aboutUsLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        GlobalMethods.errorDialog(subtitle: error, context: context);
      }

    }catch(e){

      aboutUsLoader = false;
      notifyListeners();
      GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    }
  }

  Future<void> getTerms(context) async {
    try{

      termsLoader = true;
      notifyListeners();
      final response = await CallApi.get(AppEndpoints.terms,);

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        termsLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        _termsModel = TermsModel.fromJson(jsonRes);

      }else{

        termsLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        GlobalMethods.errorDialog(subtitle: error, context: context);
      }

    }catch(e){

      termsLoader = false;
      notifyListeners();
      GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    }
  }

  Future<void> getPrivacyPolicy(context) async {
    try{

      privacyLoader = true;
      notifyListeners();
      final response = await CallApi.get(AppEndpoints.privacyPolicy,);

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        privacyLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        _privacyModel = PrivacyModel.fromJson(jsonRes);

      }else{

        privacyLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        GlobalMethods.errorDialog(subtitle: error, context: context);
      }

    }catch(e){

      privacyLoader = false;
      notifyListeners();
      GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    }
  }

  Future<void> getBanners(context) async {
    try{

      bannerLoader = true;
      notifyListeners();
      final response = await CallApi.get(AppEndpoints.banners,);

      print('=======banner======');
      print(response.statusCode);
      print(response.body.toString());

      if(response.statusCode == 200){
        bannerLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        _bannerModel = BannerModel.fromJson(jsonRes);

      }else{

        bannerLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }
    catch(e){

      bannerLoader = false;
      notifyListeners();
      // showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getHowItWorks(context) async {
    try{

      howItWorkLoader = true;
      notifyListeners();
      final response = await CallApi.get(AppEndpoints.howItWorks,);

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        howItWorkLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        _howItWorksModel = HowItWorksModel.fromJson(jsonRes);

      }else{

        howItWorkLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        GlobalMethods.errorDialog(subtitle: error, context: context);
      }

    }catch(e){

      howItWorkLoader = false;
      notifyListeners();
      GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    }
  }

  Future<void> getMyWallet(context) async {
    try{

      walletLoader = true;
      notifyListeners();
      final response = await CallApi.get(AppEndpoints.myWallet,);

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        walletLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        _walletModel = WalletModel.fromJson(jsonRes);

      }else{

        howItWorkLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){

      howItWorkLoader = false;
      notifyListeners();
      GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    }
  }

  Future<void> chargeWallet(context, { required double balance, required String referenceNumber}) async {
    try{

      walletLoader = true;
      notifyListeners();
      final response = await CallApi.post(AppEndpoints.chargeWallet,
      data: jsonEncode({
        'balance': balance.toString(),
        'referenceNumber': referenceNumber
      }));

      print('=======response======');
      print(balance);
      log(response.body.toString());

      if(response.statusCode == 200){
        walletLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        _walletModel = WalletModel.fromJson(jsonRes);

      }else{
        walletLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){
      walletLoader = false;
      notifyListeners();
      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> contactUs(context, {required String name, required String email, required String message, }) async {
    try{

      contactLoader = true;
      notifyListeners();
      final response = await CallApi.post( AppEndpoints.contactUs, data: jsonEncode({
        'name': name,
        'email': email,
        'message': message
      }));

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        contactLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        showSnackbar(jsonRes['message']);

      }else{

        faqsLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        GlobalMethods.errorDialog(subtitle: error, context: context);
      }

    }catch(e){

      contactLoader = false;
      notifyListeners();
      GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    }
  }

}