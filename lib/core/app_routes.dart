import 'package:deeplink/pages/print_page/print_page.dart';
import 'package:flutter/material.dart';

import '../pages/home_page/home_page.dart';
import '../pages/select_printer/select_printer.dart';

class AppRoutes {
  static const cInitialRoute = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/'),
            builder: (context) => const HomePage());
      case '/print_page':
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/print_page'),
            builder: (context) => const PrintPage());
      case '/select_printer':
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/select_printer'),
            builder: (context) => const SelectPrinter());
      default:
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/error_page'),
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Center(
                    child: Text('Erro'),
                  ),
                ),
                body: const Center(
                  child: Text('Página não encontrada'),
                ),
              );
            });
    }
  }
}
