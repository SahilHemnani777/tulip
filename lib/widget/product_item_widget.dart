import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/util/extensions.dart';

class ProductItemWidget extends StatefulWidget {
  const ProductItemWidget({Key? key}) : super(key: key);

  @override
  _ProductItemWidgetState createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w,vertical: 0.9.h),

      padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
                color: const Color(0xffC3C3C3)
                    .withOpacity(0.25),
                blurRadius: 3,
                spreadRadius: 0,
                offset: const Offset(0, 1)),
            BoxShadow(
                color: const Color(0xffC3C3C3)
                    .withOpacity(0.25),
                blurRadius: 3,
                spreadRadius: 0,
                offset: const Offset(0, -1)),
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/menu_icons/profile.png",
            fit: BoxFit.fill,
            height: 9.h,
            width: 9.h,
          ),
          const SizedBox(width: 14),
          Container(
            constraints: BoxConstraints(
              maxWidth: 52.w,
            ),
            child: const Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  "Oximeter",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "Lorem ipsum a the big...",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),


              ],
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
                color: Constants.primaryColor,
                borderRadius: BorderRadius.circular(5)
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 0.7.h),
            child: const Text("View",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white
              ),
            ),
          )

        ],
      ),
    );
  }
}
