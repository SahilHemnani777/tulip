class DistributorList {
  String? id;
  String? businessName;
  int? contactNo;
  String? address;
  String? distributorCode;
  String? stateId;
  List<Town>? towns;
  List<Headquarters>? headquarters;
  int? pinCode;
  String? emailId;
  String? website;
  String? gstNo;
  String? nameOfPersonToContact;
  String? desgOfContactPerson;
  int? mobileNoOfContactPerson;
  String? contactPersonEmail;
  String? logo;
  String? status;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? updatedBy;
  Region? region;
  Territory? territory;
  String? distributorType;

  DistributorList({
    this.id,
    this.businessName,
    this.contactNo,
    this.address,
    this.distributorCode,
    this.stateId,
    this.towns,
    this.headquarters,
    this.pinCode,
    this.emailId,
    this.website,
    this.gstNo,
    this.nameOfPersonToContact,
    this.desgOfContactPerson,
    this.mobileNoOfContactPerson,
    this.contactPersonEmail,
    this.logo,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.updatedBy,
    this.region,
    this.territory,
    this.distributorType,
  });

  factory DistributorList.fromJson(Map<String, dynamic> json) => DistributorList(
      id: json["_id"],
      businessName: json["businessName"],
      contactNo: json["contactNo"],
      address: json["address"],
      distributorCode: json["distributorCode"],
      stateId: json["stateId"],
      towns: json["towns"] == null ? [] : List<Town>.from(json["towns"]!.map((x) => Town.fromJson(x))),
  headquarters: json["headquarters"] == null ? [] : List<Headquarters>.from(json["headquarters"]!.map((x) => Headquarters.fromJson(x))),
  pinCode: json["pinCode"],
  emailId: json["emailId"],
  website: json["website"],
  gstNo: json["gstNo"],
  nameOfPersonToContact: json["nameOfPersonToContact"],
  desgOfContactPerson: json["desgOfContactPerson"],
  mobileNoOfContactPerson: json["mobileNoOfContactPerson"],
  contactPersonEmail: json["contactPersonEmail"],
  logo: json["logo"],
  status: json["status"],
  createdBy: json["createdBy"],
  createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  v: json["__v"],
  updatedBy: json["updatedBy"],
  region: json["region"] == null ? null : Region.fromJson(json["region"]),
  territory: json["territory"] == null ? null : Territory.fromJson(json["territory"]),
  distributorType: json["distributorType"],
  );

  Map<String, dynamic> toJson() => {
  "_id": id,
  "businessName": businessName,
  "contactNo": contactNo,
  "address": address,
  "distributorCode": distributorCode,
  "stateId": stateId,
  "towns": towns == null ? [] : List<dynamic>.from(towns!.map((x) => x.toJson())),
  "headquarters": headquarters == null ? [] : List<dynamic>.from(headquarters!.map((x) => x.toJson())),
  "pinCode": pinCode,
  "emailId": emailId,
  "website": website,
  "gstNo": gstNo,
  "nameOfPersonToContact": nameOfPersonToContact,
  "desgOfContactPerson": desgOfContactPerson,
  "mobileNoOfContactPerson": mobileNoOfContactPerson,
  "contactPersonEmail": contactPersonEmail,
  "logo": logo,
  "status": status,
  "createdBy": createdBy,
  "createdAt": createdAt?.toIso8601String(),
  "updatedAt": updatedAt?.toIso8601String(),
  "__v": v,
  "updatedBy": updatedBy,
  "region": region?.toJson(),
  "territory": territory?.toJson(),
  "distributorType": distributorType,
};
}

class Headquarters {
  String? id;
  String? headquaterName;

  Headquarters({
    this.id,
    this.headquaterName,
  });

  factory Headquarters.fromJson(Map<String, dynamic> json) => Headquarters(
    id: json["_id"],
    headquaterName: json["headquaterName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "headquaterName": headquaterName,
  };
}

class Region {
  String? id;
  String? regionName;

  Region({
    this.id,
    this.regionName,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    id: json["_id"],
    regionName: json["regionName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "regionName": regionName,
  };
}

class Territory {
  String? id;
  String? territoryName;

  Territory({
    this.id,
    this.territoryName,
  });

  factory Territory.fromJson(Map<String, dynamic> json) => Territory(
    id: json["_id"],
    territoryName: json["territoryName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "territoryName": territoryName,
  };
}

class Town {
  String? id;
  String? townName;

  Town({
    this.id,
    this.townName,
  });

  factory Town.fromJson(Map<String, dynamic> json) => Town(
    id: json["_id"],
    townName: json["townName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "townName": townName,
  };
}
