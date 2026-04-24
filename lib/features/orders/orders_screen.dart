import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'orders_controller.dart';


class OrdersScreen extends GetView<OrdersController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return Center(
            child: Text("No orders found"),
          );
        }

        return ListView.builder(
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
         

 
           
          },
        );
      }),
    );
  }
}