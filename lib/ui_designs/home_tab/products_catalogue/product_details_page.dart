import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/repo/product_repo.dart';
import 'package:tulip_app/util/extensions.dart';
import 'package:tulip_app/widget/custom_app_bar.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  const ProductDetailPage({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  final CarouselController _controller = CarouselController();
  int _current = 0;


  List<String> items = List.generate(5, (index) => 'Item ${index + 1}');
  PackSizeId? selectedValue;
  Product? productDetails;


  @override
  void initState() {
    super.initState();
    getProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar( title: 'Product Details',implyStatus: true),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),

          productDetails?.productImage !=null && productDetails!.productImage!.isNotEmpty ?
          CarouselSlider(
              items: productDetails?.productImage
                  ?.map((item) => productImageList(item))
                  .toList(),
              options: CarouselOptions(
                aspectRatio: 16/9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
                scrollDirection: Axis.horizontal,
              ),
          ) : const Center(child: CircularProgressIndicator.adaptive(),),

          productDetails?.productImage !=null && productDetails!.productImage!.isNotEmpty ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: productDetails!.productImage!.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == entry.key ? Constants.primaryTextColor : const Color(0xffD9D9D9)),
                ),
              );
            }).toList(),
          ): const Center(child: CircularProgressIndicator.adaptive()),


          Container(
              margin: EdgeInsets.only(left: 7.w,right: 3.w),
              child: Text(productDetails?.productName ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w600
              ),
              )),

          Container(
              margin: EdgeInsets.only(left: 7.w,right: 3.w),
              child: Text(productDetails?.description ?? "")),


          Container(
            margin: EdgeInsets.symmetric(horizontal: 7.w,vertical: 1.h),
            height: 4.h,width: 25.w,
            padding: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: const Color(0xffEFEFEF),
              borderRadius: BorderRadius.circular(3),
            ),

            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                iconEnabledColor: Constants.primaryColor,
                icon: const Icon(Icons.keyboard_arrow_down,size: 16,),
                value: selectedValue,
                items: productDetails?.packSizeIds?.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(item.packSizeName ?? "",style: const TextStyle(
                          fontSize: 13
                      ),),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
              ),
            ),
          ),


        ],
      ),

    );



  }

  Widget productItem()=>Container(
    margin: EdgeInsets.symmetric(horizontal: 3.w,vertical: 0.9.h),

    padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
              color: const Color(0xffC3C3C3)
                  .withOpacity(0.25),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, 1)),
          BoxShadow(
              color: const Color(0xffC3C3C3)
                  .withOpacity(0.25),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, -1)),
        ]),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/menu_icons/profile.png",
          fit: BoxFit.fill,
          height: 9.h,
          width: 9.h,
        ),
        const SizedBox(width: 14),
        Container(
          constraints: BoxConstraints(
            maxWidth: 52.w,
          ),
          child: const Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                "Oximeter",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "Lorem ipsum a the big...",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),


            ],
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: BorderRadius.circular(5)
          ),
          padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 0.7.h),
          child: const Text("View",
            style: TextStyle(
                fontSize: 14,
                color: Colors.white
            ),
          ),
        )

      ],
    ),
  );

  Widget productImageList(item)=>Center(
      child:
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child:  CachedNetworkImage(
          imageUrl: item,
          fit: BoxFit.fill,
          placeholder: (context, url) => const Icon(Icons.image, size: 64,color: Colors.grey), // Show an icon as a placeholder
          errorWidget: (context, url, error) => const Icon(Icons.image, size: 64,color: Colors.grey),
        ),));


  Future<void> getProductDetails() async {
    var response= await ProductRepo.getProductDetails(widget.productId);
    if(response.status){
      if(response.data!=null){
        productDetails=response.data;
        selectedValue=productDetails?.packSizeIds?.first;
        setState(() {

        });
      }

    }
  }

}

