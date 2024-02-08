import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/util/extensions.dart';

class CommonDialog extends StatelessWidget {
//  final VoidCallbackAction? onPositiveButtonclicked;
//  final VoidCallbackAction? onNegativeButtonclicked;
  final String title;
  final String message;
  final String positiveButtonText;
  final String negativeButtonText;

  const CommonDialog(
      {Key? key,
      required this.title,
      required this.message,
      required this.positiveButtonText,
      required this.negativeButtonText,
     // required this.onPositiveButtonclicked,
      //required this.onNegativeButtonclicked
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                GestureDetector(
                    onTap: () => Get.back(result: false),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,size: 16,
                    )),
              ],
            ),
            SizedBox(height: 1.h),
            textWidget(message),
            Container(
              margin: EdgeInsets.only(top: 3.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if(negativeButtonText.isNotEmpty)
                  GestureDetector(
                      onTap: () => Get.back(result: false),
                      child: buttonWidget(negativeButtonText, false,context)),
                  GestureDetector(
                      onTap: () {
                        Get.back(result: true);
                      },
                      child: buttonWidget(positiveButtonText, true,context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonWidget(String title, bool isPositive,BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.25,
      padding: EdgeInsets.symmetric(vertical:isPositive? 0.9.h: 0.8.h),
      decoration: BoxDecoration(
        gradient: isPositive
            ? Constants.buttonGradientColor
            : const LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                ],
              ),
        borderRadius: BorderRadius.circular(5),
          border:isPositive ? Border.all(color:Colors.white ,width: 1): Border.all(color: Constants.primaryColor,width: 2)
      ),
      child: Center(
        child: Text(
          isPositive ? positiveButtonText : negativeButtonText,
          style: TextStyle(
              color: isPositive ? Colors.white : Constants.primaryColor,
              fontSize: 13),
        ),
      ),
    );
  }

  Widget textWidget(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff424242)),
    );
  }
}
