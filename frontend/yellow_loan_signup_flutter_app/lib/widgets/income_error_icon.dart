import 'package:flutter/material.dart';

class IncomeErrorIcon extends StatelessWidget {
  const IncomeErrorIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.close,
        size: 16,
        color: Theme.of(context).colorScheme.onError,
      ),
    );
  }
}
