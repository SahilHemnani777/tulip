

import 'package:tulip_app/model/dcr_model/dcr_list_model.dart';

class ExpenseDetailsList {
  String? id;
  String? expenseId;
  String? dcrId;
  double? grandTotal;
  List<MiscellaneousExpense>? miscellaneousExpenses;
  List<dynamic>? travelBills;
  List<StandardFareChart>? standardFareChart;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ExpenseDetailsList({
    this.id,
    this.expenseId,
    this.dcrId,
    this.grandTotal,
    this.miscellaneousExpenses,
    this.travelBills,
    this.standardFareChart,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ExpenseDetailsList.fromJson(Map<String, dynamic> json) => ExpenseDetailsList(
      id: json["_id"],
      expenseId: json["expenseId"],
      dcrId: json["dcrId"],
      grandTotal: json["grandTotal"]?.toDouble(),
      miscellaneousExpenses: json["miscellaneousExpenses"] == null ? [] : List<MiscellaneousExpense>.from(json["miscellaneousExpenses"]!.map((x) => MiscellaneousExpense.fromJson(x))),
  travelBills: json["travelBills"] == null ? [] : List<dynamic>.from(json["travelBills"]!.map((x) => x)),
  standardFareChart: json["standardFareChart"] == null ? [] : List<StandardFareChart>.from(json["standardFareChart"]!.map((x) => StandardFareChart.fromJson(x))),
  userId: json["userId"],
  createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
  "_id": id,
  "expenseId": expenseId,
  "dcrId": dcrId,
  "grandTotal": grandTotal,
  "miscellaneousExpenses": miscellaneousExpenses == null ? [] : List<dynamic>.from(miscellaneousExpenses!.map((x) => x.toJson())),
  "travelBills": travelBills == null ? [] : List<dynamic>.from(travelBills!.map((x) => x)),
  "standardFareChart": standardFareChart == null ? [] : List<dynamic>.from(standardFareChart!.map((x) => x.toJson())),
  "userId": userId,
  "createdAt": createdAt?.toIso8601String(),
  "updatedAt": updatedAt?.toIso8601String(),
  "__v": v,
};
}

class MiscellaneousExpense {
  double? amount;
  String? description;

  MiscellaneousExpense({
    this.amount,
    this.description,
  });

  factory MiscellaneousExpense.fromJson(Map<String, dynamic> json) => MiscellaneousExpense(
    amount: json["amount"]?.toDouble(),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "description": description,
  };
}

class StandardFareChart {
  String? from;
  String? to;
  String? stationType;
  double? distanceKms;
  ActivityType? activityType;
  double? totalAllowance;
  double? fair;
  String? oneWay;
  TourPlanVisitId? tourPlanVisitId;
  DCRArea? area;

  StandardFareChart({
    this.from,
    this.to,
    this.stationType,
    this.activityType,

    this.distanceKms,
    this.totalAllowance,
    this.fair,
    this.oneWay,
    this.tourPlanVisitId,
    this.area,
  });

  factory StandardFareChart.fromJson(Map<String, dynamic> json) => StandardFareChart(
    from: json["from"],
    to: json["to"],
    stationType: json["stationType"],
    distanceKms: json["distanceKms"]?.toDouble(),
    totalAllowance: json["totalAllowance"]?.toDouble(),
    activityType: json["activityType"] == null ? null : ActivityType.fromJson(json["activityType"]),

    fair: json["fair"]?.toDouble(),
    oneWay: json["oneWay"],
    tourPlanVisitId: json["tourPlanVisitId"] == null ? null : TourPlanVisitId.fromJson(json["tourPlanVisitId"]),
    area: json["area"] == null ? null : DCRArea.fromJson(json["area"]),
  );

  Map<String, dynamic> toJson() => {
    "from": from,
    "to": to,
    "stationType": stationType,
    "distanceKms": distanceKms,
    "activityType": activityType?.toJson(),
    "totalAllowance": totalAllowance,
    "fair": fair,
    "oneWay": oneWay,
    "tourPlanVisitId": tourPlanVisitId?.toJson(),
    "area": area?.toJson(),
  };
}

class TourPlanVisitId {
  String? id;
  DateTime? visitDate;

  TourPlanVisitId({
    this.id,
    this.visitDate,
  });

  factory TourPlanVisitId.fromJson(Map<String, dynamic> json) => TourPlanVisitId(
    id: json["_id"],
    visitDate: json["visitDate"] == null ? null : DateTime.parse(json["visitDate"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "visitDate": visitDate?.toIso8601String(),
  };
}
