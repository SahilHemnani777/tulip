import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/customer_model/customer_list_model.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/open_url.dart';

class CustomerListDetailsWidget extends StatefulWidget {
  final CustomerListItem customerListItem;
  final bool fromSearch;

  const CustomerListDetailsWidget({Key? key, required this.customerListItem, this.fromSearch=false}) : super(key: key);

  @override
  CustomerListDetailsWidgetState createState() => CustomerListDetailsWidgetState();
}

class CustomerListDetailsWidgetState extends State<CustomerListDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: const Color(0xffC3C3C3).withOpacity(0.25),
                blurRadius: 3,
                spreadRadius: 0,
                offset: const Offset(0, 1)),
            BoxShadow(
                color: const Color(0xffC3C3C3).withOpacity(0.25),
                blurRadius: 3,
                spreadRadius: 0,
                offset: const Offset(0, -1)),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(20),
          )),
      child: Column(
        children: [
          SizedBox(height: 2.h),

          _customerTextWidget(
              "assets/menu_icons/profile_icon.png", "Name", widget.customerListItem.customerName, ""),

          if(widget.customerListItem.companyMobileNumber!=null && widget.customerListItem.companyMobileNumber!.isNotEmpty)
            SizedBox(height: 1.5.h),

          if(widget.customerListItem.companyMobileNumber!=null && widget.customerListItem.companyMobileNumber!.isNotEmpty)
          _customerTextWidget("assets/other_images/call_dark_icon.png",
              "Contact Number", widget.customerListItem.companyMobileNumber.toString(), ""),

          if(widget.customerListItem.companyEmailId!=null && widget.customerListItem.companyEmailId!.isNotEmpty)
            SizedBox(height: 1.5.h),

          if(widget.customerListItem.companyEmailId!=null && widget.customerListItem.companyEmailId!.isNotEmpty)
            _customerTextWidget("assets/lead_page_icon/email_icon.png",
              "Company Email", widget.customerListItem.companyEmailId ?? "", ""),

          SizedBox(height: 1.5.h),

          _customerTextWidget("assets/lead_page_icon/address_icon.png",
              "Address","${widget.customerListItem.address1}${widget.customerListItem.address2 != null ? ', ${widget.customerListItem.address2}' : ''}${widget.customerListItem.address3 != null ? ', ${widget.customerListItem.address3}' : ''}, ${widget.customerListItem.city}, ${widget.customerListItem.state}, ${widget.customerListItem.pinCode}" , ""),

          if(widget.customerListItem.customerType!=null && widget.customerListItem.customerType!.isNotEmpty)
            SizedBox(height: 1.5.h),

          if(widget.customerListItem.customerType!=null && widget.customerListItem.customerType!.isNotEmpty)
            _customerTextWidget("assets/other_images/type_icon.png",
              "Customer Type", widget.customerListItem.customerType ?? "", ""),

          SizedBox(height: 1.5.h),

          if(widget.customerListItem.companyMobileNumber !=null && widget.customerListItem.companyMobileNumber!.isNotEmpty )
            Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black.withOpacity(0.10)))
              ),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    OpenUrl.callNumber(widget.customerListItem.companyMobileNumber.toString());
                  },
                  child: SizedBox(
                    height: 5.h,
                    width: 40.w,
                    child: _contactFieldWidget(
                        "assets/other_images/call_dark_icon.png", "Call"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    OpenUrl.openWhatsApp(widget.customerListItem.companyMobileNumber.toString());
                  },
                  child: Container(
                      height: 5.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Constants.lightGreyColor),
                        ),
                      ),
                      child: _contactFieldWidget(
                          "assets/lead_page_icon/whatsapp_icon.png",
                          "Whatsapp")),
                ),
              ],
          ),
            ),
        ],
      ),
    );
  }
  Widget _contactFieldWidget(String imagePath, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: 15,
          width: 15,
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        )
      ],
    );
  }


  Widget _customerTextWidget(
      String imagePath, String title, String date, String time) =>
      Container(
        margin: EdgeInsets.only(left: 4.w,right: 2.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Image.asset(
                imagePath,
                height: 15,
                width: 15,
                color: Constants.primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 30.w,
              child: Text(
                "$title : ",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
                child: Text(
                  "$date   $time",
                  style: const TextStyle(fontSize: 13),
                )),
          ],
        ),
      );
}
