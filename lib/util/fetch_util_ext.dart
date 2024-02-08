import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/ui_designs/login_pages/login_page.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/util/context_util_ext.dart';

Map<String, String> _extraHeaders = {};
bool _debug = false;

enableAPIDebugging() {
  _debug = true;
}

disableAPIDebugging() {
  _debug = false;
}

upsertHeader(String key, String value) {
  if (_extraHeaders.containsKey(key)) {
    _extraHeaders[key] = value;
  } else {
    _extraHeaders.putIfAbsent(key, () => value);
  }
  log('NEW HEADERS:');
  log(_extraHeaders.toString());
}

removeHeader(String key) {
  if (_extraHeaders.containsKey(key)) {
    _extraHeaders.remove(key);
  }
}

extension HttpExtension on String {
  Future<Map<String, dynamic>> get() async {
    Map<String, String> headers = {};
    var user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseAuth.instance.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        await SessionManager.userLogout();
          Get.offAll(const LoginPage());
      }
    }
    if (user != null) {
      var idToken = await user.getIdToken();
      debugPrint('Authorization Token : $idToken');
      headers.putIfAbsent('Authorization', () => "Bearer $idToken");
    }
    // else{
    //   await SessionManager.userLogout();
    //   Get.offAll(const LoginPage());
    // }
    headers.putIfAbsent('Content-Type', () => 'application/json');

    _extraHeaders.forEach((key, value) {
      headers.putIfAbsent(key, () => value);
    });

    if (_debug) {
      log('GET: ${Uri.parse(Constants.baseUrl + this).toString()}');
    }

    return http.get(Uri.parse(Constants.baseUrl + this), headers: headers).then((response) {
      // if (response.statusCode < 200 || response.statusCode > 400) {
      //   throw Exception("Exception occured while fetching data: $this ${response.body}");
      // }
      var data = json.decode(response.body);
      if (_debug) {
        print('/$this \n${data.toString()}');
      }

      debugPrint('URL: ${Uri.parse(Constants.baseUrl + this).toString()}');
      debugPrint("data:\n ${data.toString()}");

      return data;
    });
  }

  Future<Map<String, dynamic>> post({required Map<String, dynamic> body}) async {
    Map<String, String> headers = {};
    String getCookie=await SessionManager.getCookie();
    print("Cookie is ${getCookie}");
    var user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseAuth.instance.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        await SessionManager.userLogout();
        Get.offAll(const LoginPage());
      }
    }
    if (user != null) {
      var idToken = await user.getIdToken();
      debugPrint("Authorization Token : $idToken");
      headers.putIfAbsent('Authorization', () => "Bearer $idToken");
    }
    // else{
    //   await SessionManager.userLogout();
    //   Get.offAll(const LoginPage());
    // }
    headers.putIfAbsent('Content-Type', () => 'application/json');
    headers.putIfAbsent('Cookie', () => getCookie);

    _extraHeaders.forEach((key, value) {
      headers.putIfAbsent(key, () => value);
    });
    if (_debug) {
      log('POST: ${Uri.parse(Constants.baseUrl + this).toString()}');
      log('POST: ${jsonEncode(body.toString())}');
    }
    return http.post(Uri.parse(Constants.baseUrl + this), headers: headers, body: json.encode(body)).then((response) {
      // if (response.statusCode < 200 || response.statusCode > 400) {
      //   throw Exception("Exception occured while fetching data: $this ${response.body}");
      // }
      debugPrint("Response : ${response.headers}");

      SessionManager.saveCookie(response.headers);

      var data = json.decode(response.body);
      if (_debug) {
        print('/$this \n${data.toString()}');
      }
      print("data from api");
      print('URL: ${Uri.parse(Constants.baseUrl + this).toString()}');
      print('BODY: ${jsonEncode(body)}');
      print("data:\n ${data.toString()}");

      return data;
    });
  }


  Future<Map<String, dynamic>> put({required Map<String, dynamic> body}) async {
    Map<String, String> headers = {};
    var user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseAuth.instance.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        await SessionManager.userLogout();
        Get.offAll(const LoginPage());
      }
    }
    if (user != null) {
      var idToken = await user.getIdToken();
      print("Authorization Token : $idToken");
      headers.putIfAbsent('Authorization', () => "Bearer $idToken");
    }
    // else{
    //   await SessionManager.userLogout();
    //   Get.offAll(const LoginPage());
    // }
    headers.putIfAbsent('Content-Type', () => 'application/json');

    _extraHeaders.forEach((key, value) {
      headers.putIfAbsent(key, () => value);
    });
    if (_debug) {
      log('PUT: ${Uri.parse(Constants.baseUrl + this).toString()}');
      log('PUT: ${body.toString()}');
    }
    return http
        .put(Uri.parse(Constants.baseUrl + this), headers: headers, body: json.encode(body))
        .then((response) {
      // if (response.statusCode < 200 || response.statusCode > 400) {
      //   throw Exception("Exception occured while fetching data: $this ${response.body}");
      // }
      var data = json.decode(response.body);
      if (_debug) {
        print('/$this \n${data.toString()}');
      }
      print("data from api");
      print('URL: ${Uri.parse(Constants.baseUrl + this).toString()}');
      print('BODY: ${body.toString()}');
      print("data:\n ${data.toString()}");

      return data;
    });
  }


  Future<Map<String, dynamic>> delete() async {
    Map<String, String> headers = {};
    var user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseAuth.instance.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        await SessionManager.userLogout();
        Get.offAll(const LoginPage());
      }
    }
    if (user != null) {
      var idToken = await user.getIdToken();
      debugPrint('Authorization Token : $idToken');
      headers.putIfAbsent('Authorization', () => "Bearer $idToken");
    }
    else{
      await SessionManager.userLogout();
      Get.offAll(const LoginPage());
    }
    headers.putIfAbsent('Content-Type', () => 'application/json');

    _extraHeaders.forEach((key, value) {
      headers.putIfAbsent(key, () => value);
    });

    if (_debug) {
      log('GET: ${Uri.parse(Constants.baseUrl + this).toString()}');
    }

    return http.delete(Uri.parse(Constants.baseUrl + this), headers: headers).then((response) {
      // if (response.statusCode < 200 || response.statusCode > 400) {
      //   throw Exception("Exception occured while fetching data: $this ${response.body}");
      // }
      var data = json.decode(response.body);
      if (_debug) {
        print('/$this \n${data.toString()}');
      }

      debugPrint('URL: ${Uri.parse(Constants.baseUrl + this).toString()}');
      debugPrint("data:\n ${data.toString()}");

      return data;
    });
  }
}
