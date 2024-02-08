import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/customer_model/customer_list_model.dart';
import 'package:tulip_app/model/dcr_model/dcr_reports.dart';
import 'package:tulip_app/model/login_data.dart';
import 'package:tulip_app/repo/dcr_repo.dart';
import 'package:tulip_app/repo/login_master.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/create_customer_page.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/customer_search_delegate.dart';
import 'package:tulip_app/ui_designs/home_tab/dcr_pages/lab_list_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/util/storage_utils_ext.dart';
import 'package:tulip_app/widget/custom_button.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class SEAddCallReportPage extends StatefulWidget {
  final bool isExpenseCreated;
  final DCRReport? dcrReport;
  final String tourPlanVisitId;
  final String areaName;
  final String? dcrId;
  final String? dcrLogId;
  const SEAddCallReportPage({Key? key, this.isExpenseCreated=false, required this.dcrReport, required this.tourPlanVisitId, required this.areaName, this.dcrId, this.dcrLogId}) : super(key: key);

  @override
  _SEAddCallReportPageState createState() => _SEAddCallReportPageState();
}

class _SEAddCallReportPageState extends State<SEAddCallReportPage> {

  String selectedValue = ""; // Variable for the selected value
  String selectedWarranty="";
  String? dropdownValue;

  List<UserDetails>? userList;
  UserDetails? selectedUser;

  CustomerListItem? customerList;
  final List<String> warrantyList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24",];
  final List<String> courtesyCallList = ["Payment Collection", "Sales Follow-up", "Payment Call"];
  String selectedEmployee='';

  TextEditingController customerNameController = TextEditingController();
  TextEditingController selectedTimeController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  String? warrantyMonth;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  DCRReport dcrReport = DCRReport(
    customerId: CustomerListItem(
        customerName: "",id: "", address1: '', address2: '', city: '', state: '', pinCode: ''),
    demo: [],
    pointOfBusiness: [],
    conversions: [],

  );
  Call salesCall = Call(pmCall: "",machineSerialNo: "",machineName: "",documents: [],salesCall: "");
  Call pmCall = Call(pmCall: "",machineSerialNo: "",machineName: "",documents: [],salesCall: "",warranty: "");
  Call breakDownCall = Call(pmCall: "",machineSerialNo: "",machineName: "",documents: [],salesCall: "");
  Call installCall = Call(pmCall: "",machineSerialNo: "",machineName: "",documents: [],salesCall: "");
  Call applicationCall = Call(pmCall: "",machineSerialNo: "",machineName: "",documents: [],salesCall: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserList();
    if(widget.dcrReport!=null){
      dcrReport=DCRReport.fromJson(widget.dcrReport!.toJson());
      print("Warrant is here1 ${widget.dcrReport?.pmCall?.toJson()}");
      customerNameController.text=dcrReport.customerId!.customerName;
      selectedTimeController.text=dcrReport.visitTime ?? "";
      selectedValue= widget.dcrReport?.salesCall?.salesCall ?? "";
      selectedWarranty= widget.dcrReport?.pmCall?.pmCall ?? "";
      commentController.text=dcrReport.comment ?? "";
      dropdownValue=widget.dcrReport?.courtesyCall ?? "";
      if(widget.dcrReport?.salesCall!=null) {
        salesCall=Call.fromJson(widget.dcrReport!.salesCall!.toJson());
      }
      if(widget.dcrReport?.pmCall!=null) {
        pmCall=Call.fromJson(widget.dcrReport!.pmCall!.toJson());
        if(widget.dcrReport?.pmCall?.warranty !=null && widget.dcrReport!.pmCall!.warranty!.isNotEmpty) {
          warrantyMonth=widget.dcrReport?.pmCall?.warranty;
        }
        print("Warrant is here${pmCall.warranty}");
      }
      if(widget.dcrReport?.breakDownCall!=null) {
        breakDownCall=Call.fromJson(widget.dcrReport!.breakDownCall!.toJson());
      }
      if(widget.dcrReport?.installationCall!=null) {
        installCall=Call.fromJson(widget.dcrReport!.installationCall!.toJson());
      }
      if(widget.dcrReport?.applicationSupportCall!=null) {
        applicationCall=Call.fromJson(widget.dcrReport!.applicationSupportCall!.toJson());
      }

    }
    else{
      dcrReport = DCRReport(
        customerId: CustomerListItem(customerName: "",id: "", address1: '', address2: '', city: '', state: '', pinCode: ''),
        demo: [],
        pointOfBusiness: [],
        conversions: [],
        salesCall: Call(salesCall: "",documents: [],machineName: "",machineSerialNo: "",pmCall: "")

      );
    }
  }

  Future<void> getUserList() async {
    var response =await  LoginMaster.getActiveUserInfo();
    if(response.status){
      userList = response.data;
      if(dcrReport.visitedWith?.id != null){
        selectedUser=userList?.firstWhere((element) => element.id ==dcrReport.visitedWith?.id);
      }
      setState(() {

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  hintStyle: const TextStyle(fontSize: 13),
                  labelText: "Name*",
                  hintText: "Select name",
                  readOnly: true,
                  controller: customerNameController,
                  onTap: !widget.isExpenseCreated  ? openSearchDelegate : (){},
                  validator: (val){
                    if(val!=null && val.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Enter name";
                    }
                  },
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const SizedBox(width: 5),


              if(!widget.isExpenseCreated)
                GestureDetector(
                  onTap: ()=>Get.to(()=> const CreateCustomerPage(),
                      transition: Transition.fade
                  ),
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.1.h,horizontal: 2.2.w),
                      decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: const Icon(Icons.add,color: Colors.white,)),
                ),
            ],
          ),



          SizedBox(height: 1.5.h),


          visitedWithDropDown(),

          SizedBox(height: 1.h),

          GestureDetector(
            onTap: widget.isExpenseCreated ? (){} : _selectTime,
            child: CustomTextFormField(
              labelText: "Time",
              enabled: false,
              controller: selectedTimeController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              labelStyle: TextStyle(
                  fontSize: 14, color: Colors.black.withOpacity(0.5)),
              hintText: "Select time",
              hintStyle: TextStyle(
                  fontSize: 14, color: Colors.black.withOpacity(0.5)),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            ),
          ),


          SizedBox(height: 3.h),



          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black.withOpacity(0.10))
            ),
            child: Column(
              children: [

                Theme(
                  data: ThemeData(
                      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
                      primarySwatch: MaterialColor(
                          Constants.primaryColor.value, colors()
                      )
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    collapsedBackgroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    title: const Text('Sales Call',style: TextStyle(
                        fontSize: 15
                    ),),

                    children: [

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                            // border: Border.all(color: Colors.black.withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xffC3C3C3).withOpacity(0.25),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 1)),
                              BoxShadow(
                                  color: const Color(0xffC3C3C3).withOpacity(0.25),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                  offset: const Offset(0, -1)),
                            ]
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            rowButtonWidget("Sale",selectedValue,(val) {
                              setState(() {
                                selectedValue = val!;
                                salesCall.pmCall = val;
                                print(val);
                                print(salesCall.pmCall);
                              });
                            }),

                            rowButtonWidget("AMC",selectedValue ?? "",(val) {
                              setState(() {
                                selectedValue = val!;
                                salesCall.pmCall = val;
                              });
                            }),
                          ],
                        ),
                      ),

                      SizedBox(height: 1.h),

                      CustomTextFormField(
                        hintText: "Enter machine Sr. No",
                        labelText: "Machine Sr. No",
                        onSaved: (val)=>salesCall.machineSerialNo = val!,
                        initialValue: salesCall.machineSerialNo,
                        readOnly: !widget.isExpenseCreated ? false : true,

                      ),


                      CustomTextFormField(
                        hintText: "Enter machine name",
                        labelText: "Machine Name",
                        onSaved: (val)=>salesCall.machineName = val!,
                        initialValue: salesCall.machineName,
                        readOnly: !widget.isExpenseCreated ? false : true,

                      ),


                      if(!widget.isExpenseCreated)
                      GestureDetector(
                        onTap: () async {
                          var result = await _openFilePicker(salesCall.documents ?? []);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black.withOpacity(0.10)),
                              color: Colors.white
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_rounded,color: Constants.primaryColor),

                              Text("Report Upload",style: TextStyle(
                                  color: Constants.primaryColor
                              ),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),

                      if(salesCall.documents !=null && salesCall.documents!.isNotEmpty )
                      SizedBox(
                        height: 10.h,
                        child: ListView(
                          key: ValueKey(salesCall.documents),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          children: buildSelectedImagesRow(salesCall.documents ?? []),
                        ),
                      ),
                    ],
                  ),
                ),


                dividerWidget(),

                Theme(
                  data: ThemeData(
                      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
                      primarySwatch: MaterialColor(
                          Constants.primaryColor.value, colors()
                      )
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: const Text('PM Call',style: TextStyle(
                        fontSize: 15
                    ),),
                    children: [

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                            // border: Border.all(color: Colors.black.withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xffC3C3C3).withOpacity(0.25),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 1)),
                              BoxShadow(
                                  color: const Color(0xffC3C3C3).withOpacity(0.25),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                  offset: const Offset(0, -1)),
                            ]
                        ),
                        child: Row(
                          children: [

                            rowButtonWidget("Warranty",selectedWarranty,(val) {
                              setState(() {
                                selectedWarranty = val!;
                                pmCall.pmCall=val;
                              });
                            }),

                            rowButtonWidget("AMC",selectedWarranty,(val) {
                              setState(() {
                                selectedWarranty = val!;
                                pmCall.pmCall=val;
                              });
                            }),
                          ],
                        ),
                      ),

                      SizedBox(height: 1.h),

                       CustomTextFormField(
                        hintText: "Enter machine Sr. No",
                        labelText: "Machine Sr. No",
                        onSaved: (val)=>pmCall.machineSerialNo = val!,
                         initialValue: pmCall.machineSerialNo,
                         readOnly: !widget.isExpenseCreated ? false : true,

                       ),


                       CustomTextFormField(
                        hintText: "Enter machine name",
                        labelText: "Machine Name",
                         onSaved: (val)=>pmCall.machineName = val!,
                         initialValue: pmCall.machineName,
                         readOnly: !widget.isExpenseCreated ? false : true,

                       ),


                      SizedBox(height: 1.h),

                      if(selectedWarranty == "Warranty")
                        warrantyDropdown(),

                      SizedBox(height: 1.h,),


                      if(!widget.isExpenseCreated)
                        GestureDetector(
                        onTap: () async {
                          var result = await _openFilePicker(pmCall.documents ?? []);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black.withOpacity(0.10)),
                              color: Colors.white
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_rounded,color: Constants.primaryColor),

                              Text("Report Upload",style: TextStyle(
                                  color: Constants.primaryColor
                              ),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),

                      if(pmCall.documents!=null && pmCall.documents!.isNotEmpty )
                        SizedBox(
                          height: 10.h,
                          child: ListView(
                            key: ValueKey(pmCall.documents ?? []),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            children: buildSelectedImagesRow(pmCall.documents ?? []),
                          ),
                        ),


                    ],
                  ),
                ),

                dividerWidget(),


                Theme(
                  data: ThemeData(
                      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
                      primarySwatch: MaterialColor(
                          Constants.primaryColor.value, colors()
                      )
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: const Text('Breakdown Call',
                      style: TextStyle(
                          fontSize: 15
                      ),),
                    children: [
                       CustomTextFormField(
                        hintText: "Enter machine Sr. No",
                        labelText: "Machine Sr. No",
                         initialValue: breakDownCall.machineSerialNo,
                         onSaved: (val)=>breakDownCall.machineSerialNo = val!,
                         readOnly: !widget.isExpenseCreated ? false : true,

                       ),


                       CustomTextFormField(
                        hintText: "Enter machine name",
                        labelText: "Machine Name",
                         initialValue: breakDownCall.machineName,
                         onSaved: (val)=>breakDownCall.machineName = val!,
                         readOnly: !widget.isExpenseCreated ? false : true,

                       ),


                      if(!widget.isExpenseCreated)
                        GestureDetector(
                        onTap: () async {
                          var result = await _openFilePicker(breakDownCall.documents ?? []);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black.withOpacity(0.10)),
                              color: Colors.white
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_rounded,color: Constants.primaryColor),

                              Text("Service Report Upload",style: TextStyle(
                                  color: Constants.primaryColor
                              ),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),

                      if(breakDownCall.documents !=null && breakDownCall.documents!.isNotEmpty )
                        SizedBox(
                          height: 10.h,
                          child: ListView(
                            key: ValueKey(breakDownCall.documents ?? []),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            children: buildSelectedImagesRow(breakDownCall.documents ?? []),
                          ),
                        ),
                      SizedBox(height: 1.h),


                    ],
                  ),
                ),


                dividerWidget(),

                Theme(
                  data: ThemeData(
                      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
                      primarySwatch: MaterialColor(
                          Constants.primaryColor.value, colors()
                      )
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: const Text('Installation Call',style: TextStyle(
                        fontSize: 15
                    ),),
                    children: [
                       CustomTextFormField(
                        hintText: "Enter machine Sr. No",
                        labelText: "Machine Sr. No",
                         initialValue: installCall.machineSerialNo,
                         onSaved: (val)=>installCall.machineSerialNo = val!,
                         readOnly: !widget.isExpenseCreated ? false : true,

                       ),


                      CustomTextFormField(
                        hintText: "Enter machine name",
                        labelText: "Machine Name",
                        initialValue: installCall.machineName,
                        onSaved: (val)=>installCall.machineName = val!,
                        readOnly: !widget.isExpenseCreated ? false : true,

                      ),



                      if(!widget.isExpenseCreated)
                        GestureDetector(
                        onTap: () async {
                          var result = await _openFilePicker(installCall.documents ?? []);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black.withOpacity(0.10)),
                              color: Colors.white
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_rounded,color: Constants.primaryColor),

                              Text("Installation Report Upload",style: TextStyle(
                                  color: Constants.primaryColor
                              ),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),

                      if(installCall.documents!=null && installCall.documents!.isNotEmpty )
                        SizedBox(
                          height: 10.h,
                          child: ListView(
                            key: ValueKey(installCall.documents ?? []),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            children: buildSelectedImagesRow(installCall.documents ?? []),
                          ),
                        ),
                      SizedBox(height: 1.h),

                    ],
                  ),
                ),

                dividerWidget(),

                Theme(
                  data: ThemeData(
                      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
                      primarySwatch: MaterialColor(
                          Constants.primaryColor.value, colors()
                      )
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: const Text('Application Support Call',style: TextStyle(
                        fontSize: 15
                    ),),
                    children: [

                       CustomTextFormField(
                        hintText: "Enter machine Sr. No",
                        labelText: "Machine Sr. No",
                         initialValue: applicationCall.machineSerialNo,
                         onSaved: (val)=>applicationCall.machineSerialNo = val!,
                         readOnly: !widget.isExpenseCreated ? false : true,

                       ),


                      CustomTextFormField(
                        hintText: "Enter machine name",
                        labelText: "Machine Name",
                        initialValue: applicationCall.machineName,
                        onSaved: (val)=>applicationCall.machineName = val!,
                        readOnly: !widget.isExpenseCreated ? false : true,
                      ),


                      if(!widget.isExpenseCreated)
                        GestureDetector(
                        onTap: () async {
                          var result = await _openFilePicker(applicationCall.documents  ?? []);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black.withOpacity(0.10)),
                              color: Colors.white
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_rounded,color: Constants.primaryColor),

                              Text("Application Support Upload",style: TextStyle(
                                  color: Constants.primaryColor
                              ),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),

                      if(applicationCall.documents !=null && applicationCall.documents !.isNotEmpty )
                        SizedBox(
                          height: 10.h,
                          child: ListView(
                            key: ValueKey(applicationCall.documents ?? []),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            children: buildSelectedImagesRow(applicationCall.documents  ?? []),
                          ),
                        ),

                      SizedBox(height: 1.h),

                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

        DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                labelText: "Courtesy Call",
                hintText: "Select Courtesy Call",
                hintStyle: TextStyle(
                  fontSize: 14
                ),
                fillColor: Colors.white,
                isDense: true,
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
            value: dcrReport.courtesyCall,
            isExpanded: true,
            items: courtesyCallList.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item,style: TextStyle(
                  fontSize: 14
                ),),
              );
            }).toList(),
            onChanged: (val){
              setState(() {
                dcrReport.courtesyCall = val!;
              });
            },
          ),
        ),


          SizedBox(height: 2.h),

          ///sales engineer
           CustomTextFormField(
            hintText: "Enter order booked value",
            labelText: "Order Booked Value",
             readOnly: !widget.isExpenseCreated ? false : true,
             keyboardType: TextInputType.phone,
            onSaved: (val)=>dcrReport.orderValue = val!,
             initialValue: dcrReport.orderValue,
          ),

          SizedBox(height: 1.h),

          CustomTextFormField(
            labelText: "Comment*",
            controller: commentController,
            textCapitalization: TextCapitalization.sentences,
            labelStyle: TextStyle(
                fontSize: 14, color: Colors.black.withOpacity(0.5)),
            hintText: "Add comment",
            maxLines: 3,
            readOnly: !widget.isExpenseCreated ? false : true,
            hintStyle: TextStyle(
                fontSize: 14, color: Colors.black.withOpacity(0.5)),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          ),

           if(!widget.isExpenseCreated)
           CustomButton(title: "Save",
            onTabButtonCallback:saveUpdateButtonClick,
          )


        ],
      ),
    );
  }

  Widget visitedWithDropDown()=> SizedBox(
    height: 5.5.h,
    child: DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
        isDense: true,
        style: const TextStyle(
            fontSize: 13,
            color: Colors.black
        ),
        decoration: InputDecoration(
          hintText: "Select visited with",
          hintStyle: TextStyle(
            fontSize: 14, color: Colors.black.withOpacity(0.5),
          ),
          fillColor: Colors.white,
          labelText: "Visited With",
          contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
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
        value: selectedUser,
        isExpanded: true,
        items: userList?.map((UserDetails item) {
          // items: companyList.map((CustomerTypeId item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item.userName ?? ""),
          );
        }).toList(),
        onChanged: widget.isExpenseCreated ? null : (UserDetails? val){
          if(!widget.isExpenseCreated) {
            selectedUser=val;
            dcrReport.visitedWith=val;
            print(val);
            print(dcrReport.visitedWith);

          }
        },
      ),
    ),
  );




  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        String formattedTime = picked.format(context);
        selectedTimeController.text = picked.format(context);
        // Assign the selected DateTime to your variable (dcrReport.visitTime)
        widget.dcrReport?.visitTime = formattedTime;
      });
    }
  }

  Future<void> openSearchDelegate() async {
    final data = await showSearch(
      context: context,
      delegate: CustomerSearchDelegate(true),
    );
    if(data!=null){
      print("data customer data");
      dcrReport.customerId=data;
      customerList=data;
      customerNameController.text=customerList?.customerName ?? "";
      print(customerList?.customerName);
      setState(() {

      });
    }
  }

  Widget warrantyDropdown()=> SizedBox(
    height: 5.5.h,
    child: DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
        isDense: true,
        style: const TextStyle(
            fontSize: 13,
            color: Colors.black
        ),
        decoration: InputDecoration(
          hintText: "Select warranty",
          hintStyle: TextStyle(
            fontSize: 14, color: Colors.black.withOpacity(0.5),
          ),
          fillColor: Colors.white,
          labelText: "Warranty(Months)",
          contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
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
        value: warrantyMonth,
        isExpanded: true,
        items: warrantyList.map((String item) {
          // items: companyList.map((CustomerTypeId item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item ?? ""),
          );
        }).toList(),
        onChanged: widget.isExpenseCreated ? null : (String? val){
          if(!widget.isExpenseCreated) {
            warrantyMonth=val;
            pmCall.warranty=val;
            print(val);
            print(dcrReport.visitedWith);

          }
        },
      ),
    ),
  );



  Widget rowButtonWidget(String value,String groupValue,void Function(String?)? onChanged)=>Expanded(
    child: ListTileTheme(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      child: RadioListTile(
        contentPadding: EdgeInsets.zero,
        value: value,
        groupValue: groupValue,
        onChanged: !widget.isExpenseCreated ?onChanged : null,
        title: Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    ),
  );


  Map<int, Color> colors()=>{
    50: Constants.primaryColor,
    100: Constants.primaryColor,
    200: Constants.primaryColor,
    300: Constants.primaryColor,
    400: Constants.primaryColor,
    500: Constants.primaryColor,
    600: Constants.primaryColor,
    700: Constants.primaryColor,
    800: Constants.primaryColor,
    900: Constants.primaryColor
  };

  Widget dividerWidget()=> Divider(
    color: Colors.black.withOpacity(0.3),
  );

  List<Widget> buildSelectedImagesRow(List<dynamic> selectedImages) {
    return selectedImages.asMap().entries.map((entry) {
      final int index = entry.key;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Stack(
          alignment: Alignment.topRight,
          children: [

            if(!selectedImages[index].contains("http") && selectedImages[index].contains("png") || selectedImages[index].contains("jpg") || selectedImages[index].contains("jpeg") )
            SizedBox(
              height: 100,width: 100,
              child: Image.file(File(selectedImages[index]),fit: BoxFit.fill,),
            ),

            if(selectedImages[index].contains("http"))
              SizedBox(
                height: 100,width: 100,
                child: CachedNetworkImage(
                  imageUrl: selectedImages[index],
                  fit: BoxFit.fill,
                ),
              ),


            if(selectedImages[index].contains("pdf") || selectedImages[index].contains("xlsr") || selectedImages[index].contains("docx"))
              const SizedBox(
                  height: 100,width: 100,
                child: Icon(Icons.picture_as_pdf)
              ),

            if(selectedImages[index].contains("mp4"))
              const SizedBox(
                  height: 50,width: 50,
                  child: Icon(Icons.video_call)
              ),



            GestureDetector(
              onTap: (){
                selectedImages.removeAt(index);
                setState(() {
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle
                ),
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

  Future<bool> _openFilePicker(List<dynamic> listData ) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          for(var i in result.paths){
            listData.add(i);
          }
          print(listData);
          print("listData");
        });
        return true;
      }
      return false;
    } catch (e) {
      print('Error while picking files: $e');
      return false;
    }
  }


  void saveUpdateButtonClick() async{
    if(await InternetUtil.isInternetConnected()){
      _formKey.currentState?.save();
      if(dcrReport.customerId?.id == ""){
        context.showSnackBar("Select Customer name",null);
      }
      else if(commentController.text.isEmpty ){
        context.showSnackBar("Add comment",null);

      }
      else{
        ProgressDialog.showProgressDialog(context);
        try {
          List<dynamic> salesDocumentUpload=[];

          for(var image in salesCall.documents ?? []){

            if(image.contains("http")){
              salesDocumentUpload.add(image);
            }
            else{
              var result = await File(image).uploadFileToFirebase("${DateUtil.getCurrentTimeStamp()}.png");
              salesDocumentUpload.add(result);
            }
          }
          List<dynamic> pmDocumentUpload=[];

          for(var image in pmCall.documents ?? []){

            if(image.contains("http")){
              pmDocumentUpload.add(image);
            }
            else{
              var result = await File(image).uploadFileToFirebase("${DateUtil.getCurrentTimeStamp()}.png");
              pmDocumentUpload.add(result);
            }
          }


          List<dynamic> breakDownDocumentUpload=[];

          for(var image in breakDownCall.documents ?? []){

            if(image.contains("http")){
              breakDownDocumentUpload.add(image);
            }
            else{
              var result = await File(image).uploadFileToFirebase("${DateUtil.getCurrentTimeStamp()}.png");
              breakDownDocumentUpload.add(result);
            }
          }


          List<dynamic> installDocumentUpload=[];

          for(var image in installCall.documents ?? []){

            if(image.contains("http")){
              installDocumentUpload.add(image);
            }
            else{
              var result = await File(image).uploadFileToFirebase("${DateUtil.getCurrentTimeStamp()}.png");
              installDocumentUpload.add(result);
            }
          }


          List<dynamic> applicationDocumentUpload=[];

          for(var image in applicationCall.documents ?? []){

            if(image.contains("http")){
              applicationDocumentUpload.add(image);
            }
            else{
              var result = await File(image).uploadFileToFirebase("${DateUtil.getCurrentTimeStamp()}.png");
              applicationDocumentUpload.add(result);
            }
          }

          String userId= await SessionManager.getUserId();

          print("Dcr log id ${widget.dcrLogId}");
          print("Dcr log i1d ${widget.dcrId}");

          Map<String, dynamic> body= {
            "dcrLogId": widget.dcrLogId,
            "dcrId": widget.dcrId,
            "tourPlanVisitId": widget.tourPlanVisitId,
            "customerId": dcrReport.customerId?.id,
            "visitedWith": dcrReport.visitedWith?.id,
            "userId": userId,
            "courtesyCall": dcrReport.courtesyCall,
            "orderValue": dcrReport.orderValue,
            "comment": commentController.text,
            "dcrDate": DateTime.now().toIso8601String(),
            "visitTime": selectedTimeController.text,
             "salesCall": {
              "salesCall": selectedValue ?? salesCall.pmCall,
              "machineSerialNo": salesCall.machineSerialNo,
              "machineName": salesCall.machineName,
              "documents": salesDocumentUpload
            },
            "pmCall": {
              "pmCall":selectedWarranty ?? pmCall.pmCall,
              "machineSerialNo": pmCall.machineSerialNo,
              "machineName": pmCall.machineName,
              "warranty": pmCall.warranty,
              "documents": pmDocumentUpload
            },
            "breakDownCall": {
              "machineSerialNo": breakDownCall.machineSerialNo,
              "machineName": breakDownCall.machineName,
              "documents": breakDownDocumentUpload
            },
            "installationCall": {
              "machineSerialNo": installCall.machineSerialNo,
              "machineName": installCall.machineName,
              "documents": installDocumentUpload
            },
            "applicationSupportCall": {
              "machineSerialNo": applicationCall.machineSerialNo,
              "machineName": applicationCall.machineName,
              "documents": applicationDocumentUpload
            }
          };

          log("Request body is : $body");
          var response = await DCRRepo.addDCRReport(body);
          if(response.status){
            Get.back();
            Get.to(LabListPage(tourPlanVisitId: widget.tourPlanVisitId,dcrId: response.data,areaName: widget.areaName ?? "", isExpenseCreated: widget.isExpenseCreated,));
            print("data is here ${response.data}");
          }

        }catch(e,stack){
          Get.back();
          print("Error : ${e.toString()}");
          print(stack);
          context.showSnackBar("Something went wrong",null);
        }
      }
    }
    else{
      context.showSnackBar("No Internet Connection",null);

    }
  }



}
