import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/model/distributor_model/distributors_list.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/repo/distributor_repo.dart';
import 'package:rxdart/subjects.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/search_observable.dart';

class DistributorSearchDelegate extends SearchDelegate {
  final SearchObservable _searchObservable = SearchObservable();
  final _taskPublishSubject = BehaviorSubject<SuperResponse<List<DistributorList>?>?>();
  DistributorSearchDelegate([String? territoryId]) {
    _searchObservable.debounceTextObservable.listen((val) {
      if (val.length >= 3) {
        apiCall(val,territoryId);

      }else if(val.isEmpty) {
        apiCall("",territoryId);
      }
    });
    apiCall("",territoryId);

  }

  void apiCall(String val, String? territoryId){
      DistributorRepo.getDistributorList(territoryId ?? "",val).then((result) {
        _taskPublishSubject.sink.add(result);
      }).catchError((onError) {
        debugPrint("On Error : $onError");
        _taskPublishSubject.sink.addError(onError);
      });
  }

  @override
  String get searchFieldLabel => "Search Distributor ";

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
    return Column(
      children: [
        Expanded(child:
        StreamBuilder(
          stream: _taskPublishSubject,
          builder: (BuildContext context,
              AsyncSnapshot<SuperResponse<List<DistributorList>?>?> snapshot) {
            if(snapshot.hasData){
              if(snapshot.data!=null){
                var list=snapshot.data?.data;
                if (list != null && list.isNotEmpty) {
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: (){
                              Get.back(result: list[index]);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
                                padding: EdgeInsets.symmetric(vertical: 1.w),
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
                                child: Text(list[index].businessName ?? " ")));
                      });
                }
                else{
                  return createFirmWidget();
                }
              }
              else{
                return const Center(
                  child: Text("No data"),
                );
              }
            }
            else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
        ),
      ],
    );
  }


  Widget createFirmWidget(){
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("No data found.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

        ],
      ),
    );
  }

}

