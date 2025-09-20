class NationalityModel {
  Data? data;
  String? message;
  int? status;

  NationalityModel({this.data, this.message, this.status});

  NationalityModel.fromJson(Map<String, dynamic> json) {
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
  List<Nationality>? nationalities;

  Data({this.nationalities});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['nationalities'] != null) {
      nationalities = <Nationality>[];
      json['nationalities'].forEach((v) {
        nationalities!.add( Nationality.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (nationalities != null) {
      data['nationalities'] =
          nationalities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Nationality {
  String? name;
  String? code;

  Nationality({this.name, this.code});

  Nationality.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['code'] = code;
    return data;
  }
}