

class CategoryData {
  String id;
  String categoryName;
  String categoryIcon;
  String? priority;
  String? status;
  // String? createdBy;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  // int? v;

  CategoryData({
    required this.id,
    required this.categoryName,
    required this.categoryIcon,
    this.priority,
    this.status,
    // this.createdBy,
    // this.createdAt,
    // this.updatedAt,
    // this.v,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
    id: json["_id"],
    categoryName: json["categoryName"],
    categoryIcon: json["categoryIcon"],
    priority: json["priority"],
    status: json["status"],
    // createdBy: json["createdBy"],
    // createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    // updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    // v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "categoryName": categoryName,
    "categoryIcon": categoryIcon,
    "priority": priority,
    "status": status,
    // "createdBy": createdBy,
    // "createdAt": createdAt?.toIso8601String(),
    // "updatedAt": updatedAt?.toIso8601String(),
    // "__v": v,
  };
}
