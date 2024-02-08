import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/repo/tour_repo.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_button.dart';
import 'package:tulip_app/widget/custom_dropdown.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class AddLeaveDialog extends StatefulWidget {
  final DateTime date;
  final String tourPlanId;
  const AddLeaveDialog({Key? key, required this.date, required this.tourPlanId}) : super(key: key);

  @override
  AddLeaveDialogState createState() => AddLeaveDialogState();
}

class AddLeaveDialogState extends State<AddLeaveDialog> {

  List<String> leaveList = ["Causal Leave","Personal Leave"];
  String? selectedLeave;
  bool errorText=false;
  TextEditingController noteController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 80.w,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 3.h),
                  decoration: BoxDecoration(
                      color: const Color(0xffF8F8F8),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),

                      CustomDropdown(
                        items: leaveList,
                        selectedValue: selectedLeave,
                        hintText: "Select Leave",
                        hintStyle: const TextStyle(
                          fontSize: 15
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedLeave = newValue!;
                            errorText=false;
                          });
                        }, labelText: '',
                      ),

                      if(errorText)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("Select Leave",
                        style: TextStyle(
                          fontSize: 12,color: Constants.primaryColor
                        ),
                        ),
                      ),



                      CustomTextFormField(
                        hintText: "Add Description",
                        maxLines: 3,
                        controller: noteController,
                      ),

                      CustomButton(title: "Mark Leave",onTabButtonCallback: addLeave)

                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffF8F8F8),
                      ),
                      child: const Icon(Icons.close,color: Color(0xff009EE0))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addLeave() async {
    if(selectedLeave!=null){
      if(await InternetUtil.isInternetConnected()){
        ProgressDialog.showProgressDialog(context);
        try{
          String userId=await SessionManager.getUserId();
          Map<String,dynamic> body={
            "leaveId": null,
            "userId": userId,
            "leaveType": selectedLeave,
            "description": noteController.text,
            "leaveDate": DateUtil.getServerFormatDateString(widget.date)
          };
          print(jsonEncode(body));
          var response = await TourMasterRepo.addLeave(body);
          if(response.status){
            Get.back();
            context.showSnackBar("Leave Added",null);
            Get.back(result: [widget.tourPlanId,widget.date]);
          }
          else{
            context.showSnackBar(response.data,null);
            Get.back();

          }
        }
        catch(e){
          print("Error : ${e.toString()}");
          context.showSnackBar("${e.toString()}",null);
        }
      }
      else{
        context.showSnackBar("No Internet Connection", null);
      }
    }
    else{
      errorText=true;
      setState(() {

      });
    }


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    noteController.dispose();
  }

}
