import 'package:flutter/material.dart';

class IncomeSuccessIcon extends StatelessWidget {
  const IncomeSuccessIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        size: 16,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
