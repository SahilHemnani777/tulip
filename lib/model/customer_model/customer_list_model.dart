
class CustomerList {
  List<CustomerListItem>? docs;
  int? total;
  int? page;
  int? totalPages;

  CustomerList({
    this.docs,
    this.total,
    this.page,
    this.totalPages,
  });

  factory CustomerList.fromJson(Map<String, dynamic> json) => CustomerList(
      docs: json["docs"] == null ? [] : List<CustomerListItem>.from(json["docs"]!.map((x) => CustomerListItem.fromJson(x))),
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

class CustomerListItem {
  String id;
  String customerName;
  String? companyMobileNumber;
  String? companyEmailId;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? customerType;
  String? state;
  String? pinCode;
  // DateTime? createdAt;

  CustomerListItem({
    required this.id,
    required this.customerName,
    this.companyMobileNumber,
    this.companyEmailId,
     this.address1,
     this.address2,
    this.customerType,
    this.address3,
     this.city,
     this.state,
     this.pinCode,
    // this.createdAt,
  });

  factory CustomerListItem.fromJson(Map<String, dynamic> json) => CustomerListItem(
    id: json["_id"],
    customerName: json["customerName"],
    companyMobileNumber: json["companyMobileNumber"],
    companyEmailId: json["companyEmailId"],
    address1 : json["address1"],
    customerType : json["customerType"],
    address2: json["address2"],
    address3: json["address3"],
    city: json["city"],
    state: json["state"],
    pinCode: json["pinCode"],
    // createdAt:DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "customerName": customerName,
    "companyMobileNumber": companyMobileNumber,
    "companyEmailId": companyEmailId,
    "address1": address1,
    "address2": address2,
    "customerType": customerType,
    "address3": address3,
    "city": city,
    "state": state,
    "pinCode": pinCode,
    // "createdAt": createdAt?.toIso8601String(),
  };
}
