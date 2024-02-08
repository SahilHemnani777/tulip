import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/common_alert_dialog.dart';
import 'package:tulip_app/main.dart';
import 'package:tulip_app/model/expense_model/setting_model.dart';
import 'package:tulip_app/model/login_data.dart';
import 'package:tulip_app/model/tour_plan_model/daily_plan_report_model.dart';
import 'package:tulip_app/repo/expense_repo.dart';
import 'package:tulip_app/repo/login_master.dart';
import 'package:tulip_app/tool/background_service.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/customer_list_page.dart';
import 'package:tulip_app/ui_designs/home_tab/distribution_ui/distirbution_list_page.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/lead_details_page.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/lead_list.dart';
import 'package:tulip_app/ui_designs/home_tab/menu_pages/menu_page.dart';
import 'package:tulip_app/ui_designs/home_tab/travel_plan_pages/travel_plan_list_page.dart';
import 'package:tulip_app/ui_designs/login_pages/login_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/location_controller.dart';
import 'package:tulip_app/util/notifications_util.dart';
import 'package:tulip_app/util/open_url.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/fetch_location_message.dart';
import 'package:tulip_app/widget/no_internet_widget.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  DashBoardPageState createState() => DashBoardPageState();
}

class DashBoardPageState extends State<DashBoardPage> {
  final List<Map<String, String>> dashboardItems = [
    {
      'name': 'Customers',
      'imagePath': 'assets/dashboard/customer_icon.png',
      'route': '/customers'
    },
    {
      'name': 'Lead',
      'imagePath': 'assets/dashboard/lead_icon.png',
      'route': "/lead_list"
    },
    {
      'name': 'Tour Plan',
      'imagePath': 'assets/dashboard/travel_icon.png',
      'route': '/travel_list'
    },
    {
      'name': 'DCR',
      'imagePath': 'assets/dashboard/travel_icon.png',
      'route': '/dcr'
    },
    {
      'name': 'My Expense',
      'imagePath': 'assets/dashboard/expense_icon.png',
      'route': '/expense_list'
    },
    {
      'name': 'Product Catalogue',
      'imagePath': 'assets/dashboard/product_icon.png',
      'route': '/product_list'
    },
    {
      'name': 'Distributor Stock Management',
      'imagePath': 'assets/dashboard/complaint_icon.png',
      'route': '/distributor'
    },
    {
      'name': 'My Profile',
      'imagePath': 'assets/menu_icons/profile_icon.png',
      'route': '/profile_page'
    },
    // {'name': 'Contact Us', 'imagePath': 'assets/dashboard/contact_us_icon.png','route' : '/travel_list'},
  ];
  DateTime _preBackpress = DateTime.now();
  UserDetails? userDetails;
  bool _notificationFlag = false;
  PackageInfo? packageInfo;
  LocationController locationController = Get.find();
  SettingDetails? settingDetails;
  bool _isInternetConnected = true;
  StreamSubscription? _subscription;
  late BackgroundService backgroundService;
  bool syncData = false;
  TourPlan? tourPlanId;
  @override
  void initState() {
    super.initState();
    backgroundService = BackgroundService();
    _addInternetConnectionListener();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timeGap = DateTime.now().difference(_preBackpress);
        final cantExit = timeGap >= const Duration(seconds: 2);
        _preBackpress = DateTime.now();
        if (cantExit) {
          context.showSnackBar(
              "Press Back button again to Exit", Constants.primaryColor);
          return false; // false will do nothing when back press
        } else {
          return true; // true will exit the app
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Dashboard',
          showBackButton: false,
          actions: [
            GestureDetector(
              onTap: () async {
                var result = await showDialog(
                    context: context,
                    builder: (context) {
                      return const CommonDialog(
                        title: 'Alert',
                        message: 'Are you sure you want to logout?',
                        positiveButtonText: 'Yes',
                        negativeButtonText: 'No',
                      );
                    });
                if (result != null && result) {
                  TourPlan? planId = await SessionManager.getTourPlanId(await SharedPreferences.getInstance());
                  if (planId == null) {
                    await SessionManager.userLogout();
                    context.pushAndRemoveUntil(const LoginPage());
                  } else {
                    // Get.back();
                    context.showSnackBar(
                        "Please end the ongoing tour plan to logout", null);
                  }
                }
              },
              child: Image.asset(
                "assets/menu_icons/logout_icon.png",
                height: 30,
                width: 30,
                color: Constants.white,
              ),
            ),
            SizedBox(width: 3.w),
          ],
        ),
        body: _isInternetConnected
            ? Obx(
                () => locationController.longitude.value.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3.h,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xffC3C3C3)
                                            .withOpacity(0.25),
                                        offset: const Offset(0, 4),
                                        spreadRadius: 0,
                                        blurRadius: 4)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Welcome,",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  userDetails != null
                                      ? Text(
                                          "${userDetails?.userName}  (${userDetails?.employeeId})",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator
                                              .adaptive(),
                                        ),
                                  const Divider(color: Colors.grey),
                                  const Text(
                                    "Your Current Location (Auto-detected)",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Constants.primaryColor,
                                        size: 18,
                                      ),
                                      Expanded(
                                        child: Text(
                                          locationController
                                              .currentAddress.value,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            GridView.builder(
                                shrinkWrap: true,
                                itemCount: dashboardItems.length,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 0.98,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemBuilder: (context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // Navigator.pushNamed(context, dashboardItems[index]['route']!,);
                                      if (locationController
                                              .latitude.value.isNotEmpty &&
                                          locationController
                                              .longitude.value.isNotEmpty) {
                                        // Determine which page to navigate to based on the route name
                                        switch (dashboardItems[index]
                                            ['route']) {
                                          case '/lead_list':
                                            // Navigate to LeadListPage with parameters
                                            //   print("Latitude: ${locationController.latitude}");
                                            //   print("Longitude: $longitude");

                                            Get.to(() => const LeadListPage());
                                            break;
                                          case '/customers':
                                            // Navigate to CustomerListPage with parameters
                                            Get.to(
                                                () => const CustomerListPage());
                                            break;
                                          case '/travel_list':
                                            // Navigate to TravelPlanListPage with parameters
                                            Get.to(() => TravelPlanListPage(
                                                  latitude: locationController
                                                      .latitude.value,
                                                  longitude: locationController
                                                      .longitude.value,
                                                ));
                                            break;

                                          case '/profile_page':
                                            // Navigate to TravelPlanListPage with parameters
                                            Get.to(() => const MyProfilePage());
                                            break;

                                          case '/distributor':
                                            // Navigate to TravelPlanListPage with parameters
                                            Get.to(() =>
                                                const DistributionListPage());
                                            break;
                                          // Add cases for other routes as needed
                                          // ...
                                          default:
                                            // Handle unknown route
                                            Get.toNamed(dashboardItems[index]
                                                ['route']!);
                                            break;
                                        }
                                      } else {
                                        // Handle the case when location is not available
                                        Get.snackbar(
                                          "Location Error",
                                          "Location not available",
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                        getLocation();
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Constants.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color:
                                                        const Color(0xffC3C3C3)
                                                            .withOpacity(0.25),
                                                    blurRadius: 3,
                                                    spreadRadius: 0,
                                                    offset: const Offset(0, 1)),
                                                BoxShadow(
                                                    color:
                                                        const Color(0xffC3C3C3)
                                                            .withOpacity(0.25),
                                                    blurRadius: 3,
                                                    spreadRadius: 0,
                                                    offset:
                                                        const Offset(0, -1)),
                                              ]),
                                          child: Image.asset(
                                            dashboardItems[index]['imagePath']!,
                                            height: 35,
                                            width: 35,
                                            color: Constants.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          dashboardItems[index]['name']!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                            const Spacer(),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                        "App Version : ${packageInfo?.version ?? ""}"),
                                    const Spacer(),
                                    if (Constants.baseUrl !=
                                        "https://admin.tulipdiagnostics.in/")
                                      const Icon(Icons.circle,
                                          color: Colors.red, size: 10)
                                  ],
                                )),
                            SizedBox(height: 1.h),
                          ],
                        ),
                      )
                    : const FetchLocation(),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    const NoInternetWidget(),


                    Spacer(),
                    if(!syncData)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xffC3C3C3)
                                    .withOpacity(0.25),
                                offset: const Offset(0, 1),
                                spreadRadius: 0,
                                blurRadius: 4)
                          ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            const Text("On Going Tour Plan",style: TextStyle(
                              fontSize: 16,fontWeight: FontWeight.w600,
                              color: Constants.primaryColor
                            ),),


                            SizedBox(height: 1.h),
                            tourFieldWidget("Activity Type",tourPlanId?.activityType?.activityTypeName ?? ""),
                            tourFieldWidget("Area",tourPlanId?.area?.townName ?? ""),
                            if(tourPlanId?.note !=null)
                            tourFieldWidget("Comments",tourPlanId?.note ?? ""),


                            GestureDetector(
                              onTap: () async {
                                await backgroundService.initializeService();
                                backgroundService.stopService();
                                SessionManager.saveTourPlanStop();
                                await locationController.getLocation(context);
                                SessionManager.storeLocationOffline(
                                    locationController.latitude.value,
                                    locationController.longitude.value,
                                    locationController.currentAddress.value,
                                    "Ended",await SharedPreferences.getInstance());
                                syncData = await SessionManager.syncTourPlan();

                                setState(() {});

                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 0.6.h),
                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.6.h),
                                decoration: BoxDecoration(
                                    color: Constants.primaryColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: const Text(
                                  "End Tour Plan",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),


                  ],
                ),
              ),
      ),
    );
  }
  Widget tourFieldWidget(String title, String details) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              "$title : ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(details)),

        ],
      );



  Future<void> autoUpdate() async {
    print("version is checking object${packageInfo?.buildNumber}");
    print("object${settingDetails?.forceUpdateVersion}");
    print("object${settingDetails?.forceUpdateVersion != packageInfo?.buildNumber}");

    if (int.parse(settingDetails?.forceUpdateVersion ?? "0") > int.parse(packageInfo?.buildNumber ?? "0")) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async =>
              false, // Make it not closable by pressing the back button
          child: AlertDialog(
            title: const Text('New Update Available'),
            content: const Text(
                'A new version is available. Please update to latest version to proceed.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Update'),
                onPressed: () async {
                  OpenUrl.launchUpdateAddress(
                      settingDetails?.forceUpdateUrl ?? "");
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> getUserData() async {
    var response = await LoginMaster.getUserInfo();
    if (response.status) {
      // TODO  save user data
      if (response.data != null) {
        if(response.data?.status == "InActive"){
          await SessionManager.userLogout();
          context.pushAndRemoveUntil(const LoginPage());
          setState(() {});
        }
        else{
        userDetails = response.data!;
        await SessionManager.saveUserData(response.data!);
        if (userDetails?.userAccess != null &&
            userDetails!.userAccess!.contains("enable-screen-capture")) {
        } else {
          await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
        }
        setState(() {});
        }
      } else {
        context.showSnackBar("Something went wrong", null);
      }
    } else {
      context.showSnackBar("${response.message}", null);
    }
  }

  Future<void> appRedirection(redirectString, String id) async {
    print('selectedPageIndex1 onMessageOpenedApp:133');
    switch (redirectString) {
      // case 'Breakdown':
      //   break;
      //
      // case "Job":
      //   break;
      case "FollowUp":
      Navigator.push(context, MaterialPageRoute(builder: (_) => LeadDetailsPage(leadId: id,fromCreatePage: true)));
    }
  }

  Future<void> getAppVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  Future<void> showPermissionDialog(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            'This app needs location permission to function. Please enable it in the app settings.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.of(context).pop(true);
              openAppSettings();
            },
          ),
        ],
      ),
    );
    // if(result == null){
    //   await SessionManager.userLogout();
    //   context.pushAndRemoveUntil(const LoginPage());
    // }
    var status = await Permission.location.status;
    if (status.isGranted) {
      ///TODO next step if permission granted
    } else {}
  }

  void getSettingDetails() async {
    String? fcm = await firebaseMessaging.getToken();
    print("Fcm token $fcm");

    var result = await ExpenseRepo.getSettingDetails();
    if (result.status) {
      settingDetails = result.data;
      SessionManager.saveTimeInterval(settingDetails!.trackingInterval.toString());
      // Assign settingDetails to expenseDetails (if needed)
      // Check stationTypeName and update totalAllowance accordingly
      autoUpdate();

      setState(() {});
    } else {
      context.showSnackBar("${result.message}", null);
    }
  }

  void _listenInternetConnection() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      // Got a new connectivity status!
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        _subscription?.cancel();

        Get.put(LocationController());
        getUserData();
        await getAppVersion();
        await _initPackageInfo();
        getSettingDetails();
        getLocation();
        Firebase.initializeApp();
        syncData = await SessionManager.syncTourPlan();
        syncEndedTourPlanData();

        // NotificationService().init(onSelectNotification: (val){
        //   List<String> payloadParts = val.payload!.split(',');
        //   String type = payloadParts[0];
        //   String id = payloadParts[1];
        //   appRedirection(type,id);
        // }, notifyAppLaunch: (val){
        // });
        //
        // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        //   if(message!=null){
        //     // appRedirection(message.data['type'],message.data["_id"]);
        //     NotificationService().showNotification(body: message.notification!.body!, payload: jsonEncode(message.data), title: message.notification!.title!);
        //   }
        // });
        //handle notification when app is background

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          if (message != null) {
            _notificationFlag = true;
            appRedirection(message.data['type'], message.data["_id"]);
          }
        });
        //handle notification when app is killed(But some devices it work)
        try {
          FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
            if (message != null) {
              _notificationFlag = true;
              appRedirection(message.data['type'], message.data["_id"]);
            }
          });
        } catch (e) {
          print("notification selectedPageIndex4 exception $e");
        }

        if (!_notificationFlag) {
          FirebaseMessaging.instance
              .getInitialMessage()
              .then((RemoteMessage? message) {
            if (message != null) {
              print(
                  "notification FirebaseMessaging.getInitialMessage5 $message");
              appRedirection(message.data['type'], message.data["_id"]);
            }
          });
        }

        setState(() {
          _isInternetConnected = true;
        });
      }
    });
  }

  void _addInternetConnectionListener() async {
    //if the internet is connected then make the api call
    if (!(await InternetUtil.isInternetConnected())) {
      _listenInternetConnection();
      tourPlanId = await SessionManager.getTourPlanId(await SharedPreferences.getInstance());
      syncData = await SessionManager.syncTourPlan();
      syncEndedTourPlanData();


      setState(() {
        _isInternetConnected = false;
      });
    } else {
      Get.put(LocationController());
      getUserData();
      await getAppVersion();
      await _initPackageInfo();
      getSettingDetails();
      getLocation();
      syncData = await SessionManager.syncTourPlan();
      syncEndedTourPlanData();

      Firebase.initializeApp();
      NotificationService().init(onSelectNotification: (val){
        print("notification selectedPageIndex in follow1");
        if(val.payload!.contains("FollowUp")){
          List<String> payloadParts = val.payload!.split(',');
          String type = payloadParts[0];
          String id = payloadParts[1];
          print("notification selectedPageIndex in follow2");
          appRedirection(type,id);
        }else{
          print("3notification selectedPageIndex in follow");
          Map<String, dynamic> payloadMap = jsonDecode(val.payload!);
          appRedirection(payloadMap['type'], payloadMap["_id"]);

        }
      }, notifyAppLaunch: (val){
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message != null) {
          _notificationFlag = true;
          appRedirection(message.data['type'], message.data["_id"]);
        }
      });
      //handle notification when app is killed(But some devices it work)
      try {
        FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
          if (message != null) {
            _notificationFlag = true;
            appRedirection(message.data['type'], message.data["_id"]);
          }
        });
      } catch (e) {
        print("notification selectedPageIndex4 exception $e");
      }

      if (!_notificationFlag) {
        FirebaseMessaging.instance
            .getInitialMessage()
            .then((RemoteMessage? message) {
          if (message != null) {
            print("notification FirebaseMessaging.getInitialMessage5 $message");
            appRedirection(message.data['type'], message.data["_id"]);
          }
        });
      }
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  void syncEndedTourPlanData()async {
    syncData = await SessionManager.syncTourPlan();
    print("Syncing data : $syncData");
    if(syncData){
      tourPlanId = await SessionManager.getTourPlanId(await SharedPreferences.getInstance());
      await SessionManager.sendAndClearLocations(
          tourPlanId!.id!, "Ended", context, await SharedPreferences.getInstance());
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sharedPreferences.remove("StopTourPlanNow");
      sharedPreferences.remove("activePlanId");
      print(tourPlanId);
      syncData = await SessionManager.syncTourPlan();
      setState(() {});
    }


  }

  Future<void> getLocation() async {
    await locationController.getLocation(context);
    setState(() {});
  }
}
