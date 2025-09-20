class TermsModel {
  Data? data;
  String? message;
  int? status;

  TermsModel({this.data, this.message, this.status});

  TermsModel.fromJson(Map<String, dynamic> json) {
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
  String? termsAndConditions;

  Data({this.termsAndConditions});

  Data.fromJson(Map<String, dynamic> json) {
    termsAndConditions = json['terms_and_conditions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['terms_and_conditions'] = termsAndConditions;
    return data;
  }
}