import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';

class IncomeTitle extends StatelessWidget {
  const IncomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).incomeTitle,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
