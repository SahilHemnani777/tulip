import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/customer_model/competitor_model.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/repo/customer_repo.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_textformfield.dart';

class ProductListWidget extends StatefulWidget {
  final Product productItem;
  final List<Product> selectedProduct;
  const ProductListWidget({super.key, required this.productItem, required this.selectedProduct});

  @override
  ProductListWidgetState createState() => ProductListWidgetState();
}

class ProductListWidgetState extends State<ProductListWidget> {
  PackSizeId? selectedPackSize;
  Competitor? selectedCompetitor;
  bool productSelected=false;
  bool showError = false;
  List<Competitor>? competitorList;
  late Product product;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    product=Product.fromJson(widget.productItem.toJson());
    getCompetitorList();
    // Check if the selectedProduct list already contains this product
    if (widget.selectedProduct.any((element) => element.id == product.id)) {
      productSelected = true;
      var response = widget.selectedProduct.firstWhere((element) => element.id == product.id);
      print("Product information response = ${response.toJson()}");
      selectedPackSize=widget.productItem.packSizeIds?.firstWhere((element) => element.id == response.selectedPackSizeId);
      product=Product.fromJson(response.toJson());
      print("Selected pack sized id : ${selectedPackSize?.id}");
      response.packSizeIds?.forEach((element) {
        print("Packsize id ${element.id}");
      });

      print("Product information product = ${product.toJson()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 3.w, top: 0.5.h, right: 2.w, bottom: 0.5.h),
            padding: EdgeInsets.only(left: 2.w, top: 1.h, right: 1.w, bottom: 0.5.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffC3C3C3).withOpacity(0.25),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: const Offset(0, 1),
                ),
                BoxShadow(
                  color: const Color(0xffC3C3C3).withOpacity(0.25),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    CachedNetworkImage(
                      imageUrl: widget.productItem.productImage?.first ?? "",
                      fit: BoxFit.fill,
                      height: 9.h,
                      width: 9.h,
                      placeholder: (context, url) => const Icon(Icons.image, size: 64,color: Colors.grey), // Show an icon as a placeholder
                      errorWidget: (context, url, error) => const Icon(Icons.image, size: 64,color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 55.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productItem.productName ?? "",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.productItem.description ?? "",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),

                          Container(
                            height: 4.h,
                            width: 25.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffEFEFEF),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  isDense: true,
                                  hintText: "Select Pack",
                                  hintStyle: TextStyle(
                                    fontSize: 12
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                                ),
                                iconEnabledColor: Constants.primaryColor,
                                icon: const Icon(Icons.keyboard_arrow_down, size: 16,color: Colors.black,),
                                value: selectedPackSize,
                                items: widget.productItem.packSizeIds?.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        item.packSizeName ?? "",
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                    setState(() {
                                      selectedPackSize = newValue!;
                                      print("NEw value ${newValue.id}");
                                      print("selected pack ${selectedPackSize?.id}");
                                      product.selectedPackSizeId=selectedPackSize?.id;
                                      widget.selectedProduct.removeWhere((element) => element.id==product.id);
                                      widget.selectedProduct.add(product);
                                    });
                                },
                              ),
                            ),
                          ),

                          if(showError)
                          Text("Select pack size",style: TextStyle(fontSize: 10,color: Colors.red),)

                        ],
                      ),
                    ),

                    const Spacer(),

                    Checkbox(value: productSelected, onChanged: (val){
                     if(_formKey.currentState!.validate() && selectedPackSize !=null){
                       _formKey.currentState?.save();
                       productSelected=val!;
                       if (val) {
                         // If the product is selected, add it to the selectedProducts list
                         if(!widget.selectedProduct.any((element) => element.id == product.id)) {
                           widget.selectedProduct.add(product);
                         }
                         print(widget.selectedProduct);
                       } else {
                         // If the product is deselected, remove it from the selectedProducts list
                         widget.selectedProduct.removeWhere((element) => element.id==product.id);
                         print(widget.selectedProduct);
                       }
                       showError=false;
                       setState(() {});
                     }
                     else{
                       context.showSnackBar("Please enter all details",null);
                       showError=true;
                       setState(() {
                         _autoValidateMode = AutovalidateMode.onUserInteraction;
                       });
                     }
                    }),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 10.h
                  ),
                  margin: EdgeInsets.only(right: 4.w,top: 1.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField(
                              value: selectedCompetitor,
                              decoration: InputDecoration(
                                labelText: "Competitor",
                                hintText: "Select Competitor",
                                isDense: true,
                                errorStyle: const TextStyle(
                                  fontSize: 10
                                ),
                                labelStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                hintStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                errorBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black.withOpacity(0.10),
                                  ),
                                    borderRadius: BorderRadius.circular(3),
                                ),
                                enabledBorder:   OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
                                  borderRadius: BorderRadius.circular(3),

                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
                                  borderRadius: BorderRadius.circular(3),
                                ) ,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                              ),
                              validator: (val){
                                if(val !=null){
                                  return null;
                                }
                                else{
                                  return "Select Competitor";
                                }
                              },
                              items: competitorList?.map((Competitor item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item.competitorName ?? "",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  // selectedCompetitor = newValue!;
                                  product.competitorId=newValue?.id;
                                  product.competitor=newValue?.competitorName;
                                  print(product.competitorId);
                                  print(product.competitor);

                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                       Expanded(
                        child: CustomTextFormField(
                            hintText: "Enter potential",
                            labelText: "Potential",
                          contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                          initialValue: product.competitor,
                          onChanged: (val){
                              product.potential=val;
                          },
                          validator: (val){
                            if(val!=null && val.isNotEmpty){
                              return null;
                            }
                            else{
                              return "Enter potential";
                            }
                          },
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getCompetitorList() async {
    var response = await CustomerRepo.getCompetitorList();
    if(response.status){
      competitorList=response.data!;
      if(competitorList!.any((element) => element.id == product.competitorId)){
        var data = competitorList?.firstWhere((element) => element.id == product.competitorId);
        selectedCompetitor=data;
        setState(() {
        });
      }

    }
  }
}
