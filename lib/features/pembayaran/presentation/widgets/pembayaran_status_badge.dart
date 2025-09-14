// Payment Status Badge Widget (Dipindahkan)
import 'package:flutter/material.dart';

class PembayaranStatusBadge extends StatelessWidget {
  final String status;
  const PembayaranStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'success':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'failed':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status),
      backgroundColor: color,
    );
  }
}
