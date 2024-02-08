
// DistributorStockItem
// DistributorStockList

class DistributorStockItem {
  String id;
  String? year;
  String? month;
  UserId? userId;
  DistributorId? distributorId;
  String? invoiceDate;
  String? purchaseType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? trsNo;
  String? status;
  DistributorData? distributorData;

  DistributorStockItem({
    required this.id,
    this.year,
    this.month,
    this.userId,
    this.distributorId,
    this.invoiceDate,
    this.purchaseType,
    this.createdAt,
    this.updatedAt,
    this.trsNo,
    this.status,
    this.distributorData,
  });

  factory DistributorStockItem.fromJson(Map<String, dynamic> json) => DistributorStockItem(
    id: json["_id"],
    year: json["year"],
    month: json["month"],
    userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
    distributorId: json["distributorId"] == null ? null : DistributorId.fromJson(json["distributorId"]),
    invoiceDate: json["invoiceDate"],
    purchaseType: json["purchaseType"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    trsNo: json["trsNo"],
    status: json["status"],
    distributorData: json["distributorData"] == null ? null : DistributorData.fromJson(json["distributorData"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "year": year,
    "month": month,
    "userId": userId?.toJson(),
    "distributorId": distributorId?.toJson(),
    "invoiceDate": invoiceDate,
    "purchaseType": purchaseType,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "trsNo": trsNo,
    "status": status,
    "distributorData": distributorData?.toJson(),
  };
}

class DistributorData {
  String? id;
  String? businessName;
  int? contactNo;
  String? address;
  String? distributorCode;
  String? stateId;
  List<String>? towns;
  List<String>? headquarters;
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
  String? region;
  String? territory;
  String? distributorType;

  DistributorData({
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

  factory DistributorData.fromJson(Map<String, dynamic> json) => DistributorData(
      id: json["_id"],
      businessName: json["businessName"],
      contactNo: json["contactNo"],
      address: json["address"],
      distributorCode: json["distributorCode"],
      stateId: json["stateId"],
      towns: json["towns"] == null ? [] : List<String>.from(json["towns"]!.map((x) => x)),
  headquarters: json["headquarters"] == null ? [] : List<String>.from(json["headquarters"]!.map((x) => x)),
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
  region: json["region"],
  territory: json["territory"],
  distributorType: json["distributorType"],
  );

  Map<String, dynamic> toJson() => {
  "_id": id,
  "businessName": businessName,
  "contactNo": contactNo,
  "address": address,
  "distributorCode": distributorCode,
  "stateId": stateId,
  "towns": towns == null ? [] : List<dynamic>.from(towns!.map((x) => x)),
  "headquarters": headquarters == null ? [] : List<dynamic>.from(headquarters!.map((x) => x)),
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
  "region": region,
  "territory": territory,
  "distributorType": distributorType,
};
}

class DistributorId {
  String? id;
  String? businessName;
  String? distributorCode;
  String? territory;
  String? region;

  DistributorId({
    this.id,
    this.businessName,
    this.distributorCode,
    this.territory,
    this.region,
  });

  factory DistributorId.fromJson(Map<String, dynamic> json) => DistributorId(
    id: json["_id"],
    businessName: json["businessName"],
    distributorCode: json["distributorCode"],
    territory: json["territory"],
    region: json["region"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "businessName": businessName,
    "distributorCode": distributorCode,
    "territory": territory,
    "region": region,
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
