import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/category_model/category_list.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/repo/product_repo.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/no_data_found.dart';
import 'package:tulip_app/widget/no_internet_widget.dart';

import 'product_list_page.dart';

class ProductCategoryPage extends StatefulWidget {
  final Function(Product)? onProductSelected;
  const ProductCategoryPage({Key? key, this.onProductSelected}) : super(key: key);

  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {

  List<CategoryData> categoryData=[];
  bool _isInternetConnected = true;
  StreamSubscription? _subscription;
  bool _isLoading=true;


  @override
  void initState() {
    super.initState();
    _addInternetConnectionListener();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Select Product Category",
        implyStatus: true,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 1.h),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 1.h),
            child: const Text("Product Group",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            ),
          ),

          _isInternetConnected ? !_isLoading ? categoryData.isNotEmpty ?
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              child: GridView.builder(
                  itemCount: categoryData.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,childAspectRatio: 1.1,crossAxisSpacing: 15,mainAxisSpacing: 15 // Number of columns
                  ),
                  itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  onTap: (){
                    Get.to(
                          () => ProductListPage(categoryData: categoryData[index], onProductSelected: widget.onProductSelected),
                      transition: Transition.fade,
                    )?.then((selectedProduct) {
                      if (selectedProduct != null) {
                        // If a product was selected, return it as the result.
                        Get.back(result: selectedProduct);
                      }
                    });
                  },
                  child: productItemWidget(categoryData[index]),
                );

              }),
            ),
            ):SizedBox(
              height: 70.h,
              child: const Center(child: NoDataFound())):
          const Center(child: CircularProgressIndicator.adaptive()) : SizedBox(
              height: 70.h,
              child: const Center(child: NoInternetWidget())),



          
        ],
      ),
    );
  }
  Widget productItemWidget(CategoryData categoryData)=>Container(
    padding: EdgeInsets.only(left: 3.w,right: 2.w,top: 2.h,bottom: 1.h),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0,1),
              color: const Color(0xffC3C3C3).withOpacity(0.25),
              blurRadius: 4,
              spreadRadius: 0
          ),
          BoxShadow(
              offset: const Offset(0,-1),
              color: const Color(0xffC3C3C3).withOpacity(0.25),
              blurRadius: 4,
              spreadRadius: 0
          ),
        ]
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        CachedNetworkImage(
          imageUrl: categoryData.categoryIcon,
          fit: BoxFit.fill,
          height: 10.h,
          width: 10.h,
          placeholder: (context, url) => const Icon(Icons.image, size: 64,color: Colors.grey), // Show an icon as a placeholder
          errorWidget: (context, url, error) => const Icon(Icons.image, size: 64,color: Colors.grey),
        ),

        const Spacer(),

        Row(
          children: [
            Container(
              constraints: BoxConstraints(
                  maxHeight: 5.h,maxWidth: 30.w
              ),
              child: Text(categoryData.categoryName,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14
                ),
              ),
            ),

            const Spacer(),

            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Constants.primaryColor,
              ),
              padding: const EdgeInsets.all(5),
              child: const Icon(Icons.arrow_forward,color: Colors.white,size: 16,),
            )
          ],
        )
      ],
    ),
  );


  Future<void> getCategoryList() async {
    var response = await ProductRepo.getCustomerDetails();
    if(response.status){
      if(response.data!=null) {
        categoryData=response.data!;
      }
      _isLoading=false;
      setState(() {});
    }
    else{
      context.showSnackBar(response.message!,null);
    }
  }



  void _addInternetConnectionListener() async {
    //if the internet is connected then make the api call
    if (!(await InternetUtil.isInternetConnected())) {
      _listenInternetConnection();
      setState(() {
        _isInternetConnected = false;
      });
    }
    else{
      getCategoryList();
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
        getCategoryList();
        setState(() {
          _isInternetConnected = true;
        });
      }
    });
  }



}
