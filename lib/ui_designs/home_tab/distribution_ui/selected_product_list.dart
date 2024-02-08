import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/distributor_model/distributor_products_list.dart';
import 'package:tulip_app/repo/distributor_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/distribution_ui/distirbution_list_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/custom_button.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

import 'soldDistributorWidget.dart';

class SelectedProductList extends StatefulWidget {
  final List<DistributorProductList> selectedProducts;
  final DateTime? selectedDate;
  const SelectedProductList({Key? key, required this.selectedProducts, this.selectedDate}) : super(key: key);

  @override
  _SelectedProductListState createState() => _SelectedProductListState();
}

class _SelectedProductListState extends State<SelectedProductList> {
  List<DistributorProductList> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.selectedProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Selected Products",showBackButton: true),

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          children: [
            SizedBox(height: 1.h),

            CustomTextFormField(
              hintText: "Search Products",
              onChanged: (val) {
                setState(() {
                  filteredProducts = widget.selectedProducts
                      .where((product) =>
                  product.productName?.toLowerCase().contains(val.toLowerCase()) ??
                      false)
                      .toList();
                });
              },
            ),

            SizedBox(height: 1.h),

            filteredProducts.isEmpty ? const Expanded(
              child: Center(
                child: Text("No Products found",style: TextStyle(
                  fontWeight: FontWeight.w600,fontSize: 16
                ),),
              ),
            ):
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredProducts.length,
                  itemBuilder: (context,index){
                return monthlySaleWidget(filteredProducts[index]);
              }),
            ),


          if (DateTime.now().year == widget.selectedDate?.year && DateTime.now().month == widget.selectedDate?.month)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(title: "Save" , onTabButtonCallback: (){
                  onSubmitClick("Saved");
                  },
                ),
                CustomButton(title: "Submit" , onTabButtonCallback: (){
                  onSubmitClick("Submitted");
                }),
              ],
            )
          ],
        ),
      ),
    );
  }


  Widget distributorDetailsWidget(String imagePath,String title, String details, Color? color) => Container(
    margin: EdgeInsets.symmetric(horizontal: 4.w),
    padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(imagePath,height: 15,width: 15,color: color),
        SizedBox(width: 2.w),
        SizedBox(
          width: 35.w,
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
  Widget monthlySaleWidget(DistributorProductList item) => Container(
    margin: EdgeInsets.symmetric(vertical: 0.8.h,horizontal: 4),
    decoration: BoxDecoration(
      color: Constants.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
            color: const Color(0xffC3C3C3).withOpacity(0.10),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(0, 0)),
        BoxShadow(
            color: const Color(0xffC3C3C3).withOpacity(0.10),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(0, 0)),
      ],
    ),
    child: Column(
      children: [


        SizedBox(height: 1.h),
        distributorDetailsWidget("assets/other_images/product_icon.png","Product Name", item.productName ?? "",Constants.primaryColor),
        distributorDetailsWidget("assets/distributor_images/pack_size.png","Pack Size", item.packSize.toString() ?? "",Constants.primaryColor),
        distributorDetailsWidget("assets/distributor_images/coupon.png","Product Code", item.productCode ?? "",null),
        distributorDetailsWidget("assets/distributor_images/qty_quality.png","Qty Purchased", "${item.quantity}" ?? "",Constants.primaryColor),
        distributorDetailsWidget("assets/distributor_images/sale.png","Opening Sale Qty", "${item.openingSaleQty}" ?? "",null),

        SoldDistributorWidget(
          onPackSizeSelected: (int? value) {
            item.qtySold = value;
          }, qtySold: item.qtySold ?? 0),
      ],
    ),
  );

  Future<void> onSubmitClick(String status) async {
    if(await InternetUtil.isInternetConnected()){
      if (widget.selectedProducts.any((product) => (product.qtySold ?? 0) > (product.openingSaleQty ?? 0))) {
        context.showSnackBar("Error: Qty Sold cannot be greater than Opening Sale Qty for any product", null);
      }
      else{
        try{


          String userId= await SessionManager.getUserId();

          List<Map<String, dynamic>> productsData = [];

          // Iterate through widget.selectedProducts and add data to the list
          for (var product in widget.selectedProducts) {
            Map<String, dynamic> productMap = {
              "monthPurchaseProductId": product.id,
              "qtySold": product.qtySold,
              "status": status,
              "salesUpdatedBy": userId,
              "monthPurchaseId": product.monthPurchaseId,
            };

            // Add the product map to the list
            productsData.add(productMap);
          }

          ProgressDialog.showProgressDialog(context);
          var result = await DistributorRepo.updateSelectProduct(productsData);
          if(result.status){
            Get.back();
            Get.to(()=>const DistributionListPage());
          }
          else{
            context.showSnackBar("Something went wrong", null);
            Get.back();
          }
        }catch(e){
          Get.back();
          print(e.toString());
          context.showSnackBar("Something went wrong", null);
        }
      }
    }
    else{
      context.showSnackBar("Please check your Internet Connection", null);
    }
  }

}
