
import 'package:tulip_app/model/lead_model/lead_details.dart';

class CustomerTypeList {
  List<CustomerTypeId>? docs;
  int? total;
  dynamic page;
  int? totalPages;

  CustomerTypeList({
    this.docs,
    this.total,
    this.page,
    this.totalPages,
  });

  factory CustomerTypeList.fromJson(Map<String, dynamic> json) => CustomerTypeList(
      docs: json["docs"] == null ? [] : List<CustomerTypeId>.from(json["docs"]!.map((x) => CustomerTypeId.fromJson(x))),
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

