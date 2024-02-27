import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/progress_dialog.dart';
import 'package:tulip_app/model/check_user_exists.dart';
import 'package:tulip_app/repo/login_master.dart';
import 'package:tulip_app/ui_designs/home_tab/menu_pages/dashboard_page.dart';
import 'package:tulip_app/ui_designs/login_pages/otp_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extension/string_ext_util.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/custom_button.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailId = TextEditingController();
  TextEditingController _mobileNumber = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _isPasswordVisible = true;
  bool showPasswordField = false;

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/login_images/login_bg_image.png"),
                  fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 45.h),
              CustomTextFormField(
                margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 3.w),
                controller: _mobileNumber,
                hintText: "Enter Mobile Number",
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: (val) {
                  showPasswordField = false;
                  _password.clear();
                  setState(() {});
                },
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Constants.lightGreyColor,
                ),
                suffixIcon: const Icon(Icons.phone_android),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              CustomTextFormField(
                margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 3.w),
                hintText: "Enter Email-Id",
                controller: _emailId,
                hintStyle:
                    TextStyle(fontSize: 14, color: Constants.lightGreyColor),
                onChanged: (val) {
                  showPasswordField = false;
                  _password.clear();
                  setState(() {});
                },
                suffixIcon: const Icon(Icons.email_outlined),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
              if (showPasswordField)
                CustomTextFormField(
                  margin:
                      EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 3.w),
                  controller: _password,
                  focusNode: _passwordFocusNode,
                  hintText: "Enter Password",
                  hintStyle:
                      TextStyle(fontSize: 14, color: Constants.lightGreyColor),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        _isPasswordVisible = !_isPasswordVisible;
                        setState(() {});
                      },
                      child: !_isPasswordVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off)),
                  obscureText: _isPasswordVisible,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: forgotPasswordClick,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 3.w),
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    )),
              ),
              SizedBox(height: 1.h),
              CustomButton(
                  margin:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  title: showPasswordField ? "Login" : "Next",
                  onTabButtonCallback: validateLogin),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> forgotPasswordClick() async {
    if (_mobileNumber.text.isEmpty) {
      context.showSnackBar("Please enter mobile number", null);
    } else if (_emailId.text.isEmpty) {
      context.showSnackBar("Please enter email address", null);
    } else {
      print("all data there");
      if (await InternetUtil.isInternetConnected()) {
        ProgressDialog.showProgressDialog(context);
        try {
          var response = await LoginMaster.forgotPassword(
              _mobileNumber.text, _emailId.text);
          print("xyzxyz");
          print(response.data);
          if (response.status) {
            Get.back();
            SessionManager.saveUserId(response.data!.id);
            context.showSnackBar("OTP send successfully", null);
            Get.to(() => OTPPage(
                emailId: _emailId.text,
                mobileNumber: _mobileNumber.text,
                fromForgotPassword: true,
                userID: response.data!.id));
          } else {
            Get.back();
            context.showSnackBar(response.message!, null);
          }
        } catch (e) {
          Get.back();
          debugPrint("Error : ${e.toString()}");
        }
      }
    }
  }

  Future<void> sendOTP(String userId) async {
    try {
      var result = await LoginMaster.sendOTP(userId);
      if (result.status) {
        context.showSnackBar("OTP Send Successfully", null);
        SessionManager.saveUserId(result.data);
        Get.back();
        Get.to(
          OTPPage(
            emailId: _emailId.text,
            mobileNumber: _mobileNumber.text,
            fromForgotPassword: false,
            userID: result.data,
          ),
          transition: Transition.fade,
        );
      } else {
        Get.back();
        context.showSnackBar(result.data, null);
      }
    } catch (e) {
      Get.back();
      debugPrint("Exception error is  ::: ${e.toString()}");
    }
  }

  Future<void> validateLogin() async {
    if (_mobileNumber.text.isNotEmpty && _mobileNumber.text.length == 10) {
      if (_emailId.text.isNotEmpty && _emailId.text.validateEmailId()) {
        if (!showPasswordField) {
          checkUserExists();
        } else if (_password.text.isEmpty) {
          context.showSnackBar(
              "Please enter valid password", Constants.primaryColor);
        } else {
          checkUserLogin();
        }
      } else {
        setState(() {
          showPasswordField = false;
        });
        context.showSnackBar(
            "Please enter valid email", Constants.primaryColor);
      }
    } else {
      setState(() {
        showPasswordField = false;
      });
      context.showSnackBar(
          "Please Enter Valid Mobile Number", Constants.primaryColor);
    }
  }

  Future<void> checkUserExists() async {
    if (await InternetUtil.isInternetConnected()) {
      ProgressDialog.showProgressDialog(context);
      // try {
      final value =
          await LoginMaster.checkUserExists(_mobileNumber.text, _emailId.text);
      SessionManager.saveUserId("${value.data?.id}");
      if (value.status) {
        CheckUserExists userData = value.data!;
        if (userData.isPasswordExist == true) {
          context.pop();
          showPasswordField = true;
          _passwordFocusNode.requestFocus();
          setState(() {});
        } else if (userData.isPasswordExist == false) {
          sendOTP(userData.id!);
        }
      } else {
        context.pop();
        setState(() {
          showPasswordField = false;
        });
        context.showSnackBar(value.message!, null);
      }
      // } catch (e) {
      //   context.pop();
      //   context.showSnackBar("Something went wrong try again later",null);
      // }
    } else {
      //no internet
      context.showSnackBar("Please check your internet connection", null);
    }
  }

  Future<void> checkUserLogin() async {
    if (await InternetUtil.isInternetConnected()) {
      ProgressDialog.showProgressDialog(context);
      // try{
      String userId = await SessionManager.getUserId();
      final result = await LoginMaster.checkUserLogin(userId, _password.text);
      //close the progress dialog
      if (result.status) {
        // save usser id in session
        context.pop();
        String? userId = result.data!.userDetails?.id;
        SessionManager.saveUserId(userId.toString());
        debugPrint("This is the userid ${userId.toString()}");
        SessionManager.saveUserLogin();
        context.pushAndRemoveUntil(const DashBoardPage());
        context.showSnackBar("Logged In", null);
      } else {
        context.pop();
        context.showSnackBar("${result.message!}", null);
      }
      // }catch(ex){
      //   close the progress dialog
      // context.pop();
      // context.showSnackBar("Something went wrong$ex",null);
      // print("Something went wrong$ex");
      // }
    } else {
      context.showSnackBar("No internet connection", null);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mobileNumber.dispose();
    _password.dispose();
    _passwordFocusNode.dispose();
  }
}
