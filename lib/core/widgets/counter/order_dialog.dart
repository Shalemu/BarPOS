import 'package:barpos/core/constants/app_colors.dart';
import 'package:barpos/core/widgets/top_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class OrderDialog {
  static void show(
    BuildContext context, {
    required Map order,
    required dynamic controller,
  }) {
    final List items = order['items'] ?? [];

    HapticFeedback.lightImpact();

    //payment method

    final status = order['order_status']?.toString().toLowerCase() ?? '';

    final amountController = TextEditingController(text: "0");

    final descController = TextEditingController();

    controller.loadPaymentMethods();
    final ScrollController scrollController = ScrollController();

    final FocusNode amountFocus = FocusNode();
    final FocusNode descFocus = FocusNode();

    final paymentStatus =
        order['payment_status']?.toString().toLowerCase() ?? '';

    final isPaid = paymentStatus == "paid";
    final isPartial = paymentStatus == "partial" || paymentStatus == "not_paid";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,

      builder: (_) {
        return TweenAnimationBuilder(
          duration: const Duration(milliseconds: 250),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 40 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),

            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  controller: scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,

                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 350,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HANDLE
                      /// ================= DRAG HANDLE =================
                      Center(
                        child: Container(
                          width: 42,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      /// ================= HEADER CARD =================
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey.shade50],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            /// ICON BADGE
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.08),
                                    Colors.black.withOpacity(0.03),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.receipt_long_rounded,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(width: 14),

                            /// ORDER INFO
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order #${order['order_ref']}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.3,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "Table ${order['table_ref'] ?? '-'}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // STATUS BADGE
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent, // outline style
                                borderRadius: BorderRadius.circular(
                                  10,
                                ), // reduced radius
                                border: Border.all(
                                  color: (order['order_status'] == "completed")
                                      ? Colors.green
                                      : (order['order_status'] == "processing")
                                      ? Colors.blue
                                      : Colors.orange,
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                (order['order_status'] ?? "-")
                                    .toString()
                                    .toLowerCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: (order['order_status'] == "completed")
                                      ? Colors.green
                                      : (order['order_status'] == "processing")
                                      ? Colors.blue
                                      : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _headerInfoCard(
                              "Items",
                              "${getTotalItems(items)}",
                              Icons.shopping_bag_rounded,
                              Colors.blue,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _headerInfoCard(
                              "Total",
                              "TZS ${getTotalAmount(items).toStringAsFixed(0)}",
                              Icons.payments_rounded,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [Colors.grey.shade50, Colors.white],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 18,
                                color: Colors.green.shade700,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                "Payment: ${order['payment_status'] ?? '-'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "Order Items",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ITEMS
                      ...items.map((item) {
                        final qty = item['itemQty'] ?? 0;
                        final price = item['itemPrice'] ?? 0;
                        final total = qty * price;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item['logo'] ?? '',
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Container(
                                      width: 55,
                                      height: 55,
                                      color: Colors.grey.shade300,
                                      child: const Icon(Icons.fastfood),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['itemName'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "$qty x $price",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                "TZS $total",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 20),

                      if (status == "pending") ...[
                        const SizedBox(height: 20),

                        /// HEADER
                        Row(
                          children: const [
                            Icon(Icons.payments_rounded, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              "Payment Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        //AMOUNT INPUT
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: amountController,
                            focusNode: amountFocus,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,

                            onTap: () {
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeOut,
                                  );
                                },
                              );
                            },

                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),

                            decoration: InputDecoration(
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "TZS",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),

                              hintText: "Enter amount received (TZS)",
                              hintStyle: TextStyle(color: Colors.grey.shade400),

                              border: InputBorder.none,

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // PAYMENT NOTE INPUT
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),

                          child: TextField(
                            controller: descController,
                            focusNode: descFocus,
                            maxLines: 2,
                            textInputAction: TextInputAction.done,

                            onTap: () {
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeOut,
                                  );
                                },
                              );
                            },

                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),

                            decoration: InputDecoration(
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.receipt_long_rounded,
                                  color: Colors.orange.shade700,
                                ),
                              ),

                              hintText: "Add payment note (optional)",

                              hintStyle: TextStyle(color: Colors.grey.shade400),

                              border: InputBorder.none,

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (status == "processing") ...[
                        const SizedBox(height: 20),

                        // HEADER
                        Row(
                          children: const [
                            Icon(Icons.payments_rounded, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              "Payment Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        //AMOUNT INPUT
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),

                          child: TextField(
                            controller: amountController,
                            focusNode: amountFocus,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,

                            onTap: () {
                              Future.delayed(
                                const Duration(milliseconds: 250),
                                () {
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeOut,
                                  );
                                },
                              );
                            },

                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),

                            decoration: InputDecoration(
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "TZS",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),

                              hintText: "Enter amount (TZS)",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 18,
                              ),

                              border: InputBorder.none,

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // PAYMENT DESCRIPTION
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),

                          child: TextField(
                            controller: descController,
                            focusNode: descFocus,
                            maxLines: 2,
                            textInputAction: TextInputAction.done,

                            onTap: () {
                              Future.delayed(
                                const Duration(milliseconds: 250),
                                () {
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeOut,
                                  );
                                },
                              );
                            },

                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),

                            decoration: InputDecoration(
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.receipt_long_rounded,
                                  color: Colors.orange.shade700,
                                ),
                              ),

                              hintText: "Add payment note (optional)",

                              hintStyle: TextStyle(color: Colors.grey.shade400),

                              border: InputBorder.none,

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

                        // PAYMENT METHOD HEADER
                        const Text(
                          "Select Payment Method",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // PAYMENT METHODS
                        Obx(() {
                          final methods = controller.paymentMethods;

                          if (methods.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return Column(
                            children: methods.map<Widget>((method) {
                              final isSelected =
                                  controller.selectedPaymentMethod.value ==
                                  method['id'];

                              return GestureDetector(
                                onTap: () {
                                  controller.selectedPaymentMethod.value =
                                      method['id'];
                                },

                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),

                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [
                                              Colors.blue.shade700,
                                              Colors.blue.shade400,
                                            ],
                                          )
                                        : LinearGradient(
                                            colors: [
                                              Colors.grey.shade50,
                                              Colors.grey.shade100,
                                            ],
                                          ),

                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(
                                                0.25,
                                              ),
                                              blurRadius: 16,
                                              offset: const Offset(0, 8),
                                            ),
                                          ]
                                        : [],
                                  ),

                                  child: Row(
                                    children: [
                                      // ICON
                                      Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),

                                        child: Icon(
                                          method['method_name']
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains("cash")
                                              ? Icons.payments_rounded
                                              : Icons.phone_android_rounded,

                                          color: isSelected
                                              ? Colors.blue
                                              : Colors.blueGrey,
                                        ),
                                      ),

                                      const SizedBox(width: 14),

                                      // NAME + SUBTITLE
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              method['method_name'] ??
                                                  'Unknown method',

                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              isSelected
                                                  ? "Selected payment method"
                                                  : "Tap to select method",

                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isSelected
                                                    ? Colors.white70
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      /// CHECK
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),

                                        child: Icon(
                                          isSelected
                                              ? Icons.check_circle_rounded
                                              : Icons.circle_outlined,

                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                      ],
                      const SizedBox(height: 10),

                      const SizedBox(height: 24),

                      //COMPLETED / CANCELLED BUTTON
                      if (status == "completed" || status == "cancelled") ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close),
                            label: const Text("Close"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ]
                      //PENDING
                      else if (status == "pending") ...[
                        Obx(() {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: controller.isButtonLoading.value
                                  ? null
                                  : () async {
                                      try {
                                        await controller.runAction(() async {
                                          final amount =
                                              double.tryParse(
                                                amountController.text,
                                              ) ??
                                              0.0;

                                          final desc =
                                              descController.text.trim().isEmpty
                                              ? "paid"
                                              : descController.text.trim();

                                          await controller.pickOrder(
                                            orderId: order['id'],
                                            amountReceived: amount,
                                            paymentMethod:
                                                controller
                                                    .selectedPaymentMethod
                                                    .value ??
                                                1,
                                            paymentDesc: desc,
                                          );

                                          TopNotification.show(
                                            context,
                                            message:
                                                "Order picked successfully",
                                            color: Colors.green,
                                            icon: Icons.check_circle,
                                          );

                                          Get.back();
                                        });
                                      } catch (e) {
                                        TopNotification.show(
                                          context,
                                          message: "Failed: $e",
                                          color: Colors.red,
                                          icon: Icons.error_outline,
                                        );
                                      }
                                    },
                              icon: controller.isButtonLoading.value
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.restaurant),
                              label: const Text("Pick Order"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          );
                        }),
                      ]
                      //PROCESSING
                      else if (status == "processing") ...[
                        /// ADD PAYMENT
                        if (!isPaid) ...[
                          Obx(() {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: controller.isButtonLoading.value
                                    ? null
                                    : () async {
                                        try {
                                          await controller.runAction(() async {
                                            final amount =
                                                double.tryParse(
                                                  amountController.text,
                                                ) ??
                                                0.0;

                                            final desc =
                                                descController.text
                                                    .trim()
                                                    .isEmpty
                                                ? "paid"
                                                : descController.text.trim();

                                            await controller.makePayment(
                                              orderId: order['id'],
                                              amountReceived: amount,
                                              paymentMethod:
                                                  controller
                                                      .selectedPaymentMethod
                                                      .value ??
                                                  1,
                                              paymentDesc: desc,
                                            );

                                            TopNotification.show(
                                              context,
                                              message:
                                                  "Payment added successfully",
                                              color: Colors.blue,
                                              icon: Icons.payments_rounded,
                                            );

                                            amountController.clear();
                                            descController.clear();
                                          });
                                        } catch (e) {
                                          TopNotification.show(
                                            context,
                                            message: "Payment failed: $e",
                                            color: Colors.red,
                                            icon: Icons.error_outline,
                                          );
                                        }
                                      },
                                icon: controller.isButtonLoading.value
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.payments_rounded),
                                label: const Text("Add Payment"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],

                        const SizedBox(height: 12),

                        // COMPLETE ORDER
                        if (isPaid) ...[
                          Obx(() {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: controller.isButtonLoading.value
                                    ? null
                                    : () async {
                                        try {
                                          await controller.runAction(() async {
                                            await controller.completeOrder(
                                              orderId: order['id'],
                                            );

                                            TopNotification.show(
                                              context,
                                              message:
                                                  "Order completed successfully",
                                              color: Colors.green,
                                              icon: Icons.check_circle,
                                            );

                                            Get.back();
                                          });
                                        } catch (e) {
                                          TopNotification.show(
                                            context,
                                            message: "Failed: $e",
                                            color: Colors.red,
                                            icon: Icons.error_outline,
                                          );
                                        }
                                      },
                                icon: controller.isButtonLoading.value
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.check_circle_outline),
                                label: const Text("Complete Order"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _headerInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static int getTotalItems(List items) {
    return items.fold<int>(
      0,
      (sum, item) => sum + ((item['itemQty'] ?? 0) as int),
    );
  }

  static double getTotalAmount(List items) {
    return items.fold<double>(
      0,
      (sum, item) => sum + ((item['itemQty'] ?? 0) * (item['itemPrice'] ?? 0)),
    );
  }
}
