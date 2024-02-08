import 'package:flutter/material.dart';
import 'package:tulip_app/util/extensions.dart';

class FetchLocation extends StatelessWidget {
  const FetchLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Please wait!\nFetching location",textAlign: TextAlign.center,style: TextStyle(
                color: Colors.black,fontSize: 15
            ),),
            SizedBox(height: 1.h),
            const CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
