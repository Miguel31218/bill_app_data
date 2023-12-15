class BillModel {
  int? id;
  String product;
  double price;
  String type;

  BillModel({
    this.id,
    required this.product,
    required this.price,
    required this.type,
  });
  convertirAMap() => {
        "product": product,
        "price": price,
        "type": type,
      };

  Map<String, dynamic> toJson() => {
        "product": product,
        "price": price,
        "type": type,
      };

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
        id: json["id"],
        product: json["product"],
        price: double.parse(json["price"].toString()),
        type: json["type"],
      );
}
