class PurchaseCodeModel {
  List<PurchaseCode>? purchaseCodes;
  String? message;
  int? status;

  PurchaseCodeModel({this.purchaseCodes, this.message, this.status});

  PurchaseCodeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      purchaseCodes = <PurchaseCode>[];
      json['data'].forEach((v) {
        purchaseCodes!.add(PurchaseCode.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (purchaseCodes != null) {
      data['data'] = purchaseCodes!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class PurchaseCode {
  int? id;
  int? orderId;
  int? productId;
  String? code;
  String? createdAt;
  String? updatedAt;

  PurchaseCode(
      {this.id,
        this.orderId,
        this.productId,
        this.code,
        this.createdAt,
        this.updatedAt});

  PurchaseCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['code'] = code;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}