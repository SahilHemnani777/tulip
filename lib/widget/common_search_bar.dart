import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class CommonSearchBar extends StatelessWidget {
  final String title;
  final String? filterIcon;
  final VoidCallback? searchButtonCallback;
  final VoidCallback? filterButtonCallback;
  final bool showFilter;

  const CommonSearchBar({Key? key, required this.title, this.filterIcon, this.searchButtonCallback, this.filterButtonCallback, this.showFilter=true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: searchButtonCallback,
            child: CustomTextFormField(
              hintText: title,
              enabled: false,
              hintStyle: const TextStyle(
                  fontSize: 14
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 3,horizontal: 12),
              prefixIcon: Icon(Icons.search,color: Constants.lightGreyColor,size: 20),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Constants.primaryColor),
                  borderRadius: BorderRadius.circular(8)
              ),
              disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Constants.primaryColor),
                  borderRadius: BorderRadius.circular(8)
              ),
            ),
          ),
        ),

        if(showFilter)
        SizedBox(width: 2.w),

        if(showFilter)
        GestureDetector(
          onTap: filterButtonCallback,
          child: Container(
            margin: EdgeInsets.only(left: 2.w),
            padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xffC3C3C3).withOpacity(0.25),
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: const Offset(0,1)
                  ),
                  BoxShadow(
                      color: const Color(0xffC3C3C3).withOpacity(0.25),
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: const Offset(0,-1)
                  ),
                ]
            ),
            child: Image.asset(filterIcon != null ? filterIcon! : "assets/travel_page_icon/filter_icon.png",height: 20,width: 20,color: Constants.primaryColor),
          ),
        )
      ],
    );
  }
}
