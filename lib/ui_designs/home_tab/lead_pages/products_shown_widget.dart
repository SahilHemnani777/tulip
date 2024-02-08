import 'package:flutter/material.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/product_item_widget.dart';

class ProductsShownPage extends StatefulWidget {
  const ProductsShownPage({Key? key}) : super(key: key);

  @override
  _ProductsShownPageState createState() => _ProductsShownPageState();
}

class _ProductsShownPageState extends State<ProductsShownPage> {

  List<String> imageList=[
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
    "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg"

  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _leadTextWidget(
            "Product Shown",
            "",
            ""),


        SizedBox(height: 1.h),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: imageList.length, // Number of items
          itemBuilder: (BuildContext context, int index) {
            return ProductItemWidget();
          },
        ),

      ],
    );
  }



  Widget _leadTextWidget(String title, String date, String time) => Padding(
    padding: EdgeInsets.only(left : 5.w,bottom: 1.h,top: 1.h,right: 4.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title : ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Expanded(child: Text("$date  $time",
          style: const TextStyle(
              fontSize: 13
          ),)),
      ],
    ),
  );

}
