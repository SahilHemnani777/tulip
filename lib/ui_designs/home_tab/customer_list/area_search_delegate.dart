import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tulip_app/model/customer_model/get_area_model.dart';
import 'package:tulip_app/repo/customer_repo.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/search_observable.dart';

class AreaSearchDelegate extends SearchDelegate {
  final SearchObservable _searchObservable = SearchObservable();
  final _pagingController = PagingController<int, Area>(
    firstPageKey: 1, // Initial page number
  );


  AreaSearchDelegate() {
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
  String get searchFieldLabel => "Search Area ";


  void apiCall(int pageKey) {
    // Check if the query is not empty before making the API call
    if (query.isNotEmpty) {
      CustomerRepo.getAreaList(pageKey.toString(), query)
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
    return PagedListView<int, Area>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Area>(
        itemBuilder: (context, item, index) {
          return GestureDetector(
              onTap: (){
                Get.back(result: item);
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
                padding: EdgeInsets.symmetric(vertical: 1.3.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xffC3C3C3)
                              .withOpacity(0.35),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: const Offset(0, 0)),
                      BoxShadow(
                          color: const Color(0xffC3C3C3)
                              .withOpacity(0.35),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: const Offset(0, 0)),
                    ]
                ),
                  child: Text(item.townName,style: TextStyle(
                    fontSize: 16
                  ),)));
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
