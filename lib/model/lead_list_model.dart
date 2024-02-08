

class LeadListModel {
  List<LeadItemInfo>? docs;
  int? total;
  int? page;
  int? totalPages;

  LeadListModel({
    this.docs,
    this.total,
    this.page,
    this.totalPages,
  });

  factory LeadListModel.fromJson(Map<String, dynamic> json) => LeadListModel(
      docs: json["docs"] == null ? [] : List<LeadItemInfo>.from(json["docs"]!.map((x) => LeadItemInfo.fromJson(x))),
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

class LeadItemInfo {
  String id;
  String customerName;
  String companyMobileNumber;
  String companyEmailId;
  String address1;
  String? address2;
  String? address3;
  bool? isCustomer;
  String city;
  String state;
  String pinCode;
  String status;
  DateTime createdAt;

  LeadItemInfo({
    required this.id,
    required this.customerName,
    required this.companyMobileNumber,
    required this.companyEmailId,
    required this.address1,
    required this.isCustomer,
    this.address2,
    this.address3,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.status,
    required this.createdAt,
  });

  factory LeadItemInfo.fromJson(Map<String, dynamic> json) => LeadItemInfo(
    id: json["_id"],
    customerName: json["customerName"],
    companyMobileNumber: json["companyMobileNumber"],
    companyEmailId: json["companyEmailId"],
    address1: json["address1"],
    address2: json["address2"],
    isCustomer: json["isCustomer"],
    address3: json["address3"],
    city: json["city"],
    state: json["state"],
    pinCode: json["pinCode"],
    status: json["status"],
    createdAt:DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "customerName": customerName,
    "companyMobileNumber": companyMobileNumber,
    "companyEmailId": companyEmailId,
    "address1": address1,
    "address2": address2,
    "address3": address3,
    "isCustomer": isCustomer,
    "city": city,
    "state": state,
    "pinCode": pinCode,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
  };
}
