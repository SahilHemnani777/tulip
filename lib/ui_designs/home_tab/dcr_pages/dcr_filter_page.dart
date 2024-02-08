import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/date_util_ext.dart';


class DCRFilterPage extends StatefulWidget {
  final List<dynamic>? selectedFilter;
  final Function(bool) updateFilterVisibilityCallback; // Callback to update _showFilter
  final Function(List<dynamic>) applyFilterCallback; // Callback function with optional date values

  const DCRFilterPage({Key? key, this.selectedFilter, required this.updateFilterVisibilityCallback, required this.applyFilterCallback}) : super(key: key);

  @override
  _DCRFilterPageState createState() => _DCRFilterPageState();
}

class _DCRFilterPageState extends State<DCRFilterPage> {
  bool _submitted = false;
  bool _approved = false;
  bool _rejected = false;
  DateTime? fromDate;
  DateTime? toDate;
  List<String> _selectedStatus = [];


  @override
  void initState() {
    super.initState();
    print(widget.selectedFilter);

    if (widget.selectedFilter != null) {
      _submitted = widget.selectedFilter?[0].contains('Submitted');
      _approved = widget.selectedFilter?[0].contains('Approved');
      _rejected = widget.selectedFilter?[0].contains('Rejected');
      _selectedStatus = widget.selectedFilter?[0];
      fromDate = widget.selectedFilter?[1];
      toDate = widget.selectedFilter?[2];
    }
    else{
      _submitted = false;
      _approved = false;
      _rejected = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5.w,
      top: 0.h,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 0),
                  color: Colors.black.withOpacity(0.10),
                  spreadRadius: 1,
                  blurRadius: 1),
            ]),
        width: 54.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Padding(
            //   padding: EdgeInsets.only(left: 15.0, bottom: 10),
            //   child: Text(
            //     "Filter by Status",
            //     style: TextStyle(
            //         color: Constants.primaryTextColor,
            //         fontWeight: FontWeight.w600,
            //         fontSize: 15),
            //   ),
            // ),
            // _statusCheckBox(
            //   "Submitted",
            //   _submitted,
            //       (newValue) {
            //     setState(() {
            //       _submitted = newValue!;
            //     });
            //   },
            // ),
            // _statusCheckBox(
            //   "Approved",
            //   _approved,
            //       (newValue) {
            //     setState(() {
            //       _approved = newValue!;
            //     });
            //   },
            // ),
            //
            // _statusCheckBox(
            //   "Rejected",
            //   _rejected,
            //       (newValue) {
            //     setState(() {
            //       _rejected = newValue!;
            //     });
            //   },
            // ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 10),
              child: Text(
                "Filter by Date",
                style: TextStyle(
                    color: Constants.primaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ),
            GestureDetector(
                onTap: () async {
                  final date = await Constants.pickDate(
                      DateTime(2000), DateTime.now(), context);
                  if (date != null) {
                    setState(() {
                      fromDate = date;
                    });
                    toDate = null;
                  }
                },
                child: _dateWidget(
                  "assets/travel_page_icon/filter_date.png",
                  fromDate?.getDisplayFormatDate() ?? "From Date",
                )),
            GestureDetector(
                onTap: () async {
                  if (fromDate != null) {
                    final date = await Constants.pickDate(
                        fromDate!, DateTime.now(), context);
                    if (date != null) {
                      setState(() {
                        toDate = date;
                      });
                    }
                  } else {
                    context.showSnackBar("Please select FromDate", null);
                  }
                },
                child: _dateWidget(
                    "assets/travel_page_icon/filter_date.png",
                    toDate?.getDisplayFormatDate() ?? "To Date")),
            SizedBox(height: 1.h),
            Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: (){
                          final filterData = [
                            _selectedStatus,
                            fromDate,
                            toDate,
                          ];
                          widget.applyFilterCallback(filterData);
                          widget.updateFilterVisibilityCallback(false); // Update _showFilter
                          setState(() {});
                        },
                        child: _filterButtonWidget("Apply")),
                    GestureDetector(
                        onTap: (){
                          _selectedStatus.clear();
                          fromDate=null;
                          toDate=null;
                          _submitted = false;
                          _approved = false;
                          _rejected = false;
                          setState(() {});
                        },
                        child: _filterButtonWidget("Clear")),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
  Widget _statusCheckBox(String title, bool value, Function(bool?)? onChanged) {
    return ListTileTheme(
      contentPadding: const EdgeInsets.only(left: 8),
      horizontalTitleGap: 0,
      child: CheckboxListTile(
          dense: true,
          title: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
          value: value,
          visualDensity: const VisualDensity(horizontal: -2, vertical: -4),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (newValue) {
            setState(() {
              value = newValue!;
              if (value) {
                _selectedStatus.add(title); // Add to the selected status list
              } else {
                _selectedStatus
                    .remove(title); // Remove from the selected status list
              }
              onChanged?.call(value);
            });
          }),
    );
  }
  Widget _filterButtonWidget(String title)=>Container(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Constants.primaryColor),
    child:  Text(
      title,
      style: const TextStyle(
          color: Color(0xfffefcf3),
          fontSize: 14,
          fontWeight: FontWeight.w600),
    ),
  );
  Widget _dateWidget(String imagePath, String date) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xffC3C3C3).withOpacity(0.30),
                      offset: const Offset(0, 0),
                      spreadRadius: 2,
                      blurRadius: 2),
                ]),
            child: Row(
              children: [
                Image.asset(
                  imagePath,
                  height: 20,
                  width: 20,
                  color: Constants.primaryColor,
                ),
                SizedBox(width: 2.w),
                Text(
                  date,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
