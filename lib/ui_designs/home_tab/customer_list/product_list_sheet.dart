import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/repo/customer_repo.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/common_bottom_sheet_products.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class ProductListSheet extends StatefulWidget {
  final String brandId;
  final List<Product>? selectedProducts;
  const ProductListSheet({Key? key, required this.brandId, this.selectedProducts}) : super(key: key);

  @override
  ProductListSheetState createState() => ProductListSheetState();
}

class ProductListSheetState extends State<ProductListSheet> {

  Timer? debounce;
  List<Product>? productList;
  List<Product> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    if(widget.selectedProducts!=null){
      selectedProducts=widget.selectedProducts!;
    // print("Product information 1  :${widget.selectedProducts?[0].toJson()}");
    // print("Product information selected :${widget.selectedProducts?[0].toJson()}");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 2.h),
      child: SizedBox(
        height: 65.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 4.w),
                child:
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.start,
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Add Product",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        print("object");
                        print(jsonEncode(selectedProducts));
                        Navigator.pop(context,selectedProducts);

                      },
                      child: Container(
                          height: 30,
                          width: 55,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Constants.primaryColor, borderRadius: BorderRadius.circular(6)),
                          child: const Text(
                            "Done",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 3.w, vertical:1.h),
              child:
              CustomTextFormField(
                onChanged: (val) {
                  if (debounce != null) {
                    debounce?.cancel(); // Cancel the previous debounce timer if it exists.
                  }
                  debounce = Timer(
                      const Duration(milliseconds: 500),
                          () async {
                        if (val.length >=
                            3) {
                          print("Brand id is  :${widget.brandId}");
                          var response = await CustomerRepo.getProductList("1", val, widget.brandId);
                          if (response.status) {
                            productList = response.data!.docs;
                            setState(() {

                            });
                          }
                        }
                      });
                },
                contentPadding: EdgeInsets.symmetric(
                    vertical:
                    10,
                    horizontal:
                    4.w),
                hintText:
                "Search",
              ),
            ),
            productList != null && productList!.isNotEmpty
                ? Expanded(
                child: ListView.builder(
                    itemCount: productList?.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductListWidget(productItem: productList![index],selectedProduct: selectedProducts);
                    }))
                : Container(alignment: Alignment.center, height: 50.h, child:  Text(productList == null ? "Search Product": "No Data Found")),
          ],
        ),
      ),
    );
  }
}
