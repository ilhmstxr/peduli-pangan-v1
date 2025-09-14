// Payment Method Selector Widget (Dipindahkan)
import 'package:flutter/material.dart';

class PembayaranMethodSelector extends StatelessWidget {
  final List<String> methods;
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const PembayaranMethodSelector({
    required this.methods,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedMethod,
      items: methods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
      onChanged: onChanged,
    );
  }
}
