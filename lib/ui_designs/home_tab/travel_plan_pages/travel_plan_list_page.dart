import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tulip_app/dialog/add_tour_year_dialog.dart';
import 'package:tulip_app/model/tour_plan_model/tour_plan_list_model.dart';
import 'package:tulip_app/repo/tour_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/travel_plan_pages/daily_tour_plan_list.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/no_data_found.dart';
import 'package:tulip_app/widget/no_internet_widget.dart';

import '../../../constant/constant.dart';
import 'tour_filter_page.dart';

class TravelPlanListPage extends StatefulWidget {
  final String latitude;
  final String longitude;
  const TravelPlanListPage({Key? key, required this.latitude, required this.longitude}) : super(key: key);

  @override
  _TravelPlanListPageState createState() => _TravelPlanListPageState();
}

class _TravelPlanListPageState extends State<TravelPlanListPage> {
  bool _showFilter = false;
  bool _isLoading = true;
  bool _isInternetConnected = true;
  StreamSubscription? _subscription;
  DateTime? toDate;
  List<dynamic>? _filterData;

  List<TourPlanList> tourPlanData = [];

  List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _addInternetConnectionListener();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showFilter = false;
        setState(() {});
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Tour Plans',
          implyStatus: true,
          actions: [
            GestureDetector(
              onTap: () {
                _showFilter = !_showFilter;
                setState(() {});
              },
              child: Container(
                margin: EdgeInsets.only(left: 2.w, right: 3.w),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xffC3C3C3).withOpacity(0.25),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: const Offset(0, 1)),
                      BoxShadow(
                          color: const Color(0xffC3C3C3).withOpacity(0.25),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: const Offset(0, -1)),
                    ]),
                child: Image.asset("assets/travel_page_icon/filter_icon.png",
                    height: 20, width: 20, color: Constants.white),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            _showFilter = false;
            setState(() {});
          },
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  _isInternetConnected
                      ? !_isLoading
                          ? tourPlanData.isNotEmpty
                              ? Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      tourPlanData.clear();
                                      getTourPlanData();
                                    },
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(bottom: 2.h),
                                        itemCount: tourPlanData.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                              onTap: () async {
                                                var result = await Get.to(
                                                    DailyTourPlanList(
                                                      tourPlanId:
                                                          tourPlanData[index]
                                                              .id,
                                                      tourPlanDate:
                                                          tourPlanData[index]
                                                              .date!,
                                                      status: tourPlanData[index].status!
                                                    ),
                                                    transition:
                                                        Transition.fade);
                                                if(result!=null && result){
                                                  tourPlanData.clear();
                                                  getTourPlanData();
                                                }
                                              },
                                              child: _travelPlanCardWidget(
                                                  tourPlanData[index]));
                                        }),
                                  ),
                                )
                              : SizedBox(
                                  height: 70.h,
                                  child: const Center(child: NoDataFound()))
                          : const Center(
                              child: CircularProgressIndicator.adaptive())
                      : SizedBox(
                          height: 70.h,
                          child: const Center(child: NoInternetWidget())),
                ],
              ),
              if (_showFilter)
                Container(
                  color: Colors.transparent,
                  height: double.infinity,
                  width: double.infinity,
                ),
              if (_showFilter)
                TourFilterPage(
                  selectedFilter: _filterData,
                  applyFilterCallback: applyFilter,
                  updateFilterVisibilityCallback: (bool visibility) {
                    setState(() {
                      _showFilter = visibility; // Update _showFilter
                    });
                  },
                ),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () async {
            var result = await showDialog(
                context: context,
                builder: (_) {
                  return AddTourYearDialog(latitude: widget.longitude,longitude: widget.longitude,);
                });

            if (result != null) {
              tourPlanData.clear();
              getTourPlanData();
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
        ),
      ),
    );
  }

  Widget _travelPlanCardWidget(TourPlanList item) => Container(
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1),
                  color: const Color(0xffC3C3C3).withOpacity(0.25),
                  blurRadius: 4,
                  spreadRadius: 0),
              BoxShadow(
                  offset: const Offset(0, -1),
                  color: const Color(0xffC3C3C3).withOpacity(0.25),
                  blurRadius: 4,
                  spreadRadius: 0),
            ],
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            )),
        child: Row(
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: 50.w,
                margin: EdgeInsets.only(bottom: 3.w),
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Constants.lightGreyBorderColor))),
                child: Text(
                  "${getMonthName(item.date!.month)} ${item.date?.year}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _travelPlanTextWidget(
                      "assets/other_images/requested_icon.png",
                      "Requested To",
                      item.requestedTo?.userName ?? "",
                      ""),
                  SizedBox(height: 1.5.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Image.asset(
                          "assets/other_images/status_icon.png",
                          height: 15,
                          width: 15,
                          color: Constants.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Status : ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                            color: item.status == "Approved"
                                ? Colors.green
                                : item.status == "Pending"
                                    ? Colors.orange
                                    : Colors
                                        .red, // Use index to determine the color
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          item.status ?? "", // Use index to determine the text
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  _travelPlanTextWidget("assets/other_images/leave_icon.png",
                      "Total Leaves", item.totalLeaves.toString() ?? "", ""),
                  SizedBox(height: 1.5.h),
                  _travelPlanTextWidget("assets/other_images/holiday_icon.png",
                      "Total Holidays", item.totalHolidays.toString(), ""),
                  SizedBox(height: 1.5.h),
                  if(item.notes!=null && item.notes!.isNotEmpty)
                  _travelPlanTextWidget("assets/other_images/note_icon.png",
                      "Note", item.notes ?? "", ""),
                ],
              ),
            )
          ],
        ),
      );

  Widget _travelPlanTextWidget(
          String imagePath, String title, String date, String time) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Image.asset(
              imagePath,
              height: 15,
              width: 15,
              color: title == "To" || title == "From"
                  ? null
                  : Constants.primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Expanded(
              child: Text(
            "$date   $time",
            style: const TextStyle(
              fontSize: 13,
            ),
          )),
        ],
      );

  Future<void> getTourPlanData() async {
    var result = await TourMasterRepo.getTourPlanList(
        _filterData != null ? _filterData![1] : DateTime.now().year.toString(),
        _filterData != null && _filterData![0].length != 0
            ? _filterData![0]
                .map((dynamic item) => item.replaceAll(' ', ''))
                .toList()
            : []);
    if (result.status) {
      if (result.data != null) {
        tourPlanData = result.data ?? [];
        _isLoading = false;
        setState(() {});
      }
    }
    else{
      context.showSnackBar("Something went wrong",null);
    }
  }

  void _addInternetConnectionListener() async {
    //if the internet is connected then make the api call
    if (!(await InternetUtil.isInternetConnected())) {
      _listenInternetConnection();
      setState(() {
        _isInternetConnected = false;
      });
    } else {
      getTourPlanData();
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
        getTourPlanData();
        setState(() {
          _isInternetConnected = true;
        });
      }
    });
  }

  String getMonthName(int monthNumber) {
    final DateTime date = DateTime(DateTime.now().year, monthNumber);

    // Format the month using DateFormat from the intl package
    final String monthName = DateFormat('MMMM').format(date);

    return monthName;
  }

  void applyFilter(List<dynamic> filterData) {
    _filterData = filterData;
    getTourPlanData();
    setState(() {});
  }
}
