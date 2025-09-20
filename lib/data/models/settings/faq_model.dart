class FaqsModel {
  List<Faq>? faqs;
  String? message;
  int? status;

  FaqsModel({this.faqs, this.message, this.status});

  FaqsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      faqs = <Faq>[];
      json['data'].forEach((v) {
        faqs!.add(Faq.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (faqs != null) {
      data['data'] = faqs!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class Faq {
  int? id;
  String? question;
  String? answer;
  bool isExpanded = false;

  Faq({this.id, this.question, this.answer, this.isExpanded = false,});

  Faq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}