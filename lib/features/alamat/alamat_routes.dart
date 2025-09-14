import 'package:flutter/material.dart';
import '../alamat/application/alamat_list_vm.dart';
import '../alamat/application/alamat_form_vm.dart';

class AlamatRoutes {
  static const String list = '/alamat';
  static const String form = '/alamates/form';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      list: (context) {
        // nanti bisa arahkan ke AlamatListScreen
        return const Placeholder();
      },
      form: (context) {
        // nanti bisa arahkan ke AlamatFormScreen
        return const Placeholder();
      },
    };
  }
}
