import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:barpos/features/counter/home/home_controller.dart';
import 'package:barpos/features/counter/cart/cart_controller.dart';
import 'package:barpos/core/widgets/counter/cart_widget/cart_item_card.dart';
import 'package:barpos/core/widgets/counter/dialog_widget/payment_sheet.dart'; // IMPORTANT

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.find<CartController>();
  final CounterHomeController homeController =
      Get.find<CounterHomeController>();

  final TextEditingController tableController = TextEditingController();

  @override
  void dispose() {
    tableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      body: Column(
        children: [
          /// ================= ITEMS =================
          Expanded(
            child: Obx(() {
              if (cartController.cartItems.isEmpty) {
                return const Center(child: Text("Cart is empty"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];

                  return CartItemCard(item: item, controller: cartController);
                },
              );
            }),
          ),

          /// ================= CHECKOUT =================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            child: Column(
              children: [
                /// TABLE INPUT (PREMIUM)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: tableController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.table_bar_outlined),
                      hintText: "Enter table number",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(14),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// TOTAL
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total"),
                      Text(
                        "TZS ${cartController.totalPrice}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 16),

  
                Row(
                  children: [
                
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [Colors.white, const Color(0xFFF4F6FA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: cartController.cartItems.isEmpty
                                ? null
                                : () => _openPaymentSheet(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 20,
                                  color: Colors.black87,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Payment",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // MAIN SUBMIT BUTTON 
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: cartController.cartItems.isEmpty
                                ? [Colors.grey.shade400, Colors.grey.shade500]
                                : [Colors.black, Colors.black87],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: cartController.cartItems.isEmpty
                                ? null
                                : () async {
                                    final items = cartController.cartItems.map((
                                      item,
                                    ) {
                                      return {
                                        "itemId": item.id,
                                        "itemCategory": item.category,
                                        "itemQty": item.quantity,
                                      };
                                    }).toList();

                                    final result = await cartController
                                        .submitOrder(
                                          tableRef: tableController.text.trim(),
                                          items: items,
                                        );

                                    if (result == null) {
                                      cartController.clearCart();
                                    }
                                  },
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.point_of_sale_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "SUBMIT ORDER",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PAYMENT SHEET

  void _openPaymentSheet() {
    PaymentSheet.show(
      context: context,
      homeController: homeController,
      onSubmit: (amount, desc, methodId) async {
        final items = cartController.cartItems.map((item) {
          return {
            "itemId": item.id,
            "itemCategory": item.category,
            "itemQty": item.quantity,
          };
        }).toList();

        final payments = {
          "amount_received": amount,
          "payment_method": methodId,
          "payment_desc": desc,
        };

        final result = await cartController.submitOrder(
          tableRef: tableController.text.trim(),
          items: items,
          payments: payments,
        );

        if (result == null) {
          cartController.clearCart();
        }
      },
    );
  }
}
