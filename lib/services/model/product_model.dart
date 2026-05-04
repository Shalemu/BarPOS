class ProductModel {
  final int id;
  final String name;
  final int price;
  final String logo;
  final String category;
  final String? volume;
  final int availableQty;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.logo,
    required this.category,
    this.volume,
    required this.availableQty,
  });

  String get uniqueId => "$category-$id";

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      logo: json['logo'] ?? '',
      category: json['category'],
      volume: json['volume']?.toString(),

      
      availableQty:
          json['availableQty'] ??
          json['stock'] ??
          0,
    );
  }
}