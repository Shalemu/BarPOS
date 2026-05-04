class CartItem {
  final String uniqueId; 
  final int id;
  final String name;
  final String category;
  final String logo;
  final double price;
  final String? volume;

  int quantity;
  int remainingQty; 
  final int counterId;

  CartItem({
    required this.uniqueId,
    required this.id,
    required this.name,
    required this.category,
    required this.logo,
    required this.price,
    this.volume,
    required this.counterId,
    this.quantity = 1,
    required this.remainingQty,
  });
}