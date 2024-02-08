
class CheckUserExists {
  String id;
  bool? isPasswordExist;

  CheckUserExists({
    required this.id,
    this.isPasswordExist,
  });

  factory CheckUserExists.fromJson(Map<String, dynamic> json) => CheckUserExists(
    id: json["_id"],
    isPasswordExist: json["isPasswordExist"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isPasswordExist": isPasswordExist,
  };
}
