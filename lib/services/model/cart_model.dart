class CartItem {
  final int id;
  final String name;
  final String category;
  final String logo;
  final double price;
  final String? volume;

  int quantity;

  final int counterId;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.logo,
    required this.price,
    this.volume,
     required this.counterId,
    this.quantity = 1,
  });
}