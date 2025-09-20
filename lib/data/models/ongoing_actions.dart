import '../../core/constants/app_endpoints.dart';

class OngoingActions {
  Data? data;
  String? message;
  int? status;

  OngoingActions({this.data, this.message, this.status});

  OngoingActions.fromJson(Map<String, dynamic> json) {
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
  List<Auctions>? auctions;

  Data({this.auctions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['auctions'] != null) {
      auctions = <Auctions>[];
      json['auctions'].forEach((v) {
        auctions!.add(Auctions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (auctions != null) {
      data['auctions'] = auctions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Auctions {
  int? id;
  String? title;
  String? description;
  String? price;
  int? quantity;
  int? quantitySold;
  String? image;
  String? salesPercentage;
  String? withdrawalStartTime;
  int? withdrawalStartHour;
  int? withdrawalStartDay;
  int? prizeId;

  Auctions(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.quantity,
        this.quantitySold,
        this.image,
        this.salesPercentage,
        this.withdrawalStartTime,
        this.withdrawalStartDay,
        this.withdrawalStartHour,
        this.prizeId});

  Auctions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    quantity = json['quantity'];
    quantitySold = json['quantity_sold'];
    image = json['image'] == null ? null : '${AppEndpoints.baseUrl}/' + json['image'];
    salesPercentage = json['sales_percentage'];
    withdrawalStartTime = json['withdrawal_start_time'];
    withdrawalStartHour = json['withdrawal_start_hours'];
    withdrawalStartDay = json['withdrawal_start_days'];
    prizeId = json['prize_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['quantity'] = quantity;
    data['quantity_sold'] = quantitySold;
    data['image'] = image;
    data['sales_percentage'] = salesPercentage;
    data['withdrawal_start_time'] = withdrawalStartTime;
    data['prize_id'] = prizeId;
    return data;
  }
}