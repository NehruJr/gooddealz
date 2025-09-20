import 'package:flutter/material.dart';
import 'package:goodealz/views/pages/home/home_page.dart';
import 'package:goodealz/views/pages/welcome/splash/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:goodealz/core/helper/functions/navigation_service.dart';
import 'package:goodealz/core/ys_localizations/saved_language_code.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
export 'package:provider/provider.dart';

class YsLocalizationsProvider extends ChangeNotifier {
  static YsLocalizationsProvider get(context) =>
      Provider.of<YsLocalizationsProvider>(context);

  static YsLocalizationsProvider listenFalse(context) =>
      Provider.of<YsLocalizationsProvider>(context, listen: false);

  String _languageCode = YsLocalizations.defaultLangCode;
  final List _countryCode = YsLocalizations.supportedCountryCode;

  String get languageCode => _languageCode;
  List get countryCode => _countryCode;
  Future getSavedLanguageCode() async {
    final String savedLanguageCode =
        await SevedLanguageCode().getSavedLanguageCode();
    _languageCode = savedLanguageCode;
    notifyListeners();
  }

  Future<void> setSavedLanguageCode(String langCode) async {
    await SevedLanguageCode().setSavedLanguageCode(langCode);
    _languageCode = langCode;
    notifyListeners();
    await reloadApp();
  }

  Future<void> reloadApp() async {
    final state = NavigationService.navigatorKey.currentState;
    state?.popUntil((route) => route.isFirst);
    await Future.delayed(const Duration(milliseconds: 50), () async {
      state!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    });
  }
}
