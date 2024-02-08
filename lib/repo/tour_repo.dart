import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/model/tour_plan_model/daily_plan_report_model.dart';
import 'package:tulip_app/model/tour_plan_model/tour_plan_list_model.dart';
import 'package:tulip_app/util/fetch_util_ext.dart';
import 'package:tulip_app/util/session_manager.dart';

class TourMasterRepo{
  static Future<SuperResponse<List<TourPlanList>?>> getTourPlanList(String year,List<dynamic> status) async {

    String userId = await SessionManager.getUserId();

    String apiUrl = "";
    apiUrl += "&year=$year";
    apiUrl += "&userId=$userId";
    apiUrl += status.isEmpty ? "" : "&status=${status.join(',')}";

    var body = await "tour-plan/get-tour-plans?$apiUrl".get();

    if(body['status']) {
      Iterable dataList = body["data"];
      List<TourPlanList>? dataObject = dataList.map((e) => TourPlanList.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse<List<DailyTourPlanListModel>?>> getDailyTourPlanList(String tourPlanId,
      DateTime? date) async {
    String? ddate;
    if(date!=null) {
      ddate = DateFormat('yyyy/MM/dd').format(date);
    }
    String userId = await SessionManager.getUserId();

    String apiUrl = "";
    apiUrl += "&tourPlanId=$tourPlanId";
    apiUrl += "&date=$ddate";
    apiUrl += "&userId=$userId";

    var body = await "tour-plan-visit/get_tour_plan_visit_by_tour_plan_id?$apiUrl".get();

    log("data is here :${jsonEncode(body)}");
    if(body['status']) {
      Iterable dataList = body["data"];
      List<DailyTourPlanListModel>? dataObject = dataList.map((e) => DailyTourPlanListModel.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse<List<ActivityTypeData>?>> getActivityType() async {
    var body = await "activity-type/get-activity-type".get();

    log("data is here :${jsonEncode(body)}");
    if(body['status']) {
      Iterable dataList = body["data"];
      List<ActivityTypeData>? dataObject = dataList.map((e) => ActivityTypeData.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }



  static Future<SuperResponse<List<TourPlan>?>> getTourPlanListByUserId(String tourPlanId,DateTime date) async {
    String? ddate;
    String userId = await SessionManager.getUserId();
    ddate = DateFormat('yyyy/MM/dd').format(date);


    String apiUrl = "";
    apiUrl += "tourPlanId=$tourPlanId";
    apiUrl += "&date=${ddate.replaceAll("/", "-")}";
    apiUrl += "&userId=$userId";
    var body = await "tour-plan-visit/get-tour-plan-visit?$apiUrl".get();



    log("data is here :${jsonEncode(body)}");
    if(body['status'] && body["data"]!=null) {
      Iterable dataList = body["data"]['tourPlan'];
      List<TourPlan>? dataObject = dataList.map((e) => TourPlan.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse> sendForApproval(Map<String, dynamic> approvalData) async {

    var body = await "tour-plan/create-update-tour-plan".post(body: approvalData);

    log("data is here :${jsonEncode(body)}");
    if(body['status']) {
      return SuperResponse.fromJson(body, body['status']);
    }
    else{
      return SuperResponse.fromJson(body, body['message']);
    }
  }

  static Future<SuperResponse> addLeave(Map<String, dynamic> leaveData) async {

    var body = await "leaves/create_update_leave".post(body: leaveData);

    log("data is here :${jsonEncode(body)}");
    if(body['status']) {
      return SuperResponse.fromJson(body, body['status']);
    }
    else{
      return SuperResponse.fromJson(body, body['message']);
    }
  }


  static Future<SuperResponse> updateTourPlanStatus(Map<String, dynamic> updateTourPlanBody) async {

    var body = await "tour-plan-visit/update_visit_status".post(body: updateTourPlanBody);

    log("data is here :${jsonEncode(body)}");
    if(body['status']) {
      return SuperResponse.fromJson(body, body['status']);
    }
    else{
      return SuperResponse.fromJson(body, body['message']);
    }
  }


  static Future<SuperResponse> addUpdateTourPlan(Map<String, dynamic> tourPlan) async {


    var body = await "tour-plan-visit/create-update-tour-plan-visit".post(body: tourPlan);

    log("data is here :${jsonEncode(body)}");
    if(body['status']) {
      return SuperResponse.fromJson(body, body['data']['tourPlanId']);
    }
    else{
      return SuperResponse.fromJson(body, body['message']);
    }
  }


  static Future<SuperResponse> addUpdateYearTourPlan(Map<String, dynamic> tourPlan) async {


    var body = await "tour-plan/create-update-tour-plan".post(body: tourPlan);

    log("data is here :${jsonEncode(body)}");
    if(body['status']) {
      return SuperResponse.fromJson(body, body['data']);
    }
    else{
      return SuperResponse.fromJson(body, body['message']);
    }
  }

  static Future<SuperResponse<bool?>> deleteData(String tourPlanId) async {

    var body = await "tour-plan-visit/$tourPlanId".delete();

    log("data is here :${jsonEncode(body)}");
    if(body['status']) {
      return SuperResponse.fromJson(body,body['status']);
    }
    else{
      return SuperResponse.fromJson(body, body['status']);
    }


  }


}
