
class CompetitorList {
  List<Competitor>? docs;
  int? total;
  int? page;
  int? totalPages;

  CompetitorList({
    this.docs,
    this.total,
    this.page,
    this.totalPages,
  });

  factory CompetitorList.fromJson(Map<String, dynamic> json) => CompetitorList(
      docs: json["docs"] == null ? [] : List<Competitor>.from(json["docs"]!.map((x) => Competitor.fromJson(x))),
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

class Competitor {
  String id;
  String? competitorName;
  String? status;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Competitor({
    required this.id,
    this.competitorName,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Competitor.fromJson(Map<String, dynamic> json) => Competitor(
    id: json["_id"],
    competitorName: json["competitorName"],
    status: json["status"],
    createdBy: json["createdBy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "competitorName": competitorName,
    "status": status,
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
