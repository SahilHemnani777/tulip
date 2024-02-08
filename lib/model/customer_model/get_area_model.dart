

class AreaList {
  List<Area>? docs;
  int? total;
  int? page;
  int? totalPages;

  AreaList({
    this.docs,
    this.total,
    this.page,
    this.totalPages,
  });

  factory AreaList.fromJson(Map<String, dynamic> json) => AreaList(
      docs: json["docs"] == null ? [] : List<Area>.from(json["docs"]!.map((x) => Area.fromJson(x))),
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

class Area {
  String id;
  String townName;
  int? pinCode;
  DistrictId? districtId;
  StationTypeId? stationTypeId;
  String? status;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? updatedBy;

  Area({
    required this.id,
    required this.townName,
    this.pinCode,
    this.districtId,
    this.stationTypeId,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.updatedBy,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    id: json["_id"],
    townName: json["townName"],
    pinCode: json["pinCode"],
    districtId: json["districtId"] == null ? null : DistrictId.fromJson(json["districtId"]),
    // stationTypeId: json["stationTypeId"] == null ? null : StationTypeId.fromJson(json["stationTypeId"]),
    status: json["status"],
    createdBy: json["createdBy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    updatedBy: json["updatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "townName": townName,
    "pinCode": pinCode,
    "districtId": districtId?.toJson(),
    "stationTypeId": stationTypeId?.toJson(),
    "status": status,
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "updatedBy": updatedBy,
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
