import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:goodealz/core/constants/app_endpoints.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/data/local/local_data.dart';
import 'package:goodealz/data/models/profile/profile_model.dart';
import 'package:goodealz/data/models/user_model.dart' as u;
import 'package:goodealz/views/pages/auth/login/login_page.dart';
import 'package:goodealz/views/pages/auth/otp_code/otp_code_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../core/constants/app_routes.dart';
import '../../core/helper/functions/global_methods.dart';
import '../../core/ys_localizations/ys_localizations_provider.dart';
import '../../data/models/nationality.dart';
import '../../data/remote/http_api.dart';
import '../../notification/my_notification.dart';
import '../../views/pages/auth/reset_password/reset_password_page.dart';
import '../../views/pages/auth/signup/social_register.dart';
import '../../views/pages/home/home_page.dart';
import '../cart/cart_provider.dart';
export 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  bool loginLoader = false;
  bool loginGuestLoader = false;
  bool logoutLoader = false;
  bool signupLoader = false;
  bool forgetPasswordLoader = false;
  bool profileLoader = false;
  bool verificationCodeLoader = false;
  bool resendCodeLoader = false;
  bool resetPasswordLoader = false;
  bool updateProfileLoader = false;
  bool socialLoginLoader = false;
  bool socialRegisterLoader = false;
  bool updateFCMLoader = false;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  String? _countryCode;

  String? get countryCode => _countryCode;

  List<Nationality> _nationalities = [];

  List<Nationality> get nationalities => _nationalities;

  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  bool _isGuest = false;
  bool? get isGuest => _isGuest;

  u.User? currentUser;

  Future<void> login(context,
      {required String email, required String password}) async {
    try {
      loginLoader = true;
      notifyListeners();

      String dToken = await MyNotification.getFcmToken();

      final response = await CallApi.post(AppEndpoints.login,
          data: jsonEncode(
              {'email': email, 'password': password, 'fcm_token': dToken}),
          isLogin: true);
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        loginLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        u.UserModel userModel = u.UserModel.fromJson(jsonRes);
        currentUser = userModel.data?.user;
        if (currentUser != null && currentUser!.verified == 0) {
          LocalData.setToken(userModel.data!.accessToken!);
          LocalData.changeIsLogin(false);
          AppRoutes.routeTo(context, OTPCodePage(phone: currentUser!.phone!));
        } else {
          LocalData.setUserData(currentUser!);
          LocalData.setToken(userModel.data!.accessToken!);
          LocalData.setRememberedEmail(email);
          LocalData.changeIsLogin(true);

          Provider.of<CartProvider>(context, listen: false)
              .getCartCount(context);

          notGuest();
          AppRoutes.routeRemoveAllTo(context, const HomePage());
        }
      } else {
        loginLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      loginLoader = false;
      notifyListeners();

      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> loginWithGoogle(context) async {
    try {
      socialLoginLoader = true;
      notifyListeners();

      await GoogleSignIn.instance.signOut();

      await GoogleSignIn.instance.initialize(
        serverClientId:
            "336224681714-2ol6inejkogngjkjitgcf40j71h8fmcv.apps.googleusercontent.com",
      );

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        socialLoginLoader = false;
        notifyListeners();
        return;
      }

      googleUser.authentication;

      log("Google user email: ${googleUser.email}");
      log("Google user displayName: ${googleUser.displayName}");
      log("Google user photoUrl: ${googleUser.photoUrl}");

      String dToken = await MyNotification.getFcmToken();

      final response = await CallApi.post(
        AppEndpoints.socialLogin,
        data: jsonEncode({
          'email': googleUser.email,
          'fcm_token': dToken,
          'name': googleUser.displayName ?? '',
          'photo_url': googleUser.photoUrl ?? '',
        }),
        isLogin: true,
      );

      if (response.statusCode == 200) {
        socialLoginLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        u.UserModel userModel = u.UserModel.fromJson(jsonRes);
        currentUser = userModel.data?.user;

        if (currentUser != null && currentUser!.verified == 0) {
          LocalData.setToken(userModel.data!.accessToken!);
          AppRoutes.routeTo(context, OTPCodePage(phone: currentUser!.phone!));
        } else {
          LocalData.setUserData(currentUser!);
          LocalData.setToken(userModel.data!.accessToken!);
          LocalData.changeIsLogin(true);
          Provider.of<CartProvider>(context, listen: false)
              .getCartCount(context);
          notGuest();
          AppRoutes.routeRemoveAllTo(context, const HomePage());
        }
      } else if (response.statusCode == 401) {
        socialLoginLoader = false;
        notifyListeners();

        AppRoutes.routeTo(
          context,
          SocialRegisterPage(
            name: googleUser.displayName ?? '',
            email: googleUser.email,
            photoUrl: googleUser.photoUrl ?? '',
          ),
        );
      } else {
        socialLoginLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      socialLoginLoader = false;
      notifyListeners();
      showSnackbar("Google Sign-In failed: ${e.toString()}", error: true);
    }
  }

  Future<void> loginWithApple(context) async {
    try {
      socialLoginLoader = true;
      notifyListeners();

      // await GoogleSignIn().signOut();

      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ]);

      String dToken = await MyNotification.getFcmToken();
      final response = await CallApi.post(AppEndpoints.socialLogin,
          data: jsonEncode(
              {'email': credential.email ?? '', 'fcm_token': dToken}),
          isLogin: true);
      print(response.statusCode);

      if (response.statusCode == 200) {
        socialLoginLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        u.UserModel userModel = u.UserModel.fromJson(jsonRes);
        currentUser = userModel.data?.user;
        if (currentUser != null && currentUser!.verified == 0) {
          LocalData.setToken(userModel.data!.accessToken!);
          AppRoutes.routeTo(context, OTPCodePage(phone: currentUser!.phone!));
        } else {
          LocalData.setUserData(currentUser!);
          LocalData.setToken(userModel.data!.accessToken!);
          LocalData.changeIsLogin(true);
          Provider.of<CartProvider>(context, listen: false)
              .getCartCount(context);

          notGuest();
          AppRoutes.routeRemoveAllTo(context, const HomePage());
        }
      } else if (response.statusCode == 401) {
        socialLoginLoader = false;
        notifyListeners();
        AppRoutes.routeTo(
            context,
            SocialRegisterPage(
              name: credential.givenName ?? '',
              email: credential.email ?? '',
              photoUrl: '',
            ));
      } else {
        socialLoginLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
      // GlobalMethods.errorDialog(subtitle:googleSignIn!.email.toString()+ googleSignIn.displayName.toString(), context: context);
    } catch (e) {
      socialLoginLoader = false;
      notifyListeners();
      print(e);
      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> loginWithFaceBook(context) async {
    try {
      socialLoginLoader = true;
      notifyListeners();
      await FacebookAuth.instance.logOut();

      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ["email"], loginBehavior: LoginBehavior.webOnly);

      print('loginResult.message');
      print(loginResult.message);
      print(loginResult.status);
 
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
                loginResult.accessToken!.tokenString);

        final login = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        print(';;;;;;;;;;;;;;;;;;;');
        print(login.user!.email);

        String dToken = await MyNotification.getFcmToken();
        final response = await CallApi.post(AppEndpoints.socialLogin,
            data: jsonEncode({'email': login.user!.email, 'fcm_token': dToken}),
            isLogin: true);
        print(response.statusCode);
        print(response.body);

        if (response.statusCode == 200) {
          socialLoginLoader = false;
          notifyListeners();

          final jsonRes = jsonDecode(response.body);
          u.UserModel userModel = u.UserModel.fromJson(jsonRes);
          currentUser = userModel.data?.user;
          if (currentUser != null && currentUser!.verified == 0) {
            LocalData.setToken(userModel.data!.accessToken!);
            AppRoutes.routeTo(context, OTPCodePage(phone: currentUser!.phone!));
          } else {
            LocalData.setUserData(currentUser!);
            LocalData.setToken(userModel.data!.accessToken!);
            LocalData.changeIsLogin(true);
            Provider.of<CartProvider>(context, listen: false)
                .getCartCount(context);

            notGuest();
            AppRoutes.routeRemoveAllTo(context, const HomePage());
          }
        } else if (response.statusCode == 401) {
          socialLoginLoader = false;
          notifyListeners();
          AppRoutes.routeTo(
              context,
              SocialRegisterPage(
                name: login.user!.displayName!,
                email: login.user!.email!,
                photoUrl: login.user!.photoURL!,
              ));
        } else {
          socialLoginLoader = false;
          notifyListeners();

          final error = jsonDecode(response.body)['message'] ??
              jsonDecode(response.body)['error'] ??
              'An error occurred';
          showSnackbar(error, error: true);
        }
      }
      // }
      socialLoginLoader = false;
      notifyListeners();
      // final response = await CallApi.post(AppEndpoints.socialLogin,
      //     data: jsonEncode({
      //       'email': login['email'],
      //     }),
      //     isLogin: true);
      // print(response.statusCode);
      //
      // if (response.statusCode == 200) {
      //   socialLoginLoader = false;
      //   notifyListeners();
      //
      //   final jsonRes = jsonDecode(response.body);
      //   UserModel userModel = UserModel.fromJson(jsonRes);
      //   currentUser = userModel.data?.user;
      //   if (currentUser != null) {
      //     LocalData.setUserData(currentUser!);
      //     LocalData.setToken(userModel.data!.accessToken!);
      //     LocalData.changeIsLogin(true);
      //   }
      //
      //   notGuest();
      //   AppRoutes.routeRemoveAllTo(context, const HomePage());
      // } else {
      //   socialLoginLoader = false;
      //   notifyListeners();
      //
      //   final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
      //   showSnackbar(error, error: true);
      // }
      // print(login.user?.displayName);
      // GlobalMethods.errorDialog(subtitle:login['email']+ login['name'], context: context);
    } on FirebaseAuthException catch (e) {
      socialLoginLoader = false;
      notifyListeners();
      print('..........................................');
      print(e);
    } catch (e) {
      socialLoginLoader = false;
      notifyListeners();
      print('..........................................');
      print(e);
      // showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> socialRegister(
    context, {
    required String name,
    required String firstName,
    required String lastName,
    required String gender,
    required String email,
    required String phone,
    required String photoUrl,
  }) async {
    try {
      socialRegisterLoader = true;
      notifyListeners();

      String dToken = await MyNotification.getFcmToken();

      final data = {
        'name': name,
        'given_name': firstName,
        'family_name': lastName,
        'email': email,
        'phone': phone,
        'gender': gender,
        'photoUrl': photoUrl,
        'fcm_token': dToken
        // 'locale': 'en-GB',
      };
      final response = await CallApi.post(AppEndpoints.socialRegister,
          data: jsonEncode(data));

      print('=======response======');
      print(response.statusCode);
      print(data);
      print(response.body);

      if (response.statusCode == 200) {
        socialRegisterLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        u.UserModel userModel = u.UserModel.fromJson(jsonRes);
        currentUser = userModel.data?.user;
        if (currentUser != null) {
          LocalData.setUserData(currentUser!);
          LocalData.setToken(userModel.data!.accessToken!);
          LocalData.changeIsLogin(true);
        }

        notGuest();
        AppRoutes.routeRemoveAllTo(context, const HomePage());
      } else {
        socialRegisterLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      socialRegisterLoader = false;
      notifyListeners();

      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> signup(
    context, {
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String gender,
    required String nationality,
    required String password,
  }) async {
    try {
      signupLoader = true;
      notifyListeners();

      final response = await CallApi.post(AppEndpoints.register,
          data: jsonEncode({
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'gender': gender,
            'nationality': nationality,
            'phone': phone,
            'password': password,
            'password_confirmation': password,
          }));

      if (response.statusCode == 200) {
        signupLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        u.UserModel userModel = u.UserModel.fromJson(jsonRes);
        currentUser = userModel.data?.user;
        if (currentUser != null) {
          LocalData.setUserData(currentUser!);
          LocalData.setToken(userModel.data!.accessToken!);
        }
        showSnackbar(jsonRes['message']);

        AppRoutes.routeTo(
            context,
            OTPCodePage(
              phone: phone,
            ));
      } else {
        signupLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      signupLoader = false;
      notifyListeners();

      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> updateProfile(context,
      {required String? firstName,
      required String? lastName,
      required String? email,
      required File? avatar,
      required String? phone,
      required String? password,
      bool newPhone = false}) async {
    try {
      updateProfileLoader = true;
      notifyListeners();

      final response = await CallApi.postWithFile(AppEndpoints.updateProfile,
          fileName: 'avatar',
          file: avatar,
          data: {
            if (firstName != null) 'first_name': firstName,
            if (lastName != null) 'last_name': lastName,
            if (email != null) 'email': email,
            if (phone != null) 'phone': phone,
            if (password != null) 'password': password,
            if (password != null) 'password_confirmation': password,
          });

      print('=======response======');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);
        u.UserModel userModel = u.UserModel.fromJson(jsonRes);
        currentUser = userModel.data?.user;
        if (currentUser != null) {
          LocalData.setUserData(currentUser!);
        }
        if (newPhone && currentUser!.verified == 0) {
          // LocalData.removeUserData();
          LocalData.changeIsLogin(false);
          AppRoutes.routeRemoveAllTo(
              context, OTPCodePage(phone: currentUser!.phone!));
        }
        showSnackbar(jsonRes['message'], error: true);

        updateProfileLoader = false;
        notifyListeners();
        //
        // AppRoutes.routeRemoveAllTo(context, const HomePage());
      } else {
        updateProfileLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      updateProfileLoader = false;
      notifyListeners();

      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> logout(context) async {
    try {
      logoutLoader = true;
      notifyListeners();

      final response = await CallApi.post(
        AppEndpoints.logout,
      );

      if (response.statusCode == 200) {
        logoutLoader = false;
        notifyListeners();

        LocalData.removeUserData();

        AppRoutes.routeRemoveAllTo(context, const LoginPage());
      } else {
        logoutLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        GlobalMethods.errorDialog(subtitle: error, context: context);
      }
    } catch (e) {
      logoutLoader = false;
      notifyListeners();

      GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    }
  }

  Future<void> deleteAccount(context) async {
    try {
      final response = await CallApi.get(
        AppEndpoints.deleteAccount,
      );

      if (response.statusCode == 200) {
        LocalData.removeUserData();

        AppRoutes.routeRemoveAllTo(context, const LoginPage());
      } else {
        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        log(error);
        showSnackbar(error, error: true);
      }
    } catch (e) {
      log(e.toString());
      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> forgetPassword(
    context, {
    required String phone,
  }) async {
    try {
      forgetPasswordLoader = true;
      notifyListeners();

      final params = {'phone': phone};
      final response =
          await CallApi.get(AppEndpoints.forgetPassword, params: params);

      print('=======response======');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        forgetPasswordLoader = false;
        notifyListeners();

        AppRoutes.routeRemoveAllTo(
            context,
            OTPCodePage(
              phone: phone,
              isFromReset: true,
            ));
      } else {
        forgetPasswordLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        GlobalMethods.errorDialog(subtitle: error, context: context);
      }
    } catch (e) {
      forgetPasswordLoader = false;
      notifyListeners();

      GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    }
  }

  Future<void> resendForgetPassword(
    context, {
    required String phone,
  }) async {
    try {
      resendCodeLoader = true;
      notifyListeners();

      final params = {'phone': phone};
      final response =
          await CallApi.get(AppEndpoints.forgetPassword, params: params);

      print('=======response======');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        resendCodeLoader = false;
        notifyListeners();

        showSnackbar(jsonDecode(response.body)['message']);
      } else {
        resendCodeLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      resendCodeLoader = false;
      notifyListeners();

      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> checkRestPassCode(
    context, {
    required String phone,
    required String code,
  }) async {
    try {
      verificationCodeLoader = true;
      notifyListeners();

      final data = jsonEncode({'phone': phone, "reset_password_code": code});
      final response =
          await CallApi.post(AppEndpoints.checkVerificationCode, data: data);

      print('=======response======');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        verificationCodeLoader = false;
        notifyListeners();

        AppRoutes.routeRemoveAllTo(
            context,
            ResetPasswordPage(
              phone: phone,
            ));
      } else {
        verificationCodeLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      verificationCodeLoader = false;
      notifyListeners();

      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> checkVerificationCode(
    context, {
    required String code,
  }) async {
    try {
      verificationCodeLoader = true;
      notifyListeners();

      final data = jsonEncode({"verification_code": code});

      print('url====');
      print(AppEndpoints.phoneVerification);

      final response =
          await CallApi.post(AppEndpoints.phoneVerification, data: data);

      print('=======response======');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        verificationCodeLoader = false;
        notifyListeners();

        LocalData.changeIsLogin(true);
        notGuest();
        AppRoutes.routeRemoveAllTo(context, const HomePage());
      } else {
        verificationCodeLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      verificationCodeLoader = false;
      notifyListeners();

      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> resendVerificationCode(context) async {
    try {
      resendCodeLoader = true;
      notifyListeners();

      final response = await CallApi.get(AppEndpoints.resendOtp);

      print('=======response======');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        resendCodeLoader = false;
        notifyListeners();

        showSnackbar(jsonDecode(response.body)['message']);
      } else {
        resendCodeLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      resendCodeLoader = false;
      notifyListeners();

      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> resetPassword(context,
      {required String phone,
      required String password,
      bool isFromProfile = false}) async {
    try {
      resetPasswordLoader = true;
      notifyListeners();

      final data = jsonEncode({
        'phone': phone,
        'password': password,
        'password_confirmation': password,
      });
      final response =
          await CallApi.post(AppEndpoints.resetPassword, data: data);

      print('=======response======');
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        resetPasswordLoader = false;
        notifyListeners();
        if (isFromProfile) {
          showSnackbar(jsonDecode(response.body)['message']);
          Navigator.pop(context);
        } else {
          AppRoutes.routeRemoveAllTo(context, const LoginPage());
        }
      } else {
        resetPasswordLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      resetPasswordLoader = false;
      notifyListeners();

      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> getNationalities(context) async {
    try {
      final response = await CallApi.get(
        AppEndpoints.getNationalities,
      );

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);
        NationalityModel nationalityModel = NationalityModel.fromJson(jsonRes);
        _nationalities = nationalityModel.data?.nationalities ?? [];
      } else {
        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        // GlobalMethods.errorDialog(subtitle: error, context: context);
        showSnackbar(error, error: true);
      }
    } catch (e) {
      showSnackbar(e.toString(), error: true);
      // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    }
  }

  Future<void> getProfileData(context) async {
    // try {
    profileLoader = true;
    notifyListeners();

    final response = await CallApi.get(
      AppEndpoints.getProfile,
    );

    print('=======response======');
    print(response.statusCode);
    log(response.body.toString());

    if (response.statusCode == 200) {
      profileLoader = false;
      notifyListeners();

      final jsonRes = jsonDecode(response.body);
      ProfileModel profileModel = ProfileModel.fromJson(jsonRes);
      _userProfile = profileModel.data?.user;
      print(_userProfile);
    } else {
      profileLoader = false;
      notifyListeners();

      final error = jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['error'] ??
          'An error occurred';
      showSnackbar(error, error: true);
      // GlobalMethods.errorDialog(subtitle: error, context: context);
    }
    // } catch (e) {
    //   profileLoader = false;
    //   notifyListeners();
    //   print(e);
    //   // showSnackbar(e.toString(), error: true);
    //   // GlobalMethods.errorDialog(subtitle: e.toString(), context: context);
    // }
  }

  Future<void> loginAsGuest(context) async {
    try {
      loginGuestLoader = true;
      notifyListeners();

      final response =
          await CallApi.post(AppEndpoints.loginAsGuest, isLogin: true);
      log(response.body.toString());
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        _isGuest = true;
        loginGuestLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);

        LocalData.setToken(jsonRes['data']['session_token']);

        AppRoutes.routeRemoveAllTo(context, const HomePage());
      } else {
        loginGuestLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      loginGuestLoader = false;
      notifyListeners();

      showSnackbar(e.toString(), error: true);
    }
  }

  Future<void> updateFCM() async {
    try {
      updateFCMLoader = true;
      notifyListeners();

      String dToken = await MyNotification.getFcmToken();
      final response = await CallApi.post(AppEndpoints.updateFCM,
          data: jsonEncode({'fcm_token': dToken}), isLogin: true);
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        updateFCMLoader = false;
        notifyListeners();
      } else {
        updateFCMLoader = false;
        notifyListeners();

        final error = jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            'An error occurred';
        showSnackbar(error, error: true);
      }
    } catch (e) {
      updateFCMLoader = false;
      notifyListeners();

      showSnackbar(e.toString(), error: true);
    }
  }

  void notGuest() {
    _isGuest = false;
  }

  getUserData() {
    currentUser = LocalData.getUserData();
  }

  void changeCountryCode(String nationality) {
    _countryCode = _nationalities
        .firstWhere((element) => element.name == nationality)
        .code;
    notifyListeners();
  }

  void changeRememberMe(bool? val) {
    _rememberMe = val ?? false;
    notifyListeners();
  }
}
