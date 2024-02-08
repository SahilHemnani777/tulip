import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tulip_app/ui_designs/login_pages/login_page.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/notifications_util.dart';

import 'session_manager.dart';

class LocationController extends GetxController{
  RxString latitude = "".obs;
  RxString longitude = "".obs;
  RxString currentAddress = "".obs;



  Future<void> getLocation(BuildContext context) async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw ('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always) {
        // Location permission is already granted, proceed with obtaining location
      } else {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Location permissions are denied
          throw ('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, show a dialog and request permissions again
          await showPermissionDialog(context);
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.deniedForever) {
            // Permissions are still denied forever, logout the user
            await SessionManager.userLogout();
            context.pushAndRemoveUntil(const LoginPage());
            return;
          }
        } else if (permission == LocationPermission.whileInUse) {
          // Permissions are while in use, show a dialog and request permissions again
          await showPermissionDialog(context);
          permission = await Geolocator.requestPermission();
          if (permission != LocationPermission.always) {
            // If the permission is not 'Always', logout the user
            await SessionManager.userLogout();
            context.pushAndRemoveUntil(const LoginPage());
            return;
          }
        } else {
          // Unexpected state, handle appropriately
          throw ('Unexpected location permission state.');
        }
      }

      // Proceed with obtaining the location
      final Position position = await Geolocator.getCurrentPosition();

      latitude.value = position.latitude.toString();
      longitude.value = position.longitude.toString();
      print("Location details : $latitude $longitude");

      final placemarks = await placemarkFromCoordinates(
        double.parse(latitude.value),
        double.parse(longitude.value),
      );

      String postalCode = 'N/A';
      String name = 'N/A';
      String subAdministrativeArea = 'N/A';

      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        postalCode = placemark.postalCode ?? postalCode;
        name = placemark.name ?? name;
        subAdministrativeArea = placemark.subAdministrativeArea ?? subAdministrativeArea;
      }
      currentAddress.value = ' $name, $subAdministrativeArea - $postalCode';
    } catch (e) {
      print("Error obtaining location: $e");
      // Handle errors or show appropriate messages to the user
    }
  }

  Future<void> showPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text('Please grant location permission to use the app.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // Future<void> showPermissionDialog(BuildContext context) async {
  //   var result = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) =>
  //         AlertDialog(
  //           title: const Text('Location Permission Required'),
  //           content: const Text(
  //               'This app needs location permission to function. Please enable it in the app settings and login again.'),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('Okay'),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 await SessionManager.userLogout();
  //                 context.pushAndRemoveUntil(const LoginPage());
  //               },
  //             ),
  //           ],
  //         ),
  //   );
  //   // if(result == null){
  //   //   await SessionManager.userLogout();
  //   //   context.pushAndRemoveUntil(const LoginPage());
  //   // }
  //   print("Here what is 1 $result");
  //   if(result!=null && result){
  //     context.pop();
  //     ///TODO next step if permission granted
  //   }else{
  //     await SessionManager.userLogout();
  //     context.pushAndRemoveUntil(const LoginPage());
  //     context.showSnackBar("Locaiton Permission requied", null);
  //   }
  // }


}