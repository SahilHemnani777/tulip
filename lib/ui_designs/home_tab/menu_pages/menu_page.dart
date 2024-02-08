import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/logout_dialog.dart';
import 'package:tulip_app/model/login_data.dart';
import 'package:tulip_app/model/tour_plan_model/daily_plan_report_model.dart';
import 'package:tulip_app/ui_designs/login_pages/login_page.dart';
import 'package:tulip_app/util/connectivity.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:tulip_app/widget/no_internet_widget.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  PackageInfo? _packageInfo;
  UserDetails? userDataInfo;
  bool _isInternetConnected=true;
  StreamSubscription? _subscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addInternetConnectionListener();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isInternetConnected ? Column(
        children: [
          Container(
            height: 15.h,
            decoration: const BoxDecoration(color: Constants.primaryColor),
            padding: EdgeInsets.only(top: 5.h),
            child: Row(
              children: [
                SizedBox(width: 2.w,),
                GestureDetector(
                  onTap: ()=> Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.arrow_back_ios,color: Colors.white),
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      userDataInfo?.userName ?? "Name",textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      userDataInfo?.userDesignation ?? "Designation",
                      textAlign: TextAlign.center,style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic
                    ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text("")
              ],
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          _profileInfoWidget("Personal Mobile No",userDataInfo?.personalMobileNo.toString() ?? "","assets/profile_images/phone.png"),

          _dividerWidget(),

          _profileInfoWidget("Email Address",userDataInfo?.emailId ?? "","assets/profile_images/email.png"),

          _dividerWidget(),

          _profileInfoWidget("Company Mobile No",userDataInfo?.companyMobileNo.toString() ?? "","assets/profile_images/phone.png"),

          _dividerWidget(),

          _profileInfoWidget("Department",userDataInfo?.userDepartment ?? "","assets/profile_images/department.png"),

          _dividerWidget(),

          _profileInfoWidget("Reporting Manager",userDataInfo?.reportingManager ?? "","assets/profile_images/reporting_manager.png"),

         _dividerWidget(),

          ///TODO
          GestureDetector(
              onTap: () async {
                final data = await showDialog(
                    context: context, builder: (_){
                  return const LogoutDialog();
                });

                if(data !=null && data){
                  TourPlan? planId = await SessionManager.getTourPlanId(await SharedPreferences.getInstance());
                  if(planId ==null) {
                    await SessionManager.userLogout();
                    context.pushAndRemoveUntil(const LoginPage());
                  }else{
                    Get.back();
                    context.showSnackBar("Please end the ongoing tour plan to logout", null);
                  }
                }

              },
              child: _profileInfoWidget("","Logout","assets/profile_images/logout.png")),
          _dividerWidget(),

          const Spacer(),
          Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              child: Text(
                "App Version - V ${_packageInfo?.version}",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xff757575),
                ),
              )),
        ],
      )  :
      SizedBox(
          height: 70.h,
          child: const Center(child: NoInternetWidget())),
    );
  }

  Widget _dividerWidget() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 2.w),
    child: const Divider(
      color: Colors.black,
    ),
  );

  Widget _profileInfoWidget(String title,String title1,String imagePath) => Container(
    color: Colors.white,
    child: Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 1.h),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2.91),
                  blurRadius: 18.18,
                  spreadRadius: 0,
                  color: const Color(0xff000000).withOpacity(0.12),
                )
              ]),
          child: Image.asset(
            imagePath,
            height: 3.h,
            width: 5.w,
          ),
        ),
        if(title1!="Logout")
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Color(0xff737373),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title1,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ]),
          ),

        if(title1=="Logout")
          Text(
            title1,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),

      ],
    ),
  );

  Widget bottomSheetButton(String title, String imagePath)=>Container(
    margin: EdgeInsets.only(top: 2.h),
    decoration: const BoxDecoration(
    ),
    child: Column(
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Constants.primaryColor
            ),
            child: Image.asset(imagePath,height: 4.h,width: 8.w,color: Colors.white)),
        const SizedBox(height: 5),
        Text(title,style: const TextStyle(
          fontSize: 15,
        ),),

      ],
    ),
  );




  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
  Future<void> getUserData() async{
    userDataInfo = await SessionManager.getUserData();
    print(jsonEncode(userDataInfo));
    setState(() {});
  }

  void _addInternetConnectionListener() async {
    //if the internet is connected then make the api call
    if (!(await InternetUtil.isInternetConnected())) {
      _listenInternetConnection();
      setState(() {
        _isInternetConnected = false;
      });
    }
    else{
      _initPackageInfo();
      getUserData();
      setState(() {

      });
    }
  }


  void _listenInternetConnection() {
    _subscription = Connectivity().onConnectivityChanged
        .listen((ConnectivityResult result) async {
      // Got a new connectivity status!
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        _subscription?.cancel();
        _initPackageInfo();
        getUserData();
        setState(() {
          _isInternetConnected = true;
        });

      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
