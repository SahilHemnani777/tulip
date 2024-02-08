import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/dcr_model/dcr_list_model.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/repo/dcr_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/dcr_pages/date_wise_area_list.dart';
import 'package:tulip_app/ui_designs/home_tab/dcr_pages/dcr_filter_page.dart';
import 'package:tulip_app/ui_designs/home_tab/menu_pages/dashboard_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/util/date_util_ext.dart';
import 'package:tulip_app/widget/no_data_found.dart';
import 'package:tulip_app/widget/no_internet_widget.dart';

import 'select_date_dialog.dart';
import 'travel_details_for_date.dart';

class DCRListPage extends StatefulWidget {
  const DCRListPage({Key? key}) : super(key: key);

  @override
  _DCRListPageState createState() => _DCRListPageState();
}

class _DCRListPageState extends State<DCRListPage> {
  final PagingController<int, DCRListModel> _pagingController =
      PagingController(firstPageKey: 1);
  bool _isInternetConnected = true;
  StreamSubscription? _subscription;
  List<dynamic>? _filterData;
  bool _showFilter = false;

  @override
  void initState() {
    super.initState();
    _initPageController();
    _addInternetConnectionListener();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(const DashBoardPage());
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Daily Call Report (DCR)',
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
                      ? Expanded(
                          child: RefreshIndicator(
                            onRefresh: () {
                              _pagingController.refresh();
                              return Future.delayed(const Duration(seconds: 1));
                            },
                            child: _getPaginatedListViewWidget(),
                          ),
                        )
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
                DCRFilterPage(
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
            showDialog(
                context: context,
                builder: (context) {
                  return const SelectDateDialog();
                });
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

  Widget _dcrCardWidget(DCRListModel item) => Container(
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
        decoration: BoxDecoration(
            color: Constants.white,
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
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(20),
            )),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            _dcrTextWidget("assets/lead_page_icon/created_date.png", "Tour Plan Date",
                item.date?.getDisplayFormatDate() ?? "", "", () async {
              var result = await Get.to(
                  () => AddFileExpensePage(
                      stationTypeId: item.stationType ?? "",
                      dcrArea: item.area,
                      tourPlanVisitDate: item.date!,
                      distance: item.distanceKms ?? 0.0,
                      dcrId: item.id!),
                  transition: Transition.fade);
              if(result!=null && result){
                _pagingController.itemList?.clear();
                _pagingController.refresh();
              }

            }, item.status ?? "", item.isExpensesEligible,item.isExpenses),
            SizedBox(height: 1.5.h),

            _dcrTextWidget("assets/lead_page_icon/created_date.png", "Date",
                item.createdAt?.getDisplayFormatDate() ?? "", "", null, item.status ?? "", item.isExpensesEligible,item.isExpenses),
            SizedBox(height: 1.5.h),



            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Image.asset(
                      "assets/expense_page_icon/amount_icon.png",
                      height: 15,
                      width: 15,
                      color: Constants.lightGreyColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Expenses : ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    item.isExpenses ? "Yes " : "No ",
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  ),
                  if (item.isExpenses && item.expenseId?.createdAt != null)
                    Expanded(
                        child: Text(
                      "(${DateUtil.getDisplayFormatDate(item.expenseId!.createdAt!)})",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                ],
              ),
            ),
            SizedBox(height: 1.5.h),
            _dcrTextWidget(
                "assets/other_images/call_dark_icon.png",
                "Total Lab Calls",
                item.labCalls.toString() ?? "",
                "",
                null,
                null,
                item.isExpensesEligible,item.isExpenses),
            SizedBox(height: 1.5.h),
            // _dcrTextWidget(
            //     "assets/lead_page_icon/address_icon.png",
            //     "Place Worked",
            //     item.area?.townName ?? "",
            //     "",
            //     null,
            //     null,
            //     item.isExpenses),
            // SizedBox(height: 1.5.h),
            // _dcrTextWidget(
            //     "assets/other_images/type_icon.png",
            //     "Activity",
            //     item.activityType?.activityTypeName ?? "",
            //     "",
            //     null,
            //     null,
            //     item.isExpenses),
            // SizedBox(height: 1.5.h),
            // if (item.status == "Approved")
            //   _dcrTextWidget(
            //       "assets/other_images/station_type.png",
            //       "Station Type",
            //       item.stationType ?? '',
            //       "",
            //       null,
            //       null,
            //       item.isExpenses),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: Row(
            //     children: [
            //       const Spacer(),
            //       Container(
            //         padding:
            //             EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
            //         decoration: BoxDecoration(
            //             color: item.status == "Approved"
            //                 ? Colors.green
            //                 : item.status == "Rejected"
            //                     ? Colors.red
            //                     : Colors.blue,
            //             borderRadius: const BorderRadius.only(
            //                 bottomRight: Radius.circular(20),
            //                 topLeft: Radius.circular(20))),
            //         child: Text(
            //           item.status ?? '',
            //           style: const TextStyle(
            //               color: Colors.white,
            //               fontSize: 16,
            //               fontWeight: FontWeight.w500),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      );

  Widget _dcrTextWidget(
          String imagePath,
          String title,
          String date,
          String time,
          Function()? onTap,
          String? status,
          bool expenseCreated, bool isExpense) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Image.asset(
                imagePath,
                height: 15,
                width: 15,
                color: Constants.lightGreyColor,
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
            if (onTap != null && expenseCreated && !isExpense)
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 27.w,
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),
                  decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(7)),
                  child: const Text(
                    "File Expense",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
          ],
        ),
      );

  Widget _getPaginatedListViewWidget() => PagedListView<int, DCRListModel>(
        shrinkWrap: true,
        pagingController: _pagingController,
        padding: EdgeInsets.only(bottom: 10.h),
        builderDelegate: PagedChildBuilderDelegate<DCRListModel>(
          itemBuilder: (context, item, index) {
            return InkWell(
                onTap: () async {
                  // var result = await Get.to(LabListPage(
                  //         tourPlanVisitId: item.tourPlanVisitId ?? "",
                  //         dcrId: item.id,
                  //         areaName: item.area?.townName ?? "",
                  //         status: item.status), transition: Transition.fade);
                  var result = await Get.to(DateWiseAreaListPage(selectedDate : item.date!,dcrId: item.id,isExpenseCreated: item.isExpenses), transition: Transition.fade);
                  if (result != null && true) {
                    _pagingController.refresh();
                  }
                },
                child: _dcrCardWidget(item));
          },
          noItemsFoundIndicatorBuilder: (context) => SizedBox(
            width: 100.w,
            height: 70.h,
            child: const Center(
              child: NoDataFound(
                title: "No Data Found",
                image: "assets/error_image/no_data.png",
              ),
            ),
          ),
          firstPageErrorIndicatorBuilder: (context) => SizedBox(
              height: 70.h,
              child: const Center(
                child: NoDataFound(
                  title: "Something went wrong",
                  image: "assets/error_image/error.png",
                ),
              )),
        ),
      );

  Future<SuperResponse<List<DCRListModel>>?> _fetchPage(int pageNo) async {
    var firstDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    var lastDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    try {
      print(_filterData);
      final response = await DCRRepo.getDCRList(
          pageNo.toString(),
          "",
          _filterData != null && _filterData![0].length != 0
              ? _filterData![0]
                  .map((dynamic item) => item.replaceAll(' ', ''))
                  .toList()
              : [],
          _filterData?[1] != null ? _filterData![1] : firstDate,
          _filterData?[2] != null ? _filterData![2] : lastDate);

      if (response.status) {
        if (pageNo >= (response.data?.totalPages ?? 0)) {
          _pagingController.appendLastPage(response.data?.docs ?? []);
        } else {
          _pagingController.appendPage(response.data?.docs ?? [], pageNo + 1);
        }
      } else {
        _pagingController.error = response.message;
        // debugPrint(response.message);
      }
      // return response;
    } catch (error, stack) {
      _pagingController.error = error;
      debugPrint('error $error $stack');
      return null;
    }
    return null;
  }

  void _initPageController() {
    _pagingController.addPageRequestListener((pageKey) async {
      if (await InternetUtil.isInternetConnected()) {
        _fetchPage(pageKey);
      }
    });
  }

  void _addInternetConnectionListener() async {
    //if the internet is connected then make the api call
    if (!(await InternetUtil.isInternetConnected())) {
      _listenInternetConnection();
      setState(() {
        _isInternetConnected = false;
      });
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
        _pagingController.refresh();
        setState(() {
          _isInternetConnected = true;
        });
      }
    });
  }

  void applyFilter(List<dynamic> filterData) {
    _filterData = filterData;
    print(filterData);
    _pagingController.itemList?.clear();
    _pagingController.refresh(); // Refresh the data with the new filter
  }
}
