import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/add_miscellaneous_expense.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/dcr_model/dcr_list_model.dart';
import 'package:tulip_app/model/expense_model/expense_details_list.dart';
import 'package:tulip_app/model/expense_model/setting_model.dart';
import 'package:tulip_app/repo/expense_repo.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/date_util_ext.dart';

import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/util/storage_utils_ext.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'travel_details_list_item.dart';

class AddFileExpensePage extends StatefulWidget {
  final ExpenseDetailsList? expenseDetails;
  final String? updateId;
  final String? stationTypeId;
  final DCRArea? dcrArea;
  final double distance;
  final String dcrId;
  final DateTime tourPlanVisitDate;
  const AddFileExpensePage(
      {Key? key,
      this.stationTypeId,
      this.dcrArea,
      required this.tourPlanVisitDate,
      required this.distance,
      this.expenseDetails,
      required this.dcrId,
      this.updateId})
      : super(key: key);

  @override
  _AddFileExpensePageState createState() => _AddFileExpensePageState();
}

class _AddFileExpensePageState extends State<AddFileExpensePage> {
  String selectedValue = "One Way"; // Variable for the selected value
  bool isEdit = false;
  bool updateExpense = false;
  ExpenseDetailsList expenseDetails = ExpenseDetailsList(
      id: "",
      miscellaneousExpenses: [],
      travelBills: [],
      standardFareChart: []);
  SettingDetails? settingDetails;
  SettingDetails? expenseSettingDetails;
  final picker = ImagePicker();

  List<StandardFareChart>? standardFareAddress;
  List<dynamic> travelDocuments = [];
  @override
  void initState() {
    super.initState();
    if (widget.expenseDetails != null) {
      updateExpense = true;
      expenseDetails =
          ExpenseDetailsList.fromJson(widget.expenseDetails!.toJson());
      // if(widget.expenseDetails?.standardFareChart.first?.distance !=null && widget.expenseDetails!.standardFareChart.first!.distance! > 200){
      //   fairValue = widget.expenseDetails?.standardFareChart.first?.fare;
      // }
    } else {
      expenseDetails = ExpenseDetailsList(
          id: "",
          miscellaneousExpenses: [],
          travelBills: [],
          standardFareChart: []);
    }
    getSettingDetails();
    getExpenseSettingDetails();
    getStandardFareDetails();
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
              'Travel Details for ${widget.tourPlanVisitDate.getDisplayFormatDate()}',
          implyStatus: true,
        ),
        body: Container(
          margin: EdgeInsets.only(right: 3.w, left: 3.w, top: 2.h),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
          ]),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        _titleFieldWidget("Miscellaneous Expense"),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            var result = await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return const AddMiscellaneousExpense();
                                });
                            if (result != null) {
                              expenseDetails.miscellaneousExpenses?.add(result);
                              setState(() {});
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 1.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Constants.primaryColor),
                            child: const Row(
                              children: [
                                Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(Icons.add, size: 18, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3.w,
                        )
                      ],
                    ),
                    if (expenseDetails.miscellaneousExpenses != null &&
                        expenseDetails.miscellaneousExpenses!.isNotEmpty)
                      tableWidget(expenseDetails.miscellaneousExpenses!),
                    Row(
                      children: [
                        _titleFieldWidget("Upload Travel Documents"),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                                isDismissible: true,
                                context: context,
                                builder: (context){
                                  return bottomSheetWidget();
                                });

                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 1.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Constants.primaryColor),
                            child: const Row(
                              children: [
                                Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(Icons.add, size: 18, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                      ],
                    ),
                    if (expenseDetails.travelBills != null &&
                        expenseDetails.travelBills!.isNotEmpty)
                      SizedBox(
                        height: 10.h,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          children: buildSelectedImagesRow(
                              expenseDetails.travelBills ?? []),
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Text(
                        "Upload pictures/files of bills related to travel e.g. Food, petrol, bus ticket, train ticket etc.",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black.withOpacity(0.50),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    const Divider(color: Colors.black),
                    SizedBox(height: 2.h),
                    _titleFieldWidget("Standard Fare Chart (SFC)"),
                    standardFareAddress != null
                        ? sfcListWidget()
                        : const Center(
                            child: CircularProgressIndicator.adaptive()),
                    SizedBox(height: 9.h),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onSubmitClick,
                child: Container(
                  width: 100.w,
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: Constants.buttonGradientColor),
                  child: const Text(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xfffefcf3),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _travelDetailTextWidget(
          String imagePath, String title, String title2) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 13,
              width: 13,
            ),
            Text(
              "  $title : ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Expanded(
              child: Text(
                title2,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      );
  List<Widget> buildSelectedImagesRow(List<dynamic> selectedImages) {
    return selectedImages.asMap().entries.map((entry) {
      final int index = entry.key;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            if (!selectedImages[index].contains("http") &&
                    selectedImages[index].contains("png") ||
                selectedImages[index].contains("jpg") ||
                selectedImages[index].contains("jpeg"))
              SizedBox(
                height: 100,
                width: 100,
                child:
                    Image.file(File(selectedImages[index]), fit: BoxFit.fill),
              ),
            if (selectedImages[index].contains("http"))
              SizedBox(
                height: 100,
                width: 100,
                child: CachedNetworkImage(
                  imageUrl: selectedImages[index],
                  fit: BoxFit.fill,
                ),
              ),
            if (selectedImages[index].contains("pdf") ||
                selectedImages[index].contains("xlsr") ||
                selectedImages[index].contains("docx"))
              const SizedBox(
                  height: 100, width: 100, child: Icon(Icons.picture_as_pdf)),
            if (selectedImages[index].contains("mp4"))
              const SizedBox(
                  height: 50, width: 50, child: Icon(Icons.video_call)),
            GestureDetector(
              onTap: () {
                selectedImages.removeAt(index);
                setState(() {});
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: const Icon(
                  Icons.clear,
                  size: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget sfcListWidget() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: standardFareAddress?.length,
      itemBuilder: (context, index) {

        return TravelDetailItem(
            standardFareAddress: standardFareAddress![index],
            way: standardFareAddress![index].oneWay ?? selectedValue,
            updateExpense: updateExpense,
            updateFair: standardFareAddress?[index].fair,
            updateFairPrice: (double value) {
              setState(() {
                standardFareAddress?[index].fair = value; // Update _showFilter
              });
            },
            distance: standardFareAddress?[index].distanceKms ?? 0,
            fair: standardFareAddress?[index].activityType?.isExpense == true && standardFareAddress?[index].stationType?.toLowerCase() != "hq"
                ? (settingDetails?.fare ?? 0.0)
                : 0,
            updateRouteWay: (String value) {
              setState(() {
                selectedValue = value; // Update _showFilter
              });
            },
            totalAllowance:
                standardFareAddress?[index].activityType?.isExpense == true || standardFareAddress?[index].stationType?.toLowerCase() != "hq"
                    ? getAllowance(
                        standardFareAddress?[index].stationType ?? "", index)
                    : 0,
            threadHold: settingDetails?.fareThreshold ?? 0);
      });

  Widget _titleFieldWidget(String title) => Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        child: Container(
          margin: EdgeInsets.only(left: 1.w),
          child: Text(
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
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );

  Widget tableWidget(List<MiscellaneousExpense?> item) => Container(
        margin: const EdgeInsets.all(8.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(0.7),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(54),
            3: FixedColumnWidth(84),
          },
          border: TableBorder.all(),
          children: [
            // Header row
            const TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Amount'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Description'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Edit'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Remove'),
                ),
              ],
            ),
            // Data rows
            ...item.map((point) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      point?.amount.toString() ?? "",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      point?.description != null &&
                              point!.description!.isNotEmpty
                          ? point.description ?? ""
                          : 'N/A',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () async {
                      var result = await showDialog(
                          context: context,
                          builder: (context) {
                            return AddMiscellaneousExpense(
                                miscellaneousExpense: point);
                          });
                      if (result != null) {
                        int index = expenseDetails.miscellaneousExpenses!
                            .indexOf(point!);
                        if (index != -1) {
                          expenseDetails.miscellaneousExpenses?[index] = result;
                        }
                      }
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        item.remove(point);
                      });
                    },
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      );

  Widget bottomSheetWidget()=>Container(
    margin: EdgeInsets.only(left: 5.w,top: 2.h),
    width: 100.h,
    height: 17.h,
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Upload Image",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () async {
                    final pickedFile = await picker.pickImage(source: ImageSource.camera);
                    if(pickedFile?.path !=null){
                      // print("asdasads${pickedFile!.path}");
                      expenseDetails.travelBills?.add(pickedFile?.path);
                      setState(() {

                      });

                    }
                    context.pop();
                  },
                  child: bottomSheetButton("Take Photo","assets/profile_images/camera.png")),
              GestureDetector(
                  onTap: () async {
                    await _openFilePicker(
                        expenseDetails.travelBills ?? []);
                    context.pop();
                  },
                  child: bottomSheetButton("Select from Gallery", "assets/profile_images/gallery.png")),
            ],
          )
        ]
    ),
  );
  Widget bottomSheetButton(String title, String imagePath)=>Container(
    margin: EdgeInsets.only(top: 2.h),
    decoration: const BoxDecoration(
    ),
    child: Column(
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Constants.primaryColor
            ),
            child: Image.asset(imagePath,height: 4.h,width: 8.w,color: Colors.white)),
        const SizedBox(height: 5),
        Text(title,style: const TextStyle(
          fontSize: 15,
        ),),

      ],
    ),
  );


  Future<bool> _openFilePicker(List<dynamic> listData) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          for (var i in result.paths) {
            listData.add(i);
          }
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Error while picking files: $e');
      return false;
    }
  }

  Future<void> onSubmitClick() async {
    if (await InternetUtil.isInternetConnected()) {
      ProgressDialog.showProgressDialog(context);

      if (widget.distance > (settingDetails?.fareThreshold ?? 0) &&
          expenseDetails.travelBills!.isEmpty) {
        context.showSnackBar("Please add travel document", null);
        Get.back();
      } else {
        try {
          List<dynamic> travelDocumentUploaded = [];

          for (var image in expenseDetails.travelBills ?? []) {
            if (image.contains("http")) {
              travelDocumentUploaded.add(image);
            }
            else {
              var result = await File(image).uploadFileToFirebase(
                  "Travel Documents/${DateUtil.getCurrentTimeStamp()}.png");
              travelDocumentUploaded.add(result);
            }
          }

          String userId = await SessionManager.getUserId();
          double miscellaneousExpensesTotal = expenseDetails
              .miscellaneousExpenses!
              .fold(0.0, (sum, expense) => sum + (expense.amount ?? 0));
          double sumOfFairAndTotalAllowance =
              standardFareAddress!.fold(0, (sum, item) {
            if (item.activityType != null && item.activityType!.isExpense == true || item.stationType?.toLowerCase() !="hq") {
              return sum + (item.fair ?? 0) + (item.totalAllowance ?? 0);
            } else {
              return sum;
            }
          });

          Map<String, dynamic> requestBody = {
            "_id": widget.updateId,
            'dcrId': widget.dcrId,
            "grandTotal": (sumOfFairAndTotalAllowance + miscellaneousExpensesTotal).toStringAsFixed(2),
            "miscellaneousExpenses": expenseDetails.miscellaneousExpenses,
            "travelBills": travelDocumentUploaded,
            // "standardFareChart": standardFareAddress,
            "standardFareChart": standardFareAddress
                ?.map((address) => {
                      "from": address.from,
                      "to": address.to,
                      "stationType": address.stationType,
                      "distanceKms": address.distanceKms,
                      "totalAllowance": address.activityType?.isExpense == true || address.stationType?.toLowerCase() != "hq"
                          ? address.totalAllowance
                          : 0,
                      "fair": address.activityType?.isExpense == true && address.stationType?.toLowerCase() != "hq"
                          ? address.fair
                          : 0,
                      "oneWay": address.oneWay,
                      "tourPlanVisitId": address.tourPlanVisitId?.id,
                      "area":
                          address.area?.id, // Extracting only the id property
                    })
                .toList(),
            "userId": userId,
          };

          log(jsonEncode(requestBody));

          var response = await ExpenseRepo.addFileExpense(requestBody);
          if (response.status) {
            context.showSnackBar(
                widget.expenseDetails != null
                    ? "Expense Updated"
                    : "Expense Added",
                null);
            Get.back();
            Get.back(result: true);
          } else {
            Get.back();
            context.showSnackBar(
                "Something went wrong ${response.message}", null);
          }
        } catch (e) {
          Get.back();
          context.showSnackBar("Exception $e", null);
        }
      }
    } else {
      context.showSnackBar("No Internet Connection", null);
    }
  }

  double getAllowance(String stationType, index) {
    if (stationType.toLowerCase() == "hq") {
      standardFareAddress?[index].totalAllowance = expenseSettingDetails?.hqAllowance;
      return standardFareAddress?[index].totalAllowance ?? 0;
    } else if (stationType.toLowerCase() == "os") {
      standardFareAddress?[index].totalAllowance = expenseSettingDetails?.osAllowance;
      return standardFareAddress?[index].totalAllowance ?? 0;
    } else {
      standardFareAddress?[index].totalAllowance =
          expenseSettingDetails?.exHqAllowance;
      return standardFareAddress?[index].totalAllowance ?? 0;
    }
  }

  void getExpenseSettingDetails() async {
    var result = await ExpenseRepo.getExpenseDataCalculation();
    if (result.status) {
      expenseSettingDetails = result.data;

      setState(() {});
    } else {
      context.showSnackBar("${result.message}", null);
    }
  }
  void getSettingDetails() async {
    var result = await ExpenseRepo.getSettingDetails();
    if (result.status) {
      settingDetails = result.data;

      setState(() {});
    } else {
      context.showSnackBar("${result.message}", null);
    }
  }

  void getStandardFareDetails() async {
    var result = await ExpenseRepo.getAddress(widget.tourPlanVisitDate);
    if (result.status) {
      if (widget.expenseDetails == null) {
        standardFareAddress = result.data;
      } else {
        print("here Im a");
        standardFareAddress = widget.expenseDetails?.standardFareChart ?? [];
      }
      setState(() {});
    } else {
      context.showSnackBar("${result.message}", null);
    }
  }

}
