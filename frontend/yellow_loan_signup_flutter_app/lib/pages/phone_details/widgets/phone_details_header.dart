import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';

/// Header widget for phone details page with title and subtitle
class PhoneDetailsHeader extends StatelessWidget {
  const PhoneDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).phoneDetailsTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).phoneDetailsSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
