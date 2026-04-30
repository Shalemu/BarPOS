import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/dot_loader.dart';
import 'package:barpos/core/widgets/top_notification.dart';
import 'package:barpos/features/cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barpos/features/home/home_controller.dart';

class CounterItemsWidget extends StatelessWidget {
  const CounterItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      children: [
        const SizedBox(height: 20),

        // SEARCH BAR
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (value) => controller.searchQuery.value = value,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search product...",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
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
            height: 42,
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
                  onTap: () {
                    controller.changeCategory(category);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,

                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),

                      border: isSelected
                          ? Border.all(color: Colors.black, width: 1)
                          : null,

                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
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
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final item = controller.filteredProducts[index];

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
                      // IMAGE
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

                      // CONTENT
                      Padding(
                        padding: const EdgeInsets.all(10),
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

                            // CART CONTROLS
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

                                    print(" ADD CLICKED");
                                    print("ID: ${item.id}");
                                    print("CATEGORY: ${item.category}");
                                    print("UNIQUE: ${item.uniqueId}");
                                    print(
                                      "CURRENT CART SIZE: ${cartController.cartItems.length}",
                                    );

                                    for (var c in cartController.cartItems) {
                                      print(
                                        "🛒 CART ITEM => ${c.uniqueId} | qty=${c.quantity}",
                                      );
                                    }

                                    if (msg != null) {
                                      TopNotification.show(
                                        context,
                                        message: msg,
                                        color: Colors.red,
                                        icon: Icons.warning,
                                        seconds: 5,
                                      );
                                    }
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

                              return Container(
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => cartController.decreaseQty(
                                          context,
                                          item.uniqueId,
                                        ),
                                        child: const SizedBox(
                                          width: 36,
                                          height: 36,
                                          child: Icon(Icons.remove, size: 18),
                                        ),
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

                                    Material(
                                      color: Colors.black,
                                      child: InkWell(
                                        onTap: () {
                                          final msg = cartController
                                              .increaseQty(
                                                context,
                                                item.uniqueId,
                                                item,
                                              );

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
