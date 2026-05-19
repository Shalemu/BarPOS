import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final List<dynamic> methods;
  final int selectedId;
  final Function(int id) onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.methods,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (methods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      children: methods.map<Widget>((method) {
        final id = method['id'];
        final isSelected = selectedId == id;

        final isCash = (method['method_name'] ?? '')
            .toString()
            .toLowerCase()
            .contains("cash");

        return GestureDetector(
          onTap: () => onChanged(id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            transform: Matrix4.identity()
              ..scale(isSelected ? 1.02 : 1.0),

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
                        color: Colors.blue.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),

            child: Row(
              children: [
                /// ICON
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isCash
                        ? Icons.payments_rounded
                        : Icons.phone_android_rounded,
                    color: isSelected ? Colors.blue : Colors.blueGrey,
                  ),
                ),

                const SizedBox(width: 14),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method['method_name'] ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color:
                              isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSelected
                            ? "Selected payment method"
                            : "Tap to select method",
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isSelected ? Colors.white70 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                /// CHECK
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}