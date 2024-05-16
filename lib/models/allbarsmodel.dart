class Allbars {
  final String id;
  final String barName;
  final String barAddress;
  final String barState;
  final String barPhone;
  final String barImage;
  final String barManagerUserName;

  Allbars(
      {required this.id,
      required this.barName,
      required this.barAddress,
      required this.barState,
      required this.barPhone,
      required this.barImage,
      required this.barManagerUserName});

  factory Allbars.fromJson(Map<String, dynamic> json) {
    return Allbars(
        id: json['_id'] ?? '',
        barName: json['barName'] ?? "",
        barAddress: json['barAddress'] ?? "",
        barState: json['barState'] ?? "",
        barPhone: json['barPhone'] ?? "",
        barImage: json['barImage'] ?? "",
        barManagerUserName: json['barManagerUserName'] ?? "");
  }
}
