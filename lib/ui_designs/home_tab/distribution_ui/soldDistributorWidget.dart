import 'package:flutter/material.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class SoldDistributorWidget extends StatefulWidget {
  final ValueChanged<int?> onPackSizeSelected;
  final int qtySold;

  const SoldDistributorWidget({Key? key, required this.onPackSizeSelected, required this.qtySold}) : super(key: key);

  @override
  _SoldDistributorWidgetState createState() => _SoldDistributorWidgetState();
}

class _SoldDistributorWidgetState extends State<SoldDistributorWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/distributor_images/sold.png",height: 15,width: 15),
          SizedBox(width: 2.w),
          SizedBox(
            width: 35.w,
            child: const Text(
              "Qty Sold : ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(
            width: 35.w,
            child: CustomTextFormField(
              keyboardType: TextInputType.number,
              initialValue: widget.qtySold.toString(),
              style: const TextStyle(
                fontSize: 13
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 3,horizontal: 7),
              hintText: "Enter sold value",
              onChanged: (val){
                if(val.isNotEmpty) {
                  widget.onPackSizeSelected(int.parse(val));
                }
              },
            ),

          ),
        ],
      ),
    );
  }
}
