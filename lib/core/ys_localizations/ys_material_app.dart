import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/navigation_service.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';

class YsMaterialApp extends StatelessWidget {
  const YsMaterialApp({
    super.key,
    this.title = '',
    this.theme,
    this.darkTheme,
    this.home,
  });
  final String title;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final Widget? home;

  @override
  Widget build(BuildContext context) {
    final locale = YsLocalizationsProvider.get(context);
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      locale: Locale(locale.languageCode),
      supportedLocales: YsLocalizations.supportedLocale,
      localizationsDelegates: YsLocalizations.localizationsDelegates,
      localeResolutionCallback: YsLocalizations.localeResolutionCallback,
      title: title,
      theme: theme,
      darkTheme: darkTheme,
      home: home,
    );
  }
}
