import 'package:flutter/material.dart';

class PaymentInputSection extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController descController;
  final FocusNode amountFocus;
  final FocusNode descFocus;
  final ScrollController scrollController;
  final Color accentColor;
  final String title;
  final String amountHint;
  final String descHint;

  const PaymentInputSection({
    super.key,
    required this.amountController,
    required this.descController,
    required this.amountFocus,
    required this.descFocus,
    required this.scrollController,
    required this.accentColor,
    required this.title,
    required this.amountHint,
    required this.descHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.payments_rounded, color: accentColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

      
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: TextField(
            controller: amountController,
            focusNode: amountFocus,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,

            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(descFocus);
            },

            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),

            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.all(10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "TZS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
              hintText: amountHint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

       
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: descController,
            focusNode: descFocus,
            maxLines: 2,
            textInputAction: TextInputAction.done,

            onSubmitted: (_) {
              FocusScope.of(context).unfocus();
            },

            style: const TextStyle(fontSize: 15),

            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.receipt_long_rounded,
                color: accentColor,
              ),
              hintText: descHint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}