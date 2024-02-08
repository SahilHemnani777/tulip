import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/lead_model/follow_up_model.dart';
import 'package:tulip_app/model/login_data.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';

class FollowUpDialog extends StatefulWidget {
  final FollowUpDetails? followUpDetails;
  const FollowUpDialog({Key? key, this.followUpDetails}) : super(key: key);

  @override
  State<FollowUpDialog> createState() => _FollowUpDialogState();
}

class _FollowUpDialogState extends State<FollowUpDialog> {
  final commentController = TextEditingController();
  String errorText = "";
  bool showError = false;
  String userName = "";
  String? createdDate;

  String? dropDownType;
  List<String> followUpList = [
    'Interested',
    'Not Interested',
    "Cold Followup",
    "Hot Followup",
    "Other (Added in Note)",
  ];

  DateTime? dateTime;
  String formatedStartDate = "DD/MM/YYYY";
  String selectedTime = "00:00 PM";

  bool _selectedFollowUpTime=false;

  UserDetails? userInfo;

  @override
  void initState() {
    super.initState();
    print("widget.followUpDetails");
    print(widget.followUpDetails?.toJson());
    if (widget.followUpDetails != null) {
      commentController.text = widget.followUpDetails?.followUpNotes ?? "";
      dropDownType = widget.followUpDetails?.status;
      formatedStartDate = DateUtil.getDisplayFormatDate(widget.followUpDetails!.followUpDate!);
      dateTime=widget.followUpDetails?.followUpDate;
      selectedTime = DateFormat('hh:mm a').format(widget.followUpDetails!.followUpDate!);
      _selectedFollowUpTime=true;
    }

     getUserData();
  }

  Future<void> getUserData() async {
    userInfo = await SessionManager.getUserData();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 90.w,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          decoration: BoxDecoration(
                              color: const Color(0xffF8F8F8),
                              borderRadius: BorderRadius.circular(6)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 1.h),
                                child: Center(
                                  child: Text(
                                    widget.followUpDetails !=null ?"Edit Follow Up" : "Add Follow Up",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 1.w),
                                  const Text(
                                    "Status - ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  _statusWidget(),
                                ],
                              ),
                              // if (showError)
                              //   Container(
                              //     margin: EdgeInsets.only(left: 18.w),
                              //     child: Text(
                              //       errorText,
                              //       style: TextStyle(
                              //           fontSize: 12, color: Colors.red),
                              //     ),
                              //   ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  SizedBox(width: 1.w),
                                  const Text(
                                    "Date - ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  InkWell(
                                    onTap: onDateClick,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1,color: const Color(0xffAFAFAF)),
                                          borderRadius: const BorderRadius.all(Radius.circular(3))
                                      ),
                                      child: Text(
                                        formatedStartDate,
                                        style: TextStyle(
                                            color: formatedStartDate.contains("MM") ? const Color(0xffB4B4B4) : Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 2.w,),

                                  InkWell(
                                    onTap: onTimeClick,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1,color: const Color(0xffAFAFAF)),
                                          borderRadius: const BorderRadius.all(Radius.circular(3))
                                      ),
                                      child: Text(
                                        selectedTime,
                                        style: TextStyle(
                                          color: !_selectedFollowUpTime ? const Color(0xffB4B4B4) : Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xffF6F6F6)),
                                child: TextFormField(
                                  controller: commentController,
                                  textInputAction: Platform.isIOS
                                      ? TextInputAction.done
                                      : TextInputAction.newline,
                                  maxLines: 5,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    fillColor: const Color(0xffF6F6F6),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 0)),
                                    labelText: "Description",
                                    hintStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color(0xff9C9999)),
                                    // labelText: "Comment",
                                    hintText: "Add Your Description Here",
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              if (showError)
                                Container(
                                  margin: EdgeInsets.only(bottom: 1.w),
                                  child: Text(
                                    errorText,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.only(bottom: 1.w),
                                child: Row(
                                  children: [
                                    Text("Sales Person Name : "),
                                    Text(
                                      userInfo?.userName??"",
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 1.h),
                              GestureDetector(
                                  onTap: addFollowUpClick,
                                  child: addFollowUpButton(
                                    "Add Follow Up",
                                  ))
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffF8F8F8),
                            ),
                            child: const Icon(Icons.close,
                                color: Color(0xff009EE0))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget addFollowUpButton(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
          gradient: Constants.buttonGradientColor,
          borderRadius: BorderRadius.circular(4)),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _statusWidget() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
            border: Border.all(color: Constants.lightGreyColor),
            borderRadius: BorderRadius.circular(6)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isDense: true,
            value: dropDownType,
            style: const TextStyle(fontSize: 13, color: Colors.black),
            hint: const Text("Select Status"),
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 16,
            elevation: 6,
            menuMaxHeight: MediaQuery.of(context).size.height,
            // style: const TextStyle(color: AppColor.PRIMARY_COLOR),
            onChanged: (String? newValue) {
              setState(() {
                dropDownType = newValue!;
              });
            },
            items: followUpList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 11),
                ),
              );
            }).toList(),
          ),
        ),
      );

  void addFollowUpClick() {
    if (dropDownType == null) {
      showError = true;
      errorText = "Select Status";
      setState(() {});
    }
    else if(formatedStartDate == "DD/MM/YYYY"){
      //context.showSnackBar("Select Followup Date Time");
      setState(() {
        errorText = "Select follow up date";
        showError = true;
      });
    }
    else if(selectedTime == "00:00 PM"){
      //context.showSnackBar("Select Followup Date Time");
      setState(() {
        errorText = "Select follow up time";
        showError = true;
      });
    }

    else {
      Get.back(result: [dropDownType, commentController.text,dateTime]);
    }
  }


  void onTimeClick()async {
    final now = DateTime.now();
    DateTime oneMinuteLater = now.add(const Duration(minutes: 3));

    final res = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: DateTime.now().hour,minute: oneMinuteLater.minute),

    );

    if (res != null) {
      if(formatedStartDate == "DD/MM/YYYY"){
        errorText = "Selected Date";
        showError=true;
        setState(() {

        });
      }
      else{
        final selectedDateTime = DateTime(
          dateTime!.year ,
          dateTime!.month,
          dateTime!.day,
          res.hour,
          res.minute,
        );
        setState(() {
          if(selectedDateTime.day == DateTime.now().day && selectedDateTime.month == DateTime.now().month && selectedDateTime.year == DateTime.now().year){
            if (selectedDateTime.isAfter(DateTime.now())) {
              // Only update if the selected time is not before the current time
              _selectedFollowUpTime = true;
              selectedTime = res.format(context);
              dateTime = selectedDateTime;
              showError=false;

            } else {
              errorText = "Selected time is before the current time.";
              showError=true;

            }
          }
          else{
            _selectedFollowUpTime = true;
            selectedTime = res.format(context);
            dateTime = selectedDateTime;
            showError=false;
          }
        });
      }
    }

  }


  onDateClick()async {
    formatedStartDate = "DD/MM/YYYY";
    selectedTime = "00:00 PM";
    final res = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)
    );
    if(res != null){
      formatedStartDate = DateUtil.getDisplayFormatDate(res);
      dateTime = res;
      showError=false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    commentController.dispose();
    super.dispose();
  }
}
