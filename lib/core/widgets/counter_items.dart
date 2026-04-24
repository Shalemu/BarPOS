import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/features/cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barpos/features/home/home_controller.dart';

class CounterItemsWidget extends StatelessWidget {
  const CounterItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    final categories = ["All", "Food", "Beer", "Spirits", "Soft Drinks"];

    return Column(
      children: [
        const SizedBox(height: 20),

        /// SEARCH BAR
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Text("Search menu...", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// CATEGORIES
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Obx(() {
                final selected = controller.selectedCategory.value == index;

                return GestureDetector(
                  onTap: () => controller.selectedCategory.value = index,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: selected ? Colors.black : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),

        const SizedBox(height: 12),

        /// PRODUCTS GRID
        Expanded(
          child: Obx(() {
            if (controller.products.isEmpty) {
              return const Center(child: Text("No products found"));
            }

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final item = controller.products[index];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: Container(
                          height: 90,
                          width: double.infinity,
                          color: Colors.grey.shade100,
                          child: Image.network(
                            item.logo,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image),
                          ),
                        ),
                      ),

                      /// CONTENT
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// NAME
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// PRICE
                            Text(
                              "TZS ${item.price}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// STOCK
                            Text(
                              "Available: ${item.availableQty}",
                              style: TextStyle(
                                fontSize: 11,
                                color: item.availableQty < 5
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),

                            Text(
                              "Volume: ${item.volume}",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Obx(() {
                              final cartController = Get.find<CartController>();

                              final cartItem = cartController.cartItems
                                  .firstWhereOrNull((e) => e.id == item.id);

                              final qty = cartItem?.quantity ?? 0;

                              ///  ADD BUTTON
                              if (qty == 0) {
                                return GestureDetector(
                                  onTap: () {
                                   cartController.addToCart(item);
                                  },
                                  child: Container(
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "Add",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              /// ➖ + QTY CONTROL
                              return Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    /// MINUS
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        onTap: () {
                                          cartController.decreaseQty(item.id);
                                        },
                                        child: const SizedBox(
                                          width: 36,
                                          height: 36,
                                          child: Icon(Icons.remove, size: 18),
                                        ),
                                      ),
                                    ),

                                    /// QTY
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "$qty",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// PLUS
                                    Material(
                                      color: Colors.black,
                                      child: InkWell(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        onTap: () {
                                          final product = controller.products
                                              .firstWhere(
                                                (p) => p.id == item.id,
                                              );

                                          final msg = cartController
                                              .increaseQty(item.id, product);

                                          if (msg != null) {
                                            Get.snackbar(
                                              "Stock Limit",
                                              msg,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                            );
                                          }
                                        },
                                        child: const SizedBox(
                                          width: 36,
                                          height: 36,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
