

class TourPlanList {
  String id;
  DateTime? date;
  RequestedTo? requestedTo;
  String? notes;
  String? status;
  RequestedTo? userId;
  int? totalHolidays;
  int? totalLeaves;

  TourPlanList({
    required this.id,
    this.date,
    this.requestedTo,
    this.notes,
    this.status,
    this.userId,
    this.totalHolidays,
    this.totalLeaves,
  });

  factory TourPlanList.fromJson(Map<String, dynamic> json) => TourPlanList(
    id: json["_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    requestedTo: json["requestedTo"] == null ? null : RequestedTo.fromJson(json["requestedTo"]),
    notes: json["notes"],
    status: json["status"],
    userId: json["userId"] == null ? null : RequestedTo.fromJson(json["userId"]),
    totalHolidays: json["totalHolidays"],
    totalLeaves: json["totalLeaves"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "date": date?.toIso8601String(),
    "requestedTo": requestedTo?.toJson(),
    "notes": notes,
    "status": status,
    "userId": userId?.toJson(),
    "totalHolidays": totalHolidays,
    "totalLeaves": totalLeaves,
  };
}

class RequestedTo {
  String? id;
  String? userName;

  RequestedTo({
    this.id,
    this.userName,
  });

  factory RequestedTo.fromJson(Map<String, dynamic> json) => RequestedTo(
    id: json["_id"],
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
  };
}
