import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tulip_app/model/customer_model/customer_list_model.dart';
import 'package:tulip_app/repo/customer_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/customer_detail_page.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/customer_list_details_widget.dart';
import 'package:tulip_app/widget/search_observable.dart';

class CustomerSearchDelegate extends SearchDelegate {
  bool fromWhere = false;
  final SearchObservable _searchObservable = SearchObservable();
  final _pagingController = PagingController<int, CustomerListItem>(
    firstPageKey: 1, // Initial page number
  );


  CustomerSearchDelegate(this.fromWhere) {
    _searchObservable.debounceTextObservable.listen((val) {
      if (val.length >= 3) {
        // Reset the pagination when performing a new search.
        _pagingController.refresh();
      }
    });

    // Load the initial page.
    _pagingController.addPageRequestListener((pageKey) {
      apiCall(pageKey);
    });
  }
  @override
  String get searchFieldLabel => "Search Customer";


  void apiCall(int pageKey) {
    // Check if the query is not empty before making the API call
    if (query.isNotEmpty) {
      CustomerRepo.getCustomerList(pageKey.toString(), query,"","")
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
    else{
      _pagingController.itemList=[];
    }
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
    return PagedListView<int, CustomerListItem>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<CustomerListItem>(
        itemBuilder: (context, item, index) {
          return GestureDetector(
              onTap: (){
                if(fromWhere){
                  Get.back(result: item);
                }else{
                  Get.back();
                  Get.to(CustomerDetailsPage(customerId: item.id));
                }

              },
              child: CustomerListDetailsWidget(customerListItem: item,fromSearch: true,));
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
}
