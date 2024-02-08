import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/distributor_model/distributors_list.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/model/login_data.dart';
import 'package:tulip_app/repo/login_master.dart';
import 'package:tulip_app/ui_designs/home_tab/distribution_ui/distributor_search_delegate.dart';
import 'package:tulip_app/ui_designs/home_tab/distribution_ui/file_monthly_sale_page.dart';
import 'package:tulip_app/ui_designs/home_tab/products_catalogue/product_category_page.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/custom_button.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class CreateMonthlySale extends StatefulWidget {
  const CreateMonthlySale({Key? key}) : super(key: key);

  @override
  _CreateMonthlySaleState createState() => _CreateMonthlySaleState();
}

class _CreateMonthlySaleState extends State<CreateMonthlySale> {
  TextEditingController distributorController=TextEditingController();
  TextEditingController productNameController=TextEditingController();
  DistributorList distributorDetail = DistributorList(id: "", businessName: "");
  Product product = Product(id: '');
  UserDetails? userDetails;
  List<String> monthList = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Monthly Sale',implyStatus: true,showBackButton: true,),

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w,),
        child: Column(
          children: [

            Container(
              margin: EdgeInsets.symmetric(vertical: 2 .h),
              decoration: BoxDecoration(
                  color: Constants.white,
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
                  ],
                  ),
              child: Column(
                children: [
                  distributorDetailsWidget("Trs year" , DateTime.now().year.toString()),
                  distributorDetailsWidget("Month",monthList[DateTime.now().month-1]),
                  distributorDetailsWidget("Employee Name",userDetails?.userName ?? ""),
                  distributorDetailsWidget("Region",userDetails?.territory?.region?.regionName ?? ""),
                  distributorDetailsWidget("Territory",userDetails?.territory?.territoryName ?? ""),
                  distributorDetailsWidget("HQ",userDetails?.regionHq?.headquaterName ?? ""),
                ],
              ),
            ),



            CustomTextFormField(
              hintText: "Search Distributor",
              controller: distributorController,
              onTap: () async {
                final data = await showSearch(
                  context: context,
                  delegate: DistributorSearchDelegate(userDetails?.territory?.id ?? ""),
                );
                if(data!=null){
                  distributorDetail=data;
                  distributorController.text=data!.businessName;
                  setState(() {});
                }

              },
              readOnly: true,
              validator: (val){
                if(val!=null && val.isNotEmpty){
                  return null;
                }
                else{
                  return "Search Distributor";
                }
              },
            ),

            // CustomTextFormField(
            //   readOnly: true,
            //   controller: productNameController,
            //   onTap: () async {
            //     var response = await Get.to(
            //           () => ProductCategoryPage(onProductSelected: (product) {
            //         setState(() {
            //           product = product;
            //         });
            //         // Use Get.back(result: product) if you need to pop the ProductCategoryPage immediately after selection
            //       }),
            //     );
            //
            //     // This assumes that `response` is the product selected from `ProductListPage`
            //     if (response != null) {
            //       setState(() {
            //         product = response;
            //         productNameController.text=product!.productName!;
            //       });
            //     }
            //   },
            //
            //   labelStyle: TextStyle(
            //       fontSize: 14, color: Colors.black.withOpacity(0.5)),
            //   hintText: "Select product group",
            //   hintStyle: TextStyle(
            //       fontSize: 14, color: Colors.black.withOpacity(0.5)),
            //   contentPadding:
            //   EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            // ),

            const Spacer(),

             CustomButton(title: "Next",onTabButtonCallback: (){
               if(distributorDetail.id !=null && distributorDetail.id!.isNotEmpty){
                 Get.to(()=>  FileMonthlySalePage(distributorId: distributorDetail.id ?? "") );
               }
               else{
                 context.showSnackBar("Please select distributor", null);
               }

              },),
          ],
        ),
      ),
    );
  }

  Widget distributorDetailsWidget(
      String title,
      String details,
      ) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 1.w,vertical: 0.8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 33.w,
              child: Text(
                "$title : ",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
                child: Text(
                  details,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                )),
          ],
        ),
      );

  Future<void> getUserData() async {
    var response = await LoginMaster.getUserInfo();
    if (response.status) {
      // TODO  save user data
      if (response.data != null) {
        userDetails = response.data!;

        setState(() {});
        // }
      } else {
        context.showSnackBar("Something went wrong", null);
      }
    } else {
      context.showSnackBar("${response.message}", null);
    }
  }

}
