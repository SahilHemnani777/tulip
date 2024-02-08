import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tulip_app/model/lead_list_model.dart';
import 'package:tulip_app/repo/lead_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/lead_card_widget.dart';
import 'package:tulip_app/ui_designs/home_tab/lead_pages/lead_details_page.dart';
import 'package:tulip_app/widget/search_observable.dart';

class LeadSearchDelegate extends SearchDelegate {
  final SearchObservable _searchObservable = SearchObservable();
  final _pagingController = PagingController<int, LeadItemInfo>(
    firstPageKey: 1, // Initial page number
  );


  LeadSearchDelegate() {
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
  String get searchFieldLabel => "Search lead";


  void apiCall(int pageKey) {
    // Check if the query is not empty before making the API call
    if (query.isNotEmpty) {
      LeadRepo.getLeadList(pageKey.toString(), query, [], null, null)
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
    return PagedListView<int, LeadItemInfo>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<LeadItemInfo>(
        itemBuilder: (context, item, index) {
          return GestureDetector(
              onTap: (){
                Get.back();
                Get.to(LeadDetailsPage(leadId: item.id));
              },
              child: LeadCardWidget(fromSearch: true, leadItemInfo: item));
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
