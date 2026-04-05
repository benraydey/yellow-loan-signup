import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/model/phone.dart';

class PhoneImageHolder extends StatelessWidget {
  const PhoneImageHolder({
    required this.phone,
    super.key,
  });

  final Phone phone;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Image.network(
              phone.image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
