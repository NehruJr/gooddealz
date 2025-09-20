
import '../product_model.dart';

class CartModel {
  Data? data;
  String? message;
  int? status;

  CartModel({this.data, this.message, this.status});

  CartModel.fromJson(Map<String, dynamic> json) {
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
  List<Cart>? carts;

  Data({this.carts});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      carts = <Cart>[];
      json['cart'].forEach((v) {
        carts!.add(Cart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (carts != null) {
      data['cart'] = carts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cart{
  int? id;
  String? price;
  int? quantity;
  ProductDetails? product;

  Cart({this.id, this.price, this.quantity, this.product});

  Cart.fromJson(Map<String, dynamic> json) {
    product = json['product'] != null ? ProductDetails.fromJson(json['product']) : null;
    id = json['id'];
    price = json['price'];
    quantity = json['quantity'];
}
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

      data['id'] = id;
    data['price'] = price;
    data['quantity'] = quantity;
    data['product'] = product;
    return data;
  }
}
