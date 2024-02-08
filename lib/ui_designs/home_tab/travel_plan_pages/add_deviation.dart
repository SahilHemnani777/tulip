import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/customer_model/get_area_model.dart';
import 'package:tulip_app/model/tour_plan_model/daily_plan_report_model.dart';
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
import 'package:tulip_app/widget/fetch_location_message.dart';

class AddDeviation extends StatefulWidget {
  final DateTime date;
  final String id;
  final String tourPlanId;
  final String status;
  const AddDeviation({Key? key, required this.date, required this.tourPlanId,  required this.status, required this.id})
      : super(key: key);

  @override
  AddDeviationState createState() => AddDeviationState();
}

class AddDeviationState extends State<AddDeviation> {
  TextEditingController areaController=TextEditingController();
  TextEditingController noteController=TextEditingController();
  ActivityTypeData? selectedType;
  Area? area;
  LocationController locationController = Get.find();
  bool isDeviation = true;
  bool errorText=false;
  bool errorAreaText=false;

  List<ActivityTypeData> activityList=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                        Text("  Select Activity Type",style: TextStyle(
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
                      //   Text("Station Type : ${area?.stationTypeId?.stationTypeName}",
                      //     style: const TextStyle(
                      //         fontSize: 13
                      //     ),),

                      const SizedBox(height: 5),

                      if(area!=null)
                        Text("Full address: ${area?.townName}, ${area?.districtId?.districtName}, ${area?.districtId?.stateId?.stateName}, ${area?.pinCode}",
                            style: const TextStyle(
                                fontSize: 13
                            )),

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


                      CustomButton(title: "Add Deviation",onTabButtonCallback: addTourPlanClick)
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
      validator: (val){
        if(val==null){
          return "Select Activity Type";
        }
        return null;
      },
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
      }
      else if(area?.id ==null){
        Get.back();
        errorText=true;
        setState(() {
        });
      }
      else{
        errorText=false;
        errorAreaText=false;
        try{
          String userId=await SessionManager.getUserId();
          Map<String, dynamic> body= {
            "tourPlanVisitId": widget.id,
            "tourPlanId": widget.tourPlanId,
            "activityType": selectedType?.id,
            "area": area?.id,
            "notes": noteController.text,
            "date": DateUtil.getServerFormatDateString(widget.date),
            "userId": userId,
            "deviatedVisitId": widget.id,
            "isDeviation": isDeviation,
            "coordinates": [
              {
                "status": "Created",
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

          print(jsonEncode(body));

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
      context.showSnackBar("No Internet Connection", null);
    }
  }


  Future<void> getActivityTypeList() async {
    var result = await TourMasterRepo.getActivityType();

    if(result.status){
      activityList=result.data?? [];
      setState(() {
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
