import '../../core/constants/app_endpoints.dart';

class UserModel {
  Data? data;
  String? message;
  int? status;

  UserModel({this.data, this.message, this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
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
  User? user;
  String? accessToken;

  Data({this.user, this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['access_token'] = accessToken;
    return data;
  }
}

class User {
  int? id;
  int? verified;
  String? fullName;
  // String? lastName;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? avatar;
  String? birthDate;
  String? nationality;
  String? lastLoginAt;

  User(
      {this.id,
        this.verified,
        this.fullName,
        // this.lastName,
        this.name,
        this.email,
        this.phone,
        this.gender,
        this.avatar,
        this.birthDate,
        this.nationality,
        this.lastLoginAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    // lastName = json['last_name'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    if (json['avatar'] == null) {
      avatar = null;
    } else {
      avatar = json['avatar'].startsWith('https') ? json['avatar'] : '${AppEndpoints.imageUrl}/' + json['avatar'];
    }
    birthDate = json['birth_date'];
    verified = json['verified'];
    nationality = json['nationality'];
    lastLoginAt = json['last_login_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    // data['last_name'] = lastName;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    data['avatar'] = avatar;
    data['birth_date'] = birthDate;
    data['verified'] = verified;
    data['nationality'] = nationality;
    data['last_login_at'] = lastLoginAt;
    return data;
  }
}