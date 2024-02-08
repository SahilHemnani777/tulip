import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tulip_app/constant/device_info.dart';
import 'package:tulip_app/model/check_user_exists.dart';
import 'package:tulip_app/model/login_data.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/util/fetch_util_ext.dart';
import 'package:tulip_app/util/session_manager.dart';

class LoginMaster{


  static Future<SuperResponse<CheckUserExists?>> checkUserExists(String mobileNumber,String emailId) async {

    Map<String, dynamic> body = {
      'companyMobileNo': mobileNumber,
      'loginEmailId': emailId
    };

    //extra header
    ///upsertHeader("os", 'iOS');

    var data = await "app/checkUserExist".post(body: body);

    if (data['status']) {
      CheckUserExists checkUser = CheckUserExists.fromJson(data['data']);
      return SuperResponse.fromJson(data, checkUser);
    }
    else {
      return SuperResponse.fromJson(data, null);
    }
  }

  static Future<SuperResponse<LoginData?>> checkUserLogin(String userId, String password) async {

    // final deviceId = await DeviceInfoUtils.getdeviceId();
    // String? deviceName = await DeviceInfoUtils.getDeviceName();

    Map<String, dynamic> body = {
      "userId": userId,
      "password": password,
    };

    var data = await "app/login".post(body: body);

    if (data['status']) {
      LoginData checkUserLoginResponse = LoginData.fromJson(data['data']);
      print("${data['data']['userDetails']['_id']} user is this ");
      SessionManager.saveUserId(data['data']['userDetails']['_id']);
      //login using firebase token
      String customToken = data['data']['customToken'];
      await FirebaseAuth.instance.signInWithCustomToken(customToken);
      FirebaseMessaging.instance.subscribeToTopic("all");

      return SuperResponse.fromJson(data, checkUserLoginResponse);
    }
    else {
      return SuperResponse.fromJson(data, null);
    }
  }



  static Future<SuperResponse> sendOTP(String userId) async {
    Map<String, dynamic> body = {
      'userId': userId,
    };

    var data = await "app/sendOtp".post(body: body);

    if (data['status']) {
      return SuperResponse.fromJson(data, data['data']['_id']);
    }
    else {
      return SuperResponse.fromJson(data, data['message']);
    }
  }


  static Future<SuperResponse> verifyOTP(String code,String userId) async {

    Map<String, dynamic> body = {
      'otp': code,
      'userId': userId,
    };

    var data = await "app/verifyOtp".post(body: body);

    if (data['status']) {
      return SuperResponse.fromJson(data, data['status']);
    }
    else {
      return SuperResponse.fromJson(data, data['message']);
    }
  }

  static Future<SuperResponse<CheckUserExists?>> forgotPassword(String mobileNumber,String emailId) async {

    Map<String, dynamic> body = {
      'companyMobileNo': mobileNumber,
      'loginEmailId': emailId
    };

    //extra header
    ///upsertHeader("os", 'iOS');

    var data = await "app/forgotPassword".post(body: body);

    if (data['status']) {
      CheckUserExists checkUser = CheckUserExists.fromJson(data['data']);
      return SuperResponse.fromJson(data, checkUser);
    }
    else {
      return SuperResponse.fromJson(data, null);
    }
  }



  static Future<SuperResponse> resetPassword(String userId,String password) async {

    Map<String, dynamic> body = {
      'userId': userId,
      'password': password
    };
    //extra header
    ///upsertHeader("os", 'iOS');

    var data = await "app/createPassword".post(body: body);
    return SuperResponse.fromJson(data, data['status']);
  }


  static Future<SuperResponse<UserDetails?>> getUserInfo() async {

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String userId = await SessionManager.getUserId();
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    String appVersion = packageInfo.version;

    debugPrint("user id 1-> $userId");
    final deviceId = await DeviceInfoUtils.getdeviceId();
    String? deviceName = await DeviceInfoUtils.getDeviceName();

    Map<String,dynamic> body = {
    "userId": userId,
    "deviceId": deviceId,
      "os": kIsWeb ? "web" : Platform.isIOS ? "ios" : "android",
      "app_version": appVersion.toString(),
    "deviceName": deviceName,
      "fcmToken": fcmToken.toString(),
    };


    var data = await "app/getUserDetails".post(body: body);

    if(data['status']) {
      UserDetails userDataInfo = UserDetails.fromJson(data['data']);
      return SuperResponse.fromJson(data, userDataInfo);
    }
    else {
      return SuperResponse.fromJson(data, null);
    }
  }



  static Future<SuperResponse<List<UserDetails>?>> getActiveUserInfo() async {

    String userId= await SessionManager.getUserId();

    var data = await "app/getActiveUsers?$userId".get();

    debugPrint("Result Data${data.toString()}");
    log("User Data is :${jsonEncode(data)}");
    if(data['status']) {
      Iterable dataList= data['data'];
      List<UserDetails> userDataInfo = dataList.map((e) => UserDetails.fromJson(e)).toList();
      return SuperResponse.fromJson(data, userDataInfo);
    }
    else {
      return SuperResponse.fromJson(data, null);
    }
  }


}