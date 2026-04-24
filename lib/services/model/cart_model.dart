class CartItem {
  final int id;
  final String name;
  final String category;
  final String logo;
  final double price;
  final String? volume;

  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.logo,
    required this.price,
    this.volume,
    this.quantity = 1,
  });
}