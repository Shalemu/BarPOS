import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barpos/features/counter/cart/cart_controller.dart';

class CartItemCard extends StatelessWidget {
  final dynamic item;
  final CartController controller;

  const CartItemCard({super.key, required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentItem = controller.cartItems.firstWhereOrNull(
        (e) => e.uniqueId == item.uniqueId,
      );

      if (currentItem == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ================= IMAGE =================
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xFFF5F5F5),
              ),
              clipBehavior: Clip.antiAlias,
              child: currentItem.logo != null && currentItem.logo.isNotEmpty
                  ? Image.network(currentItem.logo, fit: BoxFit.cover)
                  : const Icon(Icons.fastfood, size: 28, color: Colors.grey),
            ),

            const SizedBox(width: 12),

            /// ================= INFO =================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME
                  Text(
                    currentItem.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// CATEGORY + PRICE ROW
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          currentItem.category,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        "TZS ${currentItem.price}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// AVAILABLE QTY
                  Text(
                    "Available: ${currentItem.remainingQty}",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F7FB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// MINUS
                      _qtyButton(
                        icon: Icons.remove,
                        color: Colors.white,
                        iconColor: Colors.black87,
                        onTap: () {
                          controller.decreaseQty(context, currentItem.uniqueId);
                        },
                      ),

                      const SizedBox(width: 8),

                      /// QTY
                      SizedBox(
                        width: 30,
                        child: Center(
                          child: Text(
                            "${currentItem.quantity}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      /// PLUS
                      _qtyButton(
                        icon: Icons.add,
                        color: Colors.black,
                        iconColor: Colors.white,
                        onTap: () {
                          controller.increaseQty(context, currentItem.uniqueId);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _qtyButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Center(child: Icon(icon, size: 16, color: iconColor)),
        ),
      ),
    );
  }
}
