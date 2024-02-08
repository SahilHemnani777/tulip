import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:tulip_app/util/extensions.dart';

class SearchAbleDropdownWidget extends StatelessWidget {
  final List<String> dropdownList;
  final String? selectType;
  final String hintText;
  final String? labelText;
  final double? height;
  final double? width;
  final TextStyle? hintStyle;
  final bool searchAbleDropdown;
  final EdgeInsetsGeometry? contentPadding;

  const SearchAbleDropdownWidget({Key? key, required this.dropdownList, this.selectType, required this.hintText, this.labelText,  this.searchAbleDropdown=true, this.height, this.hintStyle, this.width, this.contentPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 5.5.h,
      width: width,
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
          fit: FlexFit.loose,
          listViewProps: const ListViewProps(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
          ),
          searchFieldProps:  TextFieldProps(
            style: TextStyle(
              fontSize: 14
            ),
              strutStyle: const StrutStyle(
                fontSize: 10,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                isDense: true,
                contentPadding: contentPadding ?? const EdgeInsets.symmetric(
                  horizontal: 10,  // Adjust horizontal padding as needed
                  vertical: 10,   // Adjust vertical padding to change the height
                ),
                focusedErrorBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.10))),
                errorBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.10))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              )
          ),
          showSearchBox: searchAbleDropdown,
          menuProps: const MenuProps(),
          showSelectedItems: true,
        ),
        items: dropdownList,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            isDense: true,
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: labelText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            focusedErrorBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withOpacity(0.10))),
            errorBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withOpacity(0.10))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            hintStyle: hintStyle ?? TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.5)
            ),
          ),
        ),

        onChanged: print,
        selectedItem: selectType,

      ),
    );
  }
}
