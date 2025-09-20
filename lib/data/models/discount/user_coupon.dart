import 'coupon_model.dart';

class UserCouponModel {
  Data? data;
  String? message;
  int? status;

  UserCouponModel({this.data, this.message, this.status});

  UserCouponModel.fromJson(Map<String, dynamic> json) {
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

    if (json['special coupons'] != null) {
      coupons = <Coupon>[];
      json['special coupons'].forEach((v) {
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