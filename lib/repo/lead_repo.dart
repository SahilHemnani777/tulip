import 'package:intl/intl.dart';
import 'package:tulip_app/model/lead_list_model.dart';
import 'package:tulip_app/model/lead_model/follow_up_model.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/util/fetch_util_ext.dart';
import 'package:tulip_app/util/session_manager.dart';

class LeadRepo{

  static Future<SuperResponse<LeadListModel?>> getLeadList(String pageNo, String? query, List<dynamic> status,
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
    var body = await "leads/get-leads?pageNo=$pageNo&limit=10$apiUrl".get();

    if(body['status']) {
      var dataList = body["data"];
      LeadListModel dataObject = LeadListModel.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse<LeadDetails?>> getLeadDetails(String id) async {

    var body = await "leads/get-lead-by-id?leadId=$id".get();

    if(body['status']) {
      var dataList = body["data"];
      LeadDetails dataObject=LeadDetails.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }



  static Future<SuperResponse> createLead( Map<String,dynamic> leadDetails) async {

    var data = await "leads/create-update-lead".post(body: leadDetails);

    if (data['status']) {
      return SuperResponse.fromJson(data, data['data']['_id']);
    } else {
      return SuperResponse.fromJson(data, null);
    }
  }


  static Future<SuperResponse<FollowUpModel?>> getFollowUpList(String pageNo,String leadId) async {


    // String userId = await SessionManager.getuserId();

    var body = await "followups/get-follow-ups?pageNo=$pageNo&limit=10&leadId=$leadId".get();

    if(body['status']) {
      var dataList = body["data"];
      FollowUpModel dataObject = FollowUpModel.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse> createFollowUp( Map<String,dynamic> createFollowUpDetails) async {

    var data = await "followups/create-follow-up".post(body: createFollowUpDetails);

    if (data['status']) {
      return SuperResponse.fromJson(data, data['data']['_id']);
    } else {
      return SuperResponse.fromJson(data, null);
    }
  }

  static Future<SuperResponse> updateFollowUp(Map<String,dynamic> updateFollowUpDetails,String followUpId) async {

    var data = await "followups/$followUpId".put(body: updateFollowUpDetails);

    if (data['status']) {
      return SuperResponse.fromJson(data, data['data']['_id']);
    } else {
      return SuperResponse.fromJson(data, null);
    }
  }

  static Future<SuperResponse> convertToCustomer(String leadId) async {

    var data = await "customers/convert-to-customer?leadId=$leadId".post(body:{});

    if (data['status']) {
      return SuperResponse.fromJson(data, data['data']['_id']);
    } else {
      return SuperResponse.fromJson(data, null);
    }
  }

}