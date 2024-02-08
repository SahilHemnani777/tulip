import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/dcr_model/dcr_reports.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/zoom_image.dart';

class SalesVisitDetails extends StatefulWidget {
  final DCRReport dcrData;
   const SalesVisitDetails({Key? key, required this.dcrData}) : super(key: key);

  @override
  State<SalesVisitDetails> createState() => _SalesVisitDetailsState();
}

class _SalesVisitDetailsState extends State<SalesVisitDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Visit Details",implyStatus: true,showBackButton: true),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleFieldWidget("Visit Calls (Sale)"),

              detailsFieldWidget("Customer name",widget.dcrData.customerId?.customerName ?? ""),
              if(widget.dcrData.visitTime !=null && widget.dcrData.visitTime!.isNotEmpty)
                detailsFieldWidget("Time",widget.dcrData.visitTime ?? ""),
              if(widget.dcrData.courtesyCall !=null && widget.dcrData.courtesyCall!.isNotEmpty)
                detailsFieldWidget("Courtesy Call",widget.dcrData.courtesyCall ?? ""),
              if(widget.dcrData.orderValue !=null && widget.dcrData.orderValue!.isNotEmpty)
                detailsFieldWidget("Order Booked Value",widget.dcrData.orderValue ?? ""),
              detailsFieldWidget("Comment",widget.dcrData.comment ?? ""),

              if(widget.dcrData.salesCall?.machineSerialNo !=null && widget.dcrData.salesCall!.machineSerialNo!.isNotEmpty)
                _titleFieldWidget("Sales Calls (Sale)"),

              if(widget.dcrData.salesCall?.machineSerialNo !=null && widget.dcrData.salesCall!.machineSerialNo!.isNotEmpty)
                detailsFieldWidget("Machine Sr. No",widget.dcrData.salesCall?.machineSerialNo ?? ""),
              if(widget.dcrData.salesCall?.machineName !=null && widget.dcrData.salesCall!.machineName!.isNotEmpty)
                detailsFieldWidget("Machine Name",widget.dcrData.salesCall?.machineName ?? ""),
              if(widget.dcrData.salesCall?.documents !=null && widget.dcrData.salesCall!.documents!.isNotEmpty)
              detailsFieldWidget("Report Files",""),

              if(widget.dcrData.salesCall?.documents !=null && widget.dcrData.salesCall!.documents!.isNotEmpty)
                SizedBox(
                height: 12.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.dcrData.salesCall?.documents?.length,
                    itemBuilder: (context,index){
                      return imageListWidget(widget.dcrData.salesCall?.documents?[index]);
                    }),
              ),

              if(widget.dcrData.salesCall?.documents !=null && widget.dcrData.salesCall!.documents!.isNotEmpty)
                dividerWidget(),



              if(widget.dcrData.pmCall?.machineSerialNo !=null && widget.dcrData.pmCall!.machineSerialNo!.isNotEmpty)
                _titleFieldWidget("PM Calls (Warranty)"),

              if(widget.dcrData.pmCall?.machineSerialNo !=null && widget.dcrData.pmCall!.machineSerialNo!.isNotEmpty)
                detailsFieldWidget("Machine Sr. No",widget.dcrData.pmCall?.machineSerialNo ?? ""),
              if(widget.dcrData.pmCall?.machineName !=null && widget.dcrData.pmCall!.machineName!.isNotEmpty)
                detailsFieldWidget("Machine Name",widget.dcrData.pmCall?.machineName ?? ""),
              if(widget.dcrData.pmCall?.warranty !=null && widget.dcrData.pmCall!.warranty!.isNotEmpty)
                detailsFieldWidget("Warranty",widget.dcrData.pmCall?.warranty ?? ""),
              if(widget.dcrData.pmCall?.documents !=null && widget.dcrData.pmCall!.documents!.isNotEmpty)
              detailsFieldWidget("Report Files",""),

              if(widget.dcrData.pmCall?.documents !=null && widget.dcrData.pmCall!.documents!.isNotEmpty)
              SizedBox(
                height: 12.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.dcrData.pmCall?.documents?.length,
                    itemBuilder: (context,index){
                      return imageListWidget(widget.dcrData.pmCall?.documents?[index]);
                    }),
              ),


              if(widget.dcrData.pmCall?.documents !=null && widget.dcrData.pmCall!.documents!.isNotEmpty)
                dividerWidget(),

              if(widget.dcrData.breakDownCall?.machineSerialNo !=null && widget.dcrData.breakDownCall!.machineSerialNo!.isNotEmpty)
                _titleFieldWidget("Breakdown Calls"),

              if(widget.dcrData.breakDownCall?.machineSerialNo !=null && widget.dcrData.breakDownCall!.machineSerialNo!.isNotEmpty)
                detailsFieldWidget("Machine Sr. No",widget.dcrData.breakDownCall?.machineSerialNo ?? ""),
              if(widget.dcrData.breakDownCall?.machineName !=null && widget.dcrData.breakDownCall!.machineName!.isNotEmpty)
                detailsFieldWidget("Machine Name",widget.dcrData.breakDownCall?.machineName ?? ""),
              if(widget.dcrData.breakDownCall?.documents !=null && widget.dcrData.breakDownCall!.documents!.isNotEmpty)
              detailsFieldWidget("Service Report Files",""),

              if(widget.dcrData.breakDownCall?.documents !=null && widget.dcrData.breakDownCall!.documents!.isNotEmpty)
                SizedBox(
                height: 12.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.dcrData.breakDownCall?.documents?.length,
                    itemBuilder: (context,index){
                      return imageListWidget(widget.dcrData.breakDownCall?.documents?[index]);
                    }),
              ),


              if(widget.dcrData.breakDownCall?.documents !=null && widget.dcrData.breakDownCall!.documents!.isNotEmpty)
                dividerWidget(),


              if(widget.dcrData.installationCall?.machineSerialNo !=null && widget.dcrData.installationCall!.machineSerialNo!.isNotEmpty)
                _titleFieldWidget("Installation Calls "),

              if(widget.dcrData.installationCall?.machineSerialNo !=null && widget.dcrData.installationCall!.machineSerialNo!.isNotEmpty)
                detailsFieldWidget("Machine Sr. No",widget.dcrData.installationCall?.machineSerialNo ?? ""),


              if(widget.dcrData.installationCall?.machineName !=null && widget.dcrData.installationCall!.machineName!.isNotEmpty)
                detailsFieldWidget("Machine Name",widget.dcrData.installationCall?.machineName ?? ""),


              if(widget.dcrData.installationCall?.documents !=null && widget.dcrData.installationCall!.documents!.isNotEmpty)
              detailsFieldWidget("Installation Report Files",""),

              if(widget.dcrData.installationCall?.documents !=null && widget.dcrData.installationCall!.documents!.isNotEmpty)
                SizedBox(
                height: 12.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.dcrData.installationCall?.documents?.length,
                    itemBuilder: (context,index){
                      return imageListWidget(widget.dcrData.installationCall?.documents?[index]);
                    }),
              ),

              if(widget.dcrData.installationCall?.documents !=null && widget.dcrData.installationCall!.documents!.isNotEmpty)
                _titleFieldWidget("Application Support Calls "),



              if(widget.dcrData.installationCall?.machineSerialNo !=null && widget.dcrData.installationCall!.machineSerialNo!.isNotEmpty)
                detailsFieldWidget("Machine Sr. No",widget.dcrData.applicationSupportCall?.machineSerialNo ?? ""),


              if(widget.dcrData.installationCall?.machineName !=null && widget.dcrData.installationCall!.machineName!.isNotEmpty)
                detailsFieldWidget("Machine Name",widget.dcrData.applicationSupportCall?.machineName ?? ""),


              if(widget.dcrData.applicationSupportCall?.documents !=null && widget.dcrData.applicationSupportCall!.documents!.isNotEmpty)
              detailsFieldWidget("Application Report Files",""),

              if(widget.dcrData.applicationSupportCall?.documents !=null && widget.dcrData.applicationSupportCall!.documents!.isNotEmpty)
                SizedBox(
                height: 12.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.dcrData.applicationSupportCall?.documents?.length,
                    itemBuilder: (context,index){
                      return imageListWidget(widget.dcrData.applicationSupportCall?.documents?[index]);
                    }),
              ),

            ],
          ),
        ),
      ),
    );
  }

    Widget imageListWidget(String imagePath)=>GestureDetector(
      onTap: (){
        Navigator.push(context,Constants.createRoute(ZoomInImagePage(imagePath: imagePath)),);
      },
      child: Hero(
        key: UniqueKey(),
        tag: imagePath.hashCode.toString(),
        child: Container(
          height: 14.h,width: 14.h,
          decoration:BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: const Color(0xffC3C3C3).withOpacity(0.30),
                  offset: const Offset(0, 0),
                  spreadRadius: 3,
                  blurRadius: 2),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
          padding: EdgeInsets.all(imagePath.isEmpty ? 20 :0),
          child:imagePath.isEmpty ? Image.asset("assets/other_images/pdf.png",fit: BoxFit.contain,) :
          CachedNetworkImage(
            imageUrl: imagePath,fit: BoxFit.fill,
          ),),
      ),
    );

  Widget detailsFieldWidget(String title1, String title2)=>Container(
    margin: EdgeInsets.symmetric(horizontal: 3.w,vertical: 0.6.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 40.w,
            child: Text("$title1 : ")),
        Expanded(child: Text(title2,style: const TextStyle(
          fontWeight: FontWeight.w600
        ),)),
      ],
    ),
  );

  Widget _titleFieldWidget(String title) => Container(
    margin: EdgeInsets.only(left: 3.w,top: 1.h,bottom: 1.h),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.transparent,
        fontSize: 15,
        decoration: TextDecoration.underline,
        decorationColor: Constants.primaryColor,
        decorationThickness: 1.5,
        shadows: [
          Shadow(
              color: Constants.primaryColor, offset: Offset(0, -3))
        ],
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget dividerWidget()=>const Divider(
    color: Colors.black,
  );
}
