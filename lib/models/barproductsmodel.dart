class Barproducts {
  final String id;
  final String catSelected;
  final String barName;
  final String otherProductName;
  final String productPrice;
  final String barManagerUserName;

  Barproducts(
      {required this.id,
      required this.catSelected,
      required this.barName,
      required this.otherProductName,
      required this.productPrice,
      required this.barManagerUserName});

  factory Barproducts.fromJson(Map<String, dynamic> json) {
    return Barproducts(
        id: json['_id'] ?? '',
        catSelected: json['catSelected'] ?? "",
        barName: json['barName'] ?? "",
        otherProductName: json['otherProductName'] ?? "",
        productPrice: json['productPrice'] ?? "",
        barManagerUserName: json['barManagerUserName'] ?? "");
  }
}
