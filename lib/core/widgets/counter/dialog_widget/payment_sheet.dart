import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:barpos/features/counter/home/home_controller.dart';
import 'package:barpos/core/widgets/counter/dialog_widget/paymentMethod_widget.dart';
import 'package:barpos/core/widgets/counter/dialog_widget/payment_input_section.dart';

class PaymentSheet {
  static void show({
    required BuildContext context,
    required CounterHomeController homeController,
    required Future<void> Function(double amount, String desc, int methodId) onSubmit,
  }) {
    final amountController = TextEditingController();
    final descController = TextEditingController();

    final amountFocus = FocusNode();
    final descFocus = FocusNode();
    final scrollController = ScrollController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Optional Payment",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                /// PAYMENT METHODS
                Obx(() {
                  return PaymentMethodSelector(
                    methods: homeController.paymentMethods,
                    selectedId: homeController.selectedPaymentMethod.value,
                    onChanged: (id) {
                      homeController.selectedPaymentMethod.value = id;
                    },
                  );
                }),

                const SizedBox(height: 14),

                /// PAYMENT INPUT
                PaymentInputSection(
                  amountController: amountController,
                  descController: descController,
                  amountFocus: amountFocus,
                  descFocus: descFocus,
                  scrollController: scrollController,
                  accentColor: Colors.black,
                  title: "Payment Info",
                  amountHint: "Amount received",
                  descHint: "Note (optional)",
                ),

                const SizedBox(height: 20),

                /// SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      final amount =
                          double.tryParse(amountController.text) ?? 0;

                      final desc = descController.text;
                      final methodId =
                          homeController.selectedPaymentMethod.value;

                      await onSubmit(amount, desc, methodId);

                      Navigator.pop(context);
                    },
                    child: const Text("SAVE PAYMENT"),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}