import 'package:flutter/material.dart';
import 'package:barpos/core/constants/app_colors.dart';

class OrderUiHelper {
  static String getButtonText(String status, String paymentStatus) {
    final orderStatus = status.toLowerCase();
    final payment = paymentStatus.toLowerCase();

    switch (orderStatus) {
      case "pending":
        if (payment == "partial") {
          return "Add Payment";
        }
        return "Pick Order";

      case "processing":
        if (payment == "paid") {
          return "Complete Order";
        }

        if (payment == "partial" || payment == "pending") {
          return "Add Payment";
        }

        return "Process Order";

      case "completed":
      case "cancelled":
        return "View Order";

      default:
        return "Open Order";
    }
  }

  static IconData getButtonIcon(String status, String paymentStatus) {
    final orderStatus = status.toLowerCase();
    final payment = paymentStatus.toLowerCase();

    switch (orderStatus) {
      case "pending":
        if (payment == "partial") {
          return Icons.payments_rounded;
        }
        return Icons.playlist_add_check_rounded;

      case "processing":
        if (payment == "paid") {
          return Icons.check_circle_rounded;
        }

        if (payment == "partial" || payment == "pending") {
          return Icons.payments_rounded;
        }

        return Icons.sync_rounded;

      case "completed":
      case "cancelled":
        return Icons.visibility_rounded;

      default:
        return Icons.receipt_long_rounded;
    }
  }

  static Color getButtonColor(String status, String paymentStatus) {
    final orderStatus = status.toLowerCase();
    final payment = paymentStatus.toLowerCase();

    switch (orderStatus) {
      case "pending":
        if (payment == "partial") {
          return Colors.amber;
        }
        return AppColors.primary;

      case "processing":
        if (payment == "paid") {
          return Colors.teal;
        }

        if (payment == "partial" || payment == "pending") {
          return Colors.amber;
        }

        return AppColors.blue;

      case "completed":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.black;
    }
  }

  static Color getStatusColor(String status, String paymentStatus) {
    final orderStatus = status.toLowerCase();
    final payment = paymentStatus.toLowerCase();

    switch (orderStatus) {
      case "pending":
        return Colors.orange;

      case "processing":
        if (payment == "partial") {
          return Colors.amber;
        }

        if (payment == "paid") {
          return Colors.teal;
        }

        return Colors.blue;

      case "ready":
        return Colors.purple;

      case "completed":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  static int getStatusPriority(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return 0;
      case "processing":
        return 1;
      case "completed":
        return 2;
      case "cancelled":
        return 3;
      default:
        return 99;
    }
  }
}
