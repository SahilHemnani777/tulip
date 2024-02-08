import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tulip_app/constant/constant.dart';

enum NotificationType {
  NORMAL_NOTIFICATION,
  SCHEDULED_NOTIFICATION_1,
  SCHEDULED_NOTIFICATION_2,
  PICUTRE_NOTIFICATION,
  MEDIA_NOTIFICATION,
}

class EnumValues<T> {
  Map<int, T> map;
  Map<T, int> reverseMap = {};

  EnumValues(this.map);

  Map<T, int> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

final notificationTypeValues = EnumValues({
  0: NotificationType.NORMAL_NOTIFICATION,
  1: NotificationType.SCHEDULED_NOTIFICATION_1,
  2: NotificationType.SCHEDULED_NOTIFICATION_2,
  3: NotificationType.PICUTRE_NOTIFICATION,
  4: NotificationType.MEDIA_NOTIFICATION,
});

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      channelId, channelTitle,
      channelDescription: 'description', priority: Priority.high, importance: Importance.high);

  final DarwinNotificationDetails iosNotificationDetails = const DarwinNotificationDetails();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  //Constants Start
  static const channelId = "2912";
  static const channelTitle = 'Tulip';
  static const channelDescription = 'Notification util for easy notifications';
  static const channelIcon = 'ic_notication';
  //Constants End


  Future<void> createChannel(
      AndroidNotificationChannel notificationChannel) async {
    return await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(notificationChannel);
  }

  Future<void> init(
      {required Function(NotificationResponse) onSelectNotification,
        required Function(String) notifyAppLaunch}) async {
    //Initialize Android and iOS related notifications settings
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings(channelIcon);
    DarwinInitializationSettings initializationSettingsIOs = const DarwinInitializationSettings();
    InitializationSettings initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
    (await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails())!;

    if (Platform.isIOS) {
      iOSSpecificPermissions();
    }

    // Initialized Time Zones for scheduling notifications
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    //Finally Initialize Notifications Plugin
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onDidReceiveNotificationResponse: onSelectNotification);

    //Callback for app launch from notification
    // notifyAppLaunch(notificationAppLaunchDetails.notificationResponse!.payload!);
  }

  iOSSpecificPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  showNotification({required String title, required String body, required String payload}) async {
    var platform =
    NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        notificationTypeValues.reverse[NotificationType.NORMAL_NOTIFICATION]!,
        title,
        body,
        platform,
        payload: payload);
  }

  Future<void> scheduleNotification(
      {required Duration duration,
        required String body,
        required String payload,
        required NotificationType type,
        String? channelTitle
      }) async {
    var scheduledNotificationDateTime = tz.TZDateTime.now(tz.local).add(duration);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelTitle ?? NotificationService.channelTitle,
      channelDescription: channelDescription,
      icon: channelIcon,
      largeIcon: const DrawableResourceAndroidBitmap(channelIcon),
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationTypeValues.reverse[type]!,
      channelTitle,
      body,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
    debugPrint(
        'SCHEDULED NOTIFICATION AT ${scheduledNotificationDateTime.hour}:${scheduledNotificationDateTime.minute}:${scheduledNotificationDateTime.second}');
  }

  Future<void> showBigPictureNotification({required String body, required String payload}) async {
    var bigPictureStyleInformation = BigPictureStyleInformation(
        const DrawableResourceAndroidBitmap(channelIcon),
        largeIcon: const DrawableResourceAndroidBitmap(channelIcon),
        contentTitle: channelTitle,
        htmlFormatContentTitle: true,
        summaryText: body,
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription: channelDescription,
      styleInformation: bigPictureStyleInformation,
    );

    var iOSPlatfromChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatfromChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notificationTypeValues.reverse[NotificationType.PICUTRE_NOTIFICATION]!,
      channelTitle,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> showNotificationMediaStyle(String body) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription: channelDescription,
      color: Constants.primaryColor,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap(channelIcon),
      styleInformation: MediaStyleInformation(),
    );

    var iOSPlatfromChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatfromChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      notificationTypeValues.reverse[NotificationType.MEDIA_NOTIFICATION]!,
      channelTitle,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> cancelNotification(List<NotificationType> types) async {
    for (var element in types) {
      await flutterLocalNotificationsPlugin.cancel(notificationTypeValues.reverse[element]!);
      debugPrint('CANCELLED NOTIFICATION: $element');
    }
  }
}
