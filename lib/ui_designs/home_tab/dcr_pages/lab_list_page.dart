import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/common_alert_dialog.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/dcr_model/dcr_log_report.dart';
import 'package:tulip_app/repo/dcr_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/dcr_pages/add_area_details_form.dart';
import 'package:tulip_app/ui_designs/home_tab/dcr_pages/date_wise_area_list.dart';
import 'package:tulip_app/ui_designs/home_tab/dcr_pages/dcr_list.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/no_data_found.dart';

import 'sales_visit_details.dart';

class LabListPage extends StatefulWidget {
  final String tourPlanVisitId;
  final String? dcrId;
  final String areaName;
  final String? status;
  final bool isExpenseCreated;
  const LabListPage({Key? key, required this.tourPlanVisitId, this.dcrId, required this.areaName, this.status, required this.isExpenseCreated}) : super(key: key);

  @override
  LabListPageState createState() => LabListPageState();
}

class LabListPageState extends State<LabListPage> {
  List<DCRLogReportsModel> dcrLogList=[];
  bool _isLoading=true;
  @override
  void initState() {
    super.initState();
    getDcrList();
    print("Lab list DCR Log Id ${widget.dcrId}");
    print("Lab list DCR Log Id ${widget.status}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(dcrLogList.isNotEmpty) {
          Get.to(DateWiseAreaListPage(selectedDate: dcrLogList.first.tourPlanVisitDate!,dcrId: widget.dcrId,));
        }
        else{
          Get.back();
        }
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: "${widget.areaName} Customer Visits",implyStatus: true,
        ),
        body: !_isLoading ? dcrLogList.isNotEmpty ?  ListView.builder(
            itemCount: dcrLogList.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
              DCRLogReportsModel item=dcrLogList[index];
          return SessionManager.userDesignation == "Service Engineer"  ? salesVisitListItem(item) : customerVisitListItem(item);
        }): const Center(child: NoDataFound()):const Center(child: CircularProgressIndicator.adaptive(),),


        floatingActionButton: !widget.isExpenseCreated ? GestureDetector(
          onTap: (){
            Get.to(()=> AddAreaReportForm(tourPlanVisitId: widget.tourPlanVisitId,
                dcrId: widget.dcrId,areaName: widget.areaName),
            transition: Transition.fade);
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
        ) : null,

      ),
    );
  }

  Widget labFieldWidget(
      String title, String details) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40.w,
            child: Text(
              "$title : ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(details)),
        ],
      );


  ///Don't delete
  Widget customerVisitListItem(DCRLogReportsModel item)=>Container(
    margin: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3.w),
    padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3.w),
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: const Color(0xffC3C3C3)
                  .withOpacity(0.25),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, 1)),
          BoxShadow(
              color: const Color(0xffC3C3C3)
                  .withOpacity(0.25),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, -1)),
        ]
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40.w,
              child: const Text(
                "Customer Name : ",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
             Expanded(child: Text(item.customerName ?? "")),


            if(!widget.isExpenseCreated)
              GestureDetector(
              onTap: () async {
                var result = await showDialog(context: context, builder: (context){
                  return const CommonDialog(title: 'Alert', message: 'Are you want to delete DCR?',
                    positiveButtonText: 'Yes', negativeButtonText: 'No',);
                });
                if(result!=null && result){
                  deleteDcr(item.id!);
                }
                },
              child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(7)),
                  child: Icon(
                    Icons.delete,
                    size: 15,
                    color: Constants.white,
                  )),
            ),

              GestureDetector(
              onTap: (){
                getDcrLogDetails(item.id!);
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(7)),
                  child: Icon(
                    widget.isExpenseCreated ? Icons.remove_red_eye : Icons.edit,
                    size: 15,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
        if(item.visitedWith !=null)
        labFieldWidget("Visited With ", item.visitedWith ?? ""),
        if(item.visitTime != null && item.visitTime!.isNotEmpty)
          labFieldWidget("Time of Visit",item.visitTime ?? ""),
        if(item.pob !=null && item.pob! > 0)
        labFieldWidget("POB's",item.pob.toString()),
        if(item.demos !=null && item.demos! > 0)
        labFieldWidget("Demos",item.demos.toString()),
          if(item.conversions !=null && item.conversions! > 0)
            labFieldWidget("Conversions",item.conversions.toString()),
      ],
    ),
  );


  Widget salesVisitListItem(DCRLogReportsModel item)=>Container(
    margin: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3.w),
    padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3.w),
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: const Color(0xffC3C3C3)
                  .withOpacity(0.25),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, 1)),
          BoxShadow(
              color: const Color(0xffC3C3C3)
                  .withOpacity(0.25),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, -1)),
        ]
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40.w,
              child: const Text(
                "Customer Name :",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
             Expanded(child: Text(item.customerName ?? "")),

            if(!widget.isExpenseCreated)
              GestureDetector(
              onTap: (){
                deleteDcr(item.id!);
              },
              child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(7)),
                  child: Icon(
                    Icons.delete,
                    size: 15,
                    color: Constants.white,
                  )),
            ),
          ],
        ),
        if(item.visitTime != null && item.visitTime!.isNotEmpty)
          labFieldWidget("Time",item.visitTime ?? ""),
        labFieldWidget("Comment",item.comment ?? ""),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if(!widget.isExpenseCreated)
            GestureDetector(
                onTap: (){
                  getDcrLogDetails(item.id!);
                },
                child: editAndViewButtonWidget("Edit Details",null)),
            GestureDetector(
                onTap: (){
                  onViewClickDcrLogDetails(item.id!);
                },
                child: editAndViewButtonWidget("View Details",Icons.arrow_forward)),
          ],
        ),
      ],
    ),
  );

  Widget editAndViewButtonWidget(String title,IconData? icon)=>Container(
    margin: EdgeInsets.only(top: 1.h,bottom: 0.8.h),
    width: 30.w,
    height: 4.h,
    decoration: BoxDecoration(
        color: icon!=null ? Constants.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
              color: const Color(0xffC3C3C3).withOpacity(0.30),
              offset: const Offset(0, 0),
              spreadRadius: 3,
              blurRadius: 2),
        ]
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text("$title ",
          style: TextStyle(
              color: icon==null ? Constants.primaryColor : Colors.white,
              fontSize: 13
          ),),
        if(icon!=null)
        Icon(icon,size: 15,color: Colors.white,),
      ],
    ),
  );


  Future<void> getDcrList() async {
    var response = await DCRRepo.getDCRLogReport(widget.tourPlanVisitId);
    if(response.status){
      dcrLogList = response.data ?? [];
      setState(() {
        _isLoading=false;
      });
    }
  }

  Future<void> getDcrLogDetails(String dcrLogId) async {
    var response = await DCRRepo.getDCRLogDetails(dcrLogId);
    if(response.status){
      if(response.data!=null){
        Get.to(()=>AddAreaReportForm(tourPlanVisitId: widget.tourPlanVisitId,
            dcrLogId: dcrLogId,
            dcrReportData: response.data,
            areaName: widget.areaName,
            dcrId: widget.dcrId,
            isExpenseCreated: widget.isExpenseCreated),
            transition: Transition.fade);
      }
      else{
        context.showSnackBar("Something went wrong",null);
      }

    }
  }


  Future<void> onViewClickDcrLogDetails(String dcrLogId) async {
    var response = await DCRRepo.getDCRLogDetails(dcrLogId);
    if(response.status){
      if(response.data!=null){
        Get.to(()=> SalesVisitDetails(dcrData: response.data!),transition: Transition.fade);
      }
      else{
        context.showSnackBar("Something went wrong",null);
      }

    }
  }


  Future<void> deleteDcr(String dcrId) async {
    if(await InternetUtil.isInternetConnected()){
      ProgressDialog.showProgressDialog(context);
      var response =await DCRRepo.deleteDCR(dcrId);
      if(response.status){
        Get.back();
        context.showSnackBar("Deleted Successfully", null);
        getDcrList();
      }
      else{
        Get.back();
        context.showSnackBar("Something went wrong", null);

      }
    }else {
      context.showSnackBar("No Internet Connection", null);
    }
  }

}
