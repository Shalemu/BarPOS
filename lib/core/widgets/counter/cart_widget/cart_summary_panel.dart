import 'package:barpos/features/counter/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:barpos/features/counter/cart/cart_controller.dart';
import 'package:barpos/core/widgets/counter/dialog_widget/paymentMethod_widget.dart';
import 'package:barpos/core/widgets/counter/dialog_widget/payment_input_section.dart';
import 'package:barpos/core/constants/app_colors.dart';

class CartSummaryPanel extends StatelessWidget {
  final CartController cartController;
  final CounterHomeController homeController;

  final TextEditingController tableController;
  final TextEditingController amountController;
  final TextEditingController descController;

  final FocusNode amountFocus;
  final FocusNode descFocus;
  final ScrollController scrollController;

  const CartSummaryPanel({
    super.key,
    required this.cartController,
    required this.homeController,
    required this.tableController,
    required this.amountController,
    required this.descController,
    required this.amountFocus,
    required this.descFocus,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat("#,##0");

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// PAYMENT METHOD
              Obx(() {
                return PaymentMethodSelector(
                  methods: homeController.paymentMethods,
                  selectedId: homeController.selectedPaymentMethod.value,
                  onChanged: (id) {
                    homeController.selectedPaymentMethod.value = id;
                  },
                );
              }),

              const SizedBox(height: 12),

              /// PAYMENT INPUT
              PaymentInputSection(
                amountController: amountController,
                descController: descController,
                amountFocus: amountFocus,
                descFocus: descFocus,
                scrollController: scrollController,
                accentColor: AppColors.primary,
                title: "Payment Details",
                amountHint: "Amount received",
                descHint: "Description (optional)",
              ),

              const SizedBox(height: 16),

              /// TOTAL
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "TZS ${format.format(cartController.totalPrice)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 12),

              /// TABLE INPUT
              TextField(
                controller: tableController,
                decoration: InputDecoration(
                  hintText: "Table number",
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// SUBMIT BUTTON
              Obx(() {
                final loading = cartController.isLoading.value;

                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: loading
                        ? null
                        : () async {
                            final items = cartController.cartItems.map((item) {
                              return {
                                "itemId": item.id,
                                "itemCategory": item.category,
                                "itemQty": item.quantity,
                              };
                            }).toList();

                            final payments = {
                              "amount_received":
                                  double.tryParse(amountController.text) ?? 0,
                              "payment_method":
                                  homeController.selectedPaymentMethod.value,
                              "payment_desc": descController.text,
                            };

                            final result = await cartController.submitOrder(
                              tableRef: tableController.text.trim(),
                              items: items,
                              payments: payments,
                            );

                            if (result == null) {
                              cartController.clearCart();
                              tableController.clear();
                              amountController.clear();
                              descController.clear();
                            }
                          },
                    child: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "SUBMIT ORDER",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
