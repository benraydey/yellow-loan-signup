import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/model/phone.dart';

/// Widget displaying the phone title and cash price
class PhoneDetailsTitleSection extends StatelessWidget {
  const PhoneDetailsTitleSection({
    required this.phone,
    super.key,
  });

  final Phone phone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          phone.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Cash price: ${phone.cashPriceInRands}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
