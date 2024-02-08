import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/open_url.dart';
import 'package:tulip_app/widget/custom_button.dart';
import 'package:tulip_app/widget/zoom_image.dart';

class LeadDetailWidget extends StatefulWidget {
  final LeadDetails leadData;
  final VoidCallback? convertCustomerClick;
  final bool isCustomer;
  const LeadDetailWidget(
      {Key? key,
      required this.leadData,
      this.convertCustomerClick,
      this.isCustomer = false})
      : super(key: key);

  @override
  _LeadDetailWidgetState createState() => _LeadDetailWidgetState();
}

class _LeadDetailWidgetState extends State<LeadDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 3.w, right: 3.w, top: 2.h, bottom: 2.h),
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
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            _titleFieldWidget("Company Info"),
            _customerTextWidget("assets/menu_icons/profile_icon.png",
                "Customer Name ", widget.leadData.customerName ?? "", ""),
            if (widget.leadData.companyMobileNumber != null &&
                widget.leadData.companyMobileNumber!.isNotEmpty)
              Container(
                padding: EdgeInsets.only(
                    left: 5.w, bottom: 1.h, top: 1.h, right: 4.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Image.asset(
                        "assets/other_images/call_dark_icon.png",
                        height: 15,
                        width: 15,
                        color: Constants.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Mobile No : ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.leadData.companyMobileNumber ?? "",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          OpenUrl.callNumber(
                              widget.leadData.companyMobileNumber ?? "");
                        },
                        child: Image.asset(
                            "assets/other_images/call_dark_icon.png",
                            height: 18,
                            width: 18)),
                    SizedBox(width: 2.w),
                    GestureDetector(
                        onTap: () {
                          OpenUrl.openWhatsApp(
                              widget.leadData.companyMobileNumber ?? "");
                        },
                        child: Image.asset(
                            "assets/lead_page_icon/whatsapp_icon.png",
                            height: 18,
                            width: 18)),
                  ],
                ),
              ),
            _customerTextWidget(
                "assets/other_images/type_icon.png",
                "Customer Type",
                widget.leadData.customerTypeId?.customerTypeName ?? "",
                ""),
            Container(
              padding:
                  EdgeInsets.only(left: 5.w, bottom: 1.h, top: 1.h, right: 4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Image.asset(
                      "assets/other_images/status_icon.png",
                      height: 15,
                      width: 15,
                      color: Constants.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Status : ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.leadData.status ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.leadData.status == "Interested"
                            ? Colors.green
                            : widget.leadData.status == "Not Interested"
                                ? Colors.red
                                : widget.leadData.status == "Cold Followup"
                                    ? Colors.blue
                                    : widget.leadData.status == "Hot Followup"
                                        ? Colors.lightBlueAccent
                                        : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _customerTextWidget(
                "assets/lead_page_icon/address_icon.png",
                "Address",
                "${widget.leadData.address1}${widget.leadData.address2 != null ? ', ${widget.leadData.address2}' : ''}${widget.leadData.address3 != null ? ', ${widget.leadData.address3}' : ''}, ${widget.leadData.city}, ${widget.leadData.state}, ${widget.leadData.pinCode}",
                ""),
            _customerTextWidget("assets/lead_page_icon/address_icon.png",
                "Area", widget.leadData.townId?.townName ?? "", ""),
            if (widget.leadData.gstLicenceCertificate != null &&
                widget.leadData.gstLicenceCertificate!.isNotEmpty)
              SizedBox(height: 1.h),
            if (widget.leadData.gstLicenceCertificate != null &&
                widget.leadData.gstLicenceCertificate!.isNotEmpty)
              _titleFieldWidget("GST Certificate"),
            if (widget.leadData.gstNumber != null &&
                widget.leadData.gstNumber!.isNotEmpty)
              _customerTextWidget("assets/lead_page_icon/gst_icon.png",
                  "GST No", widget.leadData.gstNumber ?? "", ""),
            if (widget.leadData.gstLicenceCertificate != null &&
                widget.leadData.gstLicenceCertificate!.isNotEmpty)
              SizedBox(
                height: 12.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.leadData.gstLicenceCertificate?.length,
                    itemBuilder: (context, index) {
                      return imageListWidget(
                          widget.leadData.gstLicenceCertificate![index]);
                    }),
              ),
            if (widget.leadData.drugLicenceCertificate != null &&
                widget.leadData.drugLicenceCertificate!.isNotEmpty)
              SizedBox(height: 1.h),
            if (widget.leadData.drugLicenceCertificate != null &&
                widget.leadData.drugLicenceCertificate!.isNotEmpty)
              _titleFieldWidget("Drug License Certificate"),
            if (widget.leadData.drugLicenceNumber != null &&
                widget.leadData.drugLicenceNumber!.isNotEmpty)
              _customerTextWidget(
                  "assets/lead_page_icon/drug_icon.png",
                  "Drug License No",
                  widget.leadData.drugLicenceNumber ?? "",
                  ""),
            if (widget.leadData.drugLicenceCertificate != null &&
                widget.leadData.drugLicenceCertificate!.isNotEmpty)
              SizedBox(
                height: 12.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.leadData.drugLicenceCertificate?.length,
                    itemBuilder: (context, index) {
                      return imageListWidget(
                          widget.leadData.drugLicenceCertificate![index]);
                    }),
              ),
            const Divider(
              color: Colors.black,
            ),
            if (widget.leadData.contactPersonName != null &&
                widget.leadData.contactPersonName!.isNotEmpty)
              _titleFieldWidget("Contact Person Info"),
            if (widget.leadData.contactPersonName != null &&
                widget.leadData.contactPersonName!.isNotEmpty)
              _customerTextWidget(
                  "assets/menu_icons/profile_icon.png",
                  "Contact Person Name ",
                  widget.leadData.contactPersonName ?? "",
                  ""),
            if (widget.leadData.contactPersonMobileNumber != null &&
                widget.leadData.contactPersonMobileNumber!.isNotEmpty)
              Container(
                padding: EdgeInsets.only(
                    left: 5.w, bottom: 1.h, top: 1.h, right: 4.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Image.asset(
                        "assets/other_images/call_dark_icon.png",
                        height: 15,
                        width: 15,
                        color: Constants.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Contact Person Number : ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.leadData.contactPersonMobileNumber ?? "",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          OpenUrl.callNumber(
                              widget.leadData.contactPersonMobileNumber ?? "");
                        },
                        child: Image.asset(
                            "assets/other_images/call_dark_icon.png",
                            height: 18,
                            width: 18)),
                    SizedBox(width: 2.w),
                    GestureDetector(
                        onTap: () {
                          OpenUrl.openWhatsApp(
                              widget.leadData.contactPersonMobileNumber ?? "");
                        },
                        child: Image.asset(
                            "assets/lead_page_icon/whatsapp_icon.png",
                            height: 18,
                            width: 18)),
                  ],
                ),
              ),
            if (widget.leadData.designation != null &&
                widget.leadData.designation!.isNotEmpty)
              _customerTextWidget("assets/other_images/designation.png",
                  "Designation", widget.leadData.designation ?? "", ""),
            if (widget.leadData.qualification != null &&
                widget.leadData.qualification!.isNotEmpty)
              _customerTextWidget("assets/other_images/qual_icon.png",
                  "Qualification", widget.leadData.qualification ?? "", ""),
            if (widget.leadData.notes != null &&
                widget.leadData.notes!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 6.w, top: 2.h),
                child: const Text(
                  "Additional Note :",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            if (widget.leadData.notes != null &&
                widget.leadData.notes!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 6.w, top: 1.h),
                child: Text(
                  widget.leadData.notes ?? "",
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w400),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: CustomButton(
                title: widget.isCustomer
                    ? "View Customer Details"
                    : "Convert to Customer",
                onTabButtonCallback: widget.convertCustomerClick,
              ),
            )
          ],
        ),
      ),
    );

    //   Container(
    //   margin: EdgeInsets.only(left: 3.w,right: 3.w,top: 2.h,bottom: 2.h),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     boxShadow: [
    //       BoxShadow(
    //           offset: const Offset(0, 1),
    //           color: const Color(0xffC3C3C3).withOpacity(0.25),
    //           blurRadius: 4,
    //           spreadRadius: 0),
    //       BoxShadow(
    //           offset: const Offset(0, -1),
    //           color: const Color(0xffC3C3C3).withOpacity(0.25),
    //           blurRadius: 4,
    //           spreadRadius: 0),
    //     ],
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //
    //       SizedBox(height: 1.h),
    //
    //
    //       Container(
    //         padding: EdgeInsets.only(left : 5.w,bottom: 1.h,top: 1.h,right: 4.w),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.only(top: 3.0),
    //               child: Image.asset(
    //                 "assets/menu_icons/profile_icon.png",
    //                 height: 15,
    //                 width: 15,
    //                 color: Constants.lightGreyColor,
    //               ),
    //             ),
    //             const SizedBox(width: 10),
    //             const Text(
    //               "Name : Tulip",
    //               style: TextStyle(
    //                 fontWeight: FontWeight.w600,
    //                 fontSize: 13,
    //               ),
    //             ),
    //             const Spacer(),
    //             Icon(Icons.edit,color: Constants.lightGreyColor,size: 20,),
    //           ],
    //         ),
    //       ),
    //
    //
    //
    //       _leadTextWidget(
    //           "assets/other_images/call_dark_icon.png",
    //           "Mobile No",
    //           "8899889988",
    //           ""),
    //
    //
    //       _leadTextWidget(
    //           "assets/lead_page_icon/email_icon.png",
    //           "Contact Person Email",
    //           "abcd@gmail.com",
    //           ""),
    //
    //       _leadTextWidget(
    //           "assets/lead_page_icon/address_icon.png",
    //           "Address",
    //           "Hinjewadi Phase 1, Pune 411057",
    //           ""),
    //
    //
    //       _leadTextWidget(
    //           "assets/menu_icons/profile_icon.png",
    //           "Designation",
    //           "Manager",
    //           ""),
    //
    //       _leadTextWidget(
    //           "assets/lead_page_icon/website_icon.png",
    //           "Website",
    //           "www.tulip.com",
    //           ""),
    //
    //       _leadTextWidget(
    //           "assets/other_images/call_dark_icon.png",
    //           "Company No",
    //           "98989898989",
    //           ""),
    //
    //       _leadTextWidget(
    //           "assets/lead_page_icon/email_icon.png",
    //           "Company Email",
    //           "abcd@gmail.com",
    //           ""),
    //
    //       _leadTextWidget(
    //           "assets/menu_icons/profile_icon.png",
    //           "Is Active Customer",
    //           "Yes",
    //           ""),
    //
    //       _leadTextWidget(
    //           "assets/lead_page_icon/gst_icon.png",
    //           "GSTIN",
    //           "ABC1234",
    //           ""),
    //
    //       _leadTextWidget(
    //           "assets/lead_page_icon/address_icon.png",
    //           "Nearest HQ ",
    //           "Pune",
    //           ""),
    //
    //
    //
    //
    //       Padding(
    //         padding: EdgeInsets.only(left: 6.w,top: 2.h),
    //         child: const Text("Additional Note :",
    //           style: TextStyle(
    //               color: Colors.red,
    //               fontSize: 15,
    //               fontWeight: FontWeight.w500
    //           ),
    //         ),
    //       ),
    //
    //
    //
    //       Padding(
    //         padding: EdgeInsets.only(left: 6.w,top: 1.h),
    //         child:  const Text("simply dummy text of the printing and typesetting industry. Lorem Ipsum simply",
    //           style: TextStyle(
    //               fontSize: 13,
    //               fontWeight: FontWeight.w400
    //           ),
    //         ),
    //       ),
    //
    //
    //       Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 4.w),
    //         child: const CustomButton(title: "Convert to Customer"),
    //       )
    //     ],
    //   ),
    // );
  }

  Widget imageListWidget(String imagePath) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            Constants.createRoute(ZoomInImagePage(imagePath: imagePath)),
          );
        },
        child: Hero(
          key: UniqueKey(),
          tag: imagePath.hashCode.toString(),
          child: Container(
            height: 14.h,
            width: 14.h,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: const Color(0xffC3C3C3).withOpacity(0.30),
                    offset: const Offset(0, 0),
                    spreadRadius: 3,
                    blurRadius: 2),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            padding: EdgeInsets.all(imagePath.isEmpty ? 20 : 0),
            child: imagePath.isEmpty
                ? Image.asset(
                    "assets/other_images/pdf.png",
                    fit: BoxFit.contain,
                  )
                : CachedNetworkImage(
                    imageUrl: imagePath,
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      );

  Widget _customerTextWidget(
          String imagePath, String title, String date, String time) =>
      Container(
        padding: EdgeInsets.only(left: 5.w, bottom: 1.h, top: 1.h, right: 4.w),
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
            Text(
              "$title : ",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Expanded(
              child: Text(
                "$date  $time",
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      );

  Widget _titleFieldWidget(String title) => Container(
        margin: EdgeInsets.only(left: 3.w),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.transparent,
            fontSize: 15,
            decoration: TextDecoration.underline,
            decorationColor: Constants.primaryColor,
            decorationThickness: 1.5,
            shadows: [
              Shadow(color: Constants.primaryColor, offset: Offset(0, -3))
            ],
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  // Route _createRoute(Widget widget) {
  //   return PageRouteBuilder(
  //     barrierDismissible: true,
  //     pageBuilder: (context, animation, secondaryAnimation) => widget,
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       return FadeTransition(
  //         opacity: animation,
  //         child: child,
  //       );
  //     },
  //     opaque: false, // Set to false to make the page transparent
  //     barrierColor: Colors.black.withOpacity(0.5), // Set the color of the barrier if needed
  //   );
  // }
  //
  //
  //
  // Widget _leadTextWidget(String imagePath, String title, String date, String time) => Container(
  //   padding: EdgeInsets.only(left : 5.w,bottom: 1.h,top: 1.h,right: 4.w),
  //   child: Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(top: 3.0),
  //         child: Image.asset(
  //           imagePath,
  //           height: 15,
  //           width: 15,
  //           color: Constants.lightGreyColor,
  //         ),
  //       ),
  //       const SizedBox(width: 10),
  //       Text(
  //         "$title : ",
  //         style: const TextStyle(
  //           fontWeight: FontWeight.w600,
  //           fontSize: 13,
  //         ),
  //       ),
  //       Expanded(child: Text("$date  $time",
  //         style: const TextStyle(
  //             fontSize: 13
  //         ),),
  //       ),
  //     ],
  //   ),
  // );
}
