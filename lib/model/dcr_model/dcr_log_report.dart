

class DCRLogReportsModel {
  String? id;
  String? visitTime;
  SalesCall? salesCall;
  PmCall? pmCall;
  NCall? breakDownCall;
  NCall? installationCall;
  ApplicationSupportCall? applicationSupportCall;
  DateTime? dcrDate;
  DateTime? createdAt;
  DateTime? tourPlanVisitDate;
  String? visitedWith;
  String? comment;
  String? customerName;
  int? pob;
  int? demos;
  int? conversions;

  DCRLogReportsModel({
    this.id,
    this.visitTime,
    this.salesCall,
    this.pmCall,
    this.breakDownCall,
    this.installationCall,
    this.applicationSupportCall,
    this.dcrDate,
    this.createdAt,
    this.tourPlanVisitDate,
    this.comment,
    this.visitedWith,
    this.customerName,
    this.pob,
    this.demos,
    this.conversions,
  });

  factory DCRLogReportsModel.fromJson(Map<String, dynamic> json) => DCRLogReportsModel(
    id: json["_id"],
    visitTime: json["visitTime"],
    salesCall: json["salesCall"] == null ? null : SalesCall.fromJson(json["salesCall"]),
    pmCall: json["pmCall"] == null ? null : PmCall.fromJson(json["pmCall"]),
    breakDownCall: json["breakDownCall"] == null ? null : NCall.fromJson(json["breakDownCall"]),
    installationCall: json["installationCall"] == null ? null : NCall.fromJson(json["installationCall"]),
    applicationSupportCall: json["applicationSupportCall"] == null ? null : ApplicationSupportCall.fromJson(json["applicationSupportCall"]),
    dcrDate: json["dcrDate"] == null ? null : DateTime.parse(json["dcrDate"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    tourPlanVisitDate: json["tourPlanVisitDate"] == null ? null : DateTime.parse(json["tourPlanVisitDate"]),
    visitedWith: json["visitedWith"],
    customerName: json["customerName"],
    pob: json["POB"],
    comment: json["comment"],
    demos: json["Demos"],
    conversions: json["Conversions"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "visitTime": visitTime,
    "salesCall": salesCall?.toJson(),
    "pmCall": pmCall?.toJson(),
    "breakDownCall": breakDownCall?.toJson(),
    "installationCall": installationCall?.toJson(),
    "applicationSupportCall": applicationSupportCall?.toJson(),
    "dcrDate": dcrDate?.toIso8601String(),
    "tourPlanVisitDate": tourPlanVisitDate?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "comment": comment,
    "visitedWith": visitedWith,
    "customerName": customerName,
    "POB": pob,
    "Demos": demos,
    "Conversions": conversions,
  };
}

class ApplicationSupportCall {
  String? machineSerialNo;
  String? machineName;
  List<dynamic>? documents;
  dynamic pmCall;
  dynamic salesCall;
  dynamic warrantyMonths;

  ApplicationSupportCall({
    this.machineSerialNo,
    this.machineName,
    this.documents,
    this.pmCall,
    this.salesCall,
    this.warrantyMonths,
  });

  factory ApplicationSupportCall.fromJson(Map<String, dynamic> json) => ApplicationSupportCall(
      machineSerialNo: json["machineSerialNo"],
      machineName: json["machineName"],
      documents: json["documents"] == null ? [] : List<dynamic>.from(json["documents"]!.map((x) => x)),
  pmCall: json["pmCall"],
  salesCall: json["salesCall"],
  warrantyMonths: json["warrantyMonths"],
  );

  Map<String, dynamic> toJson() => {
  "machineSerialNo": machineSerialNo,
  "machineName": machineName,
  "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x)),
  "pmCall": pmCall,
  "salesCall": salesCall,
  "warrantyMonths": warrantyMonths,
};
}

class NCall {
  String? machineSerialNo;
  String? machineName;
  List<String>? documents;
  dynamic pmCall;
  dynamic salesCall;
  dynamic warrantyMonths;

  NCall({
    this.machineSerialNo,
    this.machineName,
    this.documents,
    this.pmCall,
    this.salesCall,
    this.warrantyMonths,
  });

  factory NCall.fromJson(Map<String, dynamic> json) => NCall(
      machineSerialNo: json["machineSerialNo"],
      machineName: json["machineName"],
      documents: json["documents"] == null ? [] : List<String>.from(json["documents"]!.map((x) => x)),
  pmCall: json["pmCall"],
  salesCall: json["salesCall"],
  warrantyMonths: json["warrantyMonths"],
  );

  Map<String, dynamic> toJson() => {
  "machineSerialNo": machineSerialNo,
  "machineName": machineName,
  "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x)),
  "pmCall": pmCall,
  "salesCall": salesCall,
  "warrantyMonths": warrantyMonths,
};
}

class PmCall {
  String? machineSerialNo;
  String? machineName;
  List<String>? documents;
  String? pmCall;
  dynamic salesCall;
  dynamic warrantyMonths;

  PmCall({
    this.machineSerialNo,
    this.machineName,
    this.documents,
    this.pmCall,
    this.salesCall,
    this.warrantyMonths,
  });

  factory PmCall.fromJson(Map<String, dynamic> json) => PmCall(
      machineSerialNo: json["machineSerialNo"],
      machineName: json["machineName"],
      documents: json["documents"] == null ? [] : List<String>.from(json["documents"]!.map((x) => x)),
  pmCall: json["pmCall"],
  salesCall: json["salesCall"],
  warrantyMonths: json["warrantyMonths"],
  );

  Map<String, dynamic> toJson() => {
  "machineSerialNo": machineSerialNo,
  "machineName": machineName,
  "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x)),
  "pmCall": pmCall,
  "salesCall": salesCall,
  "warrantyMonths": warrantyMonths,
};
}

class SalesCall {
  String? machineSerialNo;
  String? machineName;
  List<String>? documents;
  dynamic pmCall;
  String? salesCall;
  dynamic warrantyMonths;

  SalesCall({
    this.machineSerialNo,
    this.machineName,
    this.documents,
    this.pmCall,
    this.salesCall,
    this.warrantyMonths,
  });

  factory SalesCall.fromJson(Map<String, dynamic> json) => SalesCall(
      machineSerialNo: json["machineSerialNo"],
      machineName: json["machineName"],
      documents: json["documents"] == null ? [] : List<String>.from(json["documents"]!.map((x) => x)),
  pmCall: json["pmCall"],
  salesCall: json["salesCall"],
  warrantyMonths: json["warrantyMonths"],
  );

  Map<String, dynamic> toJson() => {
  "machineSerialNo": machineSerialNo,
  "machineName": machineName,
  "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x)),
  "pmCall": pmCall,
  "salesCall": salesCall,
  "warrantyMonths": warrantyMonths,
};
}

