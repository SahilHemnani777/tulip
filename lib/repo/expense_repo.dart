
import 'package:intl/intl.dart';
import 'package:tulip_app/model/expense_model/expense_details_list.dart';
import 'package:tulip_app/model/expense_model/expense_list_model.dart';
import 'package:tulip_app/model/expense_model/setting_model.dart';
import 'package:tulip_app/model/login_data.dart';
import 'package:tulip_app/model/super_response.dart';
import 'package:tulip_app/util/fetch_util_ext.dart';
import 'package:tulip_app/util/session_manager.dart';

class ExpenseRepo{



  static Future<SuperResponse<List<ExpenseList>?>> getExpenseList(List<dynamic> status,
      String year) async {

    String userId = await SessionManager.getUserId();

    String apiUrl = "";
    apiUrl += status.isEmpty ? "" : "&status=${status.join(',')}";
    apiUrl += "&userId=$userId";
    apiUrl += "&year=$year";

    var body = await "expenses/get_expenses?$apiUrl".get();

    if(body['status']) {
      Iterable dataList = body["data"];
      List<ExpenseList> dataObject = dataList.map((e) => ExpenseList.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }



  static Future<SuperResponse<List<ExpenseDetailsList>?>> getExpenseDetailsList(String expenseId) async {
    String userId = await SessionManager.getUserId();
    var body = await "expenses/get_expense_logs?userId=$userId&expenseId=$expenseId".get();
    if(body['status']) {
      Iterable dataList = body["data"];
      List<ExpenseDetailsList> dataObject = dataList.map((e) => ExpenseDetailsList.fromJson(e)).toList();
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }



  static Future<SuperResponse> updateExpense(Map<String,dynamic> expense) async {
    var body = await "expenses/update_expense_total".post(body: expense);
    if(body['status']) {
      return SuperResponse.fromJson(body, body['status']);
    }
    else{
      return SuperResponse.fromJson(body, body['status']);
    }
  }




  static Future<SuperResponse<SettingDetails?>> getSettingDetails() async {

    var body = await "api/settings".get();

    if(body['status']) {
      Iterable dataList = body["data"];
      SettingDetails dataObject = SettingDetails.fromJson(dataList.first);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }

  static Future<SuperResponse<SettingDetails?>> getExpenseDataCalculation() async {
    UserDetails userData= await SessionManager.getUserData();
    String? designationId = userData.userDesignationId;
    String userId=await SessionManager.getUserId();
    var body = await "api/designations/details?designationId=$designationId&userId=$userId".get();

    if(body['status']) {
      var dataList = body["data"];
      SettingDetails dataObject = SettingDetails.fromJson(dataList);
      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }


  static Future<SuperResponse<List<StandardFareChart>?>> getAddress(DateTime date) async {
    String userId = await SessionManager.getUserId();

    String tourPlanVisitDate = DateFormat('yyyy-MM-dd').format(date);

    var body = await "dcr/get_sfc?date=$tourPlanVisitDate&userId=$userId".get();

    if(body['status']) {
      Iterable dataList = body["data"];
      List<StandardFareChart> dataObject=dataList.map((e) => StandardFareChart.fromJson(e)).toList();

      return SuperResponse.fromJson(body, dataObject);
    }
    else{
      return SuperResponse.fromJson(body, null);
    }
  }



  static Future<SuperResponse> addFileExpense(Map<String,dynamic> reqBody) async {

    var body = await "expenses/addExpenses".post(body : reqBody);

    if(body['status']) {
      return SuperResponse.fromJson(body, body['status']);
    }
    else{
      return SuperResponse.fromJson(body, body['message']);
    }
  }

}

