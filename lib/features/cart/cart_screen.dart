import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/top_notification.dart';
import 'package:barpos/features/home/home_controller.dart';
import 'package:barpos/features/orders/orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController controller = Get.find<CartController>();
  final HomeController homeController = Get.find<HomeController>();
  final OrdersController ordersController = Get.find<OrdersController>();
  final TextEditingController tableController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 90,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Your cart is empty",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Add items to submit your",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 140),
              itemCount: controller.cartItems.length,
              itemBuilder: (context, index) {
                final item = controller.cartItems[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item.logo,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// NAME + PRICE
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "TZS ${item.price}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            // MINUS
                            InkWell(
                              onTap: () => controller.decreaseQty(item.id),
                              child: const SizedBox(
                                width: 28,
                                child: Icon(
                                  Icons.remove,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            // QTY
                            Obx(() {
                              final qty = controller.cartItems
                                  .firstWhere((e) => e.id == item.id)
                                  .quantity;

                              return Text(
                                "$qty",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }),

                            InkWell(
                              onTap: () {
                                final product = homeController.products
                                    .firstWhere((p) => p.id == item.id);

                                final msg = controller.increaseQty(
                                  item.id,
                                  product,
                                );

                                if (msg != null) {
                                  Get.snackbar("Stock Limit", msg);
                                }
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            /// CHECKOUT BAR (PREMIUM UI)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE5E7EB), width: 0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// TOTAL ROW (PREMIUM)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Amount",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Obx(
                            () => Text(
                              "TZS ${controller.totalPrice.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// INPUT FIELD (PREMIUM)
                    TextField(
                      controller: tableController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Table number / reference",
                        prefixIcon: const Icon(
                          Icons.table_bar_outlined,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// BUTTON (PREMIUM)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Obx(() {
                        final loading = ordersController.isLoading.value;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: loading
                                ? null
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF111827),
                                      Color(0xFF1F2937),
                                    ],
                                  ),
                            color: loading ? Colors.grey.shade300 : null,
                          ),
                          child: ElevatedButton(
                            onPressed: loading
                                ? null
                                : () async {
                                    final tableRef = tableController.text
                                        .trim();

                                    if (tableRef.isEmpty) {
                                      TopNotification.show(
                                        context,
                                        message: "Table reference required",
                                        color: Colors.red,
                                        icon: Icons.error,
                                      );
                                      return;
                                    }

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
                                      );
                                    } else {
                                      TopNotification.show(
                                        context,
                                        message: result,
                                        color: Colors.red,
                                        icon: Icons.error,
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "SUBMIT ORDER",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
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
