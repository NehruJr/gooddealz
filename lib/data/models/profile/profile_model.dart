class ProfileModel {
  Data? data;
  String? message;
  int? status;

  ProfileModel({this.data, this.message, this.status});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  UserProfile? user;

  Data({this.user});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserProfile.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class UserProfile {
  int? id;
  String? name;
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
  List<Order>? order;

  UserProfile(
      {this.id,
        this.name,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.gender,
        this.avatar,
        this.birthDate,
        this.nationality,
        this.lastLoginAt,
        this.couponsCount,
        this.order});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
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
    if (json['order'] != null) {
      order = <Order>[];
      json['order'].forEach((v) {
        order!.add(Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
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
    if (order != null) {
      data['order'] = order!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int? id;
  String? orderNumber;
  int? clientId;
  int? discountId;
  String? discountAmount;
  String? subTotal;
  String? shippingFee;
  String? total;
  String? status;
  int? paymentStatus;
  String? paymentMethod;
  String? address;
  int? countryId;
  int? cityId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Order(
      {this.id,
        this.orderNumber,
        this.clientId,
        this.discountId,
        this.discountAmount,
        this.subTotal,
        this.shippingFee,
        this.total,
        this.status,
        this.paymentStatus,
        this.paymentMethod,
        this.address,
        this.countryId,
        this.cityId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    clientId = json['client_id'];
    discountId = json['discount_id'];
    discountAmount = json['discount_amount'];
    subTotal = json['sub_total'].toString();
    shippingFee = json['shipping_fee'].toString();
    total = json['total'].toString();
    status = json['status'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    address = json['address'];
    countryId = json['country_id'];
    cityId = json['city_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_number'] = orderNumber;
    data['client_id'] = clientId;
    data['discount_id'] = discountId;
    data['discount_amount'] = discountAmount;
    data['sub_total'] = subTotal;
    data['shipping_fee'] = shippingFee;
    data['total'] = total;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    data['payment_method'] = paymentMethod;
    data['address'] = address;
    data['country_id'] = countryId;
    data['city_id'] = cityId;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}