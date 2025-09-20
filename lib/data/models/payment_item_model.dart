class PaymentItem {
  final String id;
  final String description;
  double price;
  final int quantity;
  final String imageUrl;
  final double total;

  PaymentItem(
      {required this.id,
      required this.description,
      required this.price,
      required this.quantity,
      required this.imageUrl,
      required this.total});

  PaymentItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json["description"],
        price = json["price"],
        quantity = json["quantity"],
        imageUrl = json["imageUrl"],
        total = json["total"];

  Map<String, dynamic> toJson(){
    return {
        "id": id,
        "description": description,
        "price": price,
        "quantity": quantity,
        "imageUrl": imageUrl,
        "total": total
    };
  }
}
