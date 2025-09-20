class WalletModel {
  Data? data;
  String? message;
  int? status;

  WalletModel({this.data, this.message, this.status});

  WalletModel.fromJson(Map<String, dynamic> json) {
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
  MyWallet? myWallet;

  Data({this.myWallet});

  Data.fromJson(Map<String, dynamic> json) {
    myWallet = json['my_wallet'] != null
        ? MyWallet.fromJson(json['my_wallet'])
        : json['balance'] != null ? MyWallet.fromJson(json) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (myWallet != null) {
      data['my_wallet'] = myWallet!.toJson();
    }
    return data;
  }
}

class MyWallet {
  int? balance;

  MyWallet({this.balance});

  MyWallet.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    return data;
  }
}