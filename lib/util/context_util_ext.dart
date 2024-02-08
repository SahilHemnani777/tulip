import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';

extension ContextUtil on BuildContext {
  showSnackBar(String text,Color? color) {
    ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
            content: Text(text),
          duration: const Duration(seconds: 2),
          backgroundColor: color ==null ? Constants.primaryColor : color,
        )
    );
  }

  pop({result}) {
    Navigator.pop(this, result);
  }

  Future push(page) {
    log('Navigated to /${page.runtimeType}');
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }

  Future pushAndRemoveUntil(page) {
    log('Navigated to /${page.runtimeType}');
    return Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }
}
