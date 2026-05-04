import 'package:barpos/services/model/product_model.dart';

class OrderItem {
  final int id;
  final String name;
  final String logo;
  final double price;
  final int qty;
  final String category;
  final int remainingQty;
 final String? volume;

  OrderItem({
    required this.id,
    required this.name,
    required this.logo,
    required this.price,
    required this.qty,
    required this.category,
    required this.remainingQty,
      this.volume,
  });

  String get uniqueId => "$category-$id";

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['itemId'] ?? json['id'],
      name: json['itemName'] ?? json['name'] ?? '',
      logo: json['itemLogo'] ?? json['logo'] ?? '',
      price: (json['itemPrice'] ?? json['price'] ?? 0).toDouble(),
      qty: json['itemQty'] ?? 1,
      category: json['itemCategory'] ?? json['category'] ?? 'product',
      remainingQty: json['remainingQty'] ?? 0,
        volume: json['volume']?.toString(),
    );
  }

  OrderItem copyWith({
    int? id,
    String? name,
    String? logo,
    double? price,
    int? qty,
    String? category,
    int? remainingQty,
    String? volume,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      category: category ?? this.category,
      remainingQty: remainingQty ?? this.remainingQty,
      volume: volume ?? this.volume,
    );
  }

  OrderItem enrichOrderItem(Map item, Map<int, ProductModel> productMap) {
    final product = productMap[item['itemId']];

    return OrderItem(
      id: item['itemId'],
      name: item['itemName'] ?? '',
      logo: item['itemLogo'] ?? '',
      price: (item['itemPrice'] ?? 0).toDouble(),
      qty: item['itemQty'] ?? 1,
      category: item['itemCategory'] ?? '',
      remainingQty: product?.availableQty ?? 0,
      volume: product?.volume ?? '',
    );
  }
}
