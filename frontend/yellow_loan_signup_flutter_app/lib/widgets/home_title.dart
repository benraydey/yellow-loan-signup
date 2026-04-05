import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).homeTitle,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
