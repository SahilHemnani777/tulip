import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tulip_app/constant/constant.dart';
import 'package:tulip_app/model/distributor_model/distributor_products_list.dart';
import 'package:tulip_app/model/distributor_model/distributor_stock_list_model.dart';
import 'package:tulip_app/model/distributor_model/distributors_list.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/util/fetch_util_ext.dart';
import 'package:tulip_app/util/session_manager.dart';
import 'package:http/http.dart' as http;

class DistributorRepo{



  static Future<SuperResponse<List<DistributorList>?>> getDistributorList(String territoryId,String query) async {
    var body = await "dms-purchase/get_distributors?territoryId=$territoryId&keyword=$query".get();

    if(body['status']) {
      Iterable dataList = body["data"];
      List<DistributorList> dataObject = dataList.map((e) => DistributorList.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }



  static Future<SuperResponse<List<DistributorProductList>?>> getDistributorProductList(String distributorId,String query) async {
    var body = await "dms-purchase/get_products_by_distributor_id?distributorId=$distributorId&keyword=$query".get();

    if(body['status']) {
      Iterable dataList = body["data"];
      List<DistributorProductList> dataObject = dataList.map((e) => DistributorProductList.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }

  static Future<SuperResponse<List<DistributorStockItem>?>> getDistributorStockList(String? year, String month) async {
    String userId = await SessionManager.getUserId();
    String apiUrl = "";
    apiUrl += year == "" ? "" : "&year=$year";
    apiUrl += "&userId=$userId";
    apiUrl += month == "" ? "" : "&month=$month";
    var body = await "dms-purchase/get_month_purchases?$apiUrl".get();
    log(jsonEncode(body["data"]));

    print("asdjalshdja ${body["trsNo"]}");
    if(body['status']) {
      Iterable dataList = body["data"];
      List<DistributorStockItem>? dataObject = dataList.map((e) => DistributorStockItem.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }




  static Future<SuperResponse> updateSelectProduct(List<Map<String, dynamic>> dataList) async {

    print(jsonEncode(dataList));
    print("${Constants.baseUrl}dms-purchase/update_sales");

    const apiUrl = '${Constants.baseUrl}dms-purchase/update_sales';
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user?.getIdToken();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode(dataList),
    );

    // Check the status code of the response
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(response.body);

      // Check the status in the response
      if (responseBody['status']) {
        return SuperResponse.fromJson(responseBody, responseBody['status']);
      } else {
        return SuperResponse.fromJson(responseBody, responseBody['status']);
      }

  }

}