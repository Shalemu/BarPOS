import 'package:flutter/material.dart';

class OrderHelpers {

  static Widget headerInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  static int getTotalItems(List items) {
    return items.fold<int>(
      0,
      (sum, item) => sum + ((item['itemQty'] ?? 0) as int),
    );
  }


  static double getTotalAmount(List items) {
    return items.fold<double>(
      0,
      (sum, item) =>
          sum + ((item['itemQty'] ?? 0) * (item['itemPrice'] ?? 0)),
    );
  }
}