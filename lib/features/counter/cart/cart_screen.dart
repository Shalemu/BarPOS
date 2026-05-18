import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/top_notification.dart';
import 'package:barpos/features/counter/cart/cart_controller.dart';
import 'package:barpos/features/waiter/orders/orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController controller = Get.find<CartController>();
  final OrdersController ordersController = Get.find<OrdersController>();

  final TextEditingController tableController = TextEditingController();

  Widget _qtyBtn(
    IconData icon,
    VoidCallback onTap, {
    bool active = false,
    bool isAdd = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary
              : isAdd
              ? AppColors.primary
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 16,
          color: (active || isAdd) ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0");
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  "Cart is empty",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                Text("Add products to continue"),
              ],
            ),
          );
        }

        return Stack(
          children: [
            /// ================= LIST =================
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 220),
              itemCount: controller.cartItems.length,
              itemBuilder: (context, index) {
                final item = controller.cartItems[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      /// IMAGE
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          item.logo,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.category,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "TZS ${item.price}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// QTY CONTROL
                      Container(
                        height: 34,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// MINUS
                            _qtyBtn(
                              Icons.remove,
                              () => controller.decreaseQty(
                                context,
                                item.uniqueId,
                              ),
                            ),

                            /// QTY
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Obx(() {
                                final cartItem = controller.cartItems
                                    .firstWhere(
                                      (e) => e.uniqueId == item.uniqueId,
                                    );

                                return Text(
                                  "${cartItem.quantity}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                            ),

                            /// PLUS
                            _qtyBtn(
                              Icons.add,
                              () => controller.increaseQty(
                                context,
                                item.uniqueId,
                              ),
                              isAdd: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            /// ================= BOTTOM PANEL =================
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// TOTAL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Obx(() {
                          return Text(
                            "TZS ${currencyFormat.format(controller.totalPrice)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// TABLE INPUT
                    TextField(
                      controller: tableController,
                      decoration: InputDecoration(
                        hintText: "Table number",
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// SUBMIT BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Obx(() {
                        final loading = ordersController.isLoading.value;

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: loading
                              ? null
                              : () async {
                                  final items = controller.cartItems.map((
                                    item,
                                  ) {
                                    return {
                                      "itemId": item.id,
                                      "itemCategory": item.category,
                                      "itemQty": item.quantity,
                                    };
                                  }).toList();

                                  final result = await ordersController
                                      .submitOrder(
                                        tableRef: tableController.text.trim(),
                                        items: items,
                                      );

                                  if (result == null) {
                                    controller.clearCart();
                                    tableController.clear();

                                    TopNotification.show(
                                      context,
                                      message: "Order placed successfully",
                                      color: Colors.green,
                                      icon: Icons.check_circle,
                                      seconds: 4,
                                    );
                                  } else {
                                    TopNotification.show(
                                      context,
                                      message: result,
                                      color: Colors.red,
                                      icon: Icons.error,
                                       seconds: 4,
                                    );
                                  }
                                },
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : const Text(
                                  "SUBMIT ORDER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
