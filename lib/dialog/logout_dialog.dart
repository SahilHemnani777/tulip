import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),

              Image.asset("assets/profile_images/logout_image.png",height: 20.h,width: 25.h),

              const SizedBox(height: 15),
              const Text(
                "Are you sure,\n you want to logout ? ",textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(onTap: () => Get.back(), child: _logoutOptionWidget("No")),

                  //yes button
                  InkWell(
                    onTap: () async {

                      context.pop(result: true);
                    },
                    child: _logoutOptionWidget("Yes"),
                  ),
                ],
              ),

              SizedBox(height: 1.h,)
            ],
          ),
        ),
      ],
    );
  }

  Widget _logoutOptionWidget(String title) => Container(
    width: 30.w,
    margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Constants.primaryColor),
            color: title == "No" ? Colors.white : Constants.primaryColor,
            borderRadius: BorderRadius.circular(25)),
        child: Text(
          title,textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: title == "No" ? Colors.black : Colors.white),
        ),
      );
}
