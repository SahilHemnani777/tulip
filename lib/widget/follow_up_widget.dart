
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tulip_app/model/lead_model/follow_up_model.dart';
import 'package:tulip_app/util/date_util.dart';
import 'package:tulip_app/util/extensions.dart';

class FollowUpWidget extends StatefulWidget {
  final FollowUpDetails followUpDetails;
  final VoidCallback? backButtonCallback;
  final String userId;
  const FollowUpWidget({Key? key, required this.followUpDetails, this.backButtonCallback, required this.userId}) : super(key: key);

  @override
  State<FollowUpWidget> createState() => _FollowUpWidgetState();
}

class _FollowUpWidgetState extends State<FollowUpWidget> {


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0,4),
                color: const Color(0xff8B8B8B).withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 4
            ),

            BoxShadow(
                offset: const Offset(-2,-4),
                color: const Color(0xff909090).withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 4
            ),
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          followUpField("Follow up date :",
          "${DateUtil.getDisplayFormatDate(widget.followUpDetails.followUpDate!)} ${DateUtil.getDisplayFormatTime(widget.followUpDetails.followUpDate!) }",
            widget.backButtonCallback,widget.followUpDetails.followUpBy ?? "",Icons.edit),

          followUpField("Status :", widget.followUpDetails.status!.contains("Other") ? "Other" : widget.followUpDetails.status ?? "",(){},null,null),

          followUpField("Description :", widget.followUpDetails.followUpNotes ?? "",(){},null,null),

          followUpField("Added By : ", widget.followUpDetails.followUpByName ?? "",(){},null,null),

        ],

      ),
    );
  }


  Widget followUpField(String firstField,String secondField,Function()? onTap,String? salesUserId,IconData? icon){
    DateTime createdAt = widget.followUpDetails.createdAt!.toLocal();
    if (secondField.contains("PM") || secondField.contains("AM")) {
      createdAt = DateFormat("dd/MM/yyyy hh:mm a").parse(secondField);
    }
    DateTime now = DateTime.now();
    Duration timeDifference = now.difference(createdAt);
    bool shouldShowEditIcon = timeDifference.inHours <= 1;
    return  Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          SizedBox(
              width: 32.w,
              child: Text(firstField,
              style: const TextStyle(
                fontWeight: FontWeight.w600
              ),
              )),

           Expanded(child: Text(secondField,
             style: TextStyle(
               color: secondField=="Pending"? const Color(0xffFF8A00) :
               secondField =="Closed" ? Colors.red :
               secondField =="Finalized" ? const Color(0xff4CAF50) : Colors.black,
                 fontWeight: FontWeight.w500
             ),
           )),

          if (shouldShowEditIcon && icon != null && widget.userId==salesUserId)
            GestureDetector(
              onTap: onTap,
              child: Icon(icon,size: 17,)),

        ],
      ),
    );
  }



}
