import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/repo/product_repo.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/search_observable.dart';

import 'product_details_page.dart';

class ProductSearchDelegate extends SearchDelegate {
  final SearchObservable _searchObservable = SearchObservable();
  final _pagingController = PagingController<int, Product>(
    firstPageKey: 1, // Initial page number
  );
  final String categoryId;


  ProductSearchDelegate(this.categoryId) {
    _searchObservable.debounceTextObservable.listen((val) {
      if (val.length >= 3) {
        // Reset the pagination when performing a new search.
        _pagingController.refresh();
      }
      else if(val.isEmpty){
        _pagingController.refresh();
      }
    });

    // Load the initial page.
    _pagingController.addPageRequestListener((pageKey) {
      apiCall(pageKey);
    });
  }
  @override
  String get searchFieldLabel => "Search product";


  void apiCall(int pageKey) {
    // Check if the query is not empty before making the API call
      ProductRepo.getProductList(pageKey.toString(), categoryId, query)
          .then((result) {
        if (result.status) {
          if (result.data != null) {
            final items = result.data?.docs;
            final isLastPage = pageKey >= (result.data!.totalPages ?? 0);
            if (isLastPage) {
              _pagingController.appendLastPage(items ?? []);
            } else {
              final nextPageKey = pageKey + 1;
              _pagingController.appendPage(items ?? [], nextPageKey);
            }
          } else {
            _pagingController.appendLastPage([]); // No more items to load
          }
        } else {
          _pagingController.error = result.message;
        }
      }).catchError((onError) {
        debugPrint("On Error : $onError");
        _pagingController.error = onError;
      });

  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.black),
        onPressed: () {
          if (query.isNotEmpty) {
            query = '';
          } else {
            close(context, null);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _searchObservable.addSearchText(query.toLowerCase().trim());
    return PagedListView<int, Product>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Product>(
        itemBuilder: (context, item, index) {
          return productItem(item);
        },
        firstPageErrorIndicatorBuilder: (context) => const Center(
          child: Text("Error loading data!"),
        ),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: Text("No results found"),
        ),
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

}
