import 'package:flutter/material.dart';

class MobileShell extends StatelessWidget {
  const MobileShell({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
