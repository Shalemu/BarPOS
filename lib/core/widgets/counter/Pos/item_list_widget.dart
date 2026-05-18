import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/dot_loader.dart';
import 'package:barpos/core/widgets/top_notification.dart';
import 'package:barpos/features/counter/Pos/counter_list_controller.dart';
import 'package:barpos/features/counter/cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterItemsWidget extends StatelessWidget {
  const CounterItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounterListController>();

    return Column(
      children: [
        const SizedBox(height: 20),

        // SEARCH BAR
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (value) => controller.setProductSearch(value),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search product...",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // CATEGORY FILTER
        Obx(() {
          final categories = controller.categories;

          return SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                final isSelected =
                    controller.selectedCategory.value.toLowerCase().trim() ==
                    category.toLowerCase().trim();

                return GestureDetector(
                  onTap: () => controller.changeCategory(category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),

                    alignment: Alignment.center,

                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),

        const SizedBox(height: 12),

        // PRODUCTS GRID
        Expanded(
          child: Obx(() {
            if (controller.isLoadingProducts.value) {
              return const Center(child: DotLoader());
            }

            if (controller.filteredProducts.isEmpty) {
              return const Center(child: Text("No products found"));
            }

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final item = controller.filteredProducts[index];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// ---------------- IMAGE INNER CARD ----------------
                      Container(
                        height: 110,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            item.logo,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image),
                          ),
                        ),
                      ),

                      /// ---------------- CONTENT ----------------
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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

                            Text(
                              "TZS ${item.price}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Stock: ${item.availableQty}",
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

                            /// ---------------- CART BUTTON ----------------
                            Obx(() {
                              final cartController = Get.find<CartController>();

                              final cartItem = cartController.cartItems
                                  .firstWhereOrNull(
                                    (e) => e.uniqueId == item.uniqueId,
                                  );

                              final qty = cartItem?.quantity ?? 0;

                              if (qty == 0) {
                                return GestureDetector(
                                  onTap: () {
                                    final msg = cartController.addToCart(
                                      context,
                                      item,
                                    );

                                    if (msg != null) {
                                      TopNotification.show(
                                        context,
                                        message: msg,
                                        color: Colors.red,
                                        icon: Icons.warning,
                                        seconds: 4,
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(12),
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
                                          SizedBox(width: 6),
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

                              return Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => cartController.decreaseQty(
                                        context,
                                        item.uniqueId,
                                      ),
                                      child: const SizedBox(
                                        width: 40,
                                        child: Icon(Icons.remove, size: 18),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "$qty",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => cartController.increaseQty(
                                        context,
                                        item.uniqueId,
                                      ),
                                      child: Container(
                                        width: 40,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 18,
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

                      const SizedBox(height: 10),
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
