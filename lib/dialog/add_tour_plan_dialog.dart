import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/customer_model/get_area_model.dart';
import 'package:tulip_app/repo/tour_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/area_search_delegate.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/location_controller.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_button.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';
import '../model/tour_plan_model/daily_plan_report_model.dart';

class AddTourPlanDialog extends StatefulWidget {
  final bool canEdit;
  final TourPlan? tourPlan;
  final DateTime date;
  final String tourPlanId;
  final String status;
  const AddTourPlanDialog({Key? key, required this.canEdit, this.tourPlan, required this.date, required this.tourPlanId,required this.status})
      : super(key: key);

  @override
  AddTourPlanDialogState createState() => AddTourPlanDialogState();
}

class AddTourPlanDialogState extends State<AddTourPlanDialog> {
  TourPlan? tourPlan;
  TextEditingController areaController=TextEditingController();
  TextEditingController noteController=TextEditingController();
  ActivityTypeData? selectedType;
  String? currentAddress;
  LocationController locationController = Get.find();
  Area? area;
  bool errorText=false;
  bool errorAreaText=false;
  bool isDeviation = true;
  List<ActivityTypeData> activityList=[];
  @override
  void initState() {
    super.initState();
    print(locationController.longitude.value);
    print(locationController.latitude.value);
    if(widget.tourPlan!=null){
      tourPlan=TourPlan.fromJson(widget.tourPlan!.toJson());
      print("Area is ${widget.tourPlan?.area?.toJson()}");
      tourPlan?.area=widget.tourPlan?.area;
      area=widget.tourPlan?.area;
      noteController.text=tourPlan?.note ?? "";
      areaController.text=widget.tourPlan!.area!.townName;
    }
    getActivityTypeList();

  }

  @override
  Widget build(BuildContext context) {
    return  Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 80.w,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  decoration: BoxDecoration(
                      color: const Color(0xffF8F8F8),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),
                      activityList.isNotEmpty?
                      activityTypeWidget():const Center(child: CircularProgressIndicator.adaptive()),

                      if(errorText)
                      const Text("  Select Activity Type",style: TextStyle(
                        color: Colors.red,fontSize: 13
                      ),),


                      SizedBox(height: 1.h),
                       CustomTextFormField(
                        hintText: "Select Area",
                        controller: areaController,
                        onTap: () async {
                            final data = await showSearch(
                              context: context,
                              delegate: AreaSearchDelegate(),
                            );
                            if(data!=null){
                              area=data;
                              tourPlan?.area=data;
                              errorAreaText=false;
                              areaController.text=data!.townName;
                              setState(() {});
                          }

                        },
                        readOnly: true,
                      ),

                      if(errorAreaText)
                        const Text("  Select area",style: TextStyle(
                            color: Colors.red,fontSize: 13
                        ),),

                      CustomTextFormField(
                        hintText: "Add Note",
                        maxLines: 3,
                        controller: noteController,
                      ),


                      // if(area!=null)
                      // Text("Station Type : ${area?.stationTypeId?.stationTypeName}",
                      // style: const TextStyle(
                      //   fontSize: 13
                      // ),),

                      const SizedBox(height: 5),

                      if(area!=null)
                        Text("Full address: ${area?.townName}, ${area?.districtId?.districtName}, ${(area?.districtId?.stateId?.stateName !=null) ?  "${area?.districtId?.stateId?.stateName}," : ""}${area?.pinCode}",
                            style: const TextStyle(
                                fontSize: 13
                            )),

                      if (widget.canEdit && widget.status=="Approved")
                        ListTileTheme(
                          contentPadding: const EdgeInsets.only(right: 8),
                          horizontalTitleGap: 0,
                          child: CheckboxListTile(
                              dense: true,
                              title: const Text(
                                "Deviation",
                                style: TextStyle(fontSize: 14),
                              ),
                              value: isDeviation,
                              visualDensity: const VisualDensity(
                                  horizontal: -2, vertical: -4),
                              onChanged: (val) {
                                // isDeviation = !isDeviation;
                                // setState(() {});
                              }),
                        ),


                      CustomButton(title: "Add Travel Plan",onTabButtonCallback: addTourPlanClick)
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffF8F8F8),
                      ),
                      child: const Icon(Icons.close, color: Color(0xff009EE0))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget activityTypeWidget()=>DropdownButtonHideUnderline(
    child: DropdownButtonFormField(
      decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontSize: 14,
          ),
          hintText: "Select Activity Type",
          fillColor: Colors.white,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 1.2.h,horizontal: 3.w),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Constants.lightGreyBorderColor)),
          focusedErrorBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: Constants.lightGreyBorderColor)),
          errorBorder:   OutlineInputBorder(
              borderSide: BorderSide(color: Constants.lightGreyBorderColor)),
          focusedBorder:   OutlineInputBorder(
            borderSide: BorderSide(color: Constants.lightGreyBorderColor),
          ),
          disabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: Constants.lightGreyBorderColor),
          ) ,
      ),
      value: selectedType,
      isExpanded: true,
      items: activityList.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item.activityTypeName ?? ""),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedType = newValue!;
          print(selectedType);
          tourPlan?.activityType=selectedType;
          errorText=false;
        });
      },
    ),
  );

  Future<void> addTourPlanClick() async {
    if(await InternetUtil.isInternetConnected()){
      ProgressDialog.showProgressDialog(context);
     if(selectedType==null){
       Get.back();
       errorText=true;
       setState(() {
       });
     }else if(area?.id ==null && widget.tourPlan?.area?.id==null){
       Get.back();
       errorAreaText=true;
       setState(() {
       });
     }
     else{
       errorText=false;
       errorAreaText=false;
       try{

         String userId=await SessionManager.getUserId();
         Map<String, dynamic> body= {
           "tourPlanVisitId": tourPlan?.id,
           "tourPlanId": widget.tourPlanId,
           "activityType": selectedType?.id ?? tourPlan?.activityType?.id,
           "area": area?.id ?? widget.tourPlan?.area?.id,
           "notes": noteController.text,
           "date": DateUtil.getServerFormatDateString(widget.date),
           "userId": userId,
           if (widget.canEdit && widget.status=="Approved")
             "deviatedVisitId": tourPlan?.id,
           if (widget.canEdit && widget.status=="Approved")
             "isDeviation": isDeviation,
           "coordinates": [
             {
               "status": "Created",
               if(!widget.canEdit)
                 "geoLocation": {
                   "type": "Point",
                   "address": locationController.currentAddress.value,
                   "coordinates": [
                     locationController.latitude.value,
                     locationController.longitude.value
                   ]
                 },
               "createdAt": "${DateTime.now()}"
             }
           ],
         };

         print("Body is here${jsonEncode(body)}");

         var result = await TourMasterRepo.addUpdateTourPlan(body);

         if(result.status){
           Get.back();
           Get.back(result: [result.data,widget.date]);
           context.showSnackBar("Tour Plan Added",null);
         }
         else{
           context.showSnackBar("${result.message}",null);
           Get.back();

         }

       }
       catch(e){
         print("Error : ${e.toString()}");
         Get.back();

         context.showSnackBar("${e.toString()}",null);
       }
     }
    }
    else{
      context.showSnackBar("No Internet Connection",null);
    }
  }


  Future<void> getActivityTypeList() async {
    var result = await TourMasterRepo.getActivityType();

    if(result.status){
      activityList=result.data?? [];
      setState(() {
      if(widget.tourPlan!=null){
        selectedType = activityList.firstWhere((element) => element.id == widget.tourPlan?.activityType?.id);
      }
      });
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    noteController.dispose();
    areaController.dispose();
  }
}
