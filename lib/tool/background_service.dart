// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:tulip_app/util/notifications_util.dart';
import 'package:tulip_app/util/session_manager.dart';

const String notificationChannelId = "foreground_service";
const int foregroundServiceNotificationId = 888;
const String initialNotificationTitle = "Tour Plan Started";
const String initialNotificationContent = "";

// const int timeInterval = 30; //in seconds

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  String time = await SessionManager.getTimeInterval();

  DartPluginRegistrant.ensureInitialized();
  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  if (service is AndroidServiceInstance) {
    await service.setAsForegroundService();
    service.on('setAsForeground').listen((event) async {
      await service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) async {
      print("On started methods call 2");
      await service.setAsBackgroundService();
    });
  }

  service.on("stop_service").listen((event) async {
    await service.stopSelf();
  });

  
  Timer.periodic(Duration(minutes: int.parse(time)), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        final Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);

        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        String address = 'N/A';

        try {
          if (placemarks.isNotEmpty) {
            final placemark = placemarks[0];
            address =
                "${placemark.name ?? 'N/A'}, ${placemark.subAdministrativeArea ?? 'N/A'} - ${placemark.postalCode ?? 'N/A'}";
          }

          await SessionManager.storeLocationOffline(
              position.latitude.toString(), position.longitude.toString(), address, "Fetched");
        } catch (e) {
          // Handle the case where address information is not found
          await SessionManager.storeLocationOffline(position.latitude.toString(),
              position.longitude.toString(), 'Address not available', 'Fetched');
        }
      }
    }
  });
}

class BackgroundService {
  //Get instance for flutter background service plugin
  final FlutterBackgroundService flutterBackgroundService = FlutterBackgroundService();

  FlutterBackgroundService get instance => flutterBackgroundService;

  Future<void> initializeService() async {
    await NotificationService().createChannel(
        const AndroidNotificationChannel(notificationChannelId, notificationChannelId));
    await flutterBackgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,
        // auto start service
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId,
        foregroundServiceNotificationId: foregroundServiceNotificationId,
        initialNotificationTitle: initialNotificationTitle,
        initialNotificationContent: initialNotificationContent,
      ),
      //Currently IOS setup is not completed.
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,
        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,
      ),
    );
    await flutterBackgroundService.startService();
  }

  void setServiceAsForeGround() async {
    flutterBackgroundService.invoke("setAsForeground");
  }

  void stopService() {
    flutterBackgroundService.invoke("stop_service");
  }
}
