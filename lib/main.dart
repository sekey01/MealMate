import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mealmate/AdminPanel/OtherDetails/AdminFunctionsProvider.dart';
import 'package:mealmate/AdminPanel/OtherDetails/ID.dart';
import 'package:mealmate/AdminPanel/OtherDetails/incomingOrderProvider.dart';
import 'package:mealmate/Local_Storage/Locall_Storage_Provider/StoreCredentials.dart';
import 'package:mealmate/Notification/notification_Provider.dart';
import 'package:mealmate/PaymentProvider/paystack_payment.dart';
import 'package:mealmate/UserLocation/LocationProvider.dart';
import 'package:mealmate/firebase_options.dart';
import 'package:mealmate/models&ReadCollectionModel/sendOrderFunctionProvider.dart';
import 'package:mealmate/pages/init_pages/splashscreen.dart';
import 'package:mealmate/searchFoodItemProvider/searchFoodItemFunctionProvider.dart';
import 'package:mealmate/theme/themedata.dart';
import 'package:provider/provider.dart';
import 'AdminPanel/collectionUploadModelProvider/collectionProvider.dart';
import 'Other_Providers/Network_Images.dart';
import 'models&ReadCollectionModel/cartmodel.dart';
import 'models&ReadCollectionModel/userReadwithCollection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CartModel()),
          ChangeNotifierProvider(create: (context) => AdminCollectionProvider()),
          ChangeNotifierProvider(create: (context) => userCollectionProvider()),
          ChangeNotifierProvider(create: (context) => AdminId()),
          ChangeNotifierProvider(create: (context) => AdminFunctions()),
          ChangeNotifierProvider(create: (context) => SearchProvider()),
          ChangeNotifierProvider(create: (context) => LocationProvider()),
          ChangeNotifierProvider(create: (context) => SendOrderProvider()),
          ChangeNotifierProvider(create: (context) => LocalStorageProvider()),
          ChangeNotifierProvider(create: (context) => IncomingOrdersProvider()),
          ChangeNotifierProvider(create: (context) => NotificationProvider()),
          ChangeNotifierProvider(create: (context) => NetworkImageProvider()),
          ChangeNotifierProvider(create: (context) => PaystackPaymentProvider())
        ],
        child: MaterialApp(
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
            ],
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: Scaffold(
              body: SplashScreen(),
            )),
      ),
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }
}