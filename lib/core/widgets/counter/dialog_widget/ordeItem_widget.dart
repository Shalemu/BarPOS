import 'package:flutter/material.dart';

class OrderItemsSection extends StatelessWidget {
  final List items;

  const OrderItemsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Order Items",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        ...items.map((item) {
          final qty = item['itemQty'] ?? 0;
          final price = item['itemPrice'] ?? 0;
          final total = qty * price;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item['logo'] ?? '',
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 55,
                      height: 55,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.fastfood),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['itemName'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text("$qty x $price"),
                    ],
                  ),
                ),

                Text(
                  "TZS $total",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}