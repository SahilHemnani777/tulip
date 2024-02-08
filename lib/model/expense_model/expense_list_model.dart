
import 'package:tulip_app/model/dcr_model/dcr_list_model.dart';

class ExpenseList {
  String id;
  String? status;
  bool? paymentStatus;
  String? notes;
  DateTime? createdAt;
  String? requestedTo;
  DCRListModel? dcrData;
  double? totalFare;
  double? totalHq;
  DateTime? tourPlanDate;
  double? totalExHq;
  double? grandTotal;
  double? totalOs;
  double? totalMisc;
  double? entertainment;
  double? mobileReimbursement;

  ExpenseList({
    required this.id,
    this.status,
    this.paymentStatus,
    this.notes,
    this.dcrData,
    this.createdAt,
    this.requestedTo,
    this.totalFare,
    this.tourPlanDate,
    this.grandTotal,
    this.totalHq,
    this.totalExHq,
    this.totalOs,
    this.totalMisc,
    this.entertainment,
    this.mobileReimbursement,
  });

  factory ExpenseList.fromJson(Map<String, dynamic> json) => ExpenseList(
    id: json["_id"],
    status: json["status"],
    paymentStatus: json["paymentStatus"],
    notes: json["notes"],
    tourPlanDate: json["tourPlanDate"] == null ? null : DateTime.parse(json["tourPlanDate"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    requestedTo: json["requestedTo"],
    dcrData: json["dcrData"] == null ? null : DCRListModel.fromJson(json["dcrData"]),
    totalFare: json["totalFare"] != null ? json["totalFare"].toDouble() ?? 0.0 : 0.0,
    totalHq:  json["totalHq"] != null ? json["totalHq"].toDouble() ?? 0.0 : 0,
    totalExHq: json["totalExHq"] != null ? json["totalExHq"].toDouble() ?? 0.0 : 0,
    totalOs: json["totalOs"] != null ? json["totalOs"].toDouble() ?? 0.0 : 0,
    grandTotal: json["grandTotal"] != null ? json["grandTotal"].toDouble() ?? 0.0 : 0,
    totalMisc: json["totalMisc"] != null ? json["totalMisc"].toDouble() ?? 0.0 : 0,
    entertainment:  json["entertainment"] != null ? json["entertainment"].toDouble() ?? 0.0 : 0,
    mobileReimbursement: json["mobileReimbursement"] != null ? json["mobileReimbursement"].toDouble() ?? 0.0 : 0,

  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "status": status,
    "tourPlanDate": tourPlanDate?.toIso8601String(),
    "paymentStatus": paymentStatus,
    "notes": notes,
    "createdAt": createdAt?.toIso8601String(),
    "requestedTo": requestedTo,
    "dcrData": dcrData?.toJson(),
    "totalFare": totalFare?.toDouble(),
    "totalHq": totalHq?.toDouble(),
    "totalExHq": totalExHq?.toDouble(),
    "totalOs": totalOs?.toDouble(),
    "totalMisc": totalMisc?.toDouble(),
    "grandTotal": grandTotal?.toDouble(),
    "entertainment": entertainment?.toDouble(),
    "mobileReimbursement": mobileReimbursement?.toDouble(),
  };
}
