import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/expense_model/expense_list_model.dart';
import 'package:tulip_app/repo/expense_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/my_expense_pages/expense_details_page.dart';
import 'package:tulip_app/ui_designs/home_tab/my_expense_pages/expense_filter_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/no_data_found.dart';
import 'package:tulip_app/widget/no_internet_widget.dart';

class MyExpenseList extends StatefulWidget {
  const MyExpenseList({Key? key}) : super(key: key);

  @override
  MyExpenseListState createState() => MyExpenseListState();
}

class MyExpenseListState extends State<MyExpenseList> {
  bool _showFilter = false;
  List<ExpenseList> expenseList = [];
  bool _isInternetConnected = true;
  List<dynamic>? _filterData;
  bool _isLoading = true;
  StreamSubscription? _subscription;

  List<String> monthList = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];
  List<String> yearList = [];


  String selectedYear = DateTime.now().year.toString();

  @override
  void initState() {
    super.initState();
    _addInternetConnectionListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Expenses Management',implyStatus: true,
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
        ],),
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
                const SizedBox(height: 5),

                _isInternetConnected
                    ? !_isLoading
                    ? expenseList.isNotEmpty
                    ? Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      expenseList.clear();
                      _fetchPage();
                    },
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 2.h),
                        itemCount: expenseList.length,
                        itemBuilder:
                            (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () async {
                                var result = await Get.to(ExpenseDetailsPage(
                                    expenseListData: expenseList[index], status: expenseList[index].status,)
                                );
                                if(result !=null && result){
                                  expenseList.clear;
                                  _fetchPage();
                                }
                              },
                              child: _expensePlanCardWidget(expenseList[index],index));
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
            if(_showFilter)
              Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
              ),
            if (_showFilter) ExpenseFilterPage(selectedFilter: _filterData,
              applyFilterCallback: applyFilter,
              updateFilterVisibilityCallback: (bool visibility) {
                setState(() {
                  _showFilter = visibility; // Update _showFilter
                });
              },),
          ],
        ),
      ),
      // floatingActionButton: GestureDetector(
      //   onTap: () {
      //     Get.to(
      //       const CreateExpensePage(),
      //       transition: Transition.fade,
      //     );
      //   },
      //   child: Container(
      //     decoration: const BoxDecoration(
      //         color: Constants.primaryColor,
      //         borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(15),
      //             topRight: Radius.circular(15),
      //             bottomLeft: Radius.circular(15))),
      //     padding: const EdgeInsets.all(10),
      //     child: const Icon(Icons.add, color: Colors.white, size: 35),
      //   ),
      // ),
    );
  }





  Widget _expensePlanCardWidget(ExpenseList item,int index) => Container(
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
          bottomRight: Radius.circular(20),topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(8),topRight: Radius.circular(8),
        )),
    child: Row(
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: Container(
            alignment: Alignment.bottomCenter,
            width:50.w,
            margin: EdgeInsets.only(bottom: 3.w),
            padding: EdgeInsets.symmetric(vertical: 0.5.h),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Constants.lightGreyBorderColor))),
            child: Text("${monthList[item.tourPlanDate!.month-1].toUpperCase()} ${DateTime.now().year}",textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 17,fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),


        Expanded(
          child: Column(
            children: [
              _expenseTextField(
                  "assets/other_images/requested_icon.png",
                  "Requested To",
                  item.requestedTo ?? "",
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
                      color: Constants.lightGreyColor,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    decoration: BoxDecoration(
                        color: item.status == "Approved" ? Colors.green : item.status =="Rejected"? Colors.red : Colors.blue, // Use index to determine the color
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(
                    item.status ?? "", // Use index to determine the text
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white
                      ),),
                  ),
                ],
              ),
              if(item.notes!=null && item.notes!.isNotEmpty)
              SizedBox(height: 1.5.h),

              if(item.notes!=null && item.notes!.isNotEmpty)
              _expenseTextField(
                  "assets/other_images/note_icon.png",
                  "Notes",
                  item.notes ?? "",
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
                      color: Constants.lightGreyColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Payment Status : ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    decoration: BoxDecoration(
                        color: item.paymentStatus == true ? Colors.green: Colors.red, // Use index to determine the color
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(
                      item.paymentStatus == true ? "Paid" : "Unpaid", // Use index to determine the text
                      style: TextStyle(
                          fontSize: 13,
                          color:Colors.white
                      ),),
                  ),



                ],
              ),

              SizedBox(height: 1.5.h),

              _expenseTextField(
                  "assets/expense_page_icon/amount_icon.png",
                  "Grand Total",
                  "₹ ${item.grandTotal?.toStringAsFixed(2)}",
                  ""),
            ],
          ),
        )


      ],
    ),
  );


  Widget _expenseTextField(String imagePath, String title, String date, String time) => Row(
    children: [
      Image.asset(
        imagePath,
        height: 15,
        width: 15,
        color: title == "To" || title == "From" ? null : Constants.lightGreyColor,
      ),
      const SizedBox(width: 10),
      Text(
        "$title : ",
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      Expanded(child: Text("$date   $time",style: const TextStyle(
        fontSize: 13,
      ),)),
    ],
  );

  //
  // void generateYearList() {
  //   final currentYear = DateTime.now().year;
  //   for (int i = currentYear; i >= currentYear - 10; i--) {
  //     yearList.add(i.toString());
  //   }
  // }


  Future<void> _fetchPage() async {

    var result = await ExpenseRepo.getExpenseList(
      _filterData?[0] != null && _filterData![0].length != 0
          ? _filterData![0]
          .map((dynamic item) => item.replaceAll(' ', ''))
          .toList()
          : [],
        _filterData?[1] != null ? _filterData![1] : DateTime.now().year.toString(),
    );
    if (result.status) {
      if (result.data != null) {
        expenseList = result.data ?? [];
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
    }else{
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


  void applyFilter(List<dynamic> filterData) {
    _filterData = filterData;
    _fetchPage();
    setState(() {

    });
  }

}
