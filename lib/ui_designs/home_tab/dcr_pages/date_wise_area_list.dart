import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/model/tour_plan_model/daily_plan_report_model.dart';
import 'package:tulip_app/repo/dcr_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/dcr_pages/dcr_list.dart';
import 'package:tulip_app/ui_designs/home_tab/dcr_pages/lab_list_page.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/no_data_found.dart';

class DateWiseAreaListPage extends StatefulWidget {
  final DateTime selectedDate;
  final String? dcrId;
  final bool isExpenseCreated;
  const DateWiseAreaListPage({Key? key, required this.selectedDate, this.dcrId, this.isExpenseCreated =false}) : super(key: key);

  @override
  _DateWiseAreaListPageState createState() => _DateWiseAreaListPageState();
}

class _DateWiseAreaListPageState extends State<DateWiseAreaListPage> {
  List<TourPlan> tourPlanList=[];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAreaVisitedList();
  }

  Future<void> getAreaVisitedList() async {
    var response = await DCRRepo.getVisitedAreaList(widget.selectedDate);
    if(response.status){
      tourPlanList= response.data ?? [];
      setState(() {
        _isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(const DCRListPage());
        return false;
      },
      child: Scaffold(
        appBar:  CustomAppBar(
          title: " Areas Visited On ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}",implyStatus: true,
        ),
        body: !_isLoading ? tourPlanList.isNotEmpty ?  ListView.builder(
            itemCount: tourPlanList.length,
            shrinkWrap: true,
            itemBuilder: (context,index){
              TourPlan item=tourPlanList[index];
          return GestureDetector(
              onTap: (){
                // Get.to(()=> AddAreaReportForm(tourPlanVisitId: item.id ?? "",areaName: item.area?.townName ?? "",),
                // transition: Transition.fade);
                Get.to(()=> LabListPage(tourPlanVisitId: item.id ?? "",areaName: item.area?.townName ?? "",dcrId: widget.dcrId, isExpenseCreated: widget.isExpenseCreated),
                transition: Transition.fade);
              },
              child: areaItemWidget(item));
        }) : const Center(child: NoDataFound()): const Center(child: CircularProgressIndicator.adaptive(),) ,
      ),
    );
  }


  Widget areaFieldWidget(
      String title, String details) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              "$title : ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(details)),
        ],
      );

  Widget areaItemWidget(TourPlan item)=>Container(
    margin: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3.w),
    padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3.w),
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: const Color(0xffC3C3C3)
                  .withOpacity(0.35),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 1)),
          BoxShadow(
              color: const Color(0xffC3C3C3)
                  .withOpacity(0.35),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, -1)),
        ]
    ),
    child: Column(
      children: [
        areaFieldWidget("Area",item.area?.townName ?? ""),
        areaFieldWidget("Activity Type",item.activityType?.activityTypeName ?? ""),
        areaFieldWidget("Lab Calls","${item.labCalls ?? ''}"),
      ],
    ),
  );
}
