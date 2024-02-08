
class FollowUpModel {
  List<FollowUpDetails>? docs;
  int? total;
  int? page;
  int? totalPages;

  FollowUpModel({
    this.docs,
    this.total,
    this.page,
    this.totalPages,
  });

  factory FollowUpModel.fromJson(Map<String, dynamic> json) => FollowUpModel(
      docs: json["docs"] == null ? [] : List<FollowUpDetails>.from(json["docs"]!.map((x) => FollowUpDetails.fromJson(x))),
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

class FollowUpDetails {
  String? id;
  String? leadId;
  DateTime? followUpDate;
  String? followUpBy;
  String? status;
  String? followUpNotes;
  String? followUpByName;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  FollowUpDetails({
    this.id,
    this.leadId,
    this.followUpDate,
    this.followUpBy,
    this.status,
    this.followUpByName,
    this.followUpNotes,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FollowUpDetails.fromJson(Map<String, dynamic> json) => FollowUpDetails(
    id: json["_id"],
    leadId: json["leadId"],
    followUpDate: json["followUpDate"] == null ? null : DateTime.parse(json["followUpDate"]),
    followUpBy: json["followUpBy"],
    followUpByName: json["followUpByName"],
    status: json["status"],
    followUpNotes: json["followUpNotes"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "leadId": leadId,
    "followUpDate": followUpDate?.toIso8601String(),
    "followUpBy": followUpBy,
    "followUpByName": followUpByName,
    "status": status,
    "followUpNotes": followUpNotes,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };

}
