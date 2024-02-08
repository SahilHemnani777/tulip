
class DistributorProductList {
  String? id;
  String? monthPurchaseId;
  String? invoiceNo;
  String? invoiceDate;
  String? distributorCode;
  String? distributorName;
  String? distributorId;
  String? purchaseFromDistributorCode;
  String? purchaseFromDistributorName;
  String? purchaseFromDistributorId;
  String? userId;
  String? productId;
  String? productCode;
  String? trsNo;
  String? productName;
  String? packSize;
  int? quantity;
  int? rate;
  int? openingBalance;
  int? closingBalance;
  int? qtySold;
  int? openingSaleQty;
  DateTime? createdAt;
  DateTime? updatedAt;

  DistributorProductList({
    this.id,
    this.monthPurchaseId,
    this.invoiceNo,
    this.invoiceDate,
    this.distributorCode,
    this.distributorName,
    this.distributorId,
    this.purchaseFromDistributorCode,
    this.purchaseFromDistributorName,
    this.purchaseFromDistributorId,
    this.userId,
    this.productId,
    this.productCode,
    this.trsNo,
    this.productName,
    this.packSize,
    this.quantity,
    this.rate,
    this.openingBalance,
    this.closingBalance,
    this.qtySold,
    this.openingSaleQty,
    this.createdAt,
    this.updatedAt,
  });

  factory DistributorProductList.fromJson(Map<String, dynamic> json) => DistributorProductList(
    id: json["_id"],
    monthPurchaseId: json["monthPurchaseId"],
    invoiceNo: json["invoiceNo"],
    invoiceDate: json["invoiceDate"],
    distributorCode: json["distributorCode"],
    distributorName: json["distributorName"],
    distributorId: json["distributorId"],
    purchaseFromDistributorCode: json["purchaseFromDistributorCode"],
    purchaseFromDistributorName: json["purchaseFromDistributorName"],
    purchaseFromDistributorId: json["purchaseFromDistributorId"],
    userId: json["userId"],
    productId: json["productId"],
    productCode: json["productCode"],
    trsNo: json["trsNo"],
    productName: json["productName"],
    packSize: json["packSize"],
    quantity: json["quantity"],
    rate: json["rate"],
    openingBalance: json["openingBalance"],
    closingBalance: json["closingBalance"],
    qtySold: json["qtySold"],
    openingSaleQty: json["openingSaleQty"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "monthPurchaseId": monthPurchaseId,
    "invoiceNo": invoiceNo,
    "invoiceDate": invoiceDate,
    "distributorCode": distributorCode,
    "distributorName": distributorName,
    "distributorId": distributorId,
    "purchaseFromDistributorCode": purchaseFromDistributorCode,
    "purchaseFromDistributorName": purchaseFromDistributorName,
    "purchaseFromDistributorId": purchaseFromDistributorId,
    "userId": userId,
    "productId": productId,
    "productCode": productCode,
    "trsNo": trsNo,
    "productName": productName,
    "packSize": packSize,
    "quantity": quantity,
    "rate": rate,
    "openingBalance": openingBalance,
    "closingBalance": closingBalance,
    "qtySold": qtySold,
    "openingSaleQty": openingSaleQty,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}



