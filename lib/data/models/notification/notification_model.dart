import '../../../core/helper/functions/navigation_service.dart';
import '../../../core/ys_localizations/ys_localizations_provider.dart';

class NotificationModel {
  Data? data;
  String? message;
  int? status;

  NotificationModel({this.data, this.message, this.status});

  NotificationModel.fromJson(Map<String, dynamic> json) {
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
  List<Notifications>? notifications;

  Data({this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notifications != null) {
      data['notifications'] = notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  String? id;
  String? message;
  String? url;
  int? modalId;
  String? ticketId;
  String? modal;
  String? prizeSlug ;
  String? readAt;
  String? createdAt;

  Notifications(
      {this.id,
      this.message,
      this.url,
      this.modalId,
      this.modal,
      this.prizeSlug,
      this.readAt,
      this.createdAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'][
        YsLocalizationsProvider.listenFalse(NavigationService.currentContext)
            .languageCode];
    url = json['url'];
    modalId = json['modal_id'];
    ticketId = json['ticket_id'];
    modal = json['model'];
    prizeSlug = json['prize_slug'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['url'] = url;
    data['modal_id'] = modalId;
    data['ticket_id'] = ticketId;
    data['model'] = modal;
    data['prize_slug '] = prizeSlug;
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    return data;
  }
}
