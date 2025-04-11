import 'package:flutter/material.dart';
import 'package:gaia/custom_drawer.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final FloatingActionButton? floatingActionButton;

  const BaseScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return Hero(
              tag: 'menu-icon',
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            );
          },
        ),
        shape: Border(
          bottom: BorderSide(width: 2, color: Colors.teal[400]!),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Hero(
          tag: 'app-title-$title',
          child: Material(
            color: Colors.transparent,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontFamily: 'Habibi',
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        actions: actions,
      ),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 60,
      drawer: const CustomDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: body,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      floatingActionButton: floatingActionButton != null
          ? AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: floatingActionButton,
            )
          : null,
    );
  }
}
