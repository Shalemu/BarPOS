import 'package:flutter/material.dart';

class ProgressTracker extends StatelessWidget {
  final String status;

  const ProgressTracker({
    super.key,
    required this.status,
  });

  int _getIndex(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return 0;
      case "processing":
        return 1;
      case "ready":
        return 2;
      case "completed":
        return 3;
      default:
        return 0;
    }
  }

  bool get isCancelled => status.toLowerCase() == "cancelled";

  @override
  Widget build(BuildContext context) {
    // If cancelled → show only cancelled state
    if (isCancelled) {
      return Row(
        children: [
          _cancelledStep(),
        ],
      );
    }

    final current = _getIndex(status);

    return Row(
      children: [
        _step("Pending", 0, current),
        _line(0, current),
        _step("Processing", 1, current),
        _line(1, current),
        _step("Ready", 2, current),
        _line(2, current),
        _step("Done", 3, current),
      ],
    );
  }

  /// NORMAL STEP
  Widget _step(String label, int index, int current) {
    final isActive = index == current;
    final isDone = index < current;

    return Column(
      children: [
        CircleAvatar(
          radius: 6,
          backgroundColor: isActive
              ? Colors.orange
              : isDone
                  ? Colors.green
                  : Colors.grey.shade300,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive
                ? Colors.black
                : isDone
                    ? Colors.green
                    : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _line(int index, int current) {
    final isActive = index < current;

    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.green : Colors.grey.shade300,
      ),
    );
  }

  /// CANCELLED STATE (REPLACES ENTIRE TRACKER)
  Widget _cancelledStep() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 6,
          backgroundColor: Colors.red,
        ),
        const SizedBox(width: 8),
        const Text(
          "CANCELLED",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}