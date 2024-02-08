import 'package:flutter/material.dart';
import 'package:tulip_app/model/expense_model/expense_details_list.dart';
import 'package:tulip_app/model/expense_model/standard_fare_address.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class TravelDetailItem extends StatefulWidget {
  final StandardFareChart standardFareAddress;
  final double distance;
  final double fair;
  final double totalAllowance;
  final double? updateFair;
  final double threadHold;
  final String? way;
  final bool updateExpense;
  final Function(String) updateRouteWay; // Callback to update _showFilter
  final Function(double)? updateFairPrice; // Callback to update _showFilter
   const TravelDetailItem({super.key,required this.standardFareAddress, required this.distance, required this.fair, required this.updateRouteWay, this.way, this.updateFairPrice, required this.totalAllowance,this.updateExpense =false, required this.threadHold, this.updateFair,
  });

  @override
  State<TravelDetailItem> createState() => _TravelDetailItemState();
}

class _TravelDetailItemState extends State<TravelDetailItem> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.way!=null){
      widget.standardFareAddress.oneWay = widget.way;
    }
    print("12313 ${widget.standardFareAddress.oneWay}");
    if(!widget.updateExpense) {
      widget.standardFareAddress.fair = (widget.standardFareAddress.distanceKms??0 ) * ((widget.fair));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      padding: EdgeInsets.only(top: 1.h, left: 5.w,right: 2.w),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: const Color(0xffC3C3C3).withOpacity(0.30),
            offset: const Offset(0, 0),
            spreadRadius: 2,
            blurRadius: 2),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Row(
            children: [
              Expanded(child: _travelDetailTextWidget("Area",widget.standardFareAddress.area?.townName ?? "")),
              Expanded(child: _travelDetailTextWidget("Station Type",widget.standardFareAddress.stationType ?? "")),

            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(child: _travelDetailTextWidget("From (Started)",widget.standardFareAddress.from ?? "")),
              Expanded(child: _travelDetailTextWidget("To (Ended)",widget.standardFareAddress.to ?? "")),

            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(child: _travelDetailTextWidget("Distance", "${widget.standardFareAddress.distanceKms.toString()} kms")),

              if(widget.distance>widget.threadHold)
              Expanded(
                child: CustomTextFormField(
                  hintText: "Enter fare price",
                  initialValue: widget.updateFair?.toStringAsFixed(2) ??  widget.fair.toStringAsFixed(2),
                  keyboardType: TextInputType.number,
                  onChanged: (val){
                    widget.standardFareAddress.fair = double.parse(val);
                    widget.updateFairPrice!(widget.standardFareAddress.fair!);
                  },
                ),
              ),


              if(widget.distance < widget.threadHold)
              Expanded(child: _travelDetailTextWidget("Fare", widget.standardFareAddress.oneWay=="One Way" ?
              "Rs. ${((widget.standardFareAddress.distanceKms ?? 0) *  (widget.fair)).toStringAsFixed(2)}/-" :
              "Rs. ${((widget.standardFareAddress.distanceKms ?? 0) *  (widget.fair)*2).toStringAsFixed(2)}/-")
              ),
            ],
          ),
          SizedBox(height: 1.h),

          _travelDetailTextWidget("Total Allowance",widget.totalAllowance.toString() ?? ""),

          Row(
            children: [
              Expanded(
                child: ListTileTheme(
                  horizontalTitleGap: 0,
                  child: RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    value: "One Way",
                    groupValue: widget.standardFareAddress.oneWay ?? "One Way",
                    onChanged: (val) {
                      setState(() {
                        widget.standardFareAddress.oneWay = val!;
                        widget.updateRouteWay(widget.standardFareAddress.oneWay!);
                        // widget.standardFareAddress.fair=0;
                        widget.standardFareAddress.fair= (widget.standardFareAddress.distanceKms??0 ) * (widget.fair);
                      });
                    },
                    title: const Text(
                      "One Way",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListTileTheme(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  child: RadioListTile(
                    value: "Two Way",
                    groupValue: widget.standardFareAddress.oneWay,
                    onChanged: (val) {
                      setState(() {
                        widget.standardFareAddress.oneWay = val!;
                        widget.updateRouteWay(widget.standardFareAddress.oneWay!);
                        widget.standardFareAddress.fair = (2*(widget.standardFareAddress.distanceKms??0 ) *widget.fair);

                      });
                    },
                    title: const Text(
                      "Two Way",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),


          if(widget.standardFareAddress.activityType?.activityTypeName=="Meeting")
          const Text("Note : Expenses related to an area with the activity type “Meeting” cannot be considered.",style: TextStyle(
              fontSize: 12,color: Colors.red
          ),),
          SizedBox(height: 1.h),

        ],
      ),
    );
  }
  String addSpaces(String input) {
    // Replace commas and hyphens with a space followed by the matched character
    String formattedString = input.replaceAllMapped(RegExp(r'[,-]'), (match) => '${match.group(0)} ');

    // Remove leading space
    return formattedString.trimLeft();
  }

  Widget _travelDetailTextWidget(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        Text(
          addSpaces(value),
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }
}