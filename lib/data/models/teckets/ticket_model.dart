class TicketModel {
  List<Ticket>? tickets;
  String? message;
  int? status;

  TicketModel({this.tickets, this.message, this.status});

  TicketModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      tickets = <Ticket>[];
      json['data'].forEach((v) {
        tickets!.add(Ticket.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tickets != null) {
      data['data'] = tickets!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class Ticket {
  int? id;
  String? title;
  String? description;
  int? purchaseCodeId;
  String? createdAt;
  List<Replies>? replies;

  Ticket(
      {this.id,
        this.title,
        this.description,
        this.purchaseCodeId,
        this.createdAt,
        this.replies});

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    purchaseCodeId = json['purchase_code_id'];
    createdAt = json['created_at'];
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['purchase_code_id'] = purchaseCodeId;
    data['created_at'] = createdAt;
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Replies {
  int? id;
  String? message;
  int? userId;
  String? userType;
  String? createdAt;

  Replies({this.id, this.message, this.userId, this.userType, this.createdAt});

  Replies.fromJson(Map<String, dynamic> json) {
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