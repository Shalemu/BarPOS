class CounterModel {
  final int id;
  final String name;
  final int pendingOrdersCount;

  CounterModel({
    required this.id,
    required this.name,
    required this.pendingOrdersCount,
  });

  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      pendingOrdersCount: json['pending_orders_count'] ?? 0,
    );
  }
}
