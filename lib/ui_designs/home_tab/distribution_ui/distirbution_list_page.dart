
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/distributor_model/distributor_stock_list_model.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/repo/distributor_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/distribution_ui/create_monthly_sale.dart';
import 'package:tulip_app/ui_designs/home_tab/distribution_ui/distributor_filter_page.dart';
import 'package:tulip_app/ui_designs/home_tab/distribution_ui/file_monthly_sale_page.dart';
import 'package:tulip_app/ui_designs/home_tab/menu_pages/dashboard_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/no_data_found.dart';
import 'package:tulip_app/widget/no_internet_widget.dart';

class DistributionListPage extends StatefulWidget {
  const DistributionListPage({Key? key}) : super(key: key);

  @override
  _DistributionListPageState createState() => _DistributionListPageState();
}

class _DistributionListPageState extends State<DistributionListPage> {
  bool _showFilter = false;
  List<dynamic>? _filterData;
  bool _isInternetConnected = true;
  List<DistributorStockItem> distributorList=[];
  StreamSubscription? _subscription;
  bool _isLoading = true;
  List<String> monthList = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  void initState() {
    super.initState();
    _addInternetConnectionListener();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.off(const DashBoardPage());
          return true;
        },
      child: GestureDetector(
        onTap: () {
          _showFilter = false;
          setState(() {});
        },
        child: Scaffold(
          appBar: CustomAppBar(title: 'DSM',implyStatus: true,showBackButton: true,
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
                        ? distributorList.isNotEmpty
                        ? Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          distributorList.clear();
                          _fetchPage();
                        },
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 2.h),
                            itemCount: distributorList.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return InkWell(
                                  onTap: () async {
                                    Get.to(FileMonthlySalePage(distributorId: distributorList[index].distributorId?.id ?? "",selectedDate: selectedDate));
                                  },
                                  child: _distributorCardWidget(distributorList[index]));
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
                  DistributorFilterPage(
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
            onTap: () {
            Get.to(()=>const CreateMonthlySale());
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
      ),
    );
  }



  Widget _distributorCardWidget(DistributorStockItem item) => Container(
    margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
    decoration: BoxDecoration(
        color: Constants.white,
        boxShadow: [
          BoxShadow(
              color: const Color(0xffC3C3C3).withOpacity(0.20),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, 0)),
          BoxShadow(
              color: const Color(0xffC3C3C3).withOpacity(0.20),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, 0)),
        ],
        borderRadius:  BorderRadius.circular(8)),
    child: Column(
      children: [

        Container(
          width: 100.w,
          decoration: BoxDecoration(
            color: Colors.white,
              borderRadius:  BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xffC3C3C3).withOpacity(0.20),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: const Offset(0, 0)),
              BoxShadow(
                  color: const Color(0xffC3C3C3).withOpacity(0.20),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: const Offset(0, 0)),
            ]
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
            child: Row(
              children: [
                Text("TRS No : ${item.trsNo}",style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor
                ),),

                const Spacer(),
                Text("${item.invoiceDate}",style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Constants.primaryColor

                ),),

              ],
            ),
          ),
        ),

        SizedBox(height: 1.5.h),
        distributor("assets/lead_page_icon/created_date.png", "Month",
             "${item.month}", "",),
        SizedBox(height: 1.5.h),

        distributor("assets/lead_page_icon/created_date.png", "Year",
             "${item.year}", ""),
        SizedBox(height: 1.5.h),

        distributor("assets/distributor_images/location.png", "Region",
            "${item.distributorId?.region}", ""),
        SizedBox(height: 1.5.h),


        distributor("assets/distributor_images/distributor.png", "Distributor",
            "${item.distributorId?.businessName}", ""),
        SizedBox(height: 1.h),


        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/other_images/status_icon.png",
                height: 15,
                width: 15,
                color: Constants.primaryColor,
              ),
              const SizedBox(width: 10),
              Container(
                width:25.w,
                child: const Text(
                  "Status : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.green, // Use index to determine the color
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "${item.status}", // Use index to determine the text
                  style: TextStyle(
                      fontSize: 13, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.5.h),
      ],
    ),
  );


  Widget distributor(
      String imagePath,
      String title,
      String date,
      String time,
      ) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Image.asset(
                imagePath,
                height: 15,
                width: 15,
                color: Constants.primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 25.w,
              child: Text(
                "$title : ",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            Text(
              "$date  ",
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
            Expanded(
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                )),
          ],
        ),
      );




  void applyFilter(List<dynamic> filterData) {
    _filterData = filterData;
    print(_filterData);
    int month = monthStringToNumber(filterData[1]);

    selectedDate = DateTime(int.parse(_filterData?[0]), month, 1);

    _fetchPage();
    setState(() {});
// Refresh the data with the new filter
  }

  int monthStringToNumber(String monthString) {
    switch (monthString.toLowerCase()) {
      case 'january':
        return DateTime.january;
      case 'february':
        return DateTime.february;
      case 'march':
        return DateTime.march;
      case 'april':
        return DateTime.april;
      case 'may':
        return DateTime.may;
      case 'june':
        return DateTime.june;
      case 'july':
        return DateTime.july;
      case 'august':
        return DateTime.august;
      case 'september':
        return DateTime.september;
      case 'october':
        return DateTime.october;
      case 'november':
        return DateTime.november;
      case 'december':
        return DateTime.december;
      default:
        throw FormatException('Invalid month string: $monthString');
    }
  }

  void _fetchPage() async {
    final result = await DistributorRepo.getDistributorStockList(
        _filterData?[0] != null ? _filterData![0] : DateTime.now().year.toString(),
        _filterData?[1] != null ? _filterData![1] : monthList[DateTime.now().month-1]);

    if (result.status) {
      if (result.data != null) {
        distributorList = result.data ?? [];
        _isLoading = false;
        setState(() {});
      }
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
      _fetchPage();
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
        _fetchPage();
        setState(() {
          _isInternetConnected = true;
        });
      }
    });
  }


}
