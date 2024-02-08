import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/firebase_options.dart';
import 'package:tulip_app/ui_designs/home_tab/menu_pages/dashboard_page.dart';
import 'package:tulip_app/ui_designs/home_tab/my_expense_pages/my_expense_list.dart';
import 'package:tulip_app/util/location_controller.dart';
import 'ui_designs/home_tab/dcr_pages/dcr_list.dart';
import 'ui_designs/home_tab/products_catalogue/product_category_page.dart';
import 'util/session_manager.dart';
import 'util/size_config.dart';
import 'widget/video_player.dart';


FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Handle the background message, e.g., navigate to a specific page
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Get.put(LocationController());
  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tulip App',
      routes: {
        '/dashboard': (context) => const DashBoardPage(),
        '/expense_list': (context) => const MyExpenseList(),
        '/product_list': (context) => const ProductCategoryPage(),
        '/dcr' :(context) => const DCRListPage(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        //Default TextStyle Declared here

        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        //Default Color Declared here

        primarySwatch: MaterialColor(
            Constants.primaryColor.value, const {
          50: Constants.primaryColor,
          100: Constants.primaryColor,
          200: Constants.primaryColor,
          300: Constants.primaryColor,
          400: Constants.primaryColor,
          500: Constants.primaryColor,
          600: Constants.primaryColor,
          700: Constants.primaryColor,
          800: Constants.primaryColor,
          900: Constants.primaryColor
        }),
      ),
      home: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          if (constraints.maxWidth == 0 || constraints.maxHeight == 0) {
            return const SizedBox();
          } else {
            SizeConfig.init(constraints, orientation);
          }
          return FutureBuilder(
            future: SessionManager.isUserLogin(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data) {
                  return const DashBoardPage();
                } else {
                  return VideoPlayerScreen();
                  // return const LoginPage();
                }
              }
              return Container();
            },
          );
        });
      }),
    );
  }
}

