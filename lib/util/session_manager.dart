import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/login_data.dart';
import 'package:tulip_app/model/tour_plan_model/daily_plan_report_model.dart';
import 'package:tulip_app/repo/tour_repo.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';

class SessionManager {
  static const String userLogin = 'is_user_login';
  static const String optCookies = 'is_cookie';
  static const appLaunchFirstTime = "PREFERENCES_IS_FIRST_LAUNCH_STRING";
  static const String USER_DATA_INFO = "user_data_info";
  static const String UserId = "userId";
  static const String stopTourPlanNow = "StopTourPlanNow";
  static const String journeyStarted = "started";
  static const String storedTourPlanID = "activePlanId";
  static const String timeInterval = "timeInterval";
  static String? userDesignation;
  static const String OFFLINE_LOCATIONS_KEY = "offlineLocations";

  static Future<bool> isUserLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(userLogin) ?? false;
  }

  static Future<bool> saveUserLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(userLogin, true);
    return true;
  }

  static Future<void> saveCookie(Map<String, dynamic> headers) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (headers.containsKey('set-cookie')) {
      final setCookieValue = headers['set-cookie'];
      // If the "set-cookie" header is a list, you may want to join the values into a single string.
      final userCookie =
          setCookieValue is List ? setCookieValue.join('; ') : setCookieValue;

      await pref.setString(optCookies, userCookie);
    }
  }

  static Future<String> getCookie() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String optCookiesId = pref.getString(optCookies) ?? "";
    return optCookiesId;
  }

  static Future<String> isJourneyStarted() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String planId = pref.getString(journeyStarted) ?? "";
    return planId;
  }

  static Future<void> saveJourneyStarted(String tourPlanId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(journeyStarted, tourPlanId);
  }

  static Future<void> clearJourneyStarted() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(journeyStarted);
  }

  static Future<void> saveUserData(UserDetails userData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final userJson = jsonEncode(userData.toJson());
    userDesignation = userData.userDesignation;
    print("User Designation : $userDesignation");
    await sharedPreferences.setString(USER_DATA_INFO, userJson);
  }

  static Future<UserDetails> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap =
        json.decode(prefs.getString(USER_DATA_INFO) ?? '');
    UserDetails userDataInfo = UserDetails.fromJson(userMap);
    return userDataInfo;
  }

  //set user login -  userid
  static Future<void> saveUserId(String userid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(UserId, userid);
  }

  static Future<bool> syncTourPlan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(stopTourPlanNow) ?? false;
  }

  static Future<void> saveTourPlanStop() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(stopTourPlanNow, true);
  }

  static Future<void> saveTimeInterval(String time) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(timeInterval, time);
  }

  static Future<String> getTimeInterval() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String time = pref.getString(timeInterval) ?? "";
    return time;
  }

  //get user login - userid
  static Future<String> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString(UserId) ?? "";
    return userId;
  }

  static Future<void> storeLocationOffline(
      String latitude, String longitude, String address, String status, SharedPreferences prefs) async {
    
    List<String> locations = prefs.getStringList(OFFLINE_LOCATIONS_KEY) ?? [];
    List<String> locations2 = prefs.getStringList("locations2") ?? [];
    print("location pehle are: $locations");
    Map<String, dynamic> locationData = {
      "type": "Point",
      "status": status, // Replace with your status value
      "address": address,
      "coordinates": [latitude, longitude]
    };
    locations.add(json.encode(locationData));
    locations2.add(json.encode(locationData));
    print("locations are now: ${locations.length}");
    await prefs.setStringList(OFFLINE_LOCATIONS_KEY, locations);
    await prefs.setStringList("locatoins2", locations2);
  }

  static Future<void> sendAndClearLocations(
      String tourPlanId, String currentStatus, BuildContext context, SharedPreferences prefs) async {
    List<String> storedLocations2 =
        prefs.getStringList("locations2") ?? [];
    print("iiiiiiiiiiiiiiiiiiiiiiiiii");
    print(storedLocations2.length);
    print("iiiiiiiiiiiiiiiiiiiiiiiiii");

    // Check if there are any stored locations
    if (storedLocations2.isNotEmpty) {
      // Prepare a list of locations to be sent
      List<Map<String, dynamic>> locationsToSend = [];

      for (String locationJson in storedLocations2) {
        print("Stored data value is this $locationJson");
        Map<String, dynamic> locationMap = json.decode(locationJson);
        locationsToSend.add(locationMap);
      }
      print("ye api me ja rahi hai: $locationsToSend");
      // Construct the body with the tourPlanVisitId and the array of geoLocations
      Map<String, dynamic> body = {
        "tourPlanVisitId": tourPlanId,
        "geoLocation": locationsToSend,
      };
      // Check for internet connection
      if (await InternetUtil.isInternetConnected()) {
        try {
          ProgressDialog.showProgressDialog(context);
          var response = await TourMasterRepo.updateTourPlanStatus(body);
          if (response.status) {
            Get.back();
            // Here, you can send the data to the API using the `body` map
            print("Completed location tracked data ${jsonEncode(body)}");
            // Clear the stored locations after sending them
            await prefs.remove(OFFLINE_LOCATIONS_KEY);
          } else {
            Get.back();
            context.showSnackBar("Something went wrong", null);
          }
        } catch (e) {
          Get.back();
          print("Error inside Session manager$e");
        }
      } else {
        context.showSnackBar("No Internet Connection", null);
      }
    }
  }
   


  static Future<void> storeTourPlanId(TourPlan tourPlan, SharedPreferences prefs) async {
    
    final tourJson = jsonEncode(tourPlan.toJson());
    await prefs.setString(storedTourPlanID, tourJson);
    print("-------------------");
    print(prefs.get(storedTourPlanID));
    print("-------------------");
  }

  static Future<TourPlan?> getTourPlanId(SharedPreferences pref) async {
    
    String? storedJson = pref.getString(storedTourPlanID);

    if (storedJson != null && storedJson.isNotEmpty) {
      Map<String, dynamic> userMap = json.decode(storedJson);
      TourPlan tourPlanInfo = TourPlan.fromJson(userMap);
      return tourPlanInfo;
    } else {
      return null; // or return a default TourPlan object, or handle it based on your use case
    }
  }

  static Future<void> userLogout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    FirebaseMessaging.instance.subscribeToTopic("all");
    await sharedPreferences.clear();
  }
}
