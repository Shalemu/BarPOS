import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barpos/features/counter/home/home_controller.dart';

class OrderActionButtons extends StatelessWidget {
  final String status;
  final bool isPaid;
  final CounterHomeController controller;
  final Map order;
  final TextEditingController amountController;
  final TextEditingController descController;

  const OrderActionButtons({
    super.key,
    required this.status,
    required this.isPaid,
    required this.controller,
    required this.order,
    required this.amountController,
    required this.descController,
  });

  @override
  Widget build(BuildContext context) {
    Widget button({
      required String text,
      required IconData icon,
      required List<Color> colors,
      required VoidCallback? onPressed,
      bool loading = false,
    }) {
      return Container(
        width: double.infinity,
        height: 52,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: colors),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: onPressed,
          icon: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(icon, color: Colors.white),
          label: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    if (status == "completed" || status == "cancelled") {
      return button(
        text: "Close Order",
        icon: Icons.close_rounded,
        colors: [Colors.black, Colors.grey.shade600],
        onPressed: () => Get.back(),
      );
    }

    if (status == "pending") {
      return Obx(() {
        final loading = controller.isButtonLoading.value;

        return button(
          text: "Pick Order",
          icon: Icons.restaurant_rounded,
          loading: loading,
          colors: [Colors.orange.shade700, Colors.orange.shade400],
          onPressed: loading
              ? null
              : () async {
                  await controller.pickOrder(
                    orderId: order['id'],
                    amountReceived:
                        double.tryParse(amountController.text) ?? 0,
                    paymentMethod:
                        controller.selectedPaymentMethod.value,
                    paymentDesc: descController.text,
                      onClose: () => Navigator.of(context).pop(),
                  );
                },
        );
      });
    }

    if (status == "processing" && !isPaid) {
      return Obx(() {
        final loading = controller.isButtonLoading.value;

        return button(
          text: "Add Payment",
          icon: Icons.payments_rounded,
          loading: loading,
          colors: [Colors.blue.shade700, Colors.blue.shade400],
          onPressed: loading
              ? null
              : () async {
                  await controller.makePayment(
                    orderId: order['id'],
                    amountReceived:
                        double.tryParse(amountController.text) ?? 0,
                    paymentMethod:
                        controller.selectedPaymentMethod.value,
                    paymentDesc: descController.text,
                      onClose: () => Navigator.of(context).pop(),
                  );
                },
        );
      });
    }

    if (status == "processing" && isPaid) {
      return Obx(() {
        final loading = controller.isButtonLoading.value;

        return button(
          text: "Complete Order",
          icon: Icons.check_circle_rounded,
          loading: loading,
          colors: [Colors.green.shade700, Colors.green.shade500],
          onPressed: loading
              ? null
              : () async {
                  await controller.completeOrder(
                    orderId: order['id'],
                    onClose: () => Navigator.of(context).pop(),
                  );
                },
        );
      });
    }

    return const SizedBox();
  }
}