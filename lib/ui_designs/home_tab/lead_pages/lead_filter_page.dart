import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/date_util_ext.dart';

class LeadFilterPage extends StatefulWidget {
  final List<dynamic>? selectedFilter;
  final Function(bool) updateFilterVisibilityCallback; // Callback to update _showFilter
  final Function(List<dynamic>) applyFilterCallback; // Callback function with optional date values

  const LeadFilterPage({Key? key, this.selectedFilter, required this.applyFilterCallback, required this.updateFilterVisibilityCallback}) : super(key: key);

  @override
  LeadFilterPageState createState() => LeadFilterPageState();
}

class LeadFilterPageState extends State<LeadFilterPage> {
  late bool _interested ;
  late bool _notInterested;
  late bool _coldFollowUp;
  late bool _hotFollowUp;
  late bool _other ;

  DateTime? _fromDate;
  DateTime? _toDate;
  List<String> _selectedStatus = [];

  @override
  void initState() {
    super.initState();
    print(widget.selectedFilter);

    if (widget.selectedFilter != null) {
      _interested = widget.selectedFilter?[0].contains('Interested');
      _notInterested = widget.selectedFilter?[0].contains('Not Interested');
      _coldFollowUp = widget.selectedFilter?[0].contains('Cold Followup');
      _hotFollowUp = widget.selectedFilter?[0].contains('Hot Followup');
      _other = widget.selectedFilter?[0].contains('Other');
      _selectedStatus = widget.selectedFilter?[0];
      _fromDate = widget.selectedFilter?[1];
      _toDate = widget.selectedFilter?[2];
    }
    else{
       _interested = false;
       _notInterested = false;
       _coldFollowUp = false;
       _hotFollowUp = false;
       _other = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5.w,
      top: 7.h,
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
            const Padding(
              padding: EdgeInsets.only(left: 15.0, bottom: 10),
              child: Text(
                "Filter by Status",
                style: TextStyle(
                    color: Constants.primaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ),
            _statusCheckBox(
              "Interested",
              _interested,
              (newValue) {
                setState(() {
                  _interested = newValue!;
                  print(_selectedStatus);
                });
              },
            ),
            _statusCheckBox(
              "Not Interested",
              _notInterested,
              (newValue) {
                setState(() {
                  _notInterested = newValue!;
                });
              },
            ),
            _statusCheckBox(
              "Cold Followup",
              _coldFollowUp,
              (newValue) {
                setState(() {
                  _coldFollowUp = newValue!;
                });
              },
            ),
            _statusCheckBox(
              "Hot Followup",
              _hotFollowUp,
              (newValue) {
                setState(() {
                  _hotFollowUp = newValue!;
                });
              },
            ),
            _statusCheckBox(
              "Other",
              _other,
              (newValue) {
                setState(() {
                  _other = newValue!;
                });
              },
            ),
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
                      _fromDate = date;
                    });
                    _toDate = null;
                  }
                },
                child: _dateWidget(
                  "assets/travel_page_icon/filter_date.png",
                  _fromDate?.getDisplayFormatDate() ?? "From Date",
                )),
            GestureDetector(
                onTap: () async {
                  if (_fromDate != null) {
                    final date = await Constants.pickDate(
                        _fromDate!, DateTime.now(), context);
                    if (date != null) {
                      setState(() {
                        _toDate = date;
                      });
                    }
                  } else {
                    context.showSnackBar("Please select FromDate", null);
                  }
                },
                child: _dateWidget("assets/travel_page_icon/filter_date.png",
                    _toDate?.getDisplayFormatDate() ?? "To Date")),
            SizedBox(height: 1.h),
            Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          final filterData = [
                            _selectedStatus,
                            _fromDate,
                            _toDate,
                          ];
                          widget.applyFilterCallback(filterData);
                          widget.updateFilterVisibilityCallback(false); // Update _showFilter
                          setState(() {});
                        },
                        child: _filterButtonWidget("Apply")),
                    GestureDetector(
                        onTap: (){
                          _selectedStatus.clear();
                          _fromDate=null;
                          _toDate=null;
                           _interested = false;
                           _notInterested = false;
                           _coldFollowUp = false;
                           _hotFollowUp = false;
                           _other = false;

                          setState(() {

                          });
                        },
                        child: _filterButtonWidget("Clear")),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _dateWidget(String imagePath, String date) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
            margin: EdgeInsets.symmetric(vertical: 5),
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

  Widget _filterButtonWidget(String title) => Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Constants.primaryColor),
        child: Text(
          title,
          style: TextStyle(
              color: Color(0xfffefcf3),
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
      );

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
}
