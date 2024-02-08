
import 'package:tulip_app/model/customer_model/brand_model.dart';
import 'package:tulip_app/model/customer_model/get_area_model.dart';

class LeadDetails {
  String id;
  String? customerName;
  String? contactPersonName;
  String? designation;
  String? qualification;
  String? contactPersonMobileNumber;
  String? companyMobileNumber;
  String? companyEmailId;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? state;
  String? pinCode;
  String? gstNumber;
  String? drugLicenceNumber;
  String? notes;
  String? status;
  Area? townId;
  CustomerTypeId? customerTypeId;
  List<Product>? products;
  List<String>? gstLicenceCertificate;
  List<String>? drugLicenceCertificate;

  LeadDetails({
    required this.id,
    this.customerName,
    this.contactPersonName,
    this.designation,
    this.qualification,
    this.contactPersonMobileNumber,
    this.companyMobileNumber,
    this.companyEmailId,
    this.address1,
    this.address2,
    this.address3,
    this.city,
    this.state,
    this.pinCode,
    this.gstNumber,
    this.drugLicenceNumber,
    this.notes,
    this.status,
    this.townId,
    this.customerTypeId,
    this.gstLicenceCertificate,
    this.drugLicenceCertificate,
    this.products,
  });

  factory LeadDetails.fromJson(Map<String, dynamic> json) => LeadDetails(
      id: json["_id"],
      customerName: json["customerName"],
      contactPersonName: json["contactPersonName"],
      designation: json["designation"],
      qualification: json["qualification"],
      contactPersonMobileNumber: json["contactPersonMobileNumber"],
      companyMobileNumber: json["companyMobileNumber"],
      companyEmailId: json["companyEmailId"],
      address1: json["address1"],
      address2: json["address2"],
      address3: json["address3"],
      city: json["city"],
      state: json["state"],
      pinCode: json["pinCode"],
      gstNumber: json["gstNumber"],
      drugLicenceNumber: json["drugLicenceNumber"],
      notes: json["notes"],
      status: json["status"],
      townId: json["townId"] == null ? null : Area.fromJson(json["townId"]),
      customerTypeId: json["customerTypeId"] == null ? null : CustomerTypeId.fromJson(json["customerTypeId"]),
      gstLicenceCertificate: json["gstLicenceCertificate"] == null ? [] : List<String>.from(json["gstLicenceCertificate"]!.map((x) => x)),
  drugLicenceCertificate: json["drugLicenceCertificate"] == null ? [] : List<String>.from(json["drugLicenceCertificate"]!.map((x) => x)),
      products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
  "_id": id,
  "customerName": customerName,
  "contactPersonName": contactPersonName,
  "designation": designation,
  "qualification": qualification,
  "contactPersonMobileNumber": contactPersonMobileNumber,
  "companyMobileNumber": companyMobileNumber,
  "companyEmailId": companyEmailId,
  "address1": address1,
  "address2": address2,
  "address3": address3,
  "city": city,
  "state": state,
  "pinCode": pinCode,
  "gstNumber": gstNumber,
  "drugLicenceNumber": drugLicenceNumber,
  "gstLicenceCertificate": gstLicenceCertificate == null ? [] : List<dynamic>.from(gstLicenceCertificate!.map((x) => x)),
  "drugLicenceCertificate": drugLicenceCertificate == null ? [] : List<dynamic>.from(drugLicenceCertificate!.map((x) => x)),
  "notes": notes,
  "status": status,
  "townId": townId?.toJson(),
  "customerTypeId": customerTypeId?.toJson(),
  "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
};

    Map<String, dynamic> getJsonOnlyKey(String lat, String long,String userId,bool isLead) {
      Map<String,dynamic>jsonData= {
        "customerName": customerName,
        "contactPersonName": contactPersonName,
        "designation": designation,
        "qualification": qualification,
        "contactPersonMobileNumber": contactPersonMobileNumber,
        "companyMobileNumber": companyMobileNumber,
        "companyEmailId": companyEmailId,
        "address1": address1,
        "address2": address2,
        "address3": address3,
        "city": city,
        "gstLicenceCertificate": gstLicenceCertificate,
        "drugLicenceCertificate": drugLicenceCertificate,
        "state": state,
        "pinCode": pinCode,
        "gstNumber": gstNumber,
        "drugLicenceNumber": drugLicenceNumber,
        "notes": notes,
        "status": "Other",
        "location": {
          "type": "Point",
          "coordinates": [
            lat,
            long
          ]
        },
        "townId": townId?.id,
        "customerTypeId": customerTypeId?.id,
        "products":List<dynamic>.from(products!.map((x) => x.getProductOnlyKey())),
      };
      if (id.isNotEmpty) {
        if(isLead) {
          jsonData["leadId"] = id;
        }
        else{
          jsonData["customerId"] = id;
        }

        jsonData["updatedBy"] = userId;
      }else{
        jsonData["updatedBy"] = userId;
      jsonData["createdBy"] = userId;
    }
      return jsonData;
    }
    }


class Product {
  String id;
  String? productName;
  String? categoryId;
  BrandItem? brandId;
  List<PackSizeId>? packSizeIds;
  List<String>? productImage;
  String? potential;
  int? productMrp;
  int? sellingPrice;
  int? skuNumber;
  String? selectedPackSizeId;
  String? competitorId;
  String? description;
  String? productBrandName;
  String? dimensions;
  String? status;
  String? competitor;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Product({
    required this.id,
    this.productName,
    this.categoryId,
    this.brandId,
    this.packSizeIds,
    this.productImage,
    this.productMrp,
    this.potential,
    this.selectedPackSizeId,
    this.productBrandName,
    this.sellingPrice,
    this.competitorId,
    this.competitor,
    this.skuNumber,
    this.description,
    this.dimensions,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["_id"],
      productName: json["productName"],
      categoryId: json["categoryId"],
      brandId: json["brandId"] == null ? null : BrandItem.fromJson(json["brandId"]),
      packSizeIds: json["packSizeIds"] == null ? [] : List<PackSizeId>.from(json["packSizeIds"]!.map((x) => PackSizeId.fromJson(x))),
  productImage: json["productImage"] == null ? [] : List<String>.from(json["productImage"]!.map((x) => x)),
      productMrp: json["productMrp"],
      sellingPrice: json["sellingPrice"],
      competitor: json["competitor"],
      potential: json["potential"],
      selectedPackSizeId: json["selectedPackSizeId"],
  competitorId: json["competitorId"],
  skuNumber: json["skuNumber"],
  description: json["description"],

  dimensions: json["dimensions"],
  status: json["status"],
  createdBy: json["createdBy"],
  createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
  "_id": id,
  "productName": productName,
  "categoryId": categoryId,
  "selectedPackSizeId": selectedPackSizeId,
  "competitorId": competitorId,
  "potential": potential,
  "packSizeIds": packSizeIds == null ? [] : List<dynamic>.from(packSizeIds!.map((x) => x.toJson())),
  "productImage": productImage == null ? [] : List<dynamic>.from(productImage!.map((x) => x)),
  "productMrp": productMrp,
  "sellingPrice": sellingPrice,
  "skuNumber": skuNumber,
  "description": description,
  "competitor": competitor,
  "productBrandName": productBrandName,
  "dimensions": dimensions,
  "brandId": brandId?.toJson(),
  "status": status,
  "createdBy": createdBy,
  "createdAt": createdAt?.toIso8601String(),
  "updatedAt": updatedAt?.toIso8601String(),
  "__v": v,
};


Map<String, dynamic> getProductOnlyKey() => {
"productId": id,
"brandId": brandId?.id,
"competitorId": competitorId,
"potential": potential,
"packSizeId": selectedPackSizeId,
};
}

class PackSizeId {
  String? id;
  String? packSizeName;

  PackSizeId({
    this.id,
    this.packSizeName,
  });

  factory PackSizeId.fromJson(Map<String, dynamic> json) => PackSizeId(
    id: json["_id"],
    packSizeName: json["packSizeName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "packSizeName": packSizeName,
  };
}



class CustomerTypeId {
  String? id;
  String? customerTypeName;

  CustomerTypeId({
    this.id,
    this.customerTypeName,
  });

  factory CustomerTypeId.fromJson(Map<String, dynamic> json) => CustomerTypeId(
    id: json["_id"],
    customerTypeName: json["customerTypeName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "customerTypeName": customerTypeName,
  };
}
