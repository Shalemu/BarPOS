import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:barpos/features/counter/home/home_controller.dart';
import 'package:barpos/core/widgets/counter/dialog_widget/orderHeader_widget.dart';
import 'package:barpos/core/widgets/counter/dialog_widget/ordeItem_widget.dart';
import 'package:barpos/core/widgets/counter/dialog_widget/paymentMethod_widget.dart';
import 'package:barpos/core/widgets/counter/dialog_widget/orderAction_button.dart';
import 'package:barpos/core/widgets/counter/dialog_widget/payment_input_section.dart';

class OrderDialog {
  static void show(
    BuildContext parentContext, {
    required Map order,
    required CounterHomeController controller,
  }) {
    final List items = order['items'] ?? [];

    HapticFeedback.lightImpact();

    final status = order['order_status']?.toString().toLowerCase() ?? '';
    final paymentStatus =
        order['payment_status']?.toString().toLowerCase() ?? '';

    final isPaid = paymentStatus == "paid";
    final isCompleted = status == "completed";
    final isCancelled = status == "cancelled";

    final amountController = TextEditingController();
    final descController = TextEditingController();

    final amountFocus = FocusNode();
    final descFocus = FocusNode();
    final scrollController = ScrollController();

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// HEADER
                    OrderHeaderSection(order: order),
                    const SizedBox(height: 12),

                    /// ITEMS
                    OrderItemsSection(items: items),
                    const SizedBox(height: 12),

                    /// PAYMENT INPUT (only if allowed)
                    if (!isPaid && !isCancelled && !isCompleted) ...[
                      PaymentInputSection(
                        amountController: amountController,
                        descController: descController,
                        amountFocus: amountFocus,
                        descFocus: descFocus,
                        scrollController: scrollController,
                        accentColor: Colors.green,
                        title: "Payment Information",
                        amountHint: "Enter amount (TZS)",
                        descHint: "Add payment note (optional)",
                      ),

                      const SizedBox(height: 12),

                      PaymentMethodSelector(
                        methods: controller.paymentMethods,
                        selectedId: controller.selectedPaymentMethod.value,
                        onChanged: (id) {
                          controller.selectedPaymentMethod.value = id;
                        },
                      ),

                      const SizedBox(height: 16),
                    ],

                    // INLINE NOTIFICATION (FIXED HERE)
                    Obx(() {
                      if (!controller.showSheetMessage.value) {
                        return const SizedBox();
                      }

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 12),
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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    /// ACTION BUTTONS
                    OrderActionButtons(
                      status: status,
                      isPaid: isPaid,
                      controller: controller,
                      order: order,
                      amountController: amountController,
                      descController: descController,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
