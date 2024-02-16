import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/customer_model/customer_list_model.dart';
import 'package:tulip_app/model/dcr_model/dcr_reports.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/model/login_data.dart';
import 'package:tulip_app/repo/dcr_repo.dart';
import 'package:tulip_app/repo/login_master.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/create_customer_page.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/customer_search_delegate.dart';
import 'package:tulip_app/ui_designs/home_tab/dcr_pages/lab_list_page.dart';
import 'package:tulip_app/ui_designs/home_tab/products_catalogue/product_category_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/custom_button.dart';
import 'package:tulip_app/widget/custom_dropdown.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

import 'se_add_call_report_page.dart';

class AddAreaReportForm extends StatefulWidget {
  final DCRReport? dcrReportData;
  final String tourPlanVisitId;
  final String? areaName;
  final String? dcrId;
  final String? dcrLogId;
  final bool isExpenseCreated;
  const AddAreaReportForm({Key? key, this.dcrReportData, required this.tourPlanVisitId, this.areaName, this.dcrId, this.isExpenseCreated=false, this.dcrLogId}) : super(key: key);

  @override
  _AddAreaReportFormState createState() => _AddAreaReportFormState();
}

class _AddAreaReportFormState extends State<AddAreaReportForm> {


  List<UserDetails>? userList;
  UserDetails? selectedUser;

  // Variable for the selected value
  CustomerListItem? customerList;

  DCRReport dcrReport = DCRReport(
    customerId: CustomerListItem(customerName: "",id: "", address1: '', address2: '', city: '', state: '', pinCode: ''),
    demo: [],
    pointOfBusiness: [],
    conversions: [],

  );


  final List<String> pobInstrumentList = ["Reagents", "Instruments"];
  String selectedInstrument='';


  final List<String> pobProductList = ["Reagents", "Instruments"];
  String? selectedProductPOBType;
  String? selectedProductDemoType;
  String? selectedProductConType;
  Product? selectedPOBProductItem;
  Product? selectedDemoProductItem;
  Product? selectedConversionProductItem;


  TextEditingController selectedPOBQuantity = TextEditingController();
  TextEditingController selectedDemoQuantity = TextEditingController();
  TextEditingController selectedConversionQuantity = TextEditingController();
  TextEditingController selectedTimeController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDemoNameController = TextEditingController();
  TextEditingController productConversionNameController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();

  TimeOfDay selectedTime = TimeOfDay.now(); // Initialize with the current time.


  @override
  void initState() {
    super.initState();
    print("123123 ${widget.dcrId}");
    getUserList();
    if(widget.dcrReportData!=null){
      dcrReport=DCRReport.fromJson(widget.dcrReportData!.toJson());
      customerNameController.text=dcrReport.customerId!.customerName;
      selectedTimeController.text=dcrReport.visitTime ?? "";
      commentController.text=dcrReport.comment ?? "";
    }
    else{
      dcrReport = DCRReport(
        customerId: CustomerListItem(customerName: "",id: "", address1: '', address2: '', city: '', state: '', pinCode: ''),
        demo: [],
        pointOfBusiness: [],
        conversions: [],

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "${widget.areaName} Call Report",implyStatus: true),

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: SingleChildScrollView(
          child: SessionManager.userDesignation == "Sales & Service Executive" || SessionManager.userDesignation == "Sr. Sales & Service Executive"  ?
          SEAddCallReportPage(dcrReport: dcrReport,dcrLogId: widget.dcrLogId, tourPlanVisitId: widget.tourPlanVisitId,
              areaName: widget.areaName ?? "",dcrId: widget.dcrId,isExpenseCreated: widget.isExpenseCreated) :
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 3.h),

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
                      // initialValue: dcrReport.customerId.name,
                      // onSaved: (val) => dcrReport.customerId.name = val!
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

                  SizedBox(height: 1.5.h),
              if(!widget.isExpenseCreated || dcrReport.pointOfBusiness!=null && dcrReport.pointOfBusiness!.isNotEmpty)
                titleWidget("Point of Business (POB)", null),
              if(!widget.isExpenseCreated)
                SizedBox(height: 1.5.h),

              if(!widget.isExpenseCreated)
                CustomDropdown(items: pobInstrumentList,
                contentPadding: EdgeInsets.symmetric(vertical: 1.2.h,horizontal: 4.w),
                onChanged: widget.isExpenseCreated ? null : (val) {
                 selectedProductPOBType = val;
                },
                selectedValue: selectedProductPOBType,
                labelText: "Product Type",
                hintStyle: const TextStyle(
                  fontSize: 14
                ),
                hintText: "Select product type",
              ),

              if(!widget.isExpenseCreated)
                SizedBox(height: 1.5.h),

              if(!widget.isExpenseCreated)
                CustomTextFormField(
                labelText: "Product Name",
                readOnly: true,
                controller: productNameController,
                  onTap:  widget.isExpenseCreated ? null : () async {
                    var response = await Get.to(
                          () => ProductCategoryPage(onProductSelected: (product) {
                        setState(() {
                          selectedPOBProductItem = product;
                        });
                        // Use Get.back(result: product) if you need to pop the ProductCategoryPage immediately after selection
                      }),
                    );

                    // This assumes that `response` is the product selected from `ProductListPage`
                    if (response != null) {
                      setState(() {
                        selectedPOBProductItem = response;
                        productNameController.text=selectedPOBProductItem!.productName!;
                      });
                    }
                  },

                labelStyle: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5)),
                hintText: "Select product",
                hintStyle: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5)),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),


              if(!widget.isExpenseCreated)
                SizedBox(height: 1.h),

              if(!widget.isExpenseCreated)
                CustomTextFormField(
              labelText: "Quantity",
              controller: selectedPOBQuantity,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.phone,
              readOnly:  widget.isExpenseCreated ? true : false,
              labelStyle: TextStyle(
                  fontSize: 14, color: Colors.black.withOpacity(0.5)),
              hintText: "Enter quantity",
              hintStyle: TextStyle(
                  fontSize: 14, color: Colors.black.withOpacity(0.5)),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            ),

              if(!widget.isExpenseCreated)
              GestureDetector(
                onTap: (){
                  print("Added POB: $selectedProductPOBType, $selectedPOBProductItem, ${selectedPOBQuantity.text}");
                  if (selectedProductPOBType != null && selectedPOBProductItem != null && selectedPOBQuantity.text.isNotEmpty) {
                    dcrReport.pointOfBusiness?.add(Conversion(
                      productType: selectedProductPOBType,
                      productId: selectedPOBProductItem, // Ensure this is just the ID, not the whole Product object
                      qty: selectedPOBQuantity.text,
                    ));
                    setState(() {
                      productNameController.clear();
                      selectedPOBQuantity.clear();
                      selectedProductPOBType=null;
                    });
                  }
                  else if (selectedProductPOBType == null){
                    context.showSnackBar("Select product type", null);
                  }
                  else if (selectedPOBProductItem == null){
                    context.showSnackBar("Select product ", null);
                  }
                  else if (selectedPOBQuantity.text.isEmpty){
                    context.showSnackBar("Select quantity ", null);
                  }

                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: 25.w,
                      padding: EdgeInsets.symmetric(vertical: 0.8.h,horizontal: 2.w),
                      margin: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
                      decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Add",style: TextStyle(
                              color: Colors.white
                          ),),
                          SizedBox(width: 1.w),

                          const Icon(Icons.add,color: Colors.white,),
                        ],
                      )),
                ),
              ),

              if(dcrReport.pointOfBusiness!=null && dcrReport.pointOfBusiness!.isNotEmpty)
                tableWidget(dcrReport.pointOfBusiness!),

              if(!widget.isExpenseCreated || dcrReport.demo!=null && dcrReport.demo!.isNotEmpty)
                titleWidget("Demo",null),
              if(!widget.isExpenseCreated || dcrReport.demo!=null && dcrReport.demo!.isNotEmpty)
                SizedBox(height: 1.5.h),


              if(!widget.isExpenseCreated)
                CustomDropdown(items: pobInstrumentList,
                contentPadding: EdgeInsets.symmetric(vertical: 1.2.h,horizontal: 4.w),
                onChanged: (val) {
                  print(val);
                  selectedProductDemoType = val;
                },
                selectedValue: selectedProductDemoType,
                labelText: "Product Type",
                hintStyle: const TextStyle(
                    fontSize: 14
                ),
                hintText: "Select product type",
              ),

              if(!widget.isExpenseCreated)
                SizedBox(height: 1.5.h),

              if(!widget.isExpenseCreated)
                CustomTextFormField(
                labelText: "Product Name",
                readOnly: true,
                controller: productDemoNameController,
                onTap: () async {
                  var response = await Get.to(
                        () => ProductCategoryPage(onProductSelected: (product) {
                      setState(() {
                        selectedDemoProductItem = product;
                      });
                      // Use Get.back(result: product) if you need to pop the ProductCategoryPage immediately after selection
                    }),
                  );

                  print("Product details: ${jsonEncode(response)}");
                  // This assumes that `response` is the product selected from `ProductListPage`
                  if (response != null) {
                    setState(() {
                      selectedDemoProductItem = response;
                      productDemoNameController.text=selectedDemoProductItem!.productName!;
                    });
                  }
                },

                labelStyle: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5)),
                hintText: "Select product",
                hintStyle: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5)),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),


              if(!widget.isExpenseCreated)
                SizedBox(height: 1.h),

              if(!widget.isExpenseCreated)
                CustomTextFormField(
                labelText: "Quantity",
                controller: selectedDemoQuantity,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
                labelStyle: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5)),
                hintText: "Enter quantity",
                hintStyle: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5)),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),

              if(!widget.isExpenseCreated)
                GestureDetector(
                onTap: (){

                  if (selectedProductDemoType != null && selectedDemoProductItem != null && selectedDemoQuantity.text.isNotEmpty) {
                    dcrReport.demo?.add(Conversion(
                      productType: selectedProductDemoType,
                      productId: selectedDemoProductItem, // Ensure this is just the ID, not the whole Product object
                      qty: selectedDemoQuantity.text,
                    ));
                    setState(() {
                      productDemoNameController.clear();
                      selectedDemoQuantity.clear();
                      selectedProductDemoType=null;
                    });
                  }
                  else if (selectedProductDemoType == null){
                  context.showSnackBar("Select product type", null);
                  }
                  else if (selectedDemoProductItem == null){
                  context.showSnackBar("Select product ", null);
                  }
                  else if (selectedDemoQuantity.text.isEmpty){
                  context.showSnackBar("Select quantity ", null);
                  }

                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: 25.w,
                      padding: EdgeInsets.symmetric(vertical: 0.8.h,horizontal: 2.w),
                      margin: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
                      decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Add",style: TextStyle(
                              color: Colors.white
                          ),),
                          SizedBox(width: 1.w),

                          const Icon(Icons.add,color: Colors.white,),
                        ],
                      )),
                ),
              ),

              if(dcrReport.demo!=null && dcrReport.demo!.isNotEmpty)
                tableWidget(dcrReport.demo!),



              if(!widget.isExpenseCreated || dcrReport.conversions!=null && dcrReport.conversions!.isNotEmpty)
                titleWidget("Conversion",null),
              if(!widget.isExpenseCreated || dcrReport.conversions!=null && dcrReport.conversions!.isNotEmpty)
                SizedBox(height: 1.5.h),

              if(!widget.isExpenseCreated)
                CustomDropdown(items: pobInstrumentList,
                contentPadding: EdgeInsets.symmetric(vertical: 1.2.h,horizontal: 4.w),
                onChanged: (val) {
                  print("problem ${val}");
                  selectedProductConType = val;
                },
                selectedValue: selectedProductConType,
                labelText: "Product Type",
                hintStyle: const TextStyle(
                    fontSize: 14
                ),
                hintText: "Select product type",
              ),

              if(!widget.isExpenseCreated)
                SizedBox(height: 1.5.h),

              if(!widget.isExpenseCreated)
                CustomTextFormField(
                labelText: "Product Name",
                readOnly: true,
                controller: productConversionNameController,
                onTap: () async {
                  var response = await Get.to(
                        () => ProductCategoryPage(onProductSelected: (product) {
                      setState(() {
                        selectedConversionProductItem = product;
                      });
                      // Use Get.back(result: product) if you need to pop the ProductCategoryPage immediately after selection
                    }),
                  );
                  if (response != null) {
                    setState(() {

                      selectedConversionProductItem = response;
                      productConversionNameController.text=selectedConversionProductItem!.productName!;
                    });
                  }
                },

                labelStyle: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5)),
                hintText: "Select product",
                hintStyle: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5)),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),


              if(!widget.isExpenseCreated)
                SizedBox(height: 1.h),

              if(!widget.isExpenseCreated)
                CustomTextFormField(
                labelText: "Quantity",
                controller: selectedConversionQuantity,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
                labelStyle: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5)),
                hintText: "Enter quantity",
                hintStyle: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.5)),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),

              if(!widget.isExpenseCreated)
                GestureDetector(
                onTap: (){

                  if (selectedProductConType != null && selectedConversionProductItem != null && selectedConversionQuantity.text.isNotEmpty) {
                    dcrReport.conversions?.add(Conversion(
                      productType: selectedProductConType,
                      productId: selectedConversionProductItem, // Ensure this is just the ID, not the whole Product object
                      qty: selectedConversionQuantity.text,
                    ));
                    setState(() {
                      productConversionNameController.clear();
                      selectedConversionQuantity.clear();
                      selectedProductConType=null;
                    });
                  }
                  else if (selectedProductConType == null){
                    context.showSnackBar("Select product type", null);
                  }
                  else if (selectedConversionProductItem == null){
                  context.showSnackBar("Select product ", null);
                  }
                  else if (selectedConversionQuantity.text.isEmpty){
                    context.showSnackBar("Select quantity ", null);
                  }

                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      width: 25.w,
                      padding: EdgeInsets.symmetric(vertical: 0.8.h,horizontal: 2.w),
                      margin: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
                      decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Add",style: TextStyle(
                              color: Colors.white
                          ),),
                          SizedBox(width: 1.w),

                          const Icon(Icons.add,color: Colors.white,),
                        ],
                      )),
                ),
              ),

              if(dcrReport.conversions!=null && dcrReport.conversions!.isNotEmpty)
                tableWidget(dcrReport.conversions!),

              if(dcrReport.conversions!=null && dcrReport.conversions!.isNotEmpty)
                SizedBox(height: 2.h),

              SizedBox(height: 2.h),

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
        ),
      ),
    );
  }


  void saveUpdateButtonClick() async{
    if(await InternetUtil.isInternetConnected()){
      if(dcrReport.customerId?.id == ""){
        context.showSnackBar("Select Customer name",null);
      }
      else if(commentController.text.isEmpty ){
        context.showSnackBar("Add comment",null);

      }
      else{
        ProgressDialog.showProgressDialog(context);
        try {
          String userId= await SessionManager.getUserId();
          dcrReport.comment=commentController.text;
          log(jsonEncode(dcrReport.getDCRJsonOnlyKey(userId,widget.dcrReportData?.id,widget.tourPlanVisitId,widget.dcrId)));
          var response = await DCRRepo.addDCRReport(dcrReport.getDCRJsonOnlyKey(userId,dcrReport.id,widget.tourPlanVisitId,widget.dcrId));
          if(response.status){
            Get.back();
            Get.to(LabListPage(tourPlanVisitId: widget.tourPlanVisitId,dcrId: response.data,areaName: widget.areaName ?? "", isExpenseCreated: widget.isExpenseCreated,));
            print("data is here${response.data}");
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
  Widget dividerWidget()=> Divider(
    color: Colors.black.withOpacity(0.3),
  );

  Widget  _titleFieldWidget(String title) => Container(
    margin: EdgeInsets.symmetric(vertical: 1.h),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.transparent,
        fontSize: 15,
        decoration: TextDecoration.underline,
        decorationColor: Constants.primaryColor,
        decorationThickness: 1.5,
        shadows: [
          Shadow(
              color: Constants.primaryColor, offset: Offset(0, -3))
        ],
        fontWeight: FontWeight.w500,
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

  Widget tableWidget(List<Conversion> pointsOfBusiness)=> Container(
    margin: const EdgeInsets.all(8.0),
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(64),
        3: FixedColumnWidth(64),
      },
      border: TableBorder.all(),
      children: [
        // Header row
         TableRow(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Type'),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Name'),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('QTY'),
            ),
            if(!widget.isExpenseCreated)
              const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Remove'),
            ),
          ],
        ),
        // Data rows
        ...pointsOfBusiness.map((point) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(point.productType ?? 'N/A',style: const TextStyle(
                  fontSize: 13
                ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(point.productId?.productName ?? 'N/A',style: const TextStyle(
                    fontSize: 13
                ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(point.qty.toString(),style: const TextStyle(
                    fontSize: 13
                ),),
              ),
              if(!widget.isExpenseCreated)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    pointsOfBusiness.remove(point);
                  });
                },
              ),
            ],
          );
        }).toList(),
      ],
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
        onChanged: onChanged,
        title: Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    ),
  );

  Widget titleWidget(String title,EdgeInsetsGeometry? margin) => Container(
    margin: margin ?? EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.w),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.transparent,
        fontSize: 15,
        decoration: TextDecoration.underline,
        decorationColor: Constants.primaryColor,
        decorationThickness: 1.5,
        shadows: [
          Shadow(
              color: Constants.primaryColor, offset: Offset(0, -3))
        ],
        fontWeight: FontWeight.w500,
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
        // DateTime currentDate = DateTime.now();
        //
        // // Create a new DateTime object with the selected time and the current date
        // DateTime selectedDateTime = DateTime(
        //   currentDate.year,
        //   currentDate.month,
        //   currentDate.day,
        //   picked.hour,
        //   picked.minute,
        // );

        // print("Selected DateTime: $selectedDateTime");

        // Assign the selected DateTime to your variable (dcrReport.visitTime)
        dcrReport.visitTime = formattedTime;
      });
    }
  }

  Widget visitedWithDropDown()=>SizedBox(
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
        onChanged:widget.isExpenseCreated ? null : ( UserDetails? val){
          if(!widget.isExpenseCreated) {
            selectedUser=val;
            dcrReport.visitedWith = val;
          }
        },
      ),
    ),
  );


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


}
