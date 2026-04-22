import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barpos/features/home/home_controller.dart';

class CounterItemsWidget extends StatelessWidget {
  const CounterItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    /// RESTAURANT CATEGORIES
    final categories = ["All", "Food", "Beer", "Spirits", "Soft Drinks"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


SizedBox(height: 40,),
        /// SEARCH + FILTER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        "Search menu...",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune, color: Colors.white),
              )
            ],
          ),
        ),

        const SizedBox(height: 12),

        /// 🏷 CATEGORY PILLS
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Obx(() {
                final selected = controller.selectedCategory.value == index;

                return GestureDetector(
                  onTap: () {
                    controller.selectedCategory.value = index;
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: selected ? Colors.black : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),

        const SizedBox(height: 12),

        /// ITEMS GRID
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72, 
            ),
            itemCount: 10,
            itemBuilder: (context, index) {

              ///  MOCK RESTAURANT DATA (replace with controller.items later)
              final name = index % 2 == 0 ? "Heineken Beer" : "Grilled Chicken";
              final price = index % 2 == 0 ? "TZS 5,000" : "TZS 12,000";
              final stock = index % 2 == 0 ? 24 : 8;
              final isDrink = index % 2 == 0;

              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// IMAGE / ICON
                    Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Icon(
                          isDrink ? Icons.local_drink : Icons.restaurant,
                          size: 36,
                          color: Colors.black54,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// NAME
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 3),

                    /// PRICE
                    Text(
                      price,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 3),

                    /// STOCK
                    Text(
                      "Available: $stock",
                      style: TextStyle(
                        fontSize: 11,
                        color: stock < 5 ? Colors.red : Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// ADD BUTTON
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          // controller.addToCart(item);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}