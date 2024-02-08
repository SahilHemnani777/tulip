import 'package:tulip_app/model/category_model/category_list.dart';
import 'package:tulip_app/model/category_model/product_list.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/util/fetch_util_ext.dart';

class ProductRepo{

  static Future<SuperResponse<List<CategoryData>?>> getCustomerDetails() async {

    var body = await "products/get-product-categories".get();

    if(body['status']) {
      Iterable dataList = body["data"];
      List<CategoryData> dataObject=dataList.map((e) => CategoryData.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse<ProductLIst?>> getProductList(String pageNo, String categoryId,String query) async {
    var body = await "products/get-products-by-category-id?keyword=$query&pageNo=$pageNo&limit=10&categoryId=$categoryId".get();

    if(body['status']) {
      var dataList = body["data"];
      ProductLIst dataObject = ProductLIst.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }

  static Future<SuperResponse<Product?>> getProductDetails(String productId) async {
    var body = await "products/get-product-details?productId=$productId".get();

    if(body['status']) {
      var dataList = body["data"];
      Product dataObject = Product.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }






}