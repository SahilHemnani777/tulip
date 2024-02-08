

class BrandList {
  List<BrandItem>? docs;
  int? total;
  int? page;
  int? totalPages;

  BrandList({
    this.docs,
    this.total,
    this.page,
    this.totalPages,
  });

  factory BrandList.fromJson(Map<String, dynamic> json) => BrandList(
      docs: json["docs"] == null ? [] : List<BrandItem>.from(json["docs"]!.map((x) => BrandItem.fromJson(x))),
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

class BrandItem {
  String? id;
  String? productBrandName;
  String? status;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  BrandItem({
    this.id,
    this.productBrandName,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BrandItem.fromJson(Map<String, dynamic> json) => BrandItem(
    id: json["_id"],
    productBrandName: json["productBrandName"],
    status: json["status"],
    createdBy: json["createdBy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "productBrandName": productBrandName,
    "status": status,
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
