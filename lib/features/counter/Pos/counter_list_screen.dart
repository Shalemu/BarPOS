import 'package:barpos/features/counter/Pos/counter_list_controller.dart';
import 'package:barpos/features/counter/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/counter/Pos/Mycounter_widget.dart';

class CounterListScreen extends StatelessWidget {
  CounterListScreen({super.key});

  final controller = Get.find<CounterListController>();
  final homeController = Get.find<CounterHomeController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init(homeController.token);
    });

    return Scaffold(
     
      body: const CounterSelectionWidget(),
    );
  }
}