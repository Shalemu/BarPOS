import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/add_items_sheet.dart';
import 'package:barpos/features/addItem/add_items_controller.dart';
import 'package:barpos/services/model/order_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemsScreen extends GetView<AddItemsController> {
  const AddItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderRef = controller.orderRef;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

  
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          "Edit Order #$orderRef",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),

    
      body: Column(
        children: [
          _buildHeader(),
          _addItemsButton(),

          Expanded(
            child: Obx(() {
              final items = controller.selectedItems;

              if (items.isEmpty) {
                return _emptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _itemCard(item);
                },
              );
            }),
          ),
        ],
      ),

      bottomNavigationBar: _bottomBar(),
    );
  }


  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Update Mode",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  "Add or update items for this order",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: const Text(
              "LIVE",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }


Widget _addItemsButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      width: double.infinity,
      height: 42, // slightly smaller = more premium feel
      child: OutlinedButton.icon(
        onPressed: _openAddItemsSheet,
        icon: const Icon(Icons.add, size: 18),
        label: const Text(
          "Add Items",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,

          side: BorderSide(
            color: AppColors.primary.withOpacity(0.5),
            width: 1,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), 
          ),

          padding: const EdgeInsets.symmetric(horizontal: 12),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    ),
  );
}

  void _openAddItemsSheet() {
    Get.bottomSheet(
      const AddItemsSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
    );
  }

  // ================= EMPTY STATE =================
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
            "Tap Add Items to continue",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ================= ITEM CARD =================
  Widget _itemCard(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F1F1)),
      ),
      child: Row(
        children: [
          // IMAGE
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFFF5F5F5),
            ),
            clipBehavior: Clip.antiAlias,
            child: item.logo.isNotEmpty
                ? Image.network(item.logo, fit: BoxFit.cover)
                : const Icon(Icons.fastfood),
          ),

          const SizedBox(width: 12),

          // INFO
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
                const SizedBox(height: 6),
                Text(
                  "TZS ${item.price}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // QTY
          _qtyBox(item),
        ],
      ),
    );
  }

  // ================= QTY CONTROL =================
  Widget _qtyBox(OrderItem item) {
    final qty = item.qty;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _qtyBtn(Icons.remove, () {
            if (qty > 1) {
              controller.addItem(item, qty - 1);
            } else {
              controller.removeItem(item.id);
            }
          }),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "$qty",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          _qtyBtn(Icons.add, () {
            controller.addItem(item, qty + 1);
          }, active: true),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, {bool active = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: active ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // ================= BOTTOM BAR =================
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
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() {
          final loading = controller.isLoading.value;

          return SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : controller.submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "UPDATE ORDER",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }
}