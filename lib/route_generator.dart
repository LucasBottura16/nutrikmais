import 'package:flutter/material.dart';

class RouteGenerator {
  static const String routeLogin = "/routes";

  static var args;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    args = settings.arguments;

    switch (settings.name) {

      default:
        _errorRoute();
    }
    return null;
  }

  static Route<dynamic>? _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada"),
        ),
        body: const Center(
          child: Text("Tela não encontrada"),
        ),
      );
    });
  }
}
