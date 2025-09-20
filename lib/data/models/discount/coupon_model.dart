class CouponModel {
  Data? data;
  String? message;
  int? status;

  CouponModel({this.data, this.message, this.status});

  CouponModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class Data {
  Coupon? coupon;
  List<Coupon>? coupons;

  Data({this.coupon, this.coupons});

  Data.fromJson(Map<String, dynamic> json) {
    coupon =
    json['coupon'] != null ? Coupon.fromJson(json['coupon']) : null;

    if (json['coupons'] != null) {
      coupons = <Coupon>[];
      json['coupons'].forEach((v) {
        coupons!.add(Coupon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coupon != null) {
      data['coupon'] = coupon!.toJson();
    }
    return data;
  }
}

class Coupon {
  int? id;
  String? code;
  String? title;
  String? discountType;
  int? percent;
  double? amount;
  String? currency;
  int? numberOfUse;
  String? startAt;
  String? expiredAt;
  int? maxAmount;
  int? minimumOrder;
  int? forFirstPurchase;

  Coupon(
      {this.id,
        this.code,
        this.title,
        this.discountType,
        this.percent,
        this.amount,
        this.currency,
        this.numberOfUse,
        this.startAt,
        this.expiredAt,
        this.maxAmount,
        this.minimumOrder,
        this.forFirstPurchase});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    title = json['title'];
    discountType = json['discount_type'];
    percent = json['percentage'];
    amount = json['amount']?.toDouble();
    currency = json['currency'];
    numberOfUse = json['number_of_use'];
    startAt = json['start_at'];
    expiredAt = json['expired_at'];
    maxAmount = json['max_amount'];
    minimumOrder = json['minimum_order'];
    forFirstPurchase = json['for_first_purchase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['title'] = title;
    data['discount_type'] = discountType;
    data['percentage'] = percent;
    data['amount'] = amount;
    data['currency'] = currency;
    data['number_of_use'] = numberOfUse;
    data['start_at'] = startAt;
    data['expired_at'] = expiredAt;
    data['max_amount'] = maxAmount;
    data['minimum_order'] = minimumOrder;
    data['for_first_purchase'] = forFirstPurchase;
    return data;
  }
}