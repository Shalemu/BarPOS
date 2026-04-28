class OrderItem {
  final int id;
  final String name;
  final String logo;
  final double price;
  final int qty;
  final String category; 

  OrderItem({
    required this.id,
    required this.name,
    required this.logo,
    required this.price,
    required this.qty,
    required this.category,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['itemId'],
      name: json['itemName'] ?? '',
      logo: json['itemLogo'] ?? '',
      price: (json['itemPrice'] ?? 0).toDouble(),
      qty: json['itemQty'] ?? 1,
      category: json['itemCategory'] ?? 'product', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "itemId": id,
      "itemName": name,
      "itemCategory": category, 
      "itemLogo": logo,
      "itemPrice": price,
      "itemQty": qty,
    };
  }

  OrderItem copyWith({
    int? id,
    String? name,
    String? logo,
    double? price,
    int? qty,
    String? category,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      category: category ?? this.category,
    );
  }
}