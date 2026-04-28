import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/features/addItem/add_items_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemsScreen extends GetView<AddItemsController> {
  const AddItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = controller.orderId;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          "Edit Order #$orderId",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),

      body: Column(
        children: [
          /// HEADER CARD
          _buildHeader(),

          /// ITEMS
          Expanded(
            child: Obx(() {
              if (controller.selectedItems.isEmpty) {
                return _emptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                itemCount: controller.selectedItems.length,
                itemBuilder: (context, index) {
                  final item = controller.selectedItems[index];
                  final qty = item["itemQty"] ?? 0;

                  return _itemCard(item, qty);
                },
              );
            }),
          ),
        ],
      ),

      /// BOTTOM ACTION
      bottomNavigationBar: _bottomBar(),
    );
  }

  /// ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: const Icon(Icons.receipt_long, color: AppColors.primary),
          ),
          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Update Mode",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Add or update items for this order",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "LIVE",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// ================= EMPTY STATE =================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined,
              size: 90, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          const Text(
            "No items yet",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            "Tap + buttons to add products",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// ================= ITEM CARD =================
  Widget _itemCard(Map item, int qty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          /// PRODUCT IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 52,
              height: 52,
              color: const Color(0xFFF3F3F3),
              child: item["logo"] != null && item["logo"].toString().isNotEmpty
                  ? Image.network(
                      item["logo"],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    )
                  : const Icon(Icons.fastfood),
            ),
          ),

          const SizedBox(width: 12),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["itemName"] ?? "Product",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  item["itemCategory"] ?? "Category",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "TZS ${item["price"] ?? 0}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          /// QTY CONTROL
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _qtyBtn(
                  icon: Icons.remove,
                  onTap: () {
                    if (qty > 1) {
                      controller.addItem(
                        item["itemId"],
                        item["itemCategory"],
                        qty - 1,
                      );
                    } else {
                      controller.removeItem(item["itemId"]);
                    }
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "$qty",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                _qtyBtn(
                  icon: Icons.add,
                  color: Colors.white,
                  bg: AppColors.primary,
                  iconColor: Colors.white,
                  onTap: () {
                    controller.addItem(
                      item["itemId"],
                      item["itemCategory"],
                      qty + 1,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= QTY BUTTON =================
  Widget _qtyBtn({
    required IconData icon,
    required VoidCallback onTap,
    Color? bg,
    Color? iconColor,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bg ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: iconColor ?? Colors.black,
        ),
      ),
    );
  }

  /// ================= BOTTOM BAR =================
  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 18,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: Obx(() {
            final loading = controller.isLoading.value;

            return ElevatedButton(
              onPressed: loading ? null : controller.submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "UPDATE ORDER",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
            );
          }),
        ),
      ),
    );
  }
}