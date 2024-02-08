import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:tulip_app/model/dcr_model/dcr_list_model.dart';
import 'package:tulip_app/model/dcr_model/dcr_log_report.dart';
import 'package:tulip_app/model/dcr_model/dcr_reports.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/model/tour_plan_model/daily_plan_report_model.dart';
import 'package:tulip_app/util/fetch_util_ext.dart';
import 'package:tulip_app/util/session_manager.dart';

class DCRRepo{


  static Future<SuperResponse> addDCRReport(Map<String, dynamic> reportData) async {

    var body = await "dcr_logs/create_update_dcr_log".post(body: reportData);

    log("data is here :${jsonEncode(body)}");
    if(body['status']) {
      return SuperResponse.fromJson(body,  body['data']['dcrId']);
    }
    else{
      return SuperResponse.fromJson(body, body['message']);
    }
  }

  static Future<SuperResponse<List<DCRLogReportsModel>?>> getDCRLogReport(String tourPlanId) async {


    String userId = await SessionManager.getUserId();

    var body = await "dcr_logs/get_dcr_log?userId=$userId&tourPlanVisitId=$tourPlanId".get();

    if(body['status']) {
      Iterable dataList = body["data"];
      List<DCRLogReportsModel> dataObject = dataList.map((e) => DCRLogReportsModel.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse<List<TourPlan>?>> getVisitedAreaList(DateTime date) async {

    String dateFormatted = DateFormat('yyyy-MM-dd').format(date);

    String userId = await SessionManager.getUserId();

    var body = await "dcr_logs/getVisits?date=$dateFormatted&userId=$userId".get();

    if(body['status']) {
      Iterable dataList = body["data"];
      List<TourPlan> dataObject = dataList.map((e) => TourPlan.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse<DCRReport?>> getDCRLogDetails(String dcrLogId) async {



    var body = await "dcr_logs/get_dcr_log_details?dcrLogId=$dcrLogId".get();

    if(body['status']) {
      var dataList = body["data"];
      DCRReport dataObject = DCRReport.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }

  static Future<SuperResponse<DCRModel?>> getDCRList(String pageNo, String? query, List<dynamic> status,
      DateTime? fromDate,DateTime? toDate) async {
    String? from;
    String? to;
    if(fromDate!=null && toDate!=null) {
      from = DateFormat('yyyy-MM-dd').format(fromDate);
      to = DateFormat('yyyy-MM-dd').format(toDate);
    }
    String userId = await SessionManager.getUserId();

    String apiUrl = "";
    apiUrl += status.isEmpty ? "" : "&status=${status.join(',')}";
    apiUrl += "&userId=$userId";
    apiUrl += query =="" ? "" : "&keyword=$query";
    if (from != null) {
      apiUrl += "&fromDate=$from";
    }
    if (to != null) {
      apiUrl += "&toDate=$to";
    }

    var body = await "dcr/get_dcr?pageNo=1&limit=10$apiUrl".get();

    if(body['status']) {
      var dataList = body["data"];
      DCRModel dataObject = DCRModel.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }



  static Future<SuperResponse<bool?>> deleteDCR(String dcrId) async {

    var body = await "dcr_logs/$dcrId".delete();

    log("data is here :${jsonEncode(body)}");
    if(body['status']) {
      return SuperResponse.fromJson(body,body['status']);
    }
    else{
      return SuperResponse.fromJson(body, body['status']);
    }


  }

}

