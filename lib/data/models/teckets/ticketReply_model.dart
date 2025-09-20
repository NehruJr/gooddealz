class ReplyModel {
  List<Reply>? replies;
  String? message;
  int? status;

  ReplyModel({this.replies, this.message, this.status});

  ReplyModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      replies = <Reply>[];
      json['data'].forEach((v) {
        replies!.add(Reply.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (replies != null) {
      data['data'] = replies!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class Reply {
  int? id;
  String? message;
  int? userId;
  String? userType;
  String? createdAt;

  Reply({this.id, this.message, this.userId, this.userType, this.createdAt});

  Reply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    userId = json['user_id'];
    userType = json['user_type'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['user_id'] = userId;
    data['user_type'] = userType;
    data['created_at'] = createdAt;
    return data;
  }
}