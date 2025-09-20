import '../city_model.dart';
import '../discount/coupon_model.dart';
import '../product_model.dart';
import '../purchase_code_model.dart';

class OrderModel {
  Data? data;
  String? message;
  int? status;

  OrderModel({this.data, this.message, this.status});

  OrderModel.fromJson(Map<String, dynamic> json) {
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
  List<Orders>? orders;
  Pagination? pagination;
  Orders? orderDetails;

  Data({this.orders, this.orderDetails, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
    orderDetails = json['order'] != null ? Orders.fromJson(json['order']) : null;
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? id;
  String? orderNumber;
  num? discountAmount;
  String? subTotal;
  num? shippingFee;
  num? total;
  String? status;
  int? paymentStatus;
  String? paymentMethod;
  String? address;
  Coupon? discount;
  City? city;
  List<ProductDetails>? products;
  List<PurchaseCode>? purchaseCodes;

  Orders(
      {this.id,
        this.orderNumber,
        this.discountAmount,
        this.subTotal,
        this.shippingFee,
        this.total,
        this.status,
        this.paymentStatus,
        this.paymentMethod,
        this.address,
        this.discount,
        this.city,
        this.purchaseCodes,
        this.products});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    discountAmount = json['discount_amount'].runtimeType == String ? double.parse(json['discount_amount']) : json['discount_amount'];
    subTotal = json['sub_total'].toString();
    shippingFee = json['shipping_fee'].runtimeType == String ? double.parse(json['shipping_fee']) : json['shipping_fee'];
    total = json['total'].runtimeType == String ? double.parse(json['total']) : json['total'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    address = json['address'];
    discount = json['discount'] != null ? Coupon.fromJson(json['discount']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    if (json['products'] != null) {
      products = <ProductDetails>[];
      json['products'].forEach((v) {
        products!.add(ProductDetails.fromJson(v));
      });
    }
    if (json['purchase_codes'] != null) {
      purchaseCodes = <PurchaseCode>[];
      json['purchase_codes'].forEach((v) {
        purchaseCodes!.add(PurchaseCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_number'] = orderNumber;
    data['discount_amount'] = discountAmount;
    data['sub_total'] = subTotal;
    data['shipping_fee'] = shippingFee;
    data['total'] = total;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    data['payment_method'] = paymentMethod;
    data['address'] = address;
    data['discount'] = discount;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class City {
//   int? id;
//   String? name;
//   Country? country;
//
//   City({this.id, this.name, this.country});
//
//   City.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     country =
//     json['country'] != null ? Country.fromJson(json['country']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     if (country != null) {
//       data['country'] = country!.toJson();
//     }
//     return data;
//   }
// }
//
// class Country {
//   int? id;
//   String? name;
//   String? countryCode;
//   String? lat;
//   String? lng;
//   String? isDefault;
//
//   Country(
//       {this.id,
//         this.name,
//         this.countryCode,
//         this.lat,
//         this.lng,
//         this.isDefault});
//
//   Country.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     countryCode = json['country_code'];
//     lat = json['lat'];
//     lng = json['lng'];
//     isDefault = json['is_default'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['country_code'] = countryCode;
//     data['lat'] = lat;
//     data['lng'] = lng;
//     data['is_default'] = isDefault;
//     return data;
//   }
// }

class Pagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Pagination({this.total, this.perPage, this.currentPage, this.lastPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['per_page'] = perPage;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    return data;
  }
}


