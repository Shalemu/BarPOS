class OrderItem {
  final int id;
  final String name;
  final String logo;
  final double price;
  final int qty;

  OrderItem({
    required this.id,
    required this.name,
    required this.logo,
    required this.price,
    required this.qty,
  });

  /// from API / Map
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['itemId'],
      name: json['itemName'] ?? '',
      logo: json['itemLogo'] ?? '',
      price: (json['itemPrice'] ?? 0).toDouble(),
      qty: json['itemQty'] ?? 1,
    );
  }

  /// convert back for API submit
  Map<String, dynamic> toJson() {
    return {
      "itemId": id,
      "itemName": name,
      "itemLogo": logo,
      "itemPrice": price,
      "itemQty": qty,
    };
  }

  /// copyWith (VERY useful for updates)
  OrderItem copyWith({
    int? id,
    String? name,
    String? logo,
    double? price,
    int? qty,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      price: price ?? this.price,
      qty: qty ?? this.qty,
    );
  }
}