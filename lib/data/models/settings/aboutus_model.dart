class AboutUsModel {
  String? data;
  String? message;
  int? status;

  AboutUsModel({this.data, this.message, this.status});

  AboutUsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['data'] = data;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
