import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/add_leave_dialog.dart';
import 'package:tulip_app/dialog/add_tour_plan_dialog.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/tour_plan_model/daily_plan_report_model.dart';
import 'package:tulip_app/repo/tour_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/travel_plan_pages/tour_plan_details.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/no_data_found.dart';

class DailyTourPlanList extends StatefulWidget {
  final String tourPlanId;
  final String status;
  final DateTime tourPlanDate;
  const DailyTourPlanList(
      {Key? key,
      required this.tourPlanId,
      required this.tourPlanDate,
      required this.status})
      : super(key: key);

  @override
  DailyTourPlanListState createState() => DailyTourPlanListState();
}

class DailyTourPlanListState extends State<DailyTourPlanList> {
  late List<DateTime> dateList;
  List<DailyTourPlanListModel> dailyTourData = [];
  bool isLoading = true;
  bool isEdit = false;
  bool isSubmited = false;
  // List<TourPlanItem> tourData =[];

  @override
  void initState() {
    super.initState();

    getDailyPlanData(widget.tourPlanId, widget.tourPlanDate);
    dateList = generateDateList(widget.tourPlanDate.month);
  }

  List<DateTime> generateDateList(int month) {
    final DateTime now = DateTime.now();
    final DateTime firstDay = DateTime(now.year, month, 1);
    final DateTime lastDay = DateTime(now.year, month + 1, 0);

    final List<DateTime> dates = [];

    for (var day = firstDay;
        day.isBefore(lastDay) || day.isAtSameMomentAs(lastDay);
        day = day.add(const Duration(days: 1))) {
      dates.add(day);
    }

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isEdit) {
          Get.back(result: true);
        } else {
          Get.back();
        }
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title:
              "${getMonthName(widget.tourPlanDate.month)} ${widget.tourPlanDate.year}",
          implyStatus: true,
          actions: [
           isSubmited == false
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.2.h),
                    child: GestureDetector(
                      onTap: onSubmitClick,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Constants.primaryColor),
                          )),
                    ),
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 1.h),
            !isLoading
                ? dailyTourData.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dailyTourData.length,
                          itemBuilder: (context, index) {
                            final currentDate = dateList[index];
                            final dayName =
                                DateFormat('EEEE').format(currentDate);
                            // print("date is valiue ${dailyTourData[index].date}");
                            // print("date Length ${dailyTourData.length}");
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 10.w,
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              dayName
                                                  .substring(0, 3)
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: dayName
                                                              .substring(0, 3)
                                                              .toUpperCase() ==
                                                          "SUN"
                                                      ? Constants.primaryColor
                                                      : Colors.black),
                                            ),
                                            Text(
                                              "${currentDate.day}",
                                              style:
                                                  const TextStyle(fontSize: 19),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          //add
                                          if (!(dailyTourData[index]
                                                          .holidayData !=
                                                      null &&
                                                  dailyTourData[index]
                                                      .holidayData!
                                                      .isNotEmpty) &&
                                              !(dailyTourData[index]
                                                      .leaveData !=
                                                  null) &&
                                              !(dailyTourData[index].tourPlan !=
                                                      null &&
                                                  dailyTourData[index]
                                                      .tourPlan!
                                                      .isNotEmpty) &&
                                              widget.status != "Approved")
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3,
                                                        vertical: 4),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (widget.status !=
                                                            "Approved") {
                                                          var response =
                                                              await showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder: (_) {
                                                                    return AddTourPlanDialog(
                                                                      canEdit:
                                                                          false,
                                                                      date: dailyTourData[
                                                                              index]
                                                                          .date!,
                                                                      tourPlanId:
                                                                          widget
                                                                              .tourPlanId,
                                                                      status: widget
                                                                          .status,
                                                                    );
                                                                  });
                                                          if (response !=
                                                              null) {
                                                            isEdit = true;
                                                            dailyTourData
                                                                .clear();
                                                            getDailyPlanData(
                                                                response[0],
                                                                response[1]);
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 55.w,
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 5),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color:
                                                                Colors.purple),
                                                        child: const Text(
                                                          "Tap to add tour plan",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (widget.status !=
                                                            "Approved") {
                                                          var result =
                                                              await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (_) {
                                                                    return AddLeaveDialog(
                                                                        date: dailyTourData[index]
                                                                            .date!,
                                                                        tourPlanId:
                                                                            widget.tourPlanId);
                                                                  });

                                                          if (result != null) {
                                                            isEdit = true;
                                                            dailyTourData
                                                                .clear();
                                                            getDailyPlanData(
                                                                result[0],
                                                                result[1]);
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Constants
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 3.w,
                                                                vertical:
                                                                    0.9.h),
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 5),
                                                        child: const Text(
                                                          "Mark as leave",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),

                                          if (widget.status == "Approved" &&
                                              dailyTourData[index]
                                                  .tourPlan!
                                                  .isEmpty)
                                            Visibility(
                                              visible: dailyTourData[index]
                                                          .leaveData ==
                                                      null &&
                                                  dailyTourData[index]
                                                      .holidayData!
                                                      .isEmpty,
                                              child: Container(
                                                width: 88.w,
                                                alignment: Alignment.center,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3,
                                                        vertical: 4),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // border: Border.all(color: Constants.lightGreyColor)
                                                ),
                                                child: const Text(
                                                  "No Data Available ",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),

                                          //holiday
                                          if ((dailyTourData[index]
                                                      .holidayData !=
                                                  null &&
                                              dailyTourData[index]
                                                  .holidayData!
                                                  .isNotEmpty))
                                            Container(
                                              width: 88.w,
                                              alignment: Alignment.center,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 4),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.cyan,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                // border: Border.all(color: Constants.lightGreyColor)
                                              ),
                                              child: Text(
                                                dailyTourData[index]
                                                        .holidayData
                                                        ?.first
                                                        .holidayName ??
                                                    "",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),

                                          //leave
                                          if (dailyTourData[index].leaveData !=
                                              null)
                                            Container(
                                              width: 88.w,
                                              alignment: Alignment.center,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 4),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.cyan,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                // border: Border.all(color: Constants.lightGreyColor)
                                              ),
                                              child: Text(
                                                dailyTourData[index]
                                                        .leaveData
                                                        ?.leaveType ??
                                                    "",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),

                                          ...List.generate(
                                              dailyTourData[index]
                                                  .tourPlan!
                                                  .length, (pos) {
                                            return GestureDetector(
                                              onTap: () async {
                                                var result = await Get.to(
                                                    TourPlanDetailsPage(
                                                        tourPlanList:
                                                            dailyTourData[index]
                                                                .tourPlan!,
                                                        date:
                                                            dailyTourData[index]
                                                                .date!,
                                                        tourPlanId:
                                                            widget.tourPlanId,
                                                        status: widget.status),
                                                    transition:
                                                        Transition.fade);
                                                if (result != null) {
                                                  isEdit = true;
                                                  getDailyPlanData(
                                                      result[0], result[1]);
                                                  setState(() {});
                                                }
                                              },
                                              child: Container(
                                                  width: 88.w,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 3,
                                                      vertical: 4),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .lightBlueAccent
                                                        .withOpacity(0.09),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    // border: Border.all(color: Constants.lightGreyColor)
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            dailyTourData[index]
                                                                    .tourPlan?[
                                                                        pos]
                                                                    .activityType
                                                                    ?.activityTypeName ??
                                                                "",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          const Spacer(),
                                                          Icon(
                                                            Icons.circle,
                                                            color: dailyTourData[
                                                                            index]
                                                                        .tourPlan?[
                                                                            pos]
                                                                        .status ==
                                                                    "Created"
                                                                ? Colors.white
                                                                : dailyTourData[index]
                                                                            .tourPlan?[
                                                                                pos]
                                                                            .status ==
                                                                        "Started"
                                                                    ? Colors
                                                                        .green
                                                                    : dailyTourData[index].tourPlan?[pos].status ==
                                                                            "Paused"
                                                                        ? Colors
                                                                            .orange
                                                                        : dailyTourData[index].tourPlan?[pos].status ==
                                                                                "Resumed"
                                                                            ? Colors.blue
                                                                            : Colors.red,
                                                            size: 8,
                                                          )
                                                        ],
                                                      ),
                                                      Text(
                                                        "Area : ${dailyTourData[index].tourPlan?[pos].area?.townName ?? ""}",
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          }),
                                        ],
                                      )
                                    ],
                                  ),
                                  Divider(color: Colors.black.withOpacity(0.2))
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: NoDataFound(),
                      )
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget tourPlanFieldWidget(String title) => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Constants.primaryColor),
        child: Text(
          title,
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      );

  // Future<void> getDummyData() async {
  //   tourData = await TourMasterRepo.dummyData();
  //   print(tourData[1].date);
  //   setState(() {
  //
  //   });
  // }

  String getMonthName(int monthNumber) {
    final DateTime date = DateTime(DateTime.now().year, monthNumber);

    // Format the month using DateFormat from the intl package
    final String monthName = DateFormat('MMMM').format(date);

    return monthName;
  }

  Future<void> getDailyPlanData(String tourId, DateTime date) async {
    var result = await TourMasterRepo.getDailyTourPlanList(tourId, date);
    if (result.status) {
      if (result.data != null) {
        dailyTourData = result.data!;
        isLoading = false;
        setState(() {});
      }
    }
  }

  void onSubmitClick() async {
    if (await InternetUtil.isInternetConnected()) {
      try {
        String userId = await SessionManager.getUserId();

        ProgressDialog.showProgressDialog(context);
        Map<String, dynamic> requestBody = {
          "tourPlanId": widget.tourPlanId,
          "status": "Pending",
          "userId": userId,
          "date": widget.tourPlanDate.toIso8601String()
        };

        var response = await TourMasterRepo.sendForApproval(requestBody);
        if (response.status) {
          Get.back();
          isEdit = true;
          isSubmited = true;
          context.showSnackBar("TourPlan send for approval", null);
          setState(() {});
        } else {
          Get.back();
          context.showSnackBar("Something went wrong", null);
        }
      } catch (e) {
        Get.back();
      }
    } else {
      context.showSnackBar("Please check your internet connection", null);
    }
  }
}
