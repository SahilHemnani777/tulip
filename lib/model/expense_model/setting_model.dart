

class SettingDetails {
  String? id;
  double? osThresholdInKms;
  double? hqThresholdInKms;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic updatedBy;
  double? exHqAllowance;
  double? fare;
  int? trackingInterval;
  double? hqAllowance;
  double? osAllowance;
  double? fareThreshold;
  double mobileReimbursement=0.0;
  double entertainment=0.0;
  String? forceUpdateVersion;
  String? forceUpdateUrl;

  SettingDetails({
    this.id,
    this.forceUpdateVersion,
    this.osThresholdInKms,
    this.hqThresholdInKms,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.trackingInterval,
    this.updatedBy,
    this.fareThreshold,
    this.mobileReimbursement=0.0,
    this.entertainment=0.0,
    this.exHqAllowance,
    this.fare,
    this.hqAllowance,
    this.osAllowance,
     this.forceUpdateUrl,
  });

  factory SettingDetails.fromJson(Map<String, dynamic> json) => SettingDetails(
    id: json["_id"],
    forceUpdateVersion: json["forceUpdateVersion"],
    osThresholdInKms: json["osThresholdInKms"] !=null ? json["osThresholdInKms"].toDouble() : null,
    fareThreshold: json["fareThreshold"] !=null  ? json["fareThreshold"].toDouble() : null,
    hqThresholdInKms: json["hqThresholdInKms"] !=null ? json["hqThresholdInKms"].toDouble() : null,
    createdBy: json["createdBy"],
    trackingInterval: json["trackingInterval"],
    mobileReimbursement: json["mobileReimbursement"] !=null ? json["mobileReimbursement"].toDouble() : 0.0,
    entertainment: json["entertainmentAllowance"] !=null ? json["entertainmentAllowance"].toDouble() : 0.0,
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    updatedBy: json["updatedBy"],
    exHqAllowance: json["exHqAllowance"] !=null ? json["exHqAllowance"].toDouble() : null,
    fare: json["fare"] !=null ? json["fare"].toDouble() : null,
    hqAllowance: json["hqAllowance"] ==null ?null: json["hqAllowance"].toDouble(),
    osAllowance: json["osAllowance"] !=null ? json["osAllowance"].toDouble() : null,
    forceUpdateUrl: json["forceUpdateUrl"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "forceUpdateVersion": forceUpdateVersion,
    "fareThreshold": fareThreshold,
    "osThresholdInKms": osThresholdInKms,
    "hqThresholdInKms": hqThresholdInKms,
    "entertainment": entertainment,
    "createdBy": createdBy,
    "trackingInterval": trackingInterval,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "mobileReimbursement": mobileReimbursement,
    "updatedBy": updatedBy,
    "exHqAllowance": exHqAllowance,
    "fare": fare,
    "hqAllowance": hqAllowance,
    "osAllowance": osAllowance,
    "forceUpdateUrl": forceUpdateUrl,
  };
}
