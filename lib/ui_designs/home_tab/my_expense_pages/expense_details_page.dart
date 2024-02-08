import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/expense_model/expense_details_list.dart';
import 'package:tulip_app/model/expense_model/expense_list_model.dart';
import 'package:tulip_app/model/expense_model/setting_model.dart';
import 'package:tulip_app/model/tour_date_model.dart';
import 'package:tulip_app/repo/expense_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/dcr_pages/travel_details_for_date.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/no_data_found.dart';

class ExpenseDetailsPage extends StatefulWidget {
  final ExpenseList? expenseListData;
  final String? status;
  const ExpenseDetailsPage({Key? key, this.expenseListData, this.status})
      : super(key: key);

  @override
  ExpenseDetailsPageState createState() => ExpenseDetailsPageState();
}

class ExpenseDetailsPageState extends State<ExpenseDetailsPage> {
  late List<DateTime> dateList;
  List<TourPlanItem> tourData = [];
  double hqTotal = 0;
  double exHqTotal = 0;
  bool isEdit = false;
  // TextEditingController entValue = TextEditingController();
  double fairTotal = 0;
  double osTotal = 0;
  SettingDetails? settingDetails;
  bool isLoading = true;
  double misTotal = 0;
  List<ExpenseDetailsList> expenseList = [];

  @override
  void initState() {
    super.initState();
    getExpenseList();
    getSettingDetails();
  }

  String getMonthName(int monthNumber) {
    final DateTime date = DateTime(DateTime.now().year, monthNumber);

    // Format the month using DateFormat from the intl package
    final String monthName = DateFormat('MMMM').format(date);

    return monthName;
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
              "${getMonthName(widget.expenseListData!.tourPlanDate!.month)} ${widget.expenseListData!.tourPlanDate!.year}",
          implyStatus: true,
        ),
        body: !isLoading
            ? expenseList.isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 1.h),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: expenseList.length,
                          itemBuilder: (context, index) {
                            final currentDate = expenseList[index]
                                .standardFareChart
                                ?.first
                                .tourPlanVisitId
                                ?.visitDate;
                            final dayName =
                                DateFormat('EEEE').format(currentDate!);
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...List.generate(
                                              expenseList[index]
                                                  .standardFareChart!
                                                  .length, (pos) {
                                            StandardFareChart? item =
                                                expenseList[index]
                                                    .standardFareChart?[pos];
                                            return GestureDetector(
                                              // onTap:()=>Get.to(const TourPlanDetailsPage(),transition: Transition.fade),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      width: 80.w,
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 3,
                                                          vertical: 4),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 3.w,
                                                              vertical: 5),
                                                      decoration: BoxDecoration(
                                                          // borderRadius: BorderRadius.circular(10),
                                                          border: Border(
                                                              left: BorderSide(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2)),
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2)))),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          dateWiseCardField(
                                                              "assets/expense_page_icon/town_icon.png",
                                                              "Town Name ",
                                                              " ${item?.area?.townName ?? ""} ( ${item?.distanceKms ?? 0} km )"),
                                                          dateWiseCardField(
                                                              "assets/other_images/type_icon.png",
                                                              "Activity Type ",
                                                              " ${item?.activityType?.activityTypeName ?? ""}"),
                                                          dateWiseCardField(
                                                              "assets/expense_page_icon/fare_icon.png",
                                                              "Fare ",
                                                              " ₹ ${item?.fair?.toStringAsFixed(2)}"),
                                                          dateWiseCardField(
                                                              "assets/expense_page_icon/allowance_icon.png",
                                                              "Allowance ",
                                                              item!.activityType
                                                                          ?.activityTypeName ==
                                                                      "Meeting"
                                                                  ? " ₹ 0"
                                                                  : " ₹ ${item.totalAllowance?.toStringAsFixed(2) ?? "0"} ( ${item.stationType} )"),
                                                          item.activityType
                                                                      ?.activityTypeName ==
                                                                  "Meeting"
                                                              ? dateWiseCardField(
                                                                  "assets/expense_page_icon/amount_icon.png",
                                                                  "Total ",
                                                                  " ₹ 0")
                                                              : dateWiseCardField(
                                                                  "assets/expense_page_icon/amount_icon.png",
                                                                  "Total ",
                                                                  " ₹ ${((item.totalAllowance ?? 0) + (item.fair ?? 0)).toStringAsFixed(2)}"),
                                                          if (item.activityType
                                                                  ?.activityTypeName ==
                                                              "Meeting")
                                                            const Text(
                                                              "Note : Expenses related to an area with the activity type “Meeting” cannot be considered.",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .red),
                                                            )
                                                        ],
                                                      )),
                                                  if (widget.status !=
                                                      "Approved")
                                                    GestureDetector(
                                                        onTap: pos == 0
                                                            ? () async {
                                                                var result = await Get.to(AddFileExpensePage(
                                                                    tourPlanVisitDate: widget
                                                                        .expenseListData!
                                                                        .dcrData!
                                                                        .date!,
                                                                    dcrArea: item
                                                                        .area!,
                                                                    stationTypeId:
                                                                        item
                                                                            .stationType,
                                                                    expenseDetails:
                                                                        expenseList[
                                                                            index],
                                                                    updateId:
                                                                        expenseList[index]
                                                                            .id,
                                                                    distance:
                                                                        item.distanceKms ??
                                                                            0,
                                                                    dcrId: widget
                                                                            .expenseListData
                                                                            ?.dcrData
                                                                            ?.id ??
                                                                        ""));
                                                                if (result !=
                                                                        null &&
                                                                    result) {
                                                                  getExpenseList();
                                                                  getSettingDetails();
                                                                }
                                                              }
                                                            : () {},
                                                        child: Icon(
                                                          Icons.edit,
                                                          color: pos == 0
                                                              ? Colors.black
                                                              : Colors.white,
                                                        ))
                                                ],
                                              ),
                                            );
                                          }),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  "assets/expense_page_icon/miscellaneous_icon.png",
                                                  height: 14,
                                                  width: 14,
                                                  color: Colors.black,
                                                ),
                                                const Text(
                                                  " Total Miscellaneous :",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "  ₹ ${expenseList[index].miscellaneousExpenses?.fold(0.0, (sum, expense) => sum + (expense.amount ?? 0))}",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.black.withOpacity(0.2))
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 100.w,
                        margin: const EdgeInsets.only(top: 5),
                        padding:
                            EdgeInsets.only(top: 10, left: 3.w, right: 3.w),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(25),
                              topLeft: Radius.circular(25)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(1.0, -2),
                              color: const Color(0xffC3C3C3).withOpacity(0.25),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 0.6.h),
                              child: Text(
                                widget.status == "Approved"
                                    ? "Grand Total : ₹ ${((widget.expenseListData?.totalFare ?? 0) + (widget.expenseListData?.totalMisc ?? 0) + (widget.expenseListData?.totalHq ?? 0) + (widget.expenseListData?.totalExHq ?? 0.0) + (widget.expenseListData?.totalOs ?? 0.0) + (widget.expenseListData?.mobileReimbursement ?? 0) + (SessionManager.userDesignation?.toLowerCase() == "territory manager" ? widget.expenseListData?.entertainment ?? 0 : 0)).toStringAsFixed(2)}"
                                    : "Grand Total : ₹ ${(fairTotal + hqTotal + osTotal + exHqTotal + misTotal + (settingDetails?.mobileReimbursement ?? 0) + (settingDetails?.entertainment ?? 0)).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.transparent,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Constants.primaryColor,
                                  decorationThickness: 1.5,
                                  shadows: [
                                    Shadow(
                                        color: Constants.primaryColor,
                                        offset: Offset(0, -3))
                                  ],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    isDismissible: true,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (context, StateSetter innerState) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              right: 2.w,
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(height: 2.h),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        child: const Icon(
                                                            Icons.close,
                                                            color:
                                                                Colors.white)),
                                                    const Spacer(),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 0.6.h),
                                                      child: Text(
                                                        widget.status ==
                                                                "Approved"
                                                            ? "Grand Total : ₹ ${((widget.expenseListData?.totalFare ?? 0) + (widget.expenseListData?.totalMisc ?? 0) + (widget.expenseListData?.totalHq ?? 0) + (widget.expenseListData?.totalExHq ?? 0.0) + (widget.expenseListData?.totalOs ?? 0.0) + (widget.expenseListData?.mobileReimbursement ?? 0) + (SessionManager.userDesignation?.toLowerCase() != "territory manager" ? 0 : widget.expenseListData?.entertainment ?? 0)).toStringAsFixed(2)}"
                                                            : "Grand Total : ₹ ${(fairTotal + hqTotal + osTotal + exHqTotal + misTotal + (settingDetails?.mobileReimbursement ?? 0) + (settingDetails?.entertainment ?? 0)).toStringAsFixed(2)}",
                                                        style: const TextStyle(
                                                          color: Colors
                                                              .transparent,
                                                          fontSize: 15,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Constants
                                                                  .primaryColor,
                                                          decorationThickness:
                                                              1.5,
                                                          shadows: [
                                                            Shadow(
                                                                color: Constants
                                                                    .primaryColor,
                                                                offset: Offset(
                                                                    0, -3))
                                                          ],
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 1.h),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          child: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 1.h),
                                                _titleFieldWidget(
                                                    "Total Fare :",
                                                    (widget.status == "Approved"
                                                            ? widget.expenseListData
                                                                    ?.totalFare ??
                                                                0
                                                            : fairTotal)
                                                        .toStringAsFixed(2)),
                                                const Divider(
                                                    color: Colors.black),
                                                _titleFieldWidget(
                                                    "Daily Allowance", ""),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 6.w,
                                                        bottom: 0.3.h),
                                                    child: priceFieldWidget(
                                                        "HQ",
                                                        "${widget.status == "Approved" ? widget.expenseListData?.totalHq ?? 0 : hqTotal}")),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 6.w,
                                                        bottom: 0.3.h),
                                                    child: priceFieldWidget(
                                                        "Ex-HQ",
                                                        "${widget.status == "Approved" ? widget.expenseListData?.totalExHq ?? 0 : exHqTotal}")),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 6.w,
                                                        bottom: 0.3.h),
                                                    child: priceFieldWidget(
                                                        "OS",
                                                        "${widget.status == "Approved" ? widget.expenseListData?.totalOs ?? 0 : osTotal}")),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 6.w, bottom: 1.h),
                                                    child: priceFieldWidget(
                                                        "Total",
                                                        "${widget.status == "Approved" ? (widget.expenseListData?.totalExHq ?? 0) + (widget.expenseListData?.totalHq ?? 0) + (widget.expenseListData?.totalOs ?? 0) : exHqTotal + osTotal + hqTotal}")),
                                                const Divider(
                                                    color: Colors.black),
                                                _titleFieldWidget(
                                                    "Total Miscellaneous :",
                                                    "${widget.status == "Approved" ? widget.expenseListData?.totalMisc ?? 0 : misTotal}"),
                                                const Divider(
                                                    color: Colors.black),
                                                _titleFieldWidget("Other", ""),
                                                if (widget.expenseListData
                                                            ?.entertainment !=
                                                        0.0 ||
                                                    settingDetails
                                                            ?.entertainment !=
                                                        0.0)
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 6.w,
                                                          bottom: 0.3.h),
                                                      child: priceFieldWidget(
                                                          "Entertainment",
                                                          "${widget.status == "Approved" ? widget.expenseListData?.entertainment ?? 0 : settingDetails?.entertainment ?? 0}")),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 6.w,
                                                        bottom: 0.3.h),
                                                    child: priceFieldWidget(
                                                        "Mobile Reimbursement",
                                                        "${widget.status == "Approved" ? widget.expenseListData?.mobileReimbursement ?? 0 : settingDetails?.mobileReimbursement ?? 0}")),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 6.w, bottom: 1.h),
                                                    child: priceFieldWidget(
                                                        "Total",
                                                        widget.status ==
                                                                "Approved"
                                                            ? "${(widget.expenseListData?.mobileReimbursement ?? 0) + (widget.expenseListData?.entertainment ?? 0)}"
                                                            : "${(settingDetails?.mobileReimbursement ?? 0) + (settingDetails?.entertainment ?? 0)}")),
                                                const Divider(
                                                    color: Colors.black),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: EdgeInsets.only(
                                                      left: 3.w, bottom: 0.5.h),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        "Grand Total :",
                                                        style: TextStyle(
                                                          color: Colors
                                                              .transparent,
                                                          fontSize: 15,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Constants
                                                                  .primaryColor,
                                                          decorationThickness:
                                                              1.5,
                                                          shadows: [
                                                            Shadow(
                                                                color: Constants
                                                                    .primaryColor,
                                                                offset: Offset(
                                                                    0, -3))
                                                          ],
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        widget
                                                                    .status ==
                                                                "Approved"
                                                            ? ((widget
                                                                            .expenseListData?.totalFare ??
                                                                        0) +
                                                                    (widget
                                                                            .expenseListData?.totalMisc ??
                                                                        0) +
                                                                    (widget.expenseListData
                                                                            ?.totalHq ??
                                                                        0) +
                                                                    (widget.expenseListData
                                                                            ?.totalExHq ??
                                                                        0.0) +
                                                                    (widget.expenseListData
                                                                            ?.totalOs ??
                                                                        0.0) +
                                                                    (widget.expenseListData
                                                                            ?.mobileReimbursement ??
                                                                        0) +
                                                                    (SessionManager
                                                                                .userDesignation
                                                                                ?.toLowerCase() !=
                                                                            "territory manager"
                                                                        ? 0
                                                                        : widget.expenseListData?.entertainment ??
                                                                            0))
                                                                .toStringAsFixed(
                                                                    2)
                                                            : (fairTotal +
                                                                    hqTotal +
                                                                    osTotal +
                                                                    exHqTotal +
                                                                    misTotal +
                                                                    (settingDetails
                                                                            ?.mobileReimbursement ??
                                                                        0) +
                                                                    (settingDetails
                                                                            ?.entertainment ??
                                                                        0))
                                                                .toStringAsFixed(
                                                                    2),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                                if (widget.status != "Approved")
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: onSaveClick,
                                                        child: Container(
                                                          width: 35.w,
                                                          height: 4.h,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: Constants
                                                                .primaryColor,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  offset:
                                                                      const Offset(
                                                                          0, 1),
                                                                  color: const Color(
                                                                          0xffC3C3C3)
                                                                      .withOpacity(
                                                                          0.25),
                                                                  blurRadius: 4,
                                                                  spreadRadius:
                                                                      0),
                                                              BoxShadow(
                                                                  offset:
                                                                      const Offset(
                                                                          0,
                                                                          -1),
                                                                  color: const Color(
                                                                          0xffC3C3C3)
                                                                      .withOpacity(
                                                                          0.25),
                                                                  blurRadius: 4,
                                                                  spreadRadius:
                                                                      0),
                                                            ],
                                                          ),
                                                          child: const Text(
                                                            "Save",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Container(
                                                          width: 35.w,
                                                          height: 4.h,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            color: Constants
                                                                .primaryColor,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  offset:
                                                                      const Offset(
                                                                          0, 1),
                                                                  color: const Color(
                                                                          0xffC3C3C3)
                                                                      .withOpacity(
                                                                          0.25),
                                                                  blurRadius: 4,
                                                                  spreadRadius:
                                                                      0),
                                                              BoxShadow(
                                                                  offset:
                                                                      const Offset(
                                                                          0,
                                                                          -1),
                                                                  color: const Color(
                                                                          0xffC3C3C3)
                                                                      .withOpacity(
                                                                          0.25),
                                                                  blurRadius: 4,
                                                                  spreadRadius:
                                                                      0),
                                                            ],
                                                          ),
                                                          child: const Text(
                                                            "Cancel",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                SizedBox(height: 2.h),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(bottom: 1.h),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Constants.primaryColor,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: const Text(
                                    "Review",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : const Center(child: NoDataFound())
            : const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

  Widget dateWiseCardField(String imagePath, String title, String title1) =>
      Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              height: 14,
              width: 14,
              color: Colors.black,
            ),
            Text(
              "  $title :",
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            Expanded(
              child: Text(
                " $title1",
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
          ],
        ),
      );

  Future<void> onSaveClick() async {
    if (await InternetUtil.isInternetConnected()) {
      ProgressDialog.showProgressDialog(context);
      try {
        Map<String, dynamic> body = {};
        widget.status == "Approved"
            ? body = {
                "expenseId": widget.expenseListData?.id,
                "totalFare": widget.expenseListData?.totalFare,
                "totalHq": widget.expenseListData?.totalHq,
                "totalExHq": widget.expenseListData?.totalExHq,
                "totalOs": widget.expenseListData?.totalOs,
                "totalMisc": widget.expenseListData?.totalMisc,
                "entertainment": settingDetails?.entertainment,
                "mobileReimbursement":
                    widget.expenseListData?.mobileReimbursement,
                "grandTotal": (widget.expenseListData?.totalFare ?? 0) +
                    (widget.expenseListData?.totalMisc ?? 0) +
                    (widget.expenseListData?.totalHq ?? 0) +
                    (widget.expenseListData?.totalExHq ?? 0.0) +
                    (widget.expenseListData?.totalOs ?? 0.0) +
                    (widget.expenseListData?.mobileReimbursement ?? 0) +
                    (widget.expenseListData?.entertainment ?? 0)
              }
            : body = {
                "expenseId": widget.expenseListData?.id,
                "totalFare": fairTotal,
                "totalHq": hqTotal,
                "totalExHq": exHqTotal,
                "totalOs": osTotal,
                "totalMisc": misTotal,
                // if (SessionManager.userDesignation?.toLowerCase() == "territory manager")
                "entertainment": settingDetails?.entertainment,
                "mobileReimbursement": settingDetails?.mobileReimbursement,
                "grandTotal": fairTotal +
                    misTotal +
                    osTotal +
                    hqTotal +
                    exHqTotal +
                    (settingDetails?.mobileReimbursement ?? 0) +
                    (settingDetails?.entertainment ?? 0)
              };
        // print("Grand totallll ${jsonEncode(body)}");

        var response = await ExpenseRepo.updateExpense(body);
        Get.back();
        if (response.status) {
          isEdit = true;
          Get.back();
          context.showSnackBar("Information Saved", null);
        } else {
          context.showSnackBar("${response.message}", null);
        }
      } catch (e) {
        Get.back();
        print("Exception : $e");
        context.showSnackBar("No Internet Connection", null);
      }
    } else {
      context.showSnackBar("No Internet Connection", null);
    }
  }

  Widget _titleFieldWidget(String title, String title2) => Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 3.w, bottom: 0.5.h, right: 1.w),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.transparent,
                fontSize: 15,
                decoration: TextDecoration.underline,
                decorationColor: Constants.primaryColor,
                decorationThickness: 1.5,
                shadows: [
                  Shadow(color: Constants.primaryColor, offset: Offset(0, -3))
                ],
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              title2,
              style: const TextStyle(fontWeight: FontWeight.w600),
            )
          ],
        ),
      );

  Widget priceFieldWidget(String title, String title1) => Row(
        children: [
          Text("$title :",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      title == "Total" ? FontWeight.w600 : FontWeight.w500)),
          const Spacer(),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                title1,
                style: TextStyle(
                    fontWeight:
                        title == "Total" ? FontWeight.w600 : FontWeight.w500),
              )),
        ],
      );

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

  Future<void> getExpenseList() async {
    var response = await ExpenseRepo.getExpenseDetailsList(
        widget.expenseListData?.id ?? "");
    if (response.status) {
      expenseList = response.data!;
      isLoading = false;

      hqTotal = 0;
      osTotal = 0;
      exHqTotal = 0;
      misTotal = 0;
      fairTotal = 0;

      for (var entry in expenseList) {
        // Iterate over documents for each date
        for (MiscellaneousExpense? misAmount
            in entry.miscellaneousExpenses ?? []) {
          misTotal += misAmount?.amount ?? 0;
        }
        for (StandardFareChart? misAmount in entry.standardFareChart ?? []) {
          fairTotal += misAmount?.fair ?? 0;
          if (misAmount?.stationType?.toLowerCase() == "hq" &&
              misAmount!.activityType!.activityTypeName != "Meeting") {
            hqTotal += misAmount.totalAllowance ?? 0;
          } else if (misAmount?.stationType?.toLowerCase() == "ex-hq" &&
              misAmount!.activityType!.activityTypeName != "Meeting") {
            exHqTotal += misAmount.totalAllowance ?? 0;
          } else if (misAmount?.stationType?.toLowerCase() == "os" &&
              misAmount!.activityType!.activityTypeName != "Meeting") {
            osTotal += misAmount.totalAllowance ?? 0;
          }
        }
      }

      setState(() {});
    } else {
      context.showSnackBar("Something went wrong ${response.message}", null);
    }
  }

  void getSettingDetails() async {
    var result = await ExpenseRepo.getExpenseDataCalculation();
    if (result.status) {
      settingDetails = result.data;
      // Assign settingDetails to expenseDetails (if needed)
      // Check stationTypeName and update totalAllowance accordingly
      setState(() {});
    } else {
      context.showSnackBar("${result.message}", null);
    }
  }
}
