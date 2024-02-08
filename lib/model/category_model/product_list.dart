

import 'package:tulip_app/model/lead_model/lead_details.dart';

class ProductLIst {
  List<Product>? docs;
  int? total;
  int? page;
  int? totalPages;

  ProductLIst({
    this.docs,
    this.total,
    this.page,
    this.totalPages,
  });

  factory ProductLIst.fromJson(Map<String, dynamic> json) => ProductLIst(
      docs: json["docs"] == null ? [] : List<Product>.from(json["docs"]!.map((x) => Product.fromJson(x))),
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

