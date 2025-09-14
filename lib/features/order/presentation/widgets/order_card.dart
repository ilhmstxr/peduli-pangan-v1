// Order Card Widget
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Order'),
        subtitle: Text('Detail order'),
      ),
    );
  }
}
