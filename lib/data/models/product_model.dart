import 'package:goodealz/core/constants/app_endpoints.dart';
import 'package:goodealz/views/widgets/carousal_widget.dart';

import 'tags_model.dart';

class ProductModel {
  Data? data;
  String? message;
  int? status;

  ProductModel({this.data, this.message, this.status});

  ProductModel.fromJson(Map<String, dynamic> json) {
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
  List<ProductDetails>? products;

  Data({this.products});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <ProductDetails>[];
      json['products'].forEach((v) {
        products!.add(ProductDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  List<ProductDetails>? data;
  Meta? meta;

  Products({this.data, this.meta});

  Products.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProductDetails>[];
      json['data'].forEach((v) {
        data!.add(ProductDetails.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class ProductDetails {
  int? id;
  String? title;
  String? description;
  String? price;
  String? currency;
  String? image;
  String? salesPercentage;
  String? withdrawalStartTime;
  int? withdrawalStartHours;
  int? withdrawalStartDays;
  int? quantity;
  int? quantitySold;
  int? prizeId;
  int? quantityInOrder;
  ProductPrize? prize;
  List<MediaItem>? productImages;

  ProductDetails({
    this.id,
    this.title,
    this.description,
    this.price,
    this.currency,
    this.image,
    this.salesPercentage,
    this.withdrawalStartTime,
    this.withdrawalStartHours,
    this.withdrawalStartDays,
    this.prizeId,
    this.quantity,
    this.quantitySold,
    this.prize,
    this.quantityInOrder,
    this.productImages,
  });

  ProductDetails.fromJson(Map<String, dynamic> json) {
    print(
      "logg ${json['product_images']}",
    );
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    currency = json['currency'];
    image = json['image'] == null
        ? null
        : '${AppEndpoints.baseUrl}/' + json['image'];
    salesPercentage = json['sales_percentage'];
    withdrawalStartTime = json['withdrawal_start_time'];
    withdrawalStartHours = json['withdrawal_start_hours'];
    withdrawalStartDays = json['withdrawal_start_days'];
    quantity = json['quantity'];
    quantitySold = json['quantity_sold'];
    prizeId = json['prize_id'];
    quantityInOrder = json['quantity_in_order'];
    prize = json['prize'] != null ? ProductPrize.fromJson(json['prize']) : null;
    productImages = [];
    if (json['product_images'] != null) {
      productImages = (json['product_images'] as List)
          .map((item) => MediaItem(
                url: item['url'] ?? '',
                isVideo: item['is_video'] == true,
                thumbnailUrl: item['thumbnail_url'],
              ))
          .toList();
      productImages!.add(MediaItem(
        url: "https://www.w3schools.com/tags/mov_bbb.mp4",
        isVideo: true,
        thumbnailUrl:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/WhatCarCanYouGetForAGrand.jpg",
      ));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['currency'] = currency;
    data['image'] = image;
    data['sales_percentage'] = salesPercentage;
    data['withdrawal_start_time'] = withdrawalStartTime;
    data['withdrawal_start_hours'] = withdrawalStartHours;
    data['withdrawal_start_days'] = withdrawalStartDays;
    data['quantity'] = quantity;
    data['quantity_sold'] = quantitySold;
    data['prize_id'] = prizeId;
    data['quantity_in_order'] = quantityInOrder;
    data['product_images'] = productImages;
    if (prize != null) {
      data['prize'] = prize!.toJson();
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDetails &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ProductPrize {
  int? id;
  String? slug;
  String? title;
  String? description;
  String? image;
  String? cover;
  String? coverText;
  ProductWinner? winner;
  List<Tags>? tags;

  ProductPrize({
    this.id,
    this.slug,
    this.title,
    this.description,
    this.image,
    this.cover,
    this.coverText,
    this.tags,
    this.winner,
  });

  ProductPrize.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    title = json['title'];
    description = json['description'];
    image = json['image'] == null
        ? null
        : '${AppEndpoints.baseUrl}/' + json['image'];
    cover = json['cover'] == null
        ? null
        : '${AppEndpoints.baseUrl}/' + json['cover'];
    coverText = json['cover_text'];
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
    winner =
        json['winner'] != null ? ProductWinner.fromJson(json['winner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['cover'] = cover;
    data['cover_text'] = coverText;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    if (winner != null) {
      data['winner'] = winner!.toJson();
    }
    return data;
  }
}

class ProductWinner {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? gender;
  String? avatar;
  String? birthDate;
  String? nationality;
  String? lastLoginAt;
  int? couponsCount;

  ProductWinner(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.gender,
      this.avatar,
      this.birthDate,
      this.nationality,
      this.lastLoginAt,
      this.couponsCount});

  ProductWinner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    avatar = json['avatar'];
    birthDate = json['birth_date'];
    nationality = json['nationality'];
    lastLoginAt = json['last_login_at'];
    couponsCount = json['coupons_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    data['avatar'] = avatar;
    data['birth_date'] = birthDate;
    data['nationality'] = nationality;
    data['last_login_at'] = lastLoginAt;
    data['coupons_count'] = couponsCount;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
      this.from,
      this.lastPage,
      this.path,
      this.perPage,
      this.to,
      this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];

    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['from'] = from;
    data['last_page'] = lastPage;

    data['path'] = path;
    data['per_page'] = perPage;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}
