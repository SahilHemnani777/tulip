import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/util/extensions.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTabButtonCallback;
  final EdgeInsetsGeometry? margin;
  const CustomButton({Key? key, required this.title, this.onTabButtonCallback,this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTabButtonCallback,
      child: Container(
        alignment: Alignment.center,
        margin:  margin ?? EdgeInsets.symmetric(vertical: 2.h),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          gradient: Constants.buttonGradientColor
             ),
        child: Text(
          title,
          style: const TextStyle(
              color: Color(0xfffefcf3),
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
