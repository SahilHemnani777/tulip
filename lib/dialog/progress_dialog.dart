import 'package:flutter/material.dart';

class ProgressDialog {
  static BuildContext? _context;
  static showProgressDialog(BuildContext context) {
    _context = context;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return getProgressWidget();
        });
  }

  static popProgressDialog() {
    Navigator.pop(_context!);
  }

  //this widget is being used on other pages also do not remove it
  static getProgressWidget() {
    return Center(child:CircularProgressIndicator.adaptive(),
    );
  }

  static showProgressDialogWithMessage(context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  getProgressWidget(),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(message,
                      style:  const TextStyle(
                          fontSize: 16, color: Colors.white))
                ],
              ),
            ),
          );
        });
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         backgroundColor: Colors.transparent,
    //         child: ,
    //       );
    //     });
  }
}
