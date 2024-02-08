import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/category_model/category_list.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/repo/product_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/products_catalogue/product_search_delegate.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/common_search_bar.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/no_data_found.dart';
import 'package:tulip_app/widget/no_internet_widget.dart';

import 'product_details_page.dart';

class ProductListPage extends StatefulWidget {
  final CategoryData categoryData;
  final Function(Product)? onProductSelected;
  const ProductListPage({Key? key, required this.categoryData, this.onProductSelected}) : super(key: key);

  @override
  ProductListPageState createState() => ProductListPageState();
}

class ProductListPageState extends State<ProductListPage> {
  final PagingController<int, Product> _pagingController =
  PagingController(firstPageKey: 1);
  bool _isInternetConnected = true;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _initPageController();
    _addInternetConnectionListener();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.categoryData.categoryName,implyStatus: true,
      ),
      body: Column(
        children: [

          SizedBox(height: 1.h),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            child: CommonSearchBar(
              searchButtonCallback: openSearchDelegate,
              title: 'Search product',
              showFilter: false,
            ),
          ),

          _isInternetConnected
              ? RefreshIndicator(
                onRefresh: () {
                  _pagingController.refresh();
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: _getPaginatedListViewWidget(),
              )
              : SizedBox(
              height: 70.h,
              child: const Center(child: NoInternetWidget())),
        ],
      ),
    );
  }

  Widget productItem(Product productData)=>Container(
    margin: EdgeInsets.symmetric(horizontal: 6.w,vertical: 0.9.h),

    padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
              color: const Color(0xffC3C3C3)
                  .withOpacity(0.25),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, 1)),
          BoxShadow(
              color: const Color(0xffC3C3C3)
                  .withOpacity(0.25),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, -1)),
        ]),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: productData.productImage?.first ?? "",
          fit: BoxFit.fill,
          height: 9.h,
          width: 9.h,
          placeholder: (context, url) => const Icon(Icons.image, size: 64,color: Colors.grey), // Show an icon as a placeholder
          errorWidget: (context, url, error) => const Icon(Icons.image, size: 64,color: Colors.grey),
        ),
        const SizedBox(width: 14),
        Container(
          constraints: BoxConstraints(
            maxWidth: 47.w,
          ),
          child:  Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                productData.productName ?? "",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                productData.description ?? "",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),


            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: (){
            Get.to(()=>ProductDetailPage(productId: productData.id),transition: Transition.fade);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: BorderRadius.circular(5)
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 0.7.h),
            child: const Text("View",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white
            ),
            ),
          ),
        )

      ],
    ),
  );


  Widget _getPaginatedListViewWidget() => PagedListView<int, Product>(
    shrinkWrap: true,
    pagingController: _pagingController,
    padding: EdgeInsets.only(bottom: 10.h),
    builderDelegate: PagedChildBuilderDelegate<Product>(
      itemBuilder: (context, item, index) {
        return GestureDetector(
            onTap: (){
              if(widget.onProductSelected!=null) {
                widget.onProductSelected!.call(item);
                Get.back(result: item);
              }
            },
            child: productItem(item));
      },
      noItemsFoundIndicatorBuilder: (context) => SizedBox(
        width: 100.w,
        height: 70.h,
        child: const Center(
          child: NoDataFound(
            title: "No Data Found",
            image: "assets/error_image/no_data.png",
          ),
        ),
      ),
      firstPageErrorIndicatorBuilder: (context) => SizedBox(
          height: 70.h,
          child: const Center(
            child: NoDataFound(
              title: "Something went wrong",
              image: "assets/error_image/error.png",
            ),
          )),
    ),
  );



  void _initPageController() {
    _pagingController.addPageRequestListener((pageKey) async {
      if (await InternetUtil.isInternetConnected()) {
        _fetchPage(pageKey);
      }
    });
  }

  Future<SuperResponse<List<Product>>?> _fetchPage(int pageNo) async {
    try {
      final response = await ProductRepo.getProductList(
          pageNo.toString(),
          widget.categoryData.id,"");

      if (response.status) {
        if (pageNo >= (response.data?.totalPages ?? 0)) {
          _pagingController.appendLastPage(response.data?.docs ?? []);
        } else {
          _pagingController.appendPage(response.data?.docs ?? [], pageNo + 1);
        }
      } else {
        _pagingController.error = response.message;
        // debugPrint(response.message);
      }
      // return response;
    } catch (error, stack) {
      _pagingController.error = error;
      debugPrint('error $error $stack');
      return null;
    }
    return null;
  }

  void _addInternetConnectionListener() async {
    //if the internet is connected then make the api call
    if (!(await InternetUtil.isInternetConnected())) {
      _listenInternetConnection();
      setState(() {
        _isInternetConnected = false;
      });
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
        _pagingController.refresh();
        setState(() {
          _isInternetConnected = true;
        });
      }
    });
  }

  Future<void> openSearchDelegate() async {
    final data = await showSearch(
      context: context,
      delegate: ProductSearchDelegate(widget.categoryData.id),
    );
  }

}
