import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Constants {
  //DEV
  // static const String baseUrl = "http://15.207.24.41:4000/";
  // static const String baseUrl = "http://15.207.24.41:3001/";
  // static const String baseUrl = "http://192.168.1.21:3001/";

  //PROD
  static const String baseUrl = "https://admin.tulipdiagnostics.in/";

  static const Color primaryColor = Color(0xffE30016);
  static const Color primaryTextColor = Color(0xffE30016);
  static Color lightGreyColor = Colors.black.withOpacity(0.5);
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color lightGreyBorderColor = Colors.black.withOpacity(0.10);

  //Color Gradient
  static const Gradient buttonGradientColor = LinearGradient(colors: [
    Color(0xffE30016),
    Color(0xffA12B2E),
  ]);

  static void launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void launchWhatsApp(String phoneNumber) async {
    final url = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<DateTime?> pickDate(
      DateTime firstDate, DateTime lastDate, BuildContext context) async {
    final res = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (res != null) {
      return res;
    }
    return null;
  }

  static Route createRoute(Widget widget) {
    return PageRouteBuilder(
      barrierDismissible: true,
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      opaque: false, // Set to false to make the page transparent
      barrierColor: Colors.black
          .withOpacity(0.5), // Set the color of the barrier if needed
    );
  }
}
