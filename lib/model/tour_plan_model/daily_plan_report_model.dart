
import 'package:tulip_app/model/customer_model/get_area_model.dart';

class DailyTourPlanListModel {
  DateTime? date;
  List<TourPlan>? tourPlan;
  LeaveData? leaveData;
  List<HolidayDatum>? holidayData;

  DailyTourPlanListModel({
    this.date,
    this.tourPlan,
    this.leaveData,
    this.holidayData,
  });

  factory DailyTourPlanListModel.fromJson(Map<String, dynamic> json) => DailyTourPlanListModel(
      date: json["date"] == null ? null : DateTime.parse(json["date"]),
      tourPlan: json["tourPlan"] == null ? [] : List<TourPlan>.from(json["tourPlan"]!.map((x) => TourPlan.fromJson(x))),
  leaveData: json["leaveData"] == null ? null : LeaveData.fromJson(json["leaveData"]),
  holidayData: json["holidayData"] == null ? [] : List<HolidayDatum>.from(json["holidayData"]!.map((x) => HolidayDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
  "date": date?.toIso8601String(),
  "tourPlan": tourPlan == null ? [] : List<dynamic>.from(tourPlan!.map((x) => x.toJson())),
  "leaveData": leaveData?.toJson(),
  "holidayData": holidayData == null ? [] : List<dynamic>.from(holidayData!.map((x) => x.toJson())),
};
}

class HolidayDatum {
  String? id;
  String? holidayName;
  String? headquarterId;
  DateTime? holidayDate;
  String? holidayType;
  String? description;
  String? status;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  HolidayDatum({
    this.id,
    this.holidayName,
    this.headquarterId,
    this.holidayDate,
    this.holidayType,
    this.description,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory HolidayDatum.fromJson(Map<String, dynamic> json) => HolidayDatum(
    id: json["_id"],
    holidayName: json["holidayName"],
    headquarterId: json["headquarterId"],
    holidayDate: json["holidayDate"] == null ? null : DateTime.parse(json["holidayDate"]),
    holidayType: json["holidayType"],
    description: json["description"],
    status: json["status"],
    createdBy: json["createdBy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "holidayName": holidayName,
    "headquarterId": headquarterId,
    "holidayDate": holidayDate?.toIso8601String(),
    "holidayType": holidayType,
    "description": description,
    "status": status,
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class LeaveData {
  String? id;
  String? userId;
  String? leaveType;
  String? description;
  DateTime? leaveDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  LeaveData({
    this.id,
    this.userId,
    this.leaveType,
    this.description,
    this.leaveDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory LeaveData.fromJson(Map<String, dynamic> json) => LeaveData(
    id: json["_id"],
    userId: json["userId"],
    leaveType: json["leaveType"],
    description: json["description"],
    leaveDate: json["leaveDate"] == null ? null : DateTime.parse(json["leaveDate"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "leaveType": leaveType,
    "description": description,
    "leaveDate": leaveDate?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class TourPlan {
  String? id;
  String? tourPlanId;
  ActivityTypeData? activityType;
  Area? area;
  String? note;
  double? labCalls;
  String? status;
  DeviatedVisitId? deviatedVisitId;
  bool isDeviation;

  TourPlan({
    this.id,
    this.tourPlanId,
    this.activityType,
    this.labCalls,
    this.area,
    this.note,
    this.status,
    this.deviatedVisitId,
    this.isDeviation = false,
  });

  factory TourPlan.fromJson(Map<String, dynamic> json) => TourPlan(
    id: json["_id"],
    labCalls: json["labCalls"] !=null ? json["labCalls"].toDouble() : 0,
    tourPlanId: json["tourPlanId"],
    activityType: json["activityType"] == null ? null : ActivityTypeData.fromJson(json["activityType"]),
    area: json["area"] == null ? null : Area.fromJson(json["area"]),
    note: json["note"],
    status: json["status"],
    deviatedVisitId: json["deviatedVisitId"] == null ? null : DeviatedVisitId.fromJson(json["deviatedVisitId"]),
    isDeviation: json["isDeviation"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "labCalls": labCalls,
    "tourPlanId": tourPlanId,
    "activityType": activityType?.toJson(),
    "area": area?.toJson(),
    "note": note,
    "status": status,
    "deviatedVisitId": deviatedVisitId?.toJson(),
    "isDeviation": isDeviation,
  };
}

class DistrictId {
  String? id;
  String? districtName;
  StateId? stateId;

  DistrictId({
    this.id,
    this.districtName,
    this.stateId,
  });

  factory DistrictId.fromJson(Map<String, dynamic> json) => DistrictId(
    id: json["_id"],
    districtName: json["districtName"],
    stateId: json["stateId"] == null ? null : StateId.fromJson(json["stateId"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "districtName": districtName,
    "stateId": stateId?.toJson(),
  };
}

class StateId {
  String? id;
  String? stateName;

  StateId({
    this.id,
    this.stateName,
  });

  factory StateId.fromJson(Map<String, dynamic> json) => StateId(
    id: json["_id"],
    stateName: json["stateName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "stateName": stateName,
  };
}

class StationTypeId {
  String? id;
  String? stationTypeName;

  StationTypeId({
    this.id,
    this.stationTypeName,
  });

  factory StationTypeId.fromJson(Map<String, dynamic> json) => StationTypeId(
    id: json["_id"],
    stationTypeName: json["stationTypeName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "stationTypeName": stationTypeName,
  };
}

class DeviatedVisitId {
  String? id;
  DeviatedVisitIdArea? area;

  DeviatedVisitId({
    this.id,
    this.area,
  });

  factory DeviatedVisitId.fromJson(Map<String, dynamic> json) => DeviatedVisitId(
    id: json["_id"],
    area: json["area"] == null ? null : DeviatedVisitIdArea.fromJson(json["area"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "area": area?.toJson(),
  };
}

class DeviatedVisitIdArea {
  String? id;
  String? townName;
  int? pinCode;

  DeviatedVisitIdArea({
    this.id,
    this.townName,
    this.pinCode,
  });

  factory DeviatedVisitIdArea.fromJson(Map<String, dynamic> json) => DeviatedVisitIdArea(
    id: json["_id"],
    townName: json["townName"],
    pinCode: json["pinCode"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "townName": townName,
    "pinCode": pinCode,
  };
}

class ActivityTypeData {
  String? id;
  String? activityTypeName;
  String? status;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ActivityTypeData({
    this.id,
    this.activityTypeName,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ActivityTypeData.fromJson(Map<String, dynamic> json) => ActivityTypeData(
    id: json["_id"],
    activityTypeName: json["activityTypeName"],
    status: json["status"],
    createdBy: json["createdBy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "activityTypeName": activityTypeName,
    "status": status,
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

