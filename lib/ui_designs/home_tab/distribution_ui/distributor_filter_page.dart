import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_dropdown.dart';

class DistributorFilterPage extends StatefulWidget {
  final List<dynamic>? selectedFilter;
  final Function(bool) updateFilterVisibilityCallback; // Callback to update _showFilter
  final Function(List<dynamic>) applyFilterCallback; //
  const DistributorFilterPage({Key? key, this.selectedFilter, required this.updateFilterVisibilityCallback, required this.applyFilterCallback}) : super(key: key);

  @override
  _DistributorFilterPageState createState() => _DistributorFilterPageState();
}

class _DistributorFilterPageState extends State<DistributorFilterPage> {
 String selectedMonth = "January"; // Default to January

  List<String> monthList = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];
  String selectedYear = DateTime.now().year.toString();
  List<String> yearList = [];
  void generateYearList() {
    final currentYear = DateTime.now().year;
    for (int i = currentYear - 5; i <= currentYear + 5; i++) {
      yearList.add(i.toString());
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateYearList();
    if (widget.selectedFilter != null) {
      print(widget.selectedFilter);
      selectedMonth = widget.selectedFilter?[1];
      selectedYear = widget.selectedFilter?[0];
    }

  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 0),
                  color: Colors.black.withOpacity(0.10),
                  spreadRadius: 1,
                  blurRadius: 1),
            ]),
        width: 50.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15.0,bottom: 10),
              child: Text(
                "Filter Records",
                style: TextStyle(
                    color: Constants.primaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ),


            Container(
              height: 4.h, // Adjust the height as needed
              width: 35.w, // Adjust the width as needed
              padding: const EdgeInsets.symmetric(horizontal: 7),
              margin: EdgeInsets.only(left: 4.w,top: 1.h,bottom: 1.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 1),
                      color: const Color(0xffC3C3C3).withOpacity(0.25),
                      blurRadius: 4,
                      spreadRadius: 0),
                  BoxShadow(
                      offset: const Offset(0, -1),
                      color: const Color(0xffC3C3C3).withOpacity(0.25),
                      blurRadius: 4,
                      spreadRadius: 0),
                ],
                borderRadius: BorderRadius.circular(3),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMonth,
                  items: monthList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedMonth = newValue!;
                    });
                  },
                ),
              ),
            ),



            Container(
              height: 4.h, // Adjust the height as needed
              width: 35.w, // Adjust the width as needed
              padding: const EdgeInsets.symmetric(horizontal: 7),
              margin: EdgeInsets.only(left: 4.w,top: 1.h,bottom: 1.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 1),
                      color: const Color(0xffC3C3C3).withOpacity(0.25),
                      blurRadius: 4,
                      spreadRadius: 0),
                  BoxShadow(
                      offset: const Offset(0, -1),
                      color: const Color(0xffC3C3C3).withOpacity(0.25),
                      blurRadius: 4,
                      spreadRadius: 0),
                ],
                borderRadius: BorderRadius.circular(3),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedYear,
                  items: yearList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedYear = newValue!;
                    });
                  },
                ),
              ),
            ),


            SizedBox(height: 0.8.h),

            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap:(){
                        final filterData = [
                          selectedYear,
                          selectedMonth
                        ];
                        widget.applyFilterCallback(filterData);
                        widget.updateFilterVisibilityCallback(false); // Update _showFilter
                        setState(() {});
                      },
                      child: _filterButtonWidget("Apply")),
                  GestureDetector(
                      onTap: (){

                        selectedYear =DateTime.now().year.toString();
                        setState(() {

                        });
                      },
                      child: _filterButtonWidget("Clear")),
                ],
              ),
            ),
          ],
        ),
      ),
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


}
