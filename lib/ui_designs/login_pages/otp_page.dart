import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/repo/login_master.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_button.dart';

import 'reset_password_page.dart';

class OTPPage extends StatefulWidget {
  final String emailId;
  final String mobileNumber;
  final String userID;
  final bool fromForgotPassword;

  const OTPPage({
    Key? key,
    required this.emailId,
    required this.mobileNumber, required this.fromForgotPassword, required this.userID,
  }) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> with SingleTickerProviderStateMixin {
  // String _verificationID = "";
  final TextEditingController _otpController = TextEditingController();

  //countdown
  late Timer timer;
  int counter = 45;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    startCounter();

    debugPrint(widget.emailId);
    debugPrint(widget.mobileNumber);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/login_images/login_bg.png"),
              fit: BoxFit.fill),
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            SizedBox(height: 25.h),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Enter OTP sent to your Email ",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              alignment: Alignment.center,
              child: Text(
                "OTP sent to ${widget.emailId}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            PinCodeTextField(
              appContext: context,
              controller: _otpController,
              length: 4,
              //obscureText: true,
              enableActiveFill: true,
              autoDisposeControllers: false,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 60,
                fieldWidth: 60,
                activeColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                inactiveColor: Colors.white,
                disabledColor: Colors.white,
                selectedColor: Colors.white,
                activeFillColor: Colors.white,
              ),
              cursorColor: Constants.primaryColor,
              textStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
              animationDuration: const Duration(milliseconds: 300),
              keyboardType: TextInputType.number,
              boxShadows: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  color: const Color(0xff000000).withOpacity(0.06),
                  blurRadius: 10,
                ),
                BoxShadow(
                  offset: const Offset(0, 4),
                  color: const Color(0xff000000).withOpacity(0.010),
                  blurRadius: 10,
                ),
              ],
              onChanged: (String value) {},
            ),
            Visibility(
              visible: counter == 0, //
              child: InkWell(
                onTap: () {
                  _animationController.stop();
                  if (counter == 0) {
                    resendOTP();
                    startCounter();
                  }
                },
                child: Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Resend OTP? ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color:
                          counter == 0 ? Constants.primaryColor : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            counter < 45 && counter > 0
                ? _animationController.isAnimating
                    ? FadeTransition(
                        opacity: _animationController,
                        child: GestureDetector(
                          onTap: () {
                            startCounter();
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              counter > 9
                                  ? "Resend code in 00:$counter"
                                  : "Resend code in 00:0$counter",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: counter > 9
                                      ? Colors.black
                                      : Colors.redAccent),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          counter > 9
                              ? "Resend code in 00:$counter"
                              : "Resend code in 00:0$counter",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: counter > 9
                                  ? Colors.white
                                  : Colors.redAccent),
                        ),
                      )
                : const SizedBox(height: 0),
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: verifyOTPClick,
              child: const CustomButton(
                title: 'Verify OTP',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startCounter() {
    counter = 45;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter > 0) {
        setState(() {
          counter--;
        });
        if (counter == 9) {
          _animationController.repeat(reverse: true);
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendOTP() async {
    _otpController.clear();
    if (await InternetUtil.isInternetConnected()) {
      ProgressDialog.showProgressDialog(context);
      if(widget.fromForgotPassword){
        var response = await LoginMaster.forgotPassword(widget.mobileNumber,widget.emailId);
        if(response.status){
          Get.back();
          SessionManager.saveUserId(response.data!.id);
          context.showSnackBar("OTP send successfully",null);
        }
        else{
          Get.back();
          context.showSnackBar(response.message!, null);
        }
      }
      else{
        ProgressDialog.showProgressDialog(context);
          var result =
          await LoginMaster.sendOTP(widget.userID);
          if (result.status) {
            Get.back();
            Get.back();
            SessionManager.saveUserId(result.data);
            context.showSnackBar("OTP resend successfully", null);
          } else {
            Get.back();
            context.showSnackBar(result.data, null);
          }
      }
    }
    else {
      context.showSnackBar("Please check your internet connection", null);
    }





    // verifyMobileByOTP();
  }

  Future<void> verifyOTPClick() async {
   if(await InternetUtil.isInternetConnected()){
     ProgressDialog.showProgressDialog(context);
     try{
       var result = await LoginMaster.verifyOTP(_otpController.text,widget.userID);
       if(result.status){
         Get.back();
         String userId=await SessionManager.getUserId();
         Get.to(ResetPasswordPage(userId:userId));
       }
       else{
         Get.back();
         context.showSnackBar(result.message ?? "Something went wrong", null);
       }
     }
     catch(e){
       debugPrint("Error : : ${e.toString()}");
     }
   }
  }


  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _otpController.dispose();
    // if (timer.isActive) {
    //   timer.cancel();
    //   counter = 45;
    // }
  }
}
