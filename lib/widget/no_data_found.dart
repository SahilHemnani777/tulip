import 'package:flutter/material.dart';

class NoDataFound extends StatelessWidget {

  final String? title;
  final String? image;
  const NoDataFound({Key? key, this.title,this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.asset(image??"assets/error_image/no_data.png", width: 180, height: 180),
        const SizedBox(height: 12),
        Text(title ?? "No data found", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
