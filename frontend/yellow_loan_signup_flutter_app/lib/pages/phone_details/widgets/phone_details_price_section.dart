import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/model/phone.dart';

/// Widget displaying the "You pay" section with deposit and daily payment
class PhoneDetailsPriceSection extends StatelessWidget {
  const PhoneDetailsPriceSection({
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
          'You pay:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deposit (up front): ${phone.depositInRands}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Daily payment: ${phone.dailyPaymentInRands} per day (for one year)',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
