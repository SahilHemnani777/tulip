import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.asset("assets/error_image/no_internet.png", width: 180, height: 180),
        const SizedBox(height: 12),
        const Text("No internet connection",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
