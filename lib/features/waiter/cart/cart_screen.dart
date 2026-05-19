import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/top_notification.dart';
import 'package:barpos/core/widgets/waiter/cart_item_card.dart';
import 'package:barpos/features/waiter/home/home_controller.dart';
import 'package:barpos/features/waiter/orders/orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'cart_controller.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController controller = Get.find<CartController>();
  final WaiterHomeController homeController = Get.find<WaiterHomeController>();
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
          color: active || isAdd ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0");
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your cart is empty",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Add items to continue",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            /// ================= ITEMS =================
         ListView.builder(
  padding: const EdgeInsets.fromLTRB(
    16,
    10,
    16,
    160,
  ),
  itemCount: controller.cartItems.length,
  itemBuilder: (context, index) {

    final item = controller.cartItems[index];

    return CartItemCard(
      item: item,
      controller: controller,

      onIncrease: () {
        final product =
            homeController.products.firstWhere(
          (p) =>
              p.uniqueId ==
              item.uniqueId,
        );

        controller.increaseQty(
          context,
          item.uniqueId,
          product,
        );
      },
    );
  },
),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE9EBF0))),
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
                    /// TOTAL CARD (like your sheet style)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7FB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE6E8EF)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          Obx(
                            () => Text(
                              "TZS ${currencyFormat.format(controller.totalPrice)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// TABLE INPUT (clean style)
                    TextField(
                      controller: tableController,
                      decoration: InputDecoration(
                        hintText: "Table number ",
                        prefixIcon: const Icon(Icons.table_bar_outlined),
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Obx(() {
                        final loading = ordersController.isLoading.value;

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: loading
                              ? null
                              : () async {
                                  final tableRef = tableController.text.trim();

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
                                        tableRef: tableRef,
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
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    color: Colors.white,
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
