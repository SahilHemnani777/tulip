

import 'package:tulip_app/model/customer_model/customer_list_model.dart';
import 'package:tulip_app/model/lead_model/lead_details.dart';
import 'package:tulip_app/model/login_data.dart';

class DCRReport {
  String? id;
  CustomerListItem? customerId;
  UserId? userId;
  UserDetails? visitedWith;
  String? visitTime;
  String? courtesyCall;
  String? orderValue;
  String? comment;
  List<Conversion>? pointOfBusiness;
  List<Conversion>? demo;
  List<Conversion>? conversions;
  Call? salesCall;
  Call? pmCall;
  String? remarks;
  Call? breakDownCall;
  Call? installationCall;
  Call? applicationSupportCall;
  DateTime? dcrDate;

  DCRReport({
    this.id,
    this.customerId,
    this.userId,
    this.visitedWith,
    this.visitTime,
    this.courtesyCall,
    this.orderValue,
    this.remarks,
    this.comment,
    this.pointOfBusiness,
    this.demo,
    this.conversions,
    this.salesCall,
    this.pmCall,
    this.breakDownCall,
    this.installationCall,
    this.applicationSupportCall,
    this.dcrDate,
  });

  factory DCRReport.fromJson(Map<String, dynamic> json) => DCRReport(
    id: json["_id"],
    customerId: json["customerId"] == null ? null : CustomerListItem.fromJson(json["customerId"]),
    userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
    visitedWith: json["visitedWith"] == null ? null : UserDetails.fromJson(json["visitedWith"]),
    visitTime: json["visitTime"],
    courtesyCall: json["courtesyCall"],
    remarks: json["remarks"],
    orderValue: json["orderValue"],
    comment: json["comment"],
    pointOfBusiness: json["pointOfBusiness"] == null ? [] : List<Conversion>.from(json["pointOfBusiness"]!.map((x) => Conversion.fromJson(x))),
    demo: json["demo"] == null ? [] : List<Conversion>.from(json["demo"]!.map((x) => Conversion.fromJson(x))),
    conversions: json["conversions"] == null ? [] : List<Conversion>.from(json["conversions"]!.map((x) => Conversion.fromJson(x))),
    salesCall: json["salesCall"] == null ? null : Call.fromJson(json["salesCall"]),
    pmCall: json["pmCall"] == null ? null : Call.fromJson(json["pmCall"]),
    breakDownCall: json["breakDownCall"] == null ? null : Call.fromJson(json["breakDownCall"]),
    installationCall: json["installationCall"] == null ? null : Call.fromJson(json["installationCall"]),
    applicationSupportCall: json["applicationSupportCall"] == null ? null : Call.fromJson(json["applicationSupportCall"]),
    dcrDate: json["dcrDate"] == null ? null : DateTime.parse(json["dcrDate"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "customerId": customerId?.toJson(),
    "userId": userId?.toJson(),
    "visitedWith": visitedWith?.toJson(),
    "remarks": remarks,
    "visitTime": visitTime,
    "courtesyCall": courtesyCall,
    "orderValue": orderValue,
    "comment": comment,
    "pointOfBusiness": pointOfBusiness == null ? [] : List<dynamic>.from(pointOfBusiness!.map((x) => x.toJson())),
    "demo": demo == null ? [] : List<dynamic>.from(demo!.map((x) => x.toJson())),
    "conversions": conversions == null ? [] : List<dynamic>.from(conversions!.map((x) => x.toJson())),
    "salesCall": salesCall?.toJson(),
    "pmCall": pmCall?.toJson(),
    "breakDownCall": breakDownCall?.toJson(),
    "installationCall": installationCall?.toJson(),
    "applicationSupportCall": applicationSupportCall?.toJson(),
    "dcrDate": dcrDate?.toIso8601String(),
  };

  Map<String, dynamic> getDCRJsonOnlyKey(String currentUserId,String? dcrLogId,String tourPlanVisitId,String? dcrId) {
    Map<String,dynamic>jsonData= {
      "customerId": customerId?.id,
      "tourPlanVisitId": tourPlanVisitId,
      "userId": currentUserId,
      "visitedWith": visitedWith?.id,
      "remarks": remarks,
      "visitTime": visitTime,
      "courtesyCall": courtesyCall,
      "orderValue": orderValue,
      "comment": comment,
      "pointOfBusiness": pointOfBusiness == null ? [] : List<dynamic>.from(pointOfBusiness!.map((x) => x.toDCRJsonKey())),
      "demo": demo == null ? [] : List<dynamic>.from(demo!.map((x) => x.toDCRJsonKey())),
      "conversions": conversions == null ? [] : List<dynamic>.from(conversions!.map((x) => x.toDCRJsonKey())),
      "salesCall": salesCall?.toJson(),
      "pmCall": pmCall?.toJson(),
      "breakDownCall": breakDownCall?.toJson(),
      "installationCall": installationCall?.toJson(),
      "applicationSupportCall": applicationSupportCall?.toJson(),
      "dcrDate": dcrDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      "dcrId" : dcrId,
    };
    if (dcrLogId!=null && dcrLogId.isNotEmpty) {
      jsonData["dcrLogId"] = dcrLogId;
    }
    return jsonData;
  }
}

class Call {
  String? machineSerialNo;
  String? machineName;
  List<dynamic>? documents;
  String? pmCall;
  String? salesCall;
  String? warranty;

  Call({
    this.machineSerialNo,
    this.machineName,
    this.documents,
    this.pmCall,
    this.salesCall,
    this.warranty,
  });

  factory Call.fromJson(Map<String, dynamic> json) => Call(
    machineSerialNo: json["machineSerialNo"],
    machineName: json["machineName"],
    documents: json["documents"] == null ? [] : List<String>.from(json["documents"]!.map((x) => x)),
    pmCall: json["pmCall"],
    salesCall: json["salesCall"],
    warranty: json["warranty"],
  );

  Map<String, dynamic> toJson() => {
    "machineSerialNo": machineSerialNo,
    "machineName": machineName,
    "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x)),
    "pmCall": pmCall,
    "salesCall": salesCall,
    "warranty": warranty,
  };
}

class Conversion {
  Product? productId;
  String? qty;
  String? productType;

  Conversion({
    this.productId,
    this.qty,
    this.productType,
  });

  factory Conversion.fromJson(Map<String, dynamic> json) => Conversion(
    productId: json["productId"] == null ? null : Product.fromJson(json["productId"]),
    qty: json["qty"],
    productType: json["productType"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId?.toJson(),
    "qty": qty,
    "productType": productType,
  };
  Map<String, dynamic> toDCRJsonKey() => {
    "productId": productId?.id,
    "productName": productId?.productName,
    "qty": qty,
    "productType": productType,
  };
}

class ProductId {
  String? id;
  String? productName;

  ProductId({
    this.id,
    this.productName,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
    id: json["_id"],
    productName: json["productName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "productName": productName,
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
