import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';
import 'package:yellow_loan_signup_flutter_app/util/income_continue.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/app_primary_button.dart';

class IncomeContinueButton extends StatelessWidget {
  final GlobalKey<State> fileUploadKey;
  final void Function(bool) onFileUploadError;

  const IncomeContinueButton({
    super.key,
    required this.fileUploadKey,
    required this.onFileUploadError,
  });

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      title: AppLocalizations.of(context).buttonContinue,
      onPressed: () async {
        await incomeContinue(context, fileUploadKey, onFileUploadError);
      },
    );
  }
}
