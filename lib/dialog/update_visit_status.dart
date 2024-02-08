import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/util/extensions.dart';

  class UpdateVisitStatus extends StatefulWidget {
  const UpdateVisitStatus({Key? key}) : super(key: key);

  @override
  UpdateVisitStatusState createState() => UpdateVisitStatusState();
}


class UpdateVisitStatusState extends State<UpdateVisitStatus> {
  String dropdownValue ="Interested";

  final commentController = TextEditingController();

  String errorText = "";
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
                          decoration: BoxDecoration(
                              color: const Color(0xffF8F8F8),
                              borderRadius: BorderRadius.circular(6)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 1.h),
                                child: const Center(
                                  child: Text(
                                    "Add Follow Up",
                                    style: TextStyle(
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

                                  const Text("Status - ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  _statusWidget(),


                                ],
                              ),

                              SizedBox(height: 2.h,),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xffF6F6F6)
                                ),
                                child: TextFormField(
                                  controller: commentController,
                                  textInputAction: Platform.isIOS ? TextInputAction.done : TextInputAction.newline,
                                  maxLines: 5,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                  decoration: const InputDecoration(
                                    alignLabelWithHint: true,
                                    fillColor: Color(0xffF6F6F6),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black,width: 0)
                                    ),
                                    labelText: "Description",
                                    hintStyle: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff9C9999)
                                    ),
                                    // labelText: "Comment",
                                    hintText: "Add Your Description Here",
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.h),

                              if(showError)
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
                                child: const Row(
                                  children: [
                                    Text("Sales Person Name : "),

                                    Text(
                                      "Pratik Mankar",
                                      style: TextStyle(

                                      ),
                                    ),
                                  ],
                                ),
                              ),


                              SizedBox(height: 1.h),
                              addFollowUpButton("Add Follow Up",)
                            ],
                          ),
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

              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget addFollowUpButton(String title){
    return Container(
      padding :  EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.5.h),
      decoration: BoxDecoration(
          gradient: Constants.buttonGradientColor,
          borderRadius: BorderRadius.circular(4)
      ),
      child: Center(
        child: Text(title,style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600
        ),),
      ),
    );
  }

  Widget _statusWidget() =>Container(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    decoration: BoxDecoration(
        border: Border.all(color: Constants.lightGreyColor),
        borderRadius: BorderRadius.circular(6)),
    child: DropdownButton<String>(
      isDense: true,
      underline: const SizedBox(),
      value: dropdownValue,

      icon: const Icon(Icons.keyboard_arrow_down),
      iconSize: 16,
      elevation: 6,
      menuMaxHeight: MediaQuery.of(context).size.height,
      // style: const TextStyle(color: AppColor.PRIMARY_COLOR),
      onChanged:  (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          // selectedStatus = dropdownValue;
        });
      },
      items: <String>[
        'Interested',
        'Not Interested',
        "Cold Followup",
        "Hot Followup",
        "Other (Added in Note)",
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,style: const TextStyle(
              fontSize: 11
          ),),
        );
      }).toList(),
    ),
  );

  @override
  void dispose() {
    // TODO: implement dispose
    commentController.dispose();
    super.dispose();
  }
}

