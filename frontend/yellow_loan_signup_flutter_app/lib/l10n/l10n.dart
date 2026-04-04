import 'package:flutter/widgets.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';

export 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
