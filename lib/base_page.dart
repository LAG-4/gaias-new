import 'package:flutter/material.dart';
import 'package:gaia/custom_drawer.dart';

class BasePage extends StatelessWidget {
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  const BasePage({
    Key? key,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
