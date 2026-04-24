class CounterModel {
  final int id;
  final String name;

  CounterModel({
    required this.id,
    required this.name,
  });

  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}