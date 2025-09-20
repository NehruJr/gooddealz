import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:goodealz/core/constants/app_themes.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/core/ys_localizations/ys_material_app.dart';
import 'package:goodealz/data/remote/remote_data.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/providers/checkout/checkout_provider.dart';
import 'package:goodealz/providers/product/product_provider.dart';
import 'package:goodealz/providers/settings/settings_provider.dart';
import 'package:goodealz/views/pages/welcome/splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'data/local/local_data.dart';
import 'firebase_options.dart';
import 'notification/my_notification.dart';
import 'providers/cart/cart_provider.dart';
import 'providers/conectivity_provider.dart';
import 'providers/discount/discount_provider.dart';
import 'providers/notification/notification_provider.dart';
import 'providers/ongoing_actions/onoing_actions_provider.dart';
import 'providers/order/order_provider.dart';
import 'providers/payment/payment_provider.dart';
import 'providers/prizes/prizes_provider.dart';
import 'providers/purchase_code_provider.dart';
import 'providers/tickets/tickets_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'goodeals channel id', // id
  'goodeals channel name', // title
  description: 'goodeals channel description', // description
  importance: Importance.max,
  sound: RawResourceAndroidNotificationSound('notification'),
);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Handling a background message ${message.messageId}');
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await YsLocalizations.init();
  LocalData.init();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

  MyNotification.initialize(flutterLocalNotificationsPlugin);

  // const instanceID = '00000000-0000-0000-0000-000000000000';
  // await PusherBeams.instance.start(instanceID);
  // await PusherBeams.instance.setDeviceInterests([‘hello’]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => YsLocalizationsProvider()..getSavedLanguageCode()),
        ChangeNotifierProvider(create: (context) => ConectivityProvider()),
        ChangeNotifierProvider(create: (context) => RemoteData()),
        ChangeNotifierProvider(create: (context) => AuthProvider()..getNationalities(context)),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => PrizesProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => DiscountProvider()),
        ChangeNotifierProvider(create: (context) => CheckoutProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => TicketsProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => OngoingActionsProvider()),
        ChangeNotifierProvider(create: (context) => PurchaseProvider()),
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
      ],
      child: YsMaterialApp(
        title: 'app_name'.tr,
        theme: AppThemes.theme,
        // home: const HomePage(),
        home: const SplashPage(),
      ),
    );
  }
}
