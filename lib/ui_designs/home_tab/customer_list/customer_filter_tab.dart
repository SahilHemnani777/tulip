import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/customer_model/get_area_model.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/repo/customer_repo.dart';
import 'package:tulip_app/ui_designs/home_tab/customer_list/area_search_delegate.dart';
import 'package:tulip_app/util/extensions.dart';

class CustomerFilter extends StatefulWidget {
  final List<dynamic>? selectedFilter;
  final Function(bool) updateFilterVisibilityCallback; // Callback to update _showFilter
  final Function(List<dynamic>) applyFilterCallback; // Callback function with optional date values
  const CustomerFilter(
      {Key? key,
      this.selectedFilter,
      required this.updateFilterVisibilityCallback, required this.applyFilterCallback})
      : super(key: key);

  @override
  _CustomerFilterState createState() => _CustomerFilterState();
}

class _CustomerFilterState extends State<CustomerFilter> {
  Area? area;
  CustomerTypeId? companyTypeId;

  List<CustomerTypeId> companyList = [];

  @override
  void initState() {
    super.initState();

    getCompanyType();
  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5.w,
      top: 7.h,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
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
        width: 64.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Filter",
                style: TextStyle(
                    color: Constants.primaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ),

            GestureDetector(
              onTap:openSearchDelegate,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 1.1.h,horizontal: 3.w),
                margin: EdgeInsets.symmetric(vertical: 1.1.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Constants.lightGreyBorderColor)
                ),
                child: Text(area?.townName ?? "Select Area",
                style: TextStyle(
                  color: area == null ? Colors.grey:Colors.black
                ),
                ),
              ),
            ),


            customerTypeDropDown(),

            SizedBox(height: 2.h),
            Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: (){
                          final filterData = [
                            area?.id,
                          companyTypeId?.id
                          ];
                          widget.updateFilterVisibilityCallback(false); // Update _showFilter
                          widget.applyFilterCallback(filterData);
                        },
                        child: _filterButtonWidget("Apply")),
                    GestureDetector(
                        onTap: (){
                          area =null;
                          companyTypeId=null;
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


  Widget customerTypeDropDown()=>DropdownButtonHideUnderline(
    child: DropdownButtonFormField(
        style: const TextStyle(
            fontSize: 13,
            color: Colors.black
        ),
      decoration: InputDecoration(
          hintText: "Company Type",
          hintStyle: const TextStyle(
              fontSize: 13,
              color: Colors.black
          ),
          fillColor: Colors.white,
          isDense: true,
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Constants.lightGreyBorderColor)),
          focusedErrorBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: Constants.lightGreyBorderColor)),
          errorBorder:   OutlineInputBorder(
              borderSide: BorderSide(color: Constants.lightGreyBorderColor)),
          focusedBorder:   OutlineInputBorder(
            borderSide: BorderSide(color: Constants.lightGreyBorderColor),
          ),
          disabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: Constants.lightGreyBorderColor),
          ) ,
        contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      ),
      value: companyTypeId,
      isExpanded: true,
      items: companyList.map((CustomerTypeId item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item.customerTypeName ?? ""),
        );
      }).toList(),
      onChanged: ( val){
        companyTypeId=val;
      },
    ),
  );

  Widget _filterButtonWidget(String title) => Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Constants.primaryColor),
        child: Text(
          title,
          style: const TextStyle(
              color: Color(0xfffefcf3),
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
      );


  Future<void> openSearchDelegate() async {
    final data = await showSearch(
      context: context,
      delegate: AreaSearchDelegate(),
    );
    if(data!=null){
      area=data;
      setState(() {

      });
    }
  }

  Future<void> getCompanyType() async {
    var response = await CustomerRepo.getCustomerTypeList();
    if(response.status){
      companyList=response.data!;
      setState(() {

      });
    }
  }
}
