import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/repo/customer_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/create_customer_page.dart';
import 'package:tulip_app/ui_designs/home_tab/products_catalogue/product_details_page.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/open_url.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/zoom_image.dart';

class CustomerDetailsPage extends StatefulWidget {
  final String customerId;
  final bool fromCreatePage;
  const CustomerDetailsPage({Key? key, required this.customerId, this.fromCreatePage=false}) : super(key: key);

  @override
  CustomerDetailsPageState createState() => CustomerDetailsPageState();
}

class CustomerDetailsPageState extends State<CustomerDetailsPage> {


  LeadDetails? customerData;
  @override
  void initState() {
    super.initState();
    getCustomerInfo(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(widget.fromCreatePage){
          Get.back(result: true);
          return true;
        }
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Customer Details',implyStatus: true,
        actions: [
          GestureDetector(
              onTap: () async {
                 var result= await Get.to(
                    CreateCustomerPage(createCustomer: customerData),
                  transition: Transition.fade
                );
                 if
                 (result!=null){
                   getCustomerInfo(result);
                 }
              },
              child: const Icon(Icons.edit)),
          const SizedBox(width: 10)
        ],
        ),
        body: Container(
          margin: EdgeInsets.only(left: 3.w,right: 3.w,top: 2.h,bottom: 2.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1),
                  color: const Color(0xffC3C3C3).withOpacity(0.25),
                  blurRadius: 4,
                  spreadRadius: 0),
              BoxShadow(
                  offset: const Offset(0, -1),
                  color: const Color(0xffC3C3C3).withOpacity(0.25),
                  blurRadius: 4,
                  spreadRadius: 0),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 1.h),


                _titleFieldWidget("Company Info"),

                _customerTextWidget(
                    "assets/menu_icons/profile_icon.png",
                    "Customer / Lab Name ",
                    customerData?.customerName ?? "",
                    ""),



                if(customerData?.companyMobileNumber!=null && customerData!.companyMobileNumber!.isNotEmpty)
                  Container(
                  padding: EdgeInsets.only(left : 5.w,bottom: 1.h,top: 1.h,right: 4.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Image.asset(
                          "assets/other_images/call_dark_icon.png",
                          height: 15,
                          width: 15,
                          color: Constants.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Customer Contact No : ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(child: Text(customerData?.companyMobileNumber ?? "",
                        style: const TextStyle(
                            fontSize: 13
                        ),),
                      ),

                      GestureDetector(
                          onTap: (){
                            OpenUrl.callNumber(customerData?.companyMobileNumber ?? "");
                          },
                          child: Image.asset("assets/other_images/call_dark_icon.png",height: 18,width: 18)),
                      SizedBox(width: 2.w),
                      GestureDetector(
                          onTap: (){
                            OpenUrl.openWhatsApp(customerData?.companyMobileNumber ?? "");
                          },
                          child: Image.asset("assets/lead_page_icon/whatsapp_icon.png",height: 18,width: 18)),


                    ],
                  ),
                ),



                if(customerData?.companyEmailId!=null && customerData!.companyEmailId!.isNotEmpty)
                  _customerTextWidget(
                    "assets/lead_page_icon/email_icon.png",
                    "Customer / Lab Email Id ",
                    customerData?.companyEmailId ?? "",
                    ""),




                if(customerData?.customerTypeId?.customerTypeName!=null)
                  _customerTextWidget(
                    "assets/other_images/type_icon.png",
                    "Customer Type",
                    customerData?.customerTypeId?.customerTypeName ?? "",
                    ""),


                _customerTextWidget(
                    "assets/lead_page_icon/address_icon.png",
                    "Address",
                    "${customerData?.address1}${customerData?.address2 != null ? ', ${customerData?.address2}' : ''}${customerData?.address3 != null ? ', ${customerData?.address3}' : ''}, ${customerData?.city}, ${customerData?.state}, ${customerData?.pinCode}",
                    ""),


                _customerTextWidget(
                    "assets/lead_page_icon/address_icon.png",
                    "Area",
                    customerData?.townId?.townName ?? "",
                    ""),

                if(customerData?.gstLicenceCertificate!=null && customerData!.gstLicenceCertificate!.isNotEmpty)
                  SizedBox(height: 1.h),
                if(customerData?.gstLicenceCertificate!=null && customerData!.gstLicenceCertificate!.isNotEmpty)
                  _titleFieldWidget("GST Certificate"),


                if(customerData?.gstNumber!=null && customerData!.gstNumber!.isNotEmpty)
                  _customerTextWidget(
                    "assets/lead_page_icon/gst_icon.png",
                    "GST No",
                    customerData?.gstNumber ?? "",
                    ""),


                if(customerData?.gstLicenceCertificate!=null && customerData!.gstLicenceCertificate!.isNotEmpty)
                  SizedBox(
                    height: 12.h,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: customerData?.gstLicenceCertificate?.length,
                        itemBuilder: (context,index){
                          return imageListWidget(customerData!.gstLicenceCertificate![index]);
                        }),
                  ),


                if(customerData?.drugLicenceNumber!=null && customerData!.drugLicenceNumber!.isNotEmpty)
                  SizedBox(height: 1.h),
                if(customerData?.drugLicenceCertificate!=null && customerData!.drugLicenceCertificate!.isNotEmpty)
                  _titleFieldWidget("Drug Certificate"),

                if(customerData?.drugLicenceNumber!=null && customerData!.drugLicenceNumber!.isNotEmpty)
                  _customerTextWidget(
                    "assets/lead_page_icon/drug_icon.png",
                    "Drug License No",
                    customerData?.drugLicenceNumber ?? "",
                    ""),


                if(customerData?.drugLicenceCertificate!=null && customerData!.drugLicenceCertificate!.isNotEmpty)
                  SizedBox(
                    height: 12.h,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: customerData?.drugLicenceCertificate?.length,
                        itemBuilder: (context,index){
                          return imageListWidget(customerData!.drugLicenceCertificate![index]);
                        }),
                  ),



                const Divider(
                  color: Colors.black,
                ),

                if(customerData?.contactPersonName!=null && customerData!.contactPersonName!.isNotEmpty)
                  _titleFieldWidget("Contact Person Info"),

                if(customerData?.contactPersonName!=null && customerData!.contactPersonName!.isNotEmpty)
                _customerTextWidget(
                    "assets/menu_icons/profile_icon.png",
                    "Contact Person Name ",
                    customerData?.contactPersonName ?? "",
                    ""),




                if(customerData?.contactPersonMobileNumber!=null && customerData!.contactPersonMobileNumber!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.only(left : 5.w,bottom: 1.h,top: 1.h,right: 4.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Image.asset(
                            "assets/other_images/call_dark_icon.png",
                            height: 15,
                            width: 15,
                            color: Constants.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Contact Person Number : ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Expanded(child: Text(customerData?.contactPersonMobileNumber  ?? "",
                          style: const TextStyle(
                              fontSize: 13
                          ),),
                        ),

                        GestureDetector(
                            onTap: (){
                              OpenUrl.callNumber(customerData?.contactPersonMobileNumber  ?? "");
                            },
                            child: Image.asset("assets/other_images/call_dark_icon.png",height: 18,width: 18)),
                        SizedBox(width: 2.w),
                        GestureDetector(
                            onTap: (){
                              OpenUrl.openWhatsApp(customerData?.contactPersonMobileNumber  ?? "");
                            },
                            child: Image.asset("assets/lead_page_icon/whatsapp_icon.png",height: 18,width: 18)),


                      ],
                    ),
                  ),



                if(customerData?.designation!=null && customerData!.designation!.isNotEmpty)
                  _customerTextWidget(
                    "assets/other_images/designation.png",
                    "Designation",
                    customerData?.designation ?? "",
                    ""),

                  if(customerData?.qualification!=null && customerData!.qualification!.isNotEmpty)
                  _customerTextWidget(
                    "assets/other_images/qual_icon.png",
                    "Qualification",
                    customerData?.qualification ?? "",
                    ""),


                const Divider(
                  color: Colors.black,
                ),

                _titleFieldWidget("Product Info"),


                Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  alignment: Alignment.center,
                  child: Table(
                    columnWidths: const {
                      0: FractionColumnWidth(0.2), // 20% for Name
                      1: FractionColumnWidth(0.2), // 20% for Product Brand
                      2: FractionColumnWidth(0.2), // 20% for Potential
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
                      if(customerData?.products !=null)
                      ...customerData!.products!.map((item) {
                        return productTableWidget(item);
                      }).toList(),
                      // Add more TableRow entries as needed (up to 5)
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

  TableRow productTableWidget(Product product)=> TableRow(
    children: [
      TableCell(
        child: GestureDetector(
          onTap: ()=>Get.to(()=>ProductDetailPage(productId: product.id ?? ""),transition: Transition.fade),
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


  Widget _customerTextWidget(String imagePath, String title, String date, String time) => Container(
    padding: EdgeInsets.only(left : 5.w,bottom: 1.h,top: 1.h,right: 4.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Image.asset(
            imagePath,
            height: 15,
            width: 15,
            color: Constants.primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "$title : ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        Expanded(child: Text("$date  $time",
          style: const TextStyle(
              fontSize: 13
          ),),
        ),



      ],
    ),
  );

  Widget imageListWidget(String imagePath)=>GestureDetector(
    onTap: (){
      Navigator.push(context,Constants.createRoute(ZoomInImagePage(imagePath: imagePath)),);
    },
    child: Hero(
      key: UniqueKey(),
      tag: imagePath.hashCode.toString(),
      child: Container(
        height: 14.h,width: 14.h,
        decoration:BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: const Color(0xffC3C3C3).withOpacity(0.30),
                offset: const Offset(0, 0),
                spreadRadius: 3,
                blurRadius: 2),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
        padding: EdgeInsets.all(imagePath.isEmpty ? 20 :0),
        child: CachedNetworkImage(
          imageUrl: imagePath,fit: BoxFit.fill,
        ),),
    ),
  );


  Widget _titleFieldWidget(String title) => Container(
    margin: EdgeInsets.only(left: 3.w),
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


  Future<void> getCustomerInfo(String customerId) async {
    var response = await CustomerRepo.getCustomerDetails(customerId);
    if(response.status){
      customerData=response.data;
      setState(() {

      });
    }
  }


}
