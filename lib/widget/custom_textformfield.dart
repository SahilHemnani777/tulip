import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tulip_app/util/extensions.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextStyle? style;
  final Widget? suffixIcon;
  final int? maxLength;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final FocusNode? focusNode;
  final InputBorder? disabledBorder;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool? enabled;
  final bool readOnly;
  final double? width;
  final double? height;
  final bool autofocus;
  final String? errorText;
  final TextAlign? textAlign;
  final String? prefixText;
  final BoxDecoration? boxDecoration;
  final EdgeInsetsGeometry? margin;
  final Function()? onTap;
  const CustomTextFormField(
      {Key? key,
      this.hintText,
      this.contentPadding,
      this.maxLines,
      this.controller,
      this.prefixIcon,
      this.obscureText = false,
      this.suffixIcon,
      this.border,
      this.focusedBorder,
      this.enabledBorder,
      this.inputFormatters,
      this.keyboardType,
      this.maxLength,
      this.validator,
      this.textCapitalization = TextCapitalization.none,
      this.textInputAction,
      this.onSaved,
      this.initialValue,
      this.onChanged,
      this.labelText,
      this.labelStyle,
      this.hintStyle,
      this.enabled,
      this.readOnly = false,
      this.prefixText,
      this.disabledBorder,
      this.boxDecoration,
      this.margin,
      this.width,
      this.height,
      this.style,
      this.onTap,
      this.autofocus = false,
      this.focusNode,
      this.textAlign, this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height ?? (maxLines == null ? 5.5.h : null),
      width: width,
      decoration: boxDecoration ?? const BoxDecoration(),
      margin: margin ?? EdgeInsets.symmetric(vertical: 1.h),

      child: TextFormField(
        onTap: onTap,
        textAlign: textAlign ?? TextAlign.start,
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines ?? 1,
        initialValue: initialValue,
        onChanged: onChanged,
        focusNode: focusNode,
        enabled: enabled,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction ?? TextInputAction.next,
        textCapitalization: textCapitalization,
        validator: validator,
        onSaved: onSaved,
        readOnly: readOnly,
        autofocus: autofocus,
        style: style ??
            const TextStyle(
              color: Colors.black,
            ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isDense: true,
          fillColor: Colors.white,
          filled: true,
          prefix: prefixText != null
              ? Text(
                  prefixText!,
                )
              : null,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: hintText,
          counterText: "",
          errorText: errorText,
          hintStyle: hintStyle ?? const TextStyle(fontSize: 13),
          labelStyle: labelStyle,
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: border ?? InputBorder.none,
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black.withOpacity(0.10))),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black.withOpacity(0.10))),
          focusedBorder: focusedBorder ??
              OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
              ),
          enabledBorder: enabledBorder ??
              OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
              ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
          ),
          errorStyle: const TextStyle(height: 0.6),
        ),
        maxLength: maxLength,
      ),
    );
  }
}
