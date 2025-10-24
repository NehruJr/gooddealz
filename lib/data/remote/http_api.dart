import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:goodealz/core/constants/app_endpoints.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/app_routes.dart';
import '../../core/helper/functions/navigation_service.dart';
import '../../core/ys_localizations/ys_localizations_provider.dart';
import '../../views/pages/auth/login/login_page.dart';
import '../local/local_data.dart';

class CallApi {
  static Future<http.Response> get(
    String url, {
    Map<String, String>? params,
  }) async {
    var uri = Uri.parse(AppEndpoints.baseUrl + url);

    uri = uri.replace(queryParameters: params);

    final token = LocalData.token;
    print("token: ${token}");
    print(uri);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language':
          YsLocalizationsProvider.listenFalse(NavigationService.currentContext)
              .languageCode,
      'Authorization': 'Bearer $token',
    };

    log(token.toString());
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 401) {
      LocalData.removeUserData();
      LocalData.changeIsLogin(false);
      AppRoutes.routeRemoveAllTo(
          NavigationService.currentContext, const LoginPage());
    } else if (jsonDecode(response.body)['error'] != null &&
        jsonDecode(response.body)['error']
            .contains('Your account is not active')) {
      // showSnackbar(jsonDecode(response.body)['error'], error: true);
      AppRoutes.routeRemoveAllTo(
          NavigationService.currentContext, const LoginPage());
    }

    return response;
  }

  static Future<http.Response> post(String url,
      {data, bool isLogin = false, String? locale}) async {
    var uri = Uri.parse(AppEndpoints.baseUrl + url);

    final token = LocalData.token;
    print("token: ${token}");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': locale ??
          YsLocalizationsProvider.listenFalse(NavigationService.currentContext)
              .languageCode,
      'Authorization': 'Bearer $token',
    };

    print(uri);
    print(data);
    final response = await http.post(uri, body: (data), headers: headers);

    if (response.statusCode == 401 && !isLogin) {
      LocalData.removeUserData();
      LocalData.changeIsLogin(false);
      AppRoutes.routeRemoveAllTo(
          NavigationService.currentContext, const LoginPage());
    } else if (jsonDecode(response.body)['error'] != null &&
        jsonDecode(response.body)['error']
            .contains('Your account is not active')) {
      // showSnackbar(jsonDecode(response.body)['error'], error: true);
      AppRoutes.routeRemoveAllTo(
          NavigationService.currentContext, const LoginPage());
    }
    return response;
  }

  static Future<http.Response> postPay(String url,
      {data, bool isLogin = false, Map<String, String>? params}) async {
    var uri = Uri.parse(AppEndpoints.paymentUrl + url);
    uri = uri.replace(queryParameters: params);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    log(uri.toString());
    final response = await http.post(uri, body: (data), headers: headers);

    return response;
  }

  static Future<http.Response> postWithFile(String url,
      {required Map<String, String> data,
      String? fileName,
      File? file,
      bool isLogin = false}) async {
    var uri = Uri.parse(AppEndpoints.baseUrl + url);

    final token = LocalData.token;
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept-Language':
          YsLocalizationsProvider.listenFalse(NavigationService.currentContext)
              .languageCode,
    };

    var request = http.MultipartRequest('POST', uri);

    request.fields.addAll(data);
    if (file != null) {
      request.files
          .add(await http.MultipartFile.fromPath(fileName!, file.path));
    }
    request.headers.addAll(headers);

    print(uri);
    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 401 && !isLogin) {
      LocalData.removeUserData();
      LocalData.changeIsLogin(false);
      AppRoutes.routeRemoveAllTo(
          NavigationService.currentContext, const LoginPage());
    }
    return response;
  }
}
