import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/features/addItem/add_items_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemsSheet extends StatelessWidget {
  const AddItemsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddItemsController>();

    return SafeArea(
      child: Container(
        height: Get.height * 0.85,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            /// HANDLE
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Add Products",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 12),

            /// INLINE NOTIFICATION (🔥 NEW)
            Obx(() {
              if (!controller.showSheetMessage.value) {
                return const SizedBox.shrink();
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: controller.sheetMessageColor.value,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      controller.sheetMessageIcon.value,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        controller.sheetMessage.value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }),

            /// SEARCH
            TextField(
              onChanged: controller.setProductSearch,
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF6F7FB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// PRODUCTS LIST
            Expanded(
              child: Obx(() {
                final products = controller.filteredProducts;

                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      "No products found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final item = products[index];

                    final inCart = controller.selectedItems.any(
                      (e) => e.uniqueId == item.uniqueId,
                    );

                    final qty =
                        controller.selectedItems
                            .firstWhereOrNull(
                              (e) => e.uniqueId == item.uniqueId,
                            )
                            ?.qty ??
                        0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFF1F1F1)),
                      ),
                      child: Row(
                        children: [
                          /// IMAGE
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFF5F5F5),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: item.logo.isNotEmpty
                                ? Image.network(item.logo, fit: BoxFit.cover)
                                : const Icon(Icons.fastfood),
                          ),

                          const SizedBox(width: 12),

                          /// INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text("TZS ${item.price}"),
                                if (inCart)
                                  Text(
                                    "In cart: $qty",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          /// ADD BUTTON
                          OutlinedButton.icon(
                            onPressed: () {
                              final success = controller.addItem(item);

                              if (success) {
                                controller.showInlineNotification(
                                  "${item.name} added to cart",
                                  AppColors.primary,
                                  Icons.check_circle,
                                );
                              }
                            },
                            icon: Icon(
                              inCart ? Icons.check : Icons.add,
                              size: 14,
                            ),
                            label: Text(inCart ? "Added" : "Add"),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              minimumSize: const Size(0, 30),
                              backgroundColor: inCart
                                  ? AppColors.primary.withOpacity(0.08)
                                  : Colors.transparent,
                              side: BorderSide(
                                color: inCart
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                              ),
                              foregroundColor: inCart
                                  ? AppColors.primary
                                  : Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
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
        ),
      ),
    );
  }
}
