import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/config/constants.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';

class ApplicationSuccessPageDesktop extends StatelessWidget {
  const ApplicationSuccessPageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: formWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context).applicationSuccessTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context).applicationSuccessMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
