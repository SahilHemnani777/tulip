import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/lead_list_model.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/repo/lead_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/create_lead_page.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/lead_card_widget.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/lead_details_page.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/lead_filter_page.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/lead_search_delegate.dart';
import 'package:tulip_app/ui_designs/home_tab/menu_pages/dashboard_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/location_controller.dart';
import 'package:tulip_app/widget/common_search_bar.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/no_data_found.dart';
import 'package:tulip_app/widget/no_internet_widget.dart';

class LeadListPage extends StatefulWidget {
  const LeadListPage({Key? key}) : super(key: key);

  @override
  _LeadListPageState createState() => _LeadListPageState();
}


class _LeadListPageState extends State<LeadListPage> {

  bool _showFilter = false;

  final PagingController<int, LeadItemInfo> _pagingController =
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
    return WillPopScope(
      onWillPop: () async {
        Get.to(const DashBoardPage());
        return true;
      },
      child: Scaffold(
        appBar: const CustomAppBar(
            title: 'Lead',implyStatus: true),
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
                      searchButtonCallback: openSearchDelegate,
                      title: 'Search lead by name',
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
              if(_showFilter)
              Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
              ),
              if (_showFilter) LeadFilterPage( selectedFilter: _filterData,
                applyFilterCallback: applyFilter, updateFilterVisibilityCallback: (bool visibility) {
                  setState(() {
                    _showFilter = visibility; // Update _showFilter
                  });
                },),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () async {
            var result = await Get.to(const CreateLeadPage(),
              transition: Transition.fade
            );
            print("Result is asd ad $result");
            if(result!=null && result){
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
      ),
    );
  }

  Widget _getPaginatedListViewWidget() => PagedListView<int, LeadItemInfo>(
    shrinkWrap: true,
    pagingController: _pagingController,
    padding: EdgeInsets.only(bottom: 10.h),
    builderDelegate: PagedChildBuilderDelegate<LeadItemInfo>(
      itemBuilder: (context, item, index) {
        return InkWell(
            onTap: () async {

              var result = await Get.to(LeadDetailsPage(leadId: item.id,
                  isCustomer: item.isCustomer!),
                  transition: Transition.fade
              );
              print("Result is $result");
              if(result!=null && result){
                _pagingController.refresh();
              }
            },
            child: LeadCardWidget(leadItemInfo: item));
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



  void _initPageController() {
    _pagingController.addPageRequestListener((pageKey) async {
      if (await InternetUtil.isInternetConnected()) {
        _fetchPage(pageKey);
      }
    });
  }

  Future<SuperResponse<List<LeadItemInfo>>?> _fetchPage(int pageNo) async {
    try {
      final response = await LeadRepo.getLeadList(
          pageNo.toString(),
          "",
          _filterData?[0] != null && _filterData![0].length != 0
              ? _filterData![0]
              .map((dynamic item) => item.replaceAll(' ', ''))
              .toList()
              : [],
          _filterData?[1] != null ? _filterData![1] : null,
          _filterData?[2] != null ? _filterData![2] : null);

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
  // }

  Future<void> openSearchDelegate() async {
    final data = await showSearch(
      context: context,
      delegate: LeadSearchDelegate(),
    );
  }
}

