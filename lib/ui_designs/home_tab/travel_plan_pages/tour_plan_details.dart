import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/add_tour_plan_dialog.dart';
import 'package:tulip_app/dialog/common_alert_dialog.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/repo/tour_repo.dart';
import 'package:tulip_app/tool/background_service.dart';
import 'package:tulip_app/ui_designs/home_tab/menu_pages/dashboard_page.dart';
import 'package:tulip_app/ui_designs/home_tab/travel_plan_pages/add_deviation.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/location_controller.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';

import '../../../model/tour_plan_model/daily_plan_report_model.dart';

class TourPlanDetailsPage extends StatefulWidget {
  final List<TourPlan> tourPlanList;
  final String tourPlanId;
  final DateTime date;
  final String status;
  const TourPlanDetailsPage(
      {Key? key,
      required this.tourPlanList,
      required this.date,
      required this.tourPlanId,
      required this.status})
      : super(key: key);

  @override
  TourPlanDetailsPageState createState() => TourPlanDetailsPageState();
}

class TourPlanDetailsPageState extends State<TourPlanDetailsPage> {
  SharedPreferences? sp;
  List<TourPlan> tourPlan = [];
  bool isEdit = false;
  Timer? locationUpdateTimer; // Declare a Timer variable

  bool isPlanActive = false;
  String? currentAddress;
  LocationController locationController = Get.find();
  late BackgroundService backgroundService;

  @override
  void initState() {
    instantiateSharedPrefference();
    super.initState();
    backgroundService = BackgroundService();
    checkTourPlanActive();
    tourPlan = widget.tourPlanList;
    locationController.getLocation(context);
  }

  instantiateSharedPrefference() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        sp = value;
      });
    });
  }

  Future<void> checkTourPlanActive() async {
    TourPlan? planId = await SessionManager.getTourPlanId(sp!);
    if (planId != null) {
      isPlanActive = true;
    } else {
      isPlanActive = false;
    }
    setState(() {});
  }

  Future<void> _startPeriodicTask(TourPlan tourPlan) async {
    // Store tourPlanId in SharedPreferences
    await backgroundService.initializeService(); // it will keep app start
    //Set service as foreground.(Notification will available till the service end)
    // backgroundService.setServiceAsForeGround(); //
    await backgroundService.initializeService(); //

    
    SessionManager.storeTourPlanId(tourPlan, sp!);
    sp!.remove("offlineLocations");
    sp!.remove("locations2");
  }

  Future<void> _stopPeriodicTask(String currentStatus) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    TourPlan? tourPlanId = await SessionManager.getTourPlanId(sp!);
    // Get the latest location details
    locationController.getLocation(context);
    // Store the latest location with the current status
    await SessionManager.storeLocationOffline(
      locationController.latitude.value,
      locationController.longitude.value,
      locationController.currentAddress.value,
      currentStatus, // Pass the current status here
      sp!
    );
    // Map<String, dynamic> locationData = {
    //   "type": "Point",
    //   "status": currentStatus, // Replace with your status value
    //   "address": locationController.currentAddress.value,
    //   "coordinates": [
    //     locationController.latitude.value,
    //     locationController.longitude.value
    //   ]
    // };
    // print("Last Location Data${locationData}");
    // Send and clear locations with the latest location and status
    if (tourPlanId?.id != null && tourPlanId!.id!.isNotEmpty) {
      await SessionManager.sendAndClearLocations(
          tourPlanId.id!, currentStatus, context, sp!);
      // await SessionManager.sendAndClearLocations2(
      //     tourPlanId.id!, currentStatus, context, locationData);
      if (currentStatus == "Ended") {
        prefs.remove("activePlanId");
        prefs.remove("StopTourPlanNow");
      }
      checkTourPlanActive();
    } else {
      context.showSnackBar(
          "TourPlan plan data not found, Kindly check if started on other device.",
          null);
    }
    backgroundService.stopService();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isEdit) {
          Get.back(result: [widget.tourPlanId, widget.date]);
          return true;
        }
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Tour Plan for ${DateUtil.getDisplayFormatDate(widget.date)}",
          implyStatus: true,
        ),
        body: tourPlan.isNotEmpty
            ? ListView.builder(
                itemCount: tourPlan.length,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                itemBuilder: (context, index) {
                  return tourPlanListWidget(tourPlan[index]);
                })
            : const Center(
                child: Text(
                  "No data found",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
        floatingActionButton: widget.status != "Approved"
            ? GestureDetector(
                onTap: () async {
                  var result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AddTourPlanDialog(
                          canEdit: false,
                          date: widget.date,
                          tourPlanId: widget.tourPlanId,
                          status: widget.status,
                        );
                      });

                  if (result != null) {
                    getTourPlanData(result[0], result[1]);
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15))),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.add, color: Colors.white, size: 35),
                ),
              )
            : null,
      ),
    );
  }

  Widget tourFieldWidget(
          String title,
          String details,
          bool isEditable,
          Function()? onTap,
          Function()? editTap,
          bool? isDeviation,
          String? status,
          Function()? addDeviation) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              "$title : ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(details)),
          if (isEditable && widget.status != "Approved" && isDeviation == false)
            GestureDetector(
              onTap: onTap,
              child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(7)),
                  child: Icon(
                    Icons.delete,
                    size: 18,
                    color: Constants.white,
                  )),
            ),
          if (isEditable && widget.status != "Approved")
            GestureDetector(
              onTap: editTap,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7)),
                  child: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.white,
                  )),
            ),
          if (isEditable &&
              widget.status == "Approved" &&
              isDeviation == false &&
              status != "Ended" &&
              status != "Paused" &&
              status != "Resumed" &&
              status != "Started")
            GestureDetector(
              onTap: addDeviation,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7)),
                  child: const Text(
                    "Add Deviation",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )),
            ),
        ],
      );

  Widget tourPlanListWidget(TourPlan tourPlanData) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tourFieldWidget(
                "Activity Type",
                tourPlanData.activityType?.activityTypeName ?? "",
                true,
                () async {
                  var result = await showDialog(
                      context: context,
                      builder: (context) {
                        return const CommonDialog(
                          title: 'Alert',
                          message: 'Are you sure you want to delete this plan?',
                          positiveButtonText: 'Yes',
                          negativeButtonText: 'No',
                        );
                      });
                  if (result) {
                    deleteTourPlan(tourPlanData.id!, tourPlanData.tourPlanId!);
                  }
                },
                () async {
                  var result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AddTourPlanDialog(
                          canEdit: true,
                          date: widget.date,
                          tourPlanId: widget.tourPlanId,
                          tourPlan: tourPlanData,
                          status: widget.status,
                        );
                      });
                  if (result != null) {
                    getTourPlanData(result[0], result[1]);
                  }
                },
                tourPlanData.isDeviation,
                tourPlanData.status,
                () async {
                  var result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AddDeviation(
                          date: widget.date,
                          tourPlanId: widget.tourPlanId,
                          status: widget.status,
                          id: tourPlanData.id!,
                        );
                      });
                  if (result != null) {
                    getTourPlanData(result[0], result[1]);
                  }
                }),
            tourFieldWidget("Area", tourPlanData.area?.townName ?? "", false,
                () {}, () {}, null, null, () {}),
            if (tourPlanData.note != null && tourPlanData.note!.isNotEmpty)
              tourFieldWidget("Comment", tourPlanData.note ?? "", false, () {},
                  () {}, null, null, () {}),
            if (tourPlanData.deviatedVisitId?.area?.townName != null)
              Align(
                alignment: Alignment.center,
                child: Text(
                  tourPlanData.isDeviation
                      ? "Deviation: To ${tourPlanData.deviatedVisitId?.area?.townName}"
                      : "Deviation: From ${tourPlanData.deviatedVisitId?.area?.townName ?? ""}",
                  style: const TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            if (widget.status == "Approved" && !tourPlanData.isDeviation)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!isPlanActive && tourPlanData.status == "Created")
                    GestureDetector(
                        onTap: isSameDate(widget.date, DateTime.now())
                            ? () async {
                                if (tourPlanData.status == "Created") {
                                  locationController.getLocation(context);
                                  print(
                                      locationController.getLocation(context));
                                  await updateTourPlanStatus(tourPlanData.id!,
                                      "Started", tourPlanData.tourPlanId!);
                                  _startPeriodicTask(tourPlanData);
                                  isPlanActive = true;
                                  setState(() {});
                                }
                              }
                            : null,
                        child: startEndButtonWidget(
                            tourPlanData.status == "Created"
                                ? "Start Tour Plan"
                                : tourPlanData.status == "Started"
                                    ? "Pause Tour Plan"
                                    : tourPlanData.status == "Paused"
                                        ? "Resume Tour Plan"
                                        : "Pause Tour Plan",
                            tourPlanData.status == "Created"
                                ? Colors.green
                                : tourPlanData.status == "Started"
                                    ? Colors.blue
                                    : tourPlanData.status == "Paused"
                                        ? Colors.orange
                                        : Colors.blue,
                            tourPlanData.status!)),
                  if (tourPlanData.status == "Started" ||
                      tourPlanData.status == "Paused" ||
                      tourPlanData.status == "Resumed" &&
                          tourPlanData.status != "Ended")
                    GestureDetector(
                        onTap: () async {
                          if (tourPlanData.status == "Created") {
                            locationController.getLocation(context);
                            await updateTourPlanStatus(tourPlanData.id!,
                                "Started", tourPlanData.tourPlanId!);
                            await _startPeriodicTask(tourPlanData);
                          } else if (tourPlanData.status == "Started") {
                            await _stopPeriodicTask("Paused");
                            getTourPlanData(
                                tourPlanData.tourPlanId!, widget.date);
                          } else if (tourPlanData.status == "Paused") {
                            await updateTourPlanStatus(tourPlanData.id!,
                                "Resumed", tourPlanData.tourPlanId!);
                            await _startPeriodicTask(tourPlanData);
                          } else if (tourPlanData.status == "Resumed") {
                            await _stopPeriodicTask("Paused");
                            getTourPlanData(
                                tourPlanData.tourPlanId!, widget.date);
                          }
                        },
                        child: startEndButtonWidget(
                            tourPlanData.status == "Created"
                                ? "Start Tour Plan"
                                : tourPlanData.status == "Started"
                                    ? "Pause Tour Plan"
                                    : tourPlanData.status == "Paused"
                                        ? "Resume Tour Plan"
                                        : "Pause Tour Plan",
                            tourPlanData.status == "Created"
                                ? Colors.green
                                : tourPlanData.status == "Started"
                                    ? Colors.blue
                                    : tourPlanData.status == "Paused"
                                        ? Colors.orange
                                        : Colors.blue,
                            tourPlanData.status!)),
                  if (tourPlanData.status == "Started" ||
                      tourPlanData.status == "Paused" ||
                      tourPlanData.status == "Resumed")
                    GestureDetector(
                        onTap: () async {
                          if (await InternetUtil.isInternetConnected()) {
                            await _stopPeriodicTask("Ended");
                            getTourPlanData(
                                tourPlanData.tourPlanId!, widget.date);
                          } else {
                            await backgroundService.initializeService();
                            backgroundService.stopService();
                            SessionManager.saveTourPlanStop();
                            await locationController.getLocation(context);
                            SessionManager.storeLocationOffline(
                                locationController.latitude.value,
                                locationController.longitude.value,
                                locationController.currentAddress.value,
                                "Ended", sp!);
                            Get.off(const DashBoardPage());
                          }
                        },
                        child: startEndButtonWidget("End Tour Plan",
                            Constants.primaryColor, tourPlanData.status!)),
                  if (tourPlanData.status == "Ended")
                    startEndButtonWidget(
                        "Completed", Colors.green, tourPlanData.status!)
                ],
              ),
            const Divider(
              color: Colors.black,
            )
          ],
        ),
      );
  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget startEndButtonWidget(String title, Color color, String status) =>
      Container(
        margin: EdgeInsets.symmetric(vertical: 0.6.h),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.6.h),
        decoration: BoxDecoration(
            color: (status == "Ended") ||
                    ((status == "Created") &&
                        !isSameDate(widget.date, DateTime.now()))
                ? Colors.grey
                : color,
            borderRadius: BorderRadius.circular(6)),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      );

  Future<void> deleteTourPlan(String id, String tourId) async {
    if (await InternetUtil.isInternetConnected()) {
      try {
        ProgressDialog.showProgressDialog(context);
        var response = await TourMasterRepo.deleteData(id);
        if (response.status) {
          Get.back();
          getTourPlanData(tourId, widget.date);
          context.showSnackBar("TourPlan deleted", null);
        } else {
          Get.back();
          context.showSnackBar(response.message!, null);
        }
      } catch (e) {
        context.showSnackBar("Something went wrong", null);
      }
    }
  }

  Future<void> getTourPlanData(String tourPlanId, DateTime date) async {
    var response =
        await TourMasterRepo.getTourPlanListByUserId(tourPlanId, date);
    try {
      if (response.status) {
        if (response.data != null) {
          setState(() {
            isEdit = true;
            tourPlan.clear();
            print("Tour Plan data list : ${response.data}");
            tourPlan = response.data!;
          });
        } else {
          isEdit = true;
          tourPlan.clear();
          setState(() {});
        }
      }
    } catch (e) {
      print("Error : $e");
    }
  }

  Future<void> updateTourPlanStatus(
      String id, String status, String tourPlanId) async {
    if (await InternetUtil.isInternetConnected()) {
      try {
        Map<String, dynamic> body = {
          "tourPlanVisitId": id,
          "geoLocation": [
            {
              "type": "Point",
              "status": status,
              "address": locationController.currentAddress.value,
              "coordinates": [
                locationController.latitude.value,
                locationController.longitude.value
              ]
            }
          ]
        };
        print("-------------------");
        print(body);
        print("-------------------");
        ProgressDialog.showProgressDialog(context);
        var response = await TourMasterRepo.updateTourPlanStatus(body);
        print("-------------------");
        print(response);
        print("-------------------");
        if (response.status) {
          Get.back();
          getTourPlanData(tourPlanId, widget.date);
        }
      } catch (e) {
        print("Error $e");
      }
    } else {
      context.showSnackBar("No Internet Connection", null);
    }
  }
}
