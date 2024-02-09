import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/customer_model/customer_list_model.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/repo/customer_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/create_customer_page.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/customer_detail_page.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/customer_list_details_widget.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/customer_filter_tab.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/customer_search_delegate.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/common_search_bar.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/no_data_found.dart';
import 'package:tulip_app/widget/no_internet_widget.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({Key? key}) : super(key: key);

  @override
  CustomerListPageState createState() => CustomerListPageState();
}

class CustomerListPageState extends State<CustomerListPage> {
  bool _showFilter = false;
  DateTime? fromDate;
  DateTime? toDate;

  final PagingController<int, CustomerListItem> _pagingController =
      PagingController(firstPageKey: 1);
  bool _isInternetConnected = true;
  StreamSubscription? _subscription;
  List<dynamic>? _filterData;

  @override
  void initState() {
    super.initState();
    _initPageController();
    _addInternetConnectionListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Customers', implyStatus: true),
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: CommonSearchBar(
                    title: 'Search Customer',
                    searchButtonCallback: openSearchDelegate,
                    filterButtonCallback: () {
                      _showFilter = !_showFilter;
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 5),
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
              CustomerFilter(
                  updateFilterVisibilityCallback: (bool) {
                    _showFilter = bool;
                    setState(() {});
                  },
                  applyFilterCallback: applyFilter),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          var result = await Get.to(
              transition: Transition.fade,
              const CreateCustomerPage(
                fromCreate: true,
              ));
          print("result is $result");
          if (result != null && true) {
            _pagingController.refresh();
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
    );
  }

  Widget _getPaginatedListViewWidget() => PagedListView<int, CustomerListItem>(
        shrinkWrap: true,
        pagingController: _pagingController,
        padding: EdgeInsets.only(bottom: 10.h),
        builderDelegate: PagedChildBuilderDelegate<CustomerListItem>(
          itemBuilder: (context, item, index) {
            return InkWell(
                onTap: () async {
                  var result = await Get.to(
                      CustomerDetailsPage(
                        customerId: item.id,
                      ),
                      transition: Transition.fade);
                  print("result is $result");
                  if (result != null && true) {
                    _pagingController.refresh();
                  }
                },
                child: CustomerListDetailsWidget(customerListItem: item));
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

  Future<SuperResponse<List<CustomerListItem>>?> _fetchPage(int pageNo) async {
    try {
      final response = await CustomerRepo.getCustomerList(
          pageNo.toString(),
          "",
          _filterData?[0] != null ? _filterData![0] : "",
          _filterData?[1] != null ? _filterData![1] : "");

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
    _pagingController.refresh(); // Refresh the data with the new filter
  }

  Future<void> openSearchDelegate() async {
    final data = await showSearch(
      context: context,
      delegate: CustomerSearchDelegate(false),
    );
  }
}
