
class DCRModel {
  List<DCRListModel>? docs;
  int? total;
  int? page;
  int? totalPages;

  DCRModel({
    this.docs,
    this.total,
    this.page,
    this.totalPages,
  });

  factory DCRModel.fromJson(Map<String, dynamic> json) => DCRModel(
      docs: json["docs"] == null ? [] : List<DCRListModel>.from(json["docs"]!.map((x) => DCRListModel.fromJson(x))),
  total: json["total"],
  page: json["page"],
  totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
  "docs": docs == null ? [] : List<dynamic>.from(docs!.map((x) => x.toJson())),
  "total": total,
  "page": page,
  "totalPages": totalPages,
};
}

class DCRListModel {
  String? id;
  DateTime? date;
  int? labCalls;
  DCRArea? area;
  ActivityType? activityType;
  String? stationType;
  UserId? userId;
  ExpenseId? expenseId;
  bool isExpenses = false;
  bool isExpensesEligible = false;
  String? status;
  String? tourPlanVisitId;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? distanceKms;

  DCRListModel({
    this.id,
    this.date,
    this.labCalls,
    this.area,
    this.activityType,
    this.stationType,
    this.userId,
    this.expenseId,
    this.isExpenses = false,
    this.isExpensesEligible = false,
    this.status,
    this.tourPlanVisitId,
    this.createdAt,
    this.updatedAt,
    this.distanceKms,
  });

  factory DCRListModel.fromJson(Map<String, dynamic> json) => DCRListModel(
    id: json["_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    labCalls: json["labCalls"],
    area: json["area"] == null ? null : DCRArea.fromJson(json["area"]),
    activityType: json["activityType"] == null ? null : ActivityType.fromJson(json["activityType"]),
    stationType: json["stationType"],
    userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
    expenseId: json["expenseId"] == null ? null : ExpenseId.fromJson(json["expenseId"]),
    isExpenses: json["isExpenses"] ?? false,
    isExpensesEligible: json["isExpensesEligible"] ?? false,
    status: json["status"],
    tourPlanVisitId: json["tourPlanVisitId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    distanceKms: json["distanceKms"] !=null ? json["distanceKms"].toDouble() : 0.0,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "date": date?.toIso8601String(),
    "labCalls": labCalls,
    "area": area?.toJson(),
    "activityType": activityType?.toJson(),
    "stationType": stationType,
    "userId": userId?.toJson(),
    "expenseId": expenseId?.toJson(),
    "isExpensesEligible": isExpensesEligible,
    "isExpenses": isExpenses,
    "status": status,
    "tourPlanVisitId": tourPlanVisitId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "distanceKms": distanceKms,
  };
}

class ExpenseId {
  String? id;
  DateTime? createdAt;

  ExpenseId({
    this.id,
    this.createdAt,
  });

  factory ExpenseId.fromJson(Map<String, dynamic> json) => ExpenseId(
    id: json["_id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
  };
}


class ActivityType {
  String? id;
  bool isExpense;
  String? activityTypeName;

  ActivityType({
    this.id,
    this.activityTypeName,
    required this.isExpense,

  });

  factory ActivityType.fromJson(Map<String, dynamic> json) => ActivityType(
    id: json["_id"],
    isExpense: json["isExpense"],
    activityTypeName: json["activityTypeName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isExpense": isExpense,
    "activityTypeName": activityTypeName,
  };
}

class DCRArea {
  String? id;
  String? townName;

  DCRArea({
    this.id,
    this.townName,
  });

  factory DCRArea.fromJson(Map<String, dynamic> json) => DCRArea(
    id: json["_id"],
    townName: json["townName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "townName": townName,
  };
}

class UserId {
  String? id;
  String? userName;

  UserId({
    this.id,
    this.userName,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
  };
}



