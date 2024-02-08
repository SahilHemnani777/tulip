import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/follow_up_dialog.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/lead_model/follow_up_model.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/repo/lead_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/customer_detail_page.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/create_lead_page.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/lead_detail_widget.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/lead_list.dart';
import 'package:tulip_app/ui_designs/home_tab/products_catalogue/product_details_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/notifications_util.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/follow_up_widget.dart';
import 'package:tulip_app/widget/no_data_found.dart';

class LeadDetailsPage extends StatefulWidget {
  final String leadId;
  final bool fromCreatePage;
  final bool isCustomer;
  const LeadDetailsPage(
      {Key? key,
      required this.leadId,
      this.fromCreatePage = false,
      this.isCustomer = false})
      : super(key: key);

  @override
  _LeadDetailsPageState createState() => _LeadDetailsPageState();
}

class _LeadDetailsPageState extends State<LeadDetailsPage> {
  bool _isLeadSelected = true;

  LeadDetails? leadData;
  final PagingController<int, FollowUpDetails> _pagingController =
      PagingController(firstPageKey: 1);
  String? userId;
  bool isEdit=false;

  @override
  void initState() {
    super.initState();
    getLeadInfo();
    _initPageController();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromCreatePage || isEdit) {
          Get.off(const LeadListPage());
          return true;
        }
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Lead Details',
          implyStatus: true,
          actions: [
            GestureDetector(
              onTap: () async {
                var result = await Get.to(CreateLeadPage(createLead: leadData));
                if (result != null) {
                  getLeadInfo();
                }
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(Icons.edit)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                        blurRadius: 1,
                        color: const Color(0xffA5A5A5).withOpacity(0.015),
                      )
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isLeadSelected = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isLeadSelected
                                ? Constants.primaryColor
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 1),
                                  color:
                                      const Color(0xffC3C3C3).withOpacity(0.25),
                                  blurRadius: 4,
                                  spreadRadius: 0),
                              BoxShadow(
                                  offset: const Offset(0, -1),
                                  color:
                                      const Color(0xffC3C3C3).withOpacity(0.25),
                                  blurRadius: 4,
                                  spreadRadius: 0),
                            ],
                          ),
                          child: Text(
                            "Lead Details",
                            style: TextStyle(
                                color: _isLeadSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: _isLeadSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() {
                          _isLeadSelected = false;
                        }),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: _isLeadSelected
                                  ? Colors.white
                                  : Constants.primaryColor,
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xffA5A5A5)
                                        .withOpacity(0.25),
                                    offset: const Offset(0, 0),
                                    blurRadius: 4,
                                    spreadRadius: 0)
                              ]),
                          child: Text(
                            "Follow Up",
                            style: TextStyle(
                                color: _isLeadSelected
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: _isLeadSelected
                                    ? FontWeight.w500
                                    : FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _isLeadSelected
                  ? leadData != null
                      ? LeadDetailWidget(
                          leadData: leadData!,
                          convertCustomerClick: convertCustomerClick,
                          isCustomer: widget.isCustomer)
                      : const Center(
                          child: CircularProgressIndicator.adaptive())
                  : _getPaginatedListViewWidget(),
              if (_isLeadSelected)
                Container(
                  margin: EdgeInsets.only(left: 3.w),
                  child: const Text(
                    "Product Info",
                    style: TextStyle(
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (_isLeadSelected)
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: Table(
                      columnWidths: const {
                        0: FractionColumnWidth(0.2), // 20% for Name
                        1: FractionColumnWidth(0.2), // 20% for Product Brand
                        2: FractionColumnWidth(0.2), // 20% for Potential
                        3: FractionColumnWidth(0.3), // 20% for Competitor Usage
                      },
                      border: TableBorder.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      children: [
                        // Header row
                        const TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Text(
                                  'Name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Text(
                                  'Brand',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Text(
                                  'Potential',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Text(
                                  'Competitor Usage',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Data rows
                        if (leadData?.products != null)
                          ...leadData!.products!.map((item) {
                            return productTableWidget(item);
                          }).toList(),
                        // Add more TableRow entries as needed (up to 5)
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
        floatingActionButton: !_isLeadSelected
            ? SizedBox(
                width: 42.w,
                height: 5.h,
                child: FloatingActionButton(
                  backgroundColor: Constants.primaryColor,
                  onPressed: () async {
                    var response = await showDialog(
                        context: context,
                        builder: (context) {
                          return const FollowUpDialog();
                        });
                    if (response != null) {
                      createFollowUp(response[0], response[1],response[2]);
                    }
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      SizedBox(width: 2.w),
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(width: 1.w),
                      const Text(
                        "Add Follow Up",
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  TableRow productTableWidget(Product product) => TableRow(
        children: [
          TableCell(
            child: GestureDetector(
              onTap: () => Get.to(
                  () => ProductDetailPage(productId: product.id ?? ""),
                  transition: Transition.fade),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.productName ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.transparent,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                    decorationThickness: 1.5,
                    shadows: [
                      Shadow(color: Colors.blue, offset: Offset(0, -3))
                    ],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.brandId?.productBrandName ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.potential ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.competitor ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ); // Add more TableRow entries as needed (up to 5)

  Widget _getPaginatedListViewWidget() => SizedBox(
        height: 100.h,
        child: PagedListView<int, FollowUpDetails>(
          shrinkWrap: true,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<FollowUpDetails>(
            itemBuilder: (context, item, index) {
              return FollowUpWidget(
                  followUpDetails: item,
                  backButtonCallback: () async {
                    var response = await showDialog(
                        context: context,
                        builder: (context) {
                          return FollowUpDialog(followUpDetails: item);
                        });
                    if (response != null) {
                      updateFollowUp(response[0], response[1],response[2],item.id ?? "");
                    }
                  },
                  userId: userId!);
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
        ),
      );

  Future<void> getLeadInfo() async {
    var response = await LeadRepo.getLeadDetails(widget.leadId);
    if (response.status) {
      leadData = response.data;
      setState(() {});
    }
  }

  void _initPageController() {
    _pagingController.addPageRequestListener((pageKey) async {
      _fetchPage(pageKey);
    });
  }

  Future<SuperResponse<List<FollowUpDetails>>?> _fetchPage(int pageNo) async {
    try {
      final response =
          await LeadRepo.getFollowUpList(pageNo.toString(), widget.leadId);

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

  Future<void> createFollowUp(String status, String notes,DateTime followUpDate) async {
    //status.contains("Other") ? "Other" : status,
    if (await InternetUtil.isInternetConnected()) {
      ProgressDialog.showProgressDialog(context);

      String userId = await SessionManager.getUserId();
      try {
        Map<String, dynamic> apiKey = {
          "leadId": leadData?.id,
          "followUpDate": followUpDate.toIso8601String(),
          "followUpBy": userId,
          "status": status,
          "followUpNotes": notes
        };

        var response = await LeadRepo.createFollowUp(apiKey);
        if (response.status) {
          Get.back();
          DateTime now = DateTime.now();
          Duration durationUntilFollowUp = followUpDate!.isAfter(now)
              ? followUpDate.difference(now)
              : Duration.zero;

          await NotificationService().scheduleNotification(
              body: "Follow-up with ${leadData?.customerName} \n open to view details.",
              payload: 'FollowUp,${leadData?.id}',
              duration: durationUntilFollowUp,
              channelTitle: "Follow-up Reminder",
              type: NotificationType.SCHEDULED_NOTIFICATION_1);

          isEdit=true;
          context.showSnackBar("Follow Up Created", null);

          _pagingController.refresh();
        } else {
          Get.back();
          context.showSnackBar(response.message!, null);
        }
      } catch (e) {
        Get.back();
        print(e.toString());
        context.showSnackBar("Something went wrong", null);
      }
    } else {
      context.showSnackBar("No Internet Connection", null);
    }
  }

  void updateFollowUp(String status, String notes,DateTime followUpDate, String followUpId) async {
    if (await InternetUtil.isInternetConnected()) {
      ProgressDialog.showProgressDialog(context);

      String userId = await SessionManager.getUserId();
      // try {
        Map<String, dynamic> apiKey = {
          "leadId": leadData?.id,
          "followUpBy": userId,
          "status": status,
          "followUpNotes": notes,
          "followUpDate":followUpDate.toIso8601String()
        };

        var response = await LeadRepo.updateFollowUp(apiKey, followUpId);
        if (response.status) {
          Get.back();
          DateTime now = DateTime.now();
          Duration durationUntilFollowUp = followUpDate!.isAfter(now)
              ? followUpDate.difference(now)
              : Duration.zero;

          await NotificationService().scheduleNotification(
              body: "Follow-up with ${leadData?.customerName}\n open to view details.",
              payload: 'FollowUp,${leadData?.id}',
              duration: durationUntilFollowUp,
              channelTitle: "Follow-up Reminder",
              type: NotificationType.SCHEDULED_NOTIFICATION_1);

          isEdit=true;
          context.showSnackBar("Follow Up Updated", null);

          _pagingController.refresh();
        } else {
          Get.back();
          context.showSnackBar(response.message!, null);
        }
      // } catch (e) {
      //   Get.back();
      //   print(e.toString());
      //   context.showSnackBar("Something went wrong", null);
      // }
    } else {
      context.showSnackBar("No Internet Connection", null);
    }
  }

  Future<void> getUserId() async {
    userId = await SessionManager.getUserId();
    setState(() {});
  }

  void convertCustomerClick() async {
    if (await InternetUtil.isInternetConnected()) {
      ProgressDialog.showProgressDialog(context);

      try {
        var response = await LeadRepo.convertToCustomer(leadData?.id ?? "");
        if (response.status) {
          Get.back();
          context.showSnackBar("Lead is converted to customer", null);
          var result = await Get.to(CustomerDetailsPage(customerId: response.data,fromCreatePage: true,));
          if(result!=null && result){

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LeadDetailsPage(leadId: widget.leadId,fromCreatePage: true,isCustomer: true)));

            _pagingController.refresh();
          }
        } else {
          Get.back();
          context.showSnackBar(response.message!, null);
        }
      } catch (e) {
        Get.back();
        print(e.toString());
        context.showSnackBar("Something went wrong", null);
      }
    } else {
      context.showSnackBar("No Internet Connection", null);
    }
  }
}
