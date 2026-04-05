import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';

class IncomeSubtitle extends StatelessWidget {
  const IncomeSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).incomeSubtitle,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
