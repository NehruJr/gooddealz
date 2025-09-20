import 'product_model.dart';

class PurchaseCodeModel {
  List<PurchaseCode>? data;
  String? message;
  int? status;

  PurchaseCodeModel({this.data, this.message, this.status});

  PurchaseCodeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PurchaseCode>[];
      json['data'].forEach((v) {
        data!.add(PurchaseCode.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class PurchaseCode {
  String? orderNum;
  String? code;
  ProductDetails? productDetails;

  PurchaseCode({this.orderNum, this.code, this.productDetails});

  PurchaseCode.fromJson(Map<String, dynamic> json) {
    orderNum = json['order_num'];
    code = json['code'];
    productDetails = json['product_details'] != null
        ? ProductDetails.fromJson(json['product_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_num'] = orderNum;
    data['code'] = code;
    if (productDetails != null) {
      data['product_details'] = productDetails!.toJson();
    }
    return data;
  }
}