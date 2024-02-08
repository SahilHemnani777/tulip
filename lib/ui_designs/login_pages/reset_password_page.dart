import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/repo/login_master.dart';
import 'package:tulip_app/ui_designs/home_tab/menu_pages/dashboard_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_button.dart';

class ResetPasswordPage extends StatefulWidget {
  // final String mobileNumber;
  final String userId;
  const ResetPasswordPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: const Icon(Icons.arrow_back_ios,color: Colors.white,)),
            SizedBox(height: 15.h),

            const Align(
              alignment: Alignment.center,
              child: Text(
                "Reset Password",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric( vertical: 3.h),
              child: const Text(
                "Set your new password so you can Login and access your account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),


            Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "New Password",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                )),
            TextFormField(
              controller: _passwordController,
              obscureText: !isPasswordVisible ? true : false,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                border: InputBorder.none,
                filled: true,
                fillColor: const Color(0xffFFFFFF),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder:const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                disabledBorder:const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ) ,
                hintText: "Enter your password",
                hintStyle: TextStyle(
                  color: Constants.lightGreyColor,
                    fontSize: 14
                ),
                isDense: false,
                prefixIcon:  Icon(Icons.lock,
                    size: 20, color: Constants.lightGreyColor),
                suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    child: !isPasswordVisible
                        ?  Icon(Icons.visibility,
                            size: 20, color: Constants.lightGreyColor)
                        :  Icon(Icons.visibility_off,
                            size: 20, color: Constants.lightGreyColor)),
              ),
            ),

            SizedBox(height: 2.h),

            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                child: const Text(
                  "Confirm New Password",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                )),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !isConfirmPasswordVisible ? true : false,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                filled: true,
                fillColor: const Color(0xffFFFFFF),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder:const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                disabledBorder:const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ) ,
                hintText: "Confirm your password",
                hintStyle: TextStyle(
                  color: Constants.lightGreyColor,
                  fontSize: 14
                ),
                isDense: false,
                prefixIcon: Icon(Icons.lock,
                    size: 20, color: Constants.lightGreyColor),
                suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                    child: isConfirmPasswordVisible
                        ? Icon(Icons.visibility_off,
                            size: 20, color: Constants.lightGreyColor)
                        : Icon(Icons.visibility,
                            size: 20, color: Constants.lightGreyColor)),
              ),
            ),

            SizedBox(height: 2.h),

            CustomButton(title: "Reset Password",onTabButtonCallback: passwordReset,)
          ],
        ),
      ),
    );
  }



  void passwordReset() {
    if (_passwordController.text.isEmpty || _passwordController.text == "") {
      context.showSnackBar("Please enter new password",null);
    } else if (_passwordController.text.length < 6) {
      context.showSnackBar("Password should be minimum 6 characters",null);
      _confirmPasswordController.clear();
    } else if (_confirmPasswordController.text.isEmpty ||
        _confirmPasswordController.text == "") {
      context.showSnackBar("Please enter confirm password",null);
    } else if (_passwordController.text != _confirmPasswordController.text) {
      context.showSnackBar("Password does not match",null);
    } else if (_passwordController.text == _confirmPasswordController.text) {
      //reset password
      resetPassword();
    }
  }

  Future<void> resetPassword() async {
    if (await InternetUtil.isInternetConnected()) {
      //dialog
      ProgressDialog.showProgressDialog(context);

      try {

        final result = await LoginMaster.resetPassword(widget.userId,_passwordController.text);

        //close dialog
        context.pop();
        if (result.status) {
          context.pop();
          SessionManager.saveUserLogin();
          context.pushAndRemoveUntil(const DashBoardPage());
          context.showSnackBar("Password updatated successfully",Colors.green);
        } else {
          context.showSnackBar(result.message!,null);
        }
      } catch (e) {
        // close the progress dialog
        context.pop();
        context.showSnackBar(e.toString(),null);
      }
    } else {
      context.showSnackBar("Please check your internet connection",null);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }
}
