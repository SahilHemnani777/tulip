class LoginData {
  String? customToken;
  UserDetails? userDetails;

  LoginData({
    this.customToken,
    this.userDetails,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        customToken: json["customToken"],
        userDetails: json["userDetails"] == null
            ? null
            : UserDetails.fromJson(json["userDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "customToken": customToken,
        "userDetails": userDetails?.toJson(),
      };
}

class UserDetails {
  String? id;
  String? userName;
  int? personalMobileNo;
  int? companyMobileNo;
  String? userType;
  String? employeeId;
  String? userDesignation;
  String? userDesignationId;
  String? userDepartment;
  String? reportingManager;
  String? emailId;
  List<String>? userAccess;
  Territory? territory;
  String? status;
  RegionHq? regionHq;

  UserDetails({
    this.id,
    this.userName,
    this.personalMobileNo,
    this.companyMobileNo,
    this.userType,
    this.userAccess,
    this.employeeId,
    this.userDesignationId,
    this.status,
    this.userDesignation,
    this.userDepartment,
    this.reportingManager,
    this.emailId,
    this.territory,
    this.regionHq,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["_id"],
        userName: json["userName"],
        personalMobileNo: json["personalMobileNo"],
        companyMobileNo: json["companyMobileNo"],
        userType: json["userType"],
        regionHq: json["regionHq"] == null
            ? null
            : RegionHq.fromJson(json["regionHq"]),
        userDesignation: json["userDesignation"],
        employeeId: json["employeeId"],
        status: json["status"],
        userDepartment: json["userDepartment"],
        userDesignationId: json["userDesignationId"],
        userAccess: json["userAccess"] == null
            ? []
            : List<String>.from(json["userAccess"]!.map((x) => x)),
        reportingManager: json["reportingManager"],
        emailId: json["emailId"],
        territory: json["territory"] == null
            ? null
            : Territory.fromJson(json["territory"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "personalMobileNo": personalMobileNo,
        "employeeId": employeeId,
        "companyMobileNo": companyMobileNo,
        "userType": userType,
        "regionHq": regionHq?.toJson(),
        "userDesignation": userDesignation,
        "userDesignationId": userDesignationId,
        "status": status,
        "userAccess": userAccess == null
            ? []
            : List<dynamic>.from(userAccess!.map((x) => x)),
        "userDepartment": userDepartment,
        "reportingManager": reportingManager,
        "emailId": emailId,
        "territory": territory?.toJson(),
      };
}

class Territory {
  String? id;
  String? territoryName;
  Region? region;

  Territory({
    this.id,
    this.territoryName,
    this.region,
  });

  factory Territory.fromJson(Map<String, dynamic> json) => Territory(
        id: json["_id"],
        territoryName: json["territoryName"],
        region: json["region"] == null ? null : Region.fromJson(json["region"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "territoryName": territoryName,
        "region": region?.toJson(),
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

class RegionHq {
  String? id;
  String? headquaterName;

  RegionHq({
    this.id,
    this.headquaterName,
  });

  factory RegionHq.fromJson(Map<String, dynamic> json) => RegionHq(
        id: json["_id"],
        headquaterName: json["headquaterName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "headquaterName": headquaterName,
      };
}
