import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const Center(child: Text("Cart is empty"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];

                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("Price: ${item.price}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () =>
                              controller.decreaseQty(item),
                        ),
                        Text(item.quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () =>
                              controller.increaseQty(item),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Total section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() => Text(
                    "Total: ${controller.totalPrice}",
                    style: const TextStyle(fontSize: 18),
                  )),
            ),
          ],
        );
      }),
    );
  }
}