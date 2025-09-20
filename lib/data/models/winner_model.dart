import '../../core/constants/app_endpoints.dart';

class PrizeModel {
  Data? data;
  String? message;
  int? status;

  PrizeModel({this.data, this.message, this.status});

  PrizeModel.fromJson(Map<String, dynamic> json) {
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
  List<Prize>? prizes;

  Data({this.prizes});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['prizes'] != null) {
      prizes = <Prize>[];
      json['prizes'].forEach((v) {
        prizes!.add(Prize.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (prizes != null) {
      data['prizes'] = prizes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Prize {
  int? id;
  String? slug;
  String? title;
  String? description;
  String? image;
  String? cover;
  String? coverText;
  String? video;
  String? videoBrief;
  Product? product;
  Winner? winner;

  Prize(
      {this.id,
        this.slug,
        this.title,
        this.description,
        this.image,
        this.cover,
        this.coverText,
        this.product,
        this.video,
        this.videoBrief,
        this.winner});

  Prize.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    title = json['title'];
    description = json['description'];
    image = json['image'] == null ? null : '${AppEndpoints.baseUrl}/' + json['image'];
    cover = json['cover'] == null ? null : '${AppEndpoints.baseUrl}/' + json['cover'];
    coverText = json['cover_text'];
    videoBrief = json['video_brief'];
    video = json['video'] == null ? null : '${AppEndpoints.imageUrl}/' + json['video'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    winner =
    json['winner'] != null ? Winner.fromJson(json['winner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['cover'] = cover;
    data['video'] = video;
    data['video_brief'] = videoBrief;
    data['cover_text'] = coverText;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (winner != null) {
      data['winner'] = winner!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? title;
  String? description;
  String? price;
  String? image;
  String? salesPercentage;
  int? quantity;
  int? quantitySold;
  int? prizeId;

  Product(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.image,
        this.salesPercentage,
        this.quantity,
        this.quantitySold,
        this.prizeId});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    salesPercentage = json['sales_percentage'];
    quantity = json['quantity'];
    quantitySold = json['quantity_sold'];
    prizeId = json['prize_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['image'] = image;
    data['sales_percentage'] = salesPercentage;
    data['quantity'] = quantity;
    data['quantity_sold'] = quantitySold;
    data['prize_id'] = prizeId;
    return data;
  }
}

class Winner {
  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? avatar;
  String? birthDate;
  String? nationality;
  String? lastLoginAt;

  Winner(
      {this.id,
        this.firstName,
        this.lastName,
        this.name,
        this.email,
        this.phone,
        this.gender,
        this.avatar,
        this.birthDate,
        this.nationality,
        this.lastLoginAt});

  Winner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    avatar = json['avatar'] == null ? null : '${AppEndpoints.imageUrl}/' + json['avatar'];
    birthDate = json['birth_date'];
    nationality = json['nationality'];
    lastLoginAt = json['last_login_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    data['avatar'] = avatar;
    data['birth_date'] = birthDate;
    data['nationality'] = nationality;
    data['last_login_at'] = lastLoginAt;
    return data;
  }
}