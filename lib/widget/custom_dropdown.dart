import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';

class CustomDropdown extends StatelessWidget {
  final List<dynamic> items;
  final dynamic selectedValue;
  final String? labelText;
  final TextStyle? hintStyle;
  final String? hintText;
  final TextStyle? style;
  final String? Function(dynamic)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(dynamic)? onChanged; // Make onChanged nullable

  const CustomDropdown({super.key,
  required this.items,
  this.selectedValue,
  required this.onChanged, this.labelText, this.hintText, this.hintStyle, this.contentPadding, this.style, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
        style: style,
        decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            hintStyle: hintStyle,
            fillColor: Colors.white,
            isDense: true,
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Constants.lightGreyBorderColor)),
            focusedErrorBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: Constants.lightGreyBorderColor)),
            errorBorder:   OutlineInputBorder(
                borderSide: BorderSide(color: Constants.lightGreyBorderColor)),
            focusedBorder:   OutlineInputBorder(
              borderSide: BorderSide(color: Constants.lightGreyBorderColor),
            ),
            disabledBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: Constants.lightGreyBorderColor),
            ) ,
            contentPadding: contentPadding
        ),
        value: selectedValue ?? null,
        validator: validator,
        isExpanded: true,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
