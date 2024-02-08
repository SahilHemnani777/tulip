import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/customer_model/brand_model.dart';
import 'package:tulip_app/model/customer_model/get_area_model.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/customer_detail_page.dart';
import 'package:tulip_app/util/extension/string_ext_util.dart';
import 'package:tulip_app/util/location_controller.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/util/storage_utils_ext.dart';
import 'package:tulip_app/repo/customer_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/area_search_delegate.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/brand_search_delegate.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/product_list_sheet.dart';
import 'package:tulip_app/ui_designs/home_tab/products_catalogue/product_details_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/custom_button.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';
import 'package:tulip_app/widget/search_observable.dart';
import 'package:tulip_app/widget/zoom_image.dart';

class CreateCustomerPage extends StatefulWidget {
  final LeadDetails? createCustomer;
  final bool fromCreate;
  const CreateCustomerPage({Key? key, this.createCustomer,this.fromCreate=false}) : super(key: key);

  @override
  CreateCustomerPageState createState() => CreateCustomerPageState();
}

class CreateCustomerPageState extends State<CreateCustomerPage> {
  Area? area;
  List<dynamic> gstLicenseImageList = [];
  List<dynamic> drugLicenseImageList = [];
  BrandItem? selectedBrand;
  CustomerTypeId? companyTypeId;
  LeadDetails? createCustomer;
  List<CustomerTypeId> companyList = [];
  LocationController locationController= Get.find();
  TextEditingController areaController=TextEditingController();
  ImagePicker picker = ImagePicker();


  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SearchObservable searchObservable = SearchObservable();

  @override
  void initState() {
    super.initState();
    getCompanyType();
    if(widget.createCustomer!=null){
      createCustomer=LeadDetails.fromJson(widget.createCustomer!.toJson());
      if(widget.createCustomer?.gstLicenceCertificate !=null){
        for (var element in widget.createCustomer!.gstLicenceCertificate!) {
          gstLicenseImageList.add(element);
        }
      }
      if(widget.createCustomer?.drugLicenceCertificate !=null){
        for (var element in widget.createCustomer!.drugLicenceCertificate!) {
          drugLicenseImageList.add(element);
        }
      }
      areaController.text=widget.createCustomer!.townId!.townName;
    }
    else{
      createCustomer=LeadDetails(id: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.createCustomer !=null ? "Edit Customer" :"Create Customer",implyStatus: true,),
      body : Container(
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                 CustomTextFormField(
                    hintText: "Search area", labelText: "Area*",
                controller: areaController,
                onTap : openSearchDelegate,
                   validator: (val){
                      if(val!=null && val.isNotEmpty){
                        return null;
                      }
                      else{
                        return "Search Area";
                      }
                   },
                ),
                SizedBox(height: 1.h),


                 CustomTextFormField(
                    hintText: "Customer name", labelText: "Customer Name*",
                  onSaved: (val)=>createCustomer?.customerName=val,
                  initialValue: createCustomer?.customerName,
                   textCapitalization: TextCapitalization.words,
                   validator: (val){
                    if(val!=null && val.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Enter customer name";
                    }
                  },
                ),
                SizedBox(height: 1.h),
                customerTypeDropDown(),

                SizedBox(height: 1.h),
                CustomTextFormField(
                    hintText: "Enter GST Number", labelText: "GST Number Number",
                  validator: (val){
                    if(val!.isNotEmpty && !val.validateGSTN()){
                      return "Enter valid GST No";
                    }
                    return null;
                  },
                  onSaved: (val)=>createCustomer?.gstNumber=val,
                  initialValue: createCustomer?.gstNumber,
                ),

                const Text(
                  "Upload GST License certificate",
                  style: TextStyle(fontSize: 14),
                ),

                _getImagesList(gstLicenseImageList),

                SizedBox(height: 1.h),


                CustomTextFormField(
                    hintText: "Enter drug license Number",
                    labelText: "Drug License Number Number",

                  onSaved: (val)=>createCustomer?.drugLicenceNumber=val,
                  initialValue: createCustomer?.drugLicenceNumber,
                ),

                const Text(
                  "Upload Drug License certificate",
                  style: TextStyle(fontSize: 14),
                ),

                _getImagesList(drugLicenseImageList),
                SizedBox(height: 1.h),
                 CustomTextFormField(
                    hintText: "Enter contact person name",
                    labelText: "Contact Person Name",
                   textCapitalization: TextCapitalization.words,
                   onSaved: (val)=>createCustomer?.contactPersonName=val,
                  initialValue: createCustomer?.contactPersonName,

                ),

                CustomTextFormField(
                  hintText: "Enter contact person number",

                  labelText: "Contact Person Number",
                  onSaved: (val)=>createCustomer?.contactPersonMobileNumber=val,
                  initialValue: createCustomer?.contactPersonMobileNumber,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                    keyboardType: TextInputType.number,
                ),

                CustomTextFormField(
                    hintText: "Enter designation", labelText: "Designation",
                  onSaved: (val)=>createCustomer?.designation=val,
                  textCapitalization: TextCapitalization.words,
                  initialValue: createCustomer?.designation,
                ),
                 CustomTextFormField(
                    hintText: "Enter qualification", labelText: "Qualification",
                  onSaved: (val)=>createCustomer?.qualification=val,
                   textCapitalization: TextCapitalization.words,
                   initialValue: createCustomer?.qualification,
                ),
                CustomTextFormField(
                    hintText: "Enter company contact number",
                    labelText: "Company Contact Number",

                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    onSaved: (val)=>createCustomer?.companyMobileNumber=val,
                    initialValue: createCustomer?.companyMobileNumber,
                    maxLength: 10),

                CustomTextFormField(
                    hintText: "Enter email", labelText: "Company Email ID",
                  onSaved: (val)=>createCustomer?.companyEmailId=val,
                  initialValue: createCustomer?.companyEmailId,
                  keyboardType: TextInputType.emailAddress,
                ),
                 CustomTextFormField(
                    hintText: "Enter address", labelText: "Address 1*",
                  onSaved: (val)=>createCustomer?.address1=val,
                  initialValue: createCustomer?.address1,
                   textCapitalization: TextCapitalization.words,
                   validator: (val){
                     if(val!=null && val.isNotEmpty){
                       return null;
                     }
                     else{
                       return "Enter address one";
                     }
                   },

                ),
                 CustomTextFormField(
                    hintText: "Enter address", labelText: "Address 2*",
                  onSaved: (val)=>createCustomer?.address2=val,
                   textCapitalization: TextCapitalization.words,
                   initialValue: createCustomer?.address2,
                  validator: (val){
                    if(val!=null && val.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Enter address two";
                    }
                  },
                ),
                 CustomTextFormField(
                    hintText: "Enter address", labelText: "Address 3",
                  onSaved: (val)=>createCustomer?.address3=val,
                   textCapitalization: TextCapitalization.words,
                   initialValue: createCustomer?.address3,
                  ),
                 CustomTextFormField(
                    hintText: "Enter city", labelText: "City*",
                  onSaved: (val)=>createCustomer?.city=val,
                   textCapitalization: TextCapitalization.words,
                   initialValue: createCustomer?.city,
                  validator: (val){
                    if(val!=null && val.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Enter city";
                    }
                  },),
                 CustomTextFormField(
                    hintText: "Enter state", labelText: "State*",
                  onSaved: (val)=>createCustomer?.state=val,
                   textCapitalization: TextCapitalization.words,
                   initialValue: createCustomer?.state,
                  validator: (val){
                    if(val!=null && val.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Enter state";
                    }
                  },
                ),
                 CustomTextFormField(
                    hintText: "Enter pincode", labelText: "Pincode*",
                   keyboardType: TextInputType.number,
                   onSaved: (val)=>createCustomer?.pinCode=val,
                  initialValue: createCustomer?.pinCode,
                  validator: (val){
                    if(val!=null && val.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Enter pincode";
                    }
                  },
                ),
                SizedBox(height: 1.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add Products*",
                      style: TextStyle(fontSize: 14),
                    ),


                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              bool showError = false;
                              return StatefulBuilder(
                                builder: (_, setStateInner) {
                                  return Material(
                                    type: MaterialType.transparency,
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 80.w,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 4.h),
                                              padding: EdgeInsets.only(
                                                  left: 4.w,
                                                  right: 4.w,
                                                  top: 3.h),
                                              decoration: BoxDecoration(
                                                  color: const Color(0xffF8F8F8),
                                                  borderRadius:
                                                  BorderRadius.circular(15)),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final data =
                                                      await showSearch(
                                                        context: context,
                                                        delegate: BrandSearchDelegate(),
                                                      );
                                                      if (data != null) {
                                                        showError = false;
                                                        selectedBrand = data;
                                                        print(selectedBrand?.id);
                                                        setStateInner(() {});
                                                      }
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      padding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 1.4.h),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(6),
                                                          border: Border.all(
                                                              color: Constants.lightGreyBorderColor)),
                                                      child: Text(
                                                        selectedBrand == null
                                                            ? "Select branch" : selectedBrand?.productBrandName ?? "",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (showError)
                                                    const Text(
                                                      "Select branch",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.red),
                                                    ),
                                                  CustomButton(
                                                    title: "Next",
                                                    onTabButtonCallback:
                                                        () async {
                                                      if (selectedBrand != null) {
                                                        Get.back();
                                                        var response = await showModalBottomSheet(
                                                            context: context,
                                                            enableDrag: false,
                                                            isDismissible: false,
                                                            isScrollControlled:
                                                            true,
                                                            builder: (context) {
                                                              return ProductListSheet(brandId: selectedBrand!.id!,selectedProducts: createCustomer?.products);
                                                            });
                                                        setState(() {
                                                          if(response!=null){
                                                            createCustomer?.products=response;
                                                            print(response);
                                                          }
                                                        });

                                                      }
                                                      else {
                                                        showError = true;
                                                        setStateInner(() {});
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                  padding:
                                                  const EdgeInsets.all(10),
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
                                    ),
                                  );
                                },
                              );
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
                          decoration: BoxDecoration(
                              color: Constants.lightGreyColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1, color: const Color(0xffD1D4D6))),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 20)),
                    ),

                  ],
                ),

                if(createCustomer?.products!=null && createCustomer!.products!.isNotEmpty)
                selectedProductTable(createCustomer!.products!),


                SizedBox(
                  height: 1.5.h,
                ),
                CustomTextFormField(
                  labelText: "Note",
                  onSaved: (val)=>createCustomer?.notes=val,
                  initialValue: createCustomer?.notes,
                  textCapitalization: TextCapitalization.sentences,
                  labelStyle: TextStyle(
                      fontSize: 14, color: Colors.black.withOpacity(0.5)),
                  hintText: "Additional Note......",
                  maxLines: 4,
                  hintStyle: TextStyle(
                      fontSize: 14, color: Colors.black.withOpacity(0.5)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                ),
                 CustomButton(title: widget.createCustomer !=null ? "Update":"Create",onTabButtonCallback: onCreateClick),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customerTypeDropDown()=>SizedBox(
    height: 5.5.h,
    child: DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
        isDense: true,
        style: const TextStyle(
            fontSize: 13,
            color: Colors.black
        ),
        decoration: InputDecoration(
          hintText: "Select company type",
          hintStyle: TextStyle(
              fontSize: 14, color: Colors.black.withOpacity(0.5),
          ),
          fillColor: Colors.white,
          labelText: "Company Type",
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
        value: companyTypeId,
        isExpanded: true,

        items: companyList.map((CustomerTypeId item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item.customerTypeName ?? ""),
          );
        }).toList(),
        onChanged: (val){
          companyTypeId=val;
          if(companyTypeId!=null) {
            createCustomer?.customerTypeId=companyTypeId!;
          }
        },
      ),
    ),
  );




  Widget _getImagesList(List imageFileList) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          //select image from gallary or camera
          chooseMultipleImage(imageFileList);
        },
        child: Container(
            height: 70,
            width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Constants.lightGreyColor,
                borderRadius: BorderRadius.circular(5),
                border:
                Border.all(width: 1, color: const Color(0xffD1D4D6))),
            child: const Icon(Icons.add, color: Colors.white, size: 45)),
      ),
      Expanded(
        child: Container(
          height: 80,
          width: 80,
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              if (imageFileList.isNotEmpty)
                ...List.generate(imageFileList.length, (index) {
                  return Stack(
                    children: [
                      //image
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 5),
                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(8)),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                Constants.createRoute(ZoomInImagePage(imagePath: imageFileList[index])),
                              );
                            },
                            child: Hero(
                              tag: imageFileList[index].hashCode.toString(),
                              child: imageFileList[index].runtimeType != String ?
                              Image.file(
                                File(imageFileList[index].path),width: 70,height: 70,
                                //fit: BoxFit.cover,
                              ): CachedNetworkImage(imageUrl: imageFileList[index],height: 70,width: 70,),
                            ),
                          ),
                        ),
                      ),
                      //close
                      Positioned(
                        top: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            //delete item from list
                            imageFileList.remove(imageFileList[index]);
                            debugPrint("${imageFileList.length}");
                            setState(() {});
                          },
                          child: Container(
                              height: 16,
                              width: 16,
                              decoration: const BoxDecoration(
                                color: Color(0xffFF0000),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 8,
                              )),
                        ),
                      )
                    ],
                  );
                }),
            ],
          ),
        ),
      ),
    ],
  );




  Widget selectedProductTable(List<Product> productInfo)=> Container(
    margin: EdgeInsets.symmetric(vertical: 1.h),
    alignment: Alignment.center,
    child: Table(
      columnWidths: const {
        0: FractionColumnWidth(0.25), // 20% for Name
        1: FractionColumnWidth(0.2), // 20% for Product Brand
        2: FractionColumnWidth(0.25), // 20% for Potential
        3: FractionColumnWidth(0.3), // 20% for Competitor Usage
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: Colors.black,
        width: 1.0,
      ),
      children: [
        // Header row
        const TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                child: Text(
                  'Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                child: Text(
                  'Brand',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                child: Text(
                  'Potential',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                child: Text(
                  'Competitor Usage',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        // Data rows
        ...productInfo.map((item) {
          return productTableWidget(item);
        }).toList(),

      ],
    ),
  );


   TableRow productTableWidget(Product product)=> TableRow(
    children: [
      TableCell(
        child: GestureDetector(
          onTap: ()=>Get.to(()=> ProductDetailPage(productId: product.id ?? ""),transition: Transition.fade),
          child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.productName ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.transparent,
                fontSize: 12,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
                decorationThickness: 1.5,
                shadows: [
                  Shadow(
                      color: Colors.blue, offset: Offset(0, -3))
                ],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
       TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            product.brandId?.productBrandName ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
       TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            product.potential ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
       TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            product.competitor ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    ],
  ); // Add more TableRow entries as needed (up to 5)

  Future<void> chooseMultipleImage(List<dynamic> imageFileList) async {

    final List<XFile> selectedImages = await picker.pickMultipleMedia();

    imageFileList.addAll(selectedImages);

    setState(() {});
  }
  Future<void> openSearchDelegate() async {
    final data = await showSearch(
      context: context,
      delegate: AreaSearchDelegate(),
    );
    if(data!=null){
      area=data;
      createCustomer?.townId=data;
      areaController.text=data!.townName;
      setState(() {

      });
    }
  }

  Future<void> getCompanyType() async {
    var response = await CustomerRepo.getCustomerTypeList();
    if(response.status){
      companyList=response.data!;

      if(widget.createCustomer!=null){
        companyTypeId = companyList.firstWhere((element) => element.id == widget.createCustomer?.customerTypeId?.id);
      }
      setState(() {

      });
    }
  }

  Future<void> onCreateClick() async {
    if(await InternetUtil.isInternetConnected()){
      ProgressDialog.showProgressDialog(context);
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

       if(createCustomer?.customerTypeId!=null){
         if(createCustomer?.products!=null && createCustomer!.products!.isNotEmpty){
           try{

             List<String> imageUploadFileGST = [];
             List<String> imageUploadFileDrug = [];

             if(gstLicenseImageList.isNotEmpty){

               for(int i=0;i<gstLicenseImageList.length;i++){

                 if(gstLicenseImageList[i].runtimeType == String){
                   imageUploadFileGST.add(gstLicenseImageList[i].toString());
                 }
                 else {

                   Uint8List path = await gstLicenseImageList[i].readAsBytes();

                   if(path.lengthInBytes > 1000000) {
                     var data = await imageCompress(path);

                     var temp = await data.uploadBytesToFirebase("Customer/GSTCertificate/${DateTime.now().millisecondsSinceEpoch}.jpg");
                     imageUploadFileGST.add(temp);
                   }
                   else{
                     var temp = await path.uploadBytesToFirebase("Customer/GSTCertificate/${DateTime.now().millisecondsSinceEpoch}.jpg");
                     imageUploadFileGST.add(temp);
                   }
                 }
               }
             }
             else {
               print("no image selected");
             }


             if(drugLicenseImageList.isNotEmpty){
               //upload to aws & get link
               for(int i=0;i<drugLicenseImageList.length;i++){

                 if(drugLicenseImageList[i].runtimeType == String){
                   imageUploadFileDrug.add(drugLicenseImageList[i].toString());
                 }
                 else {

                   Uint8List path = await drugLicenseImageList[i].readAsBytes();

                   if(path.lengthInBytes > 1000000) {
                     var data = await imageCompress(path);

                     var temp = await data.uploadBytesToFirebase("Customer/DrugCertificate/${DateTime.now().millisecondsSinceEpoch}.jpg");
                     imageUploadFileDrug.add(temp);
                   }
                   else{
                     var temp = await path.uploadBytesToFirebase("Customer/DrugCertificate/${DateTime.now().millisecondsSinceEpoch}.jpg");
                     imageUploadFileDrug.add(temp);
                   }

                 }

               }
             }
             else {
               print("no image selected");
             }

             print("Image is ::::::$imageUploadFileGST");

             createCustomer?.gstLicenceCertificate = imageUploadFileGST;
             createCustomer?.drugLicenceCertificate = imageUploadFileDrug;


             String userId= await SessionManager.getUserId();

             var response = await CustomerRepo.createCustomer(createCustomer!.getJsonOnlyKey(locationController.latitude.value,locationController.longitude.value,userId,false));
             if(response.status){
               Get.back();
               context.showSnackBar(widget.createCustomer !=null ? "Customer Details Updated":"Customer Created Successfully", null);
               if(widget.fromCreate){
                 Get.off(CustomerDetailsPage(customerId: response.data,fromCreatePage: true));
               }
               else{
                 Get.back(result: response.data);
               }

             }
           }
           catch(e,stack){
             debugPrint("Error : $e \n $stack");
           }
         }
         else{
           Get.back();
           context.showSnackBar("Add Products", null);
         }

       }else{
         context.showSnackBar("Please select company type",null);
         Get.back();
        }
      } else {
        Get.back();
        context.showSnackBar("Please enter all details",null);
        setState(() {
          _autoValidateMode = AutovalidateMode.onUserInteraction;
        });
      }



    }
  }

  Future<Uint8List> imageCompress(Uint8List data) async {
    var result = await FlutterImageCompress.compressWithList(
      data,
      minHeight: 800,
      minWidth: 800,
      quality: 80,
    );
    return result;
  }


  // Future<void> getLocation() async {
  //   try {
  //     final Position position = await Geolocator.getCurrentPosition();
  //
  //     latitude = position.latitude.toString();
  //     longitude = position.longitude.toString();
  //     print("Long gg g gg${latitude}");
  //
  //     setState(() {
  //     });
  //   } catch (e) {
  //     print("Error obtaining location: $e");
  //   }
  // }





  @override
  void dispose() {
    searchObservable.dispose();
    areaController.dispose();
    super.dispose();
  }
}
