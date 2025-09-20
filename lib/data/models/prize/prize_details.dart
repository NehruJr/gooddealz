import '../../../core/constants/app_endpoints.dart';
import '../product_model.dart';
import '../tags_model.dart';

class PrizeDetailsModel {
  Data? data;
  String? message;
  int? status;

  PrizeDetailsModel({this.data, this.message, this.status});

  PrizeDetailsModel.fromJson(Map<String, dynamic> json) {
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
  PrizeDetails? prize;

  Data({this.prize});

  Data.fromJson(Map<String, dynamic> json) {
    prize = json['prize'] != null ? PrizeDetails.fromJson(json['prize']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (prize != null) {
      data['prize'] = prize!.toJson();
    }
    return data;
  }
}

class PrizeDetails {
  int? id;
  String? slug;
  String? title;
  String? description;
  String? image;
  String? cover;
  String? coverText;
  List<ProductDetails>? products;
  List<Tags>? tags;

  PrizeDetails(
      {this.id,
      this.slug,
      this.title,
      this.description,
      this.image,
      this.cover,
      this.coverText,
      this.products});

  PrizeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    title = json['title'];
    description = json['description'];
    image =json['image'] == null ? null : '${AppEndpoints.baseUrl}/' + json['image'];
    cover = json['cover'] == null ? null : '${AppEndpoints.baseUrl}/' + json['cover'];
    coverText = json['cover_text'];
    if (json['product'] != null) {
      products = <ProductDetails>[];
      json['product'].forEach((v) {
        products!.add(ProductDetails.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
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
    if (products != null) {
      data['product'] = products!.map((v) => v.toJson()).toList();
    }
      if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}