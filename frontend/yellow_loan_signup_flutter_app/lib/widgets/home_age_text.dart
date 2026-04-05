import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';

class HomeAgeText extends StatelessWidget {
  final int age;

  const HomeAgeText({
    super.key,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${AppLocalizations.of(context).homeAge} = $age',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
