import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/distributor_model/distributor_products_list.dart';
import 'package:tulip_app/repo/distributor_repo.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';
import 'package:tulip_app/widget/no_data_found.dart';
import 'package:tulip_app/widget/no_internet_widget.dart';

import 'selected_product_list.dart';

class FileMonthlySalePage extends StatefulWidget {
  final String distributorId;
  final DateTime? selectedDate;
  const FileMonthlySalePage({Key? key, required this.distributorId, this.selectedDate}) : super(key: key);

  @override
  _FileMonthlySalePageState createState() => _FileMonthlySalePageState();
}

class _FileMonthlySalePageState extends State<FileMonthlySalePage> {

  bool _isLoading = true;
  bool _isInternetConnected = true;
  StreamSubscription? _subscription;

  List<DistributorProductList> selectedProducts = [];
  List<DistributorProductList> distributorProductList = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? debounce;
  bool isSelected =false;

  @override
  void initState() {
    super.initState();
    print("asdasdsad${widget.selectedDate}");
    print("asdasdsad${DateTime.now().year}");
    print("asdasdsad${DateTime.now().month}");
    print("asdasdsad${widget.selectedDate?.month}");
    print("asdasdsad${widget.selectedDate?.year}");
    print("asdasdsad${DateTime.now().year != widget.selectedDate?.year && DateTime.now().month != widget.selectedDate?.month}");
    _addInternetConnectionListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'File Monthly Sale',
        implyStatus: true,
        showBackButton: true,
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              children: [
                SizedBox(height: 1.h),
                CustomTextFormField(
                  hintText: "Search Products",
                  controller: _searchController,
                  onChanged: (val) {
                    if (debounce != null) {
                      debounce?.cancel(); // Cancel the previous debounce timer if it exists.
                    }
                    debounce = Timer(
                        const Duration(milliseconds: 500),
                            () async {
                              setState(() {
                                if (val.length >= 3) {
                                  distributorProductList.clear();
                                  getDistributorProductList();
                                }
                          else if(val.isEmpty){
                            getDistributorProductList();
                          }});
                        });
                  },
                  validator: (val) {
                    if (val != null && val.isNotEmpty) {
                      return null;
                    } else {
                      return "Search Products";
                    }
                  },
                ),

                _isInternetConnected
                    ? !_isLoading
                    ? distributorProductList.isNotEmpty
                    ? Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      distributorProductList.clear();
                      getDistributorProductList();
                    },
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 8.h),
                        itemCount: distributorProductList.length,
                        itemBuilder:
                            (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                              },
                              child: monthlySaleWidget(distributorProductList[index]));
                        }),
                  ),
                )
                    : SizedBox(
                    height: 70.h,
                    child: const Center(child: NoDataFound()))
                    : const Center(
                    child: CircularProgressIndicator.adaptive())
                    : SizedBox(
                    height: 70.h,
                    child: const Center(child: NoInternetWidget())),


              ],
            ),
          ),
          if (DateTime.now().year == widget.selectedDate?.year && DateTime.now().month == widget.selectedDate?.month)
            Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 100.w,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 1),
                      color: const Color(0xffC3C3C3).withOpacity(0.45),
                      blurRadius: 4,
                      spreadRadius: 0),
                  BoxShadow(
                      offset: const Offset(0, -1),
                      color: const Color(0xffC3C3C3).withOpacity(0.45),
                      blurRadius: 4,
                      spreadRadius: 0),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: onNextClick,
                    child: Container(
                      width: 45.w,
                      height: 5.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Constants.primaryColor,
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
                      child: Text(
                        "Next(${selectedProducts.length})",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

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
        child: Row(
          children: [
            Column(
              children: [
                distributorDetailsWidget("assets/other_images/product_icon.png","Product Name", item.productName ?? "",Constants.primaryColor),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 2.w),
                //   padding:
                //   EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Image.asset("assets/distributor_images/pack_size.png",height: 15,width: 15,color : Constants.primaryColor),
                //       SizedBox(width: 2.w),
                //       SizedBox(
                //         width: 30.w,
                //         child: const Text(
                //           "Pack Size :",
                //           style: TextStyle(
                //             fontWeight: FontWeight.w600,
                //             fontSize: 13,
                //           ),
                //         ),
                //       ),
                //       DistributorPackSize(item: item.packSize ?? [],
                //         onPackSizeSelected: (selectedPackSize) {
                //           // Handle the selected pack size here
                //           if (selectedPackSize != null) {
                //             item.selectedPackSize = selectedPackSize;
                //           }
                //         },),
                //     ],
                //   ),
                // ),


                distributorDetailsWidget("assets/distributor_images/pack_size.png","Pack Size", item.packSize ?? "",Constants.primaryColor),

                distributorDetailsWidget("assets/distributor_images/coupon.png","Product Code", item.productCode ?? "",null),

                if (!(DateTime.now().year != widget.selectedDate?.year && DateTime.now().month != widget.selectedDate?.month))
                  distributorDetailsWidget("assets/distributor_images/qty_quality.png","Qty Purchased", item.quantity.toString() ?? "",Constants.primaryColor),


                if (!(DateTime.now().year != widget.selectedDate?.year && DateTime.now().month != widget.selectedDate?.month))
                  distributorDetailsWidget("assets/distributor_images/sale.png","Opening sale Qty", item.openingSaleQty.toString() ?? "",null),

                if (!(DateTime.now().year == widget.selectedDate?.year && DateTime.now().month == widget.selectedDate?.month))
                  distributorDetailsWidget("assets/distributor_images/sold.png","Qty Sold", item.qtySold.toString() ?? "",null),
              ],
            ),
            if (DateTime.now().year == widget.selectedDate?.year && DateTime.now().month == widget.selectedDate?.month)
              Checkbox(
                value: selectedProducts.contains(item),
                onChanged: (bool? val){
                  if (val != null) {
                    setState(() {
                      if (val) {
                        selectedProducts.add(item);
                      } else {
                        selectedProducts.remove(item);
                      }
                    });
                  }
            }),
          ],
        ),
      );

  Widget distributorDetailsWidget(String imagePath,String title, String details, Color? color) => Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imagePath,height: 15,width: 15,color: color),
            SizedBox(width: 2.w),
            SizedBox(
              width: 31.w,
              child: Text(
                "$title : ",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(
                width: 38.w,
                child: Text(
              details,
              style: const TextStyle(
                fontSize: 13,
              ),
            )),
          ],
        ),
      );


  void _addInternetConnectionListener() async {
    //if the internet is connected then make the api call
    if (!(await InternetUtil.isInternetConnected())) {
      _listenInternetConnection();
      setState(() {
        _isInternetConnected = false;
      });
    } else {
      getDistributorProductList();

    }
  }



  void _listenInternetConnection() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      // Got a new connectivity status!
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        _subscription?.cancel();
        getDistributorProductList();

        setState(() {
          _isInternetConnected = true;
        });
      }
    });
  }

  void getDistributorProductList() async {
    var result = await DistributorRepo.getDistributorProductList(widget.distributorId,_searchController.text);
    if(result.status){
      distributorProductList = result.data!;
      _isLoading = false;
      setState(() {

      });
    }
    else{
      context.showSnackBar("Something went wrong", null);
    }
  }




  void onNextClick(){
    print(selectedProducts);
    if(selectedProducts.isEmpty){
      context.showSnackBar("Please select at least one product",null);
    }
    else{
      print("Selected Product Data : ${jsonEncode(selectedProducts)}");
      Get.to(SelectedProductList(selectedProducts: selectedProducts,selectedDate: widget.selectedDate));
    }
  }

}
