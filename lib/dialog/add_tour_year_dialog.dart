
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/repo/tour_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/travel_plan_pages/daily_tour_plan_list.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_dropdown.dart';

class AddTourYearDialog extends StatefulWidget {
  final String latitude;
  final String longitude;
  const AddTourYearDialog({Key? key, required this.latitude, required this.longitude}) : super(key: key);

  @override
  AddTourYearDialogState createState() => AddTourYearDialogState();
}


class AddTourYearDialogState extends State<AddTourYearDialog> {
  String selectedYear = DateTime.now().year.toString();
  int monthNumber=1;
  List<String> yearList = [];
  List<String> monthList = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];
  String selectedMonth = "January"; // Default to January

  @override
  void initState() {
    super.initState();
    DateTime tourPlanDate=DateUtil.parseServerFormatDateTime("$selectedYear-$monthNumber-01");
    print("Date imte ${tourPlanDate}");
    print("Date imte11 ${"${tourPlanDate.year}-${tourPlanDate.month}-01"}");
    generateYearList();

  }

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
                  width: 70.w,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 3.h),
                  decoration: BoxDecoration(
                      color: const Color(0xffF8F8F8),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      const Text("Select Year & Month",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                      ),


                      const SizedBox(height: 20.0), // Add spacing between dropdowns
                      CustomDropdown(
                        items: yearList,
                        selectedValue: selectedYear,
                        labelText: "Year",
                        onChanged: (newValue) {
                          setState(() {
                            selectedYear = newValue!;
                            print(newValue);
                          });
                        },
                      ),
                      const SizedBox(height: 20.0), // Add spacing between dropdowns
                      CustomDropdown(
                        items: monthList,
                        selectedValue: selectedMonth,
                        labelText: "Month",
                        onChanged: (newValue) {
                          setState(() {
                            selectedMonth = newValue!;
                            int selectedMonthIndex = monthList.indexOf(newValue);
                            if (selectedMonthIndex >= 0) {
                              monthNumber = selectedMonthIndex + 1; // Month numbers are 1-based
                              print("Selected Month Number: $monthNumber");


                            }
                          });
                        },
                      ),

                      const SizedBox(height: 20.0), // Add spacing between dropdowns

                      addFollowUpButton("Proceed"),
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



    Widget addFollowUpButton(String title){
      return GestureDetector(
        onTap:(){
          createPlanClick();
          // Get.to( DailyTourPlanList(),
          // transition: Transition.fade);
        },
        child: Container(
            width: 50.w,
            height: 5.h,
          padding : EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.5.h),
          decoration: BoxDecoration(
              gradient: Constants.buttonGradientColor,
              borderRadius: BorderRadius.circular(4)
          ),
          child: Text(title,textAlign: TextAlign.center,style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600
          ),),
        ),
      );
    }


    Future<void> createPlanClick() async {
    if(await InternetUtil.isInternetConnected()){
      ProgressDialog.showProgressDialog(context);
      try{
        DateTime tourPlanDate = DateTime(int.parse(selectedYear), monthNumber, 1);

        var formattedDate = DateFormat('yyyy-MM-dd').format(tourPlanDate);
        print("Date imte ${formattedDate}");
        String userId = await SessionManager.getUserId();
        Map<String,dynamic> body={
          "tourPlanId": null,

          "date": formattedDate,
          "notes": "",
          "userId": userId
        };
        var response = await TourMasterRepo.addUpdateYearTourPlan(body);
        if(response.status){
          Get.back();
          Get.back(result: true);
          Get.to(DailyTourPlanList(tourPlanId: response.data["_id"], tourPlanDate: DateTime.parse(response.data["date"]), status: response.data['status'], ),
              transition: Transition.fade);
          context.showSnackBar("Tour Plan Added",null);
        }
        else{
          Get.back();
          Get.back();
          context.showSnackBar("${response.message}",null);
        }
      }catch(e){
        Get.back();
        print("Error : $e");
      }
    }
    }

  void generateYearList() {
    final currentYear = DateTime.now().year;
    for (int i = currentYear; i <= currentYear + 5; i++) {
      yearList.add(i.toString());
    }
  }
}



