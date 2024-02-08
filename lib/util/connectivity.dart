import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class InternetUtil {
  static Future<bool> isInternetConnected() async {
    if (kIsWeb) {
      return true;
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
