import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/lead_list_model.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/open_url.dart';

class LeadCardWidget extends StatefulWidget {
  final LeadItemInfo? leadItemInfo;
  final bool fromSearch;
  const LeadCardWidget({Key? key, this.leadItemInfo, this.fromSearch=false}) : super(key: key);

  @override
  LeadCardWidgetState createState() => LeadCardWidgetState();
}

class LeadCardWidgetState extends State<LeadCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
      decoration: BoxDecoration(
          color: Constants.white,
          boxShadow: [
            BoxShadow(
                color: const Color(0xffC3C3C3).withOpacity(0.25),
                blurRadius: 3,
                spreadRadius: 0,
                offset: const Offset(0,1)
            ),
            BoxShadow(
                color: const Color(0xffC3C3C3).withOpacity(0.25),
                blurRadius: 3,
                spreadRadius: 0,
                offset: const Offset(0,-1)
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(20),)),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            children: [
              SizedBox(height: 2.h),
              _leadTextWidget("assets/menu_icons/profile_icon.png",
                  "Name", widget.leadItemInfo?.customerName ?? "", ""),

              if(widget.leadItemInfo?.companyMobileNumber !=null && widget.leadItemInfo!.companyMobileNumber.isNotEmpty )
              SizedBox(height: 1.5.h),

              if(widget.leadItemInfo?.companyMobileNumber !=null && widget.leadItemInfo!.companyMobileNumber.isNotEmpty )
                _leadTextWidget("assets/other_images/call_dark_icon.png",
                  "Company No", widget.leadItemInfo?.companyMobileNumber ?? "", ""),

              if(widget.leadItemInfo?.companyEmailId !=null && widget.leadItemInfo!.companyEmailId.isNotEmpty )
              SizedBox(height: 1.5.h),

              if(widget.leadItemInfo?.companyEmailId !=null && widget.leadItemInfo!.companyEmailId.isNotEmpty )
                _leadTextWidget("assets/lead_page_icon/email_icon.png",
                  "Email", widget.leadItemInfo?.companyEmailId ?? "", ""),


              SizedBox(height: 1.5.h),

              _leadTextWidget("assets/lead_page_icon/address_icon.png",
                  "Address", "${widget.leadItemInfo?.address1}${widget.leadItemInfo?.address2 != null ? ', ${widget.leadItemInfo?.address2}' : ''}${widget.leadItemInfo?.address3 != null ? ', ${widget.leadItemInfo?.address3}' : ''}, ${widget.leadItemInfo?.city}, ${widget.leadItemInfo?.state}, ${widget.leadItemInfo?.pinCode}", ""),
              SizedBox(height: 1.5.h),

              if(widget.leadItemInfo?.createdAt !=null )
                _leadTextWidget("assets/lead_page_icon/created_date.png",
                "Created Date", DateUtil.getDisplayFormatDate(widget.leadItemInfo!.createdAt), ""),
              SizedBox(height: 1.5.h),


              Container(
                decoration: BoxDecoration(
                  border :Border(top: BorderSide(color: Colors.black.withOpacity(0.10)))),
                child: Row(
                  children: [
                    const Spacer(),
                    if (widget.leadItemInfo?.companyMobileNumber !=null && widget.leadItemInfo!.companyMobileNumber.isNotEmpty )
                      GestureDetector(
                      onTap: (){
                        OpenUrl.callNumber(widget.leadItemInfo?.companyMobileNumber ?? "");
                      },
                      child: _contactFieldWidget("assets/other_images/call_dark_icon.png","Call"
                      ),
                    ),

                    const Spacer(),

                    if (widget.leadItemInfo?.companyMobileNumber !=null && widget.leadItemInfo!.companyMobileNumber.isNotEmpty )
                      GestureDetector(
                      onTap: () async {
                        OpenUrl.openWhatsApp(widget.leadItemInfo?.companyMobileNumber ?? "");
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 0.5.h),
                          decoration:  BoxDecoration(
                            border: Border(left: BorderSide(color: Constants.lightGreyColor),
                            ),
                          ),
                          child: _contactFieldWidget("assets/lead_page_icon/whatsapp_icon.png","Whatsapp"
                          )),
                    ),



                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 35.w
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration:  BoxDecoration(
                          color: widget.leadItemInfo?.status == "Interested"? Colors.green: widget.leadItemInfo?.status == "Not Interested"? Colors.red :widget.leadItemInfo?.status == "Cold Followup"? Colors.blue : widget.leadItemInfo?.status == "Hot Followup" ? Colors.lightBlueAccent:Colors.grey ,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topLeft: Radius.circular(20))),
                      child: Text(
                        widget.leadItemInfo!.status.contains("Other") ? "Other" : widget.leadItemInfo?.status ?? "",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if(widget.leadItemInfo?.isCustomer == true)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 2),
            decoration: const BoxDecoration(
              color:  Colors.green,
              borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomLeft: Radius.circular(5))
            ),
            child: const Text("Customer",
            style: TextStyle(
              color: Colors.white
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leadTextWidget(
      String imagePath, String title, String date, String time) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
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
              width: 24.w,
              child: Text(
                "$title : ",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
                child: Text(
                  "$date   $time",
                  style: const TextStyle(fontSize: 12),
                )),
          ],
        ),
      );

  Widget _contactFieldWidget(String imagePath, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(imagePath, height: 15, width: 15,),
        SizedBox(width: 2.w),
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

}
