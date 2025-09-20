import '../../core/constants/app_endpoints.dart';

class Tags {
  int? id;
  String? title;
  String? image;

  Tags({this.id, this.title, this.image});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'] == null ? null : '${AppEndpoints.baseUrl}/' + json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    return data;
  }
}
