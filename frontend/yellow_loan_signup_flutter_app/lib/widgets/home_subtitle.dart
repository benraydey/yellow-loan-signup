import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';

class HomeSubtitle extends StatelessWidget {
  const HomeSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).homeSubtitle,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
