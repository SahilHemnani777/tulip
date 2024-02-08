import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class DeviceInfoUtils {

  //get device id
  static Future<String?> getdeviceId() async {
    //send fcm token, uuid, device id, os, appversion
    if (kIsWeb) {
      var uuid = const Uuid();
      return uuid.v4();
    } else {
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        //ios
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else {
        //android
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.id; // unique ID on Android
      }
    }
  }


  //get device name or brand
  static Future<String?> getDeviceName() async {
    //send fcm token, uuid, device id, os, appversion
    if (kIsWeb) {
      var uuid = const Uuid();
      return uuid.v4();
    } else {
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        var iosDeviceInfo = await deviceInfo.iosInfo;
        String deviceNModelName = "${iosDeviceInfo.name}-${iosDeviceInfo.model}";
        return deviceNModelName; // unique ID on iOS
      } else {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        String deviceNModelName = "${androidDeviceInfo.brand}-${androidDeviceInfo.model}";
        return deviceNModelName; // unique ID on Android
      }
    }
  }

}