// Cancel Order Dialog
import 'package:flutter/material.dart';

Future<void> showCancelOrderDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Batalkan Pesanan'),
        content: Text('Apakah Anda yakin ingin membatalkan pesanan ini?'),
        actions: <Widget>[
          TextButton(
            child: Text('Tidak'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Ya'),
            onPressed: () {
              // TODO: Tambahkan logic pembatalan
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
