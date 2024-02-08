import 'package:tulip_app/model/customer_model/brand_model.dart';
import 'package:tulip_app/model/customer_model/competitor_model.dart';
import 'package:tulip_app/model/customer_model/customer_list_model.dart';
import 'package:tulip_app/model/customer_model/get_area_model.dart';
import 'package:tulip_app/model/customer_model/product_model.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/util/fetch_util_ext.dart';
import 'package:tulip_app/util/session_manager.dart';

  class CustomerRepo{

  static Future<SuperResponse<CustomerList?>> getCustomerList(String pageNo, String? query, String townId,String customerTypeId,) async {
    String userId = await SessionManager.getUserId();
    String apiUrl = "";
    apiUrl += townId == "" ? "" : "&townId=$townId";
    apiUrl += "&userId=$userId";
    apiUrl += customerTypeId == "" ? "" : "&customerTypeId=$customerTypeId";
    var body = await "customers/get-customers?keyword=$query&pageNo=$pageNo&limit=10$apiUrl".get();

    if(body['status']) {
      var dataList = body["data"];
      CustomerList dataObject = CustomerList.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse<AreaList?>> getAreaList(String pageNo, String? query) async {
    var body = await "towns/get-towns?keyword=$query&pageNo=$pageNo&limit=10".get();

    if(body['status']) {
      var dataList = body["data"];
      AreaList dataObject = AreaList.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }

  static Future<SuperResponse<BrandList?>> getBrandList(String pageNo, String? query,) async {

    var body = await "product-brand/get-product-brands?keyword=$query&pageNo=$pageNo&limit=10".get();

    if(body['status']) {
      var dataList = body["data"];
      BrandList dataObject = BrandList.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse<ProductItemList?>> getProductList(String pageNo, String? query,String brandId) async {

    var body = await "products/get-products-by-brand-id?keyword=$query&pageNo=$pageNo&limit=100&brandId=$brandId".get();

    if(body['status']) {
      var dataList = body["data"];
      ProductItemList dataObject = ProductItemList.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse<List<CustomerTypeId>?>> getCustomerTypeList() async {

    var body = await "customer-type/get-customer-type".get();

    if(body['status']) {
      Iterable dataList = body["data"];
      List<CustomerTypeId> dataObject=dataList.map((e) => CustomerTypeId.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }

  static Future<SuperResponse<List<Competitor>?>> getCompetitorList() async {

    var body = await "competitors/get-competitors".get();

    if(body['status']) {
      Iterable dataList = body["data"];
      List<Competitor> dataObject=dataList.map((e) => Competitor.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }

  static Future<SuperResponse<LeadDetails?>> getCustomerDetails(String id) async {

    var body = await "customers/get-customer-by-id?customerId=$id".get();

    if(body['status']) {
      var dataList = body["data"];
      LeadDetails dataObject=LeadDetails.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }



  static Future<SuperResponse> createCustomer( Map<String,dynamic> customerDetails) async {

    var data = await "customers/create-update-customer".post(body: customerDetails);

    if (data['status']) {
      return SuperResponse.fromJson(data, data['data']['_id']);
    } else {
      return SuperResponse.fromJson(data, null);
    }
  }


}