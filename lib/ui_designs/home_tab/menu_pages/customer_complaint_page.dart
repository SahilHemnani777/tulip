import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/dialog/common_alert_dialog.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/common_search_bar.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';
import 'package:tulip_app/widget/custom_button.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class CustomerComplaintPage extends StatefulWidget {
  const CustomerComplaintPage({Key? key}) : super(key: key);

  @override
  _CustomerComplaintPageState createState() => _CustomerComplaintPageState();
}

class _CustomerComplaintPageState extends State<CustomerComplaintPage> {
  List<String> items = List.generate(5, (index) => 'Item ${index + 1}');
  String selectedValue = 'Item 1';
  bool isBreakdownSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Create Customer Complaint",
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonSearchBar(
                title: 'Search Customer',
                showFilter: false,
              ),
              SizedBox(height: 1.h),
              _titleFieldWidget("Product"),

              SizedBox(height: 1.h),


              GestureDetector(
                onTap: () {
                  _crewMemberList();
                },
                child: Container(
                  width: 100.w,
                  height: 6.5.h,
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xffC3C3C3).withOpacity(0.25),
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: const Offset(0, 1)),
                        BoxShadow(
                            color: const Color(0xffC3C3C3).withOpacity(0.25),
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: const Offset(0, -1)),
                      ]),
                  child: Row(
                    children: [
                      Text(
                        "Select Products",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5)),
                      ),
                      Spacer(),

                      Icon(Icons.arrow_forward_ios_outlined,size: 16,)
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),


              _titleFieldWidget(" Customer & Product Info"),
              SizedBox(height: 1.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 1.h),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xffC3C3C3).withOpacity(0.25),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: const Offset(0, 1)),
                      BoxShadow(
                          color: const Color(0xffC3C3C3).withOpacity(0.25),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: const Offset(0, -1)),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _informationTextWidget("Name : Pratik Mankar"),
                    _informationTextWidget("Mobile No : 9999888899"),
                    _informationTextWidget("Company Name : Tulip"),
                    _informationTextWidget("Address : Hinjewadi Road"),
                    _informationTextWidget("Nearest HQ : Pune"),
                    _informationTextWidget("GSTIN : ABCD1234"),
                    const Divider(
                      color: Colors.black,
                    ),
                    _informationTextWidget(  "Product Name : Thermometer"),
                    _informationTextWidget("Pack Size : 4"),
                    _informationTextWidget("Purchase Amount : 1000"),
                    _informationTextWidget("Product Purchase Date : 09/09/2022"),
                    _informationTextWidget("Product Warranty : 1 Year"),
                    _informationTextWidget("Warranty Status : Active"),
                    _informationTextWidget("REM Free Services : 5 month"),
                    _informationTextWidget("Free Breakdown Calls : 2"),
                    _informationTextWidget("Old Complaint Status : "),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              
              _titleFieldWidget("Complaint Type"),
              
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xffC3C3C3).withOpacity(0.25),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: const Offset(0, 1)),
                      BoxShadow(
                          color: const Color(0xffC3C3C3).withOpacity(0.25),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: const Offset(0, -1)),
                    ]),
                margin: EdgeInsets.symmetric(vertical: 1.h,horizontal: 0.5.w),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTileTheme(
                        horizontalTitleGap: 0,
                        child: RadioListTile(
                          value: true,
                          groupValue: isBreakdownSelected,
                          onChanged: (val) {
                            isBreakdownSelected = val!;
                            setState(() {
                            });
                          },
                          title: const Text("Breakdown",
                          style: TextStyle(
                            fontSize: 13
                          ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTileTheme(
                        horizontalTitleGap: 0,
                        child: RadioListTile(
                          value: false,
                          groupValue: isBreakdownSelected,
                          onChanged: (val) {
                            isBreakdownSelected = val!;
                            setState(() {
                            });

                          },
                          title: const Text("Maintenance",
                          style: TextStyle(
                            fontSize: 13
                          ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 1.h),

              const CustomTextFormField(
                hintText: "Complaint Description",
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
                maxLines: 4,
              ),
               CustomButton(title: "Create Complaint",
              onTabButtonCallback: (){
                showDialog(context: context, builder: (context){
                  return const CommonDialog(title: 'Alert', message: 'Are you certain about proceeding with this complaint?',
                    positiveButtonText: 'Yes', negativeButtonText: 'No',);
                });
              },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleFieldWidget(String title) => Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
      );

  Widget _informationTextWidget(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Text("$title "),
    );
  }

  Future<void> _crewMemberList() async {
    await showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SizedBox(
                    height: 55.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.all(2.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Add Product",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      height: 30,
                                      width: 55,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Constants.primaryColor,
                                          borderRadius: BorderRadius.circular(6)),
                                      child: const Text(
                                        "Done",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ],
                            )),
                        Expanded(
                            child: ListView.builder(
                                itemCount: 14,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return _showProductWidget();
                                })),
                      ],
                    ),
                  ),
                );
              });
        });
    setState(() {});
  }
  Widget _showProductWidget()=>Container(
    margin: EdgeInsets.only(
        left: 3.w,
        top: 0.5.h,
        right: 2.w,
        bottom: 0.5.h
    ),
    padding: EdgeInsets.only(
        left: 2.w,
        top: 0.5.h,
        right: 1.w,
        bottom: 0.5.h),
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
        const SizedBox(width: 8),
        SizedBox(
          width: 55.w,
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                "Oximeter",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              const Text(
                "Lorem ipsum a the big...",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),


              Container(
                height: 3.h,width: 20.w,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  color: const Color(0xffEFEFEF),
                  borderRadius: BorderRadius.circular(3),
                ),

                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item,style: const TextStyle(
                            fontSize: 11
                        ),),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    ),
  );


}
