import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/ui_designs/home_tab/dcr_pages/date_wise_area_list.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class SelectDateDialog extends StatefulWidget {
  const SelectDateDialog({Key? key}) : super(key: key);

  @override
  _SelectDateDialogState createState() => _SelectDateDialogState();
}

class _SelectDateDialogState extends State<SelectDateDialog> {

  TextEditingController _selectDate = TextEditingController();
  DateTime? selectedDate;

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

                      const Text("Select Date",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          final date = await Constants.pickDate(
                              DateTime(2000), DateTime(2030), context);
                          if (date != null) {
                            setState(() {
                              String dateFormatted = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
                              selectedDate=date;
                              _selectDate.text =DateUtil.getDisplayFormatDate(DateTime.parse(dateFormatted));
                            });
                          }
                        },
                        child:  CustomTextFormField(
                          labelText: "Date",
                          controller: _selectDate,
                          enabled: false,
                          suffixIcon: const Icon(Icons.date_range),
                          labelStyle: TextStyle(
                              fontSize: 14, color: Colors.black.withOpacity(0.5)),
                          hintText: "Select Date",
                          hintStyle: TextStyle(
                              fontSize: 14, color: Colors.black.withOpacity(0.5)),
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                        ),

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
        if(selectedDate !=null){
          Get.back();
          Get.to(DateWiseAreaListPage(selectedDate : selectedDate!), transition: Transition.fade);
        }else{
          context.showSnackBar("Please select date",null);
        }

      },
      child: Container(
        width: 50.w,
        height: 5.h,
        padding :  EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.5.h),
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





}
