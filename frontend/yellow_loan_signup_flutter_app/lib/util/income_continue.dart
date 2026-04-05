import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formy/formy.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/income_upload_file_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/config/app_form_field.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/l10n.dart';

Future<void> incomeContinue(
  BuildContext context,
  GlobalKey<State> fileUploadKey,
  void Function(bool) setShowFileUploadError,
) async {
  // Validate form fields
  if (!Formy.of(context).validate(
    include: [
      AppFormField.monthlyIncome.name,
    ],
  )) {
    return;
  }

  // Validate file upload
  final uploadState = context.read<IncomeUploadFileBloc>().state;

  if (uploadState.status != IncomeUploadFileStatus.success ||
      uploadState.fileId == null) {
    // File not uploaded or invalid
    setShowFileUploadError(true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).incomeProofOfIncomeError,
        ),
        duration: Duration(seconds: 6),
      ),
    );

    // Scroll to file upload widget
    await Scrollable.ensureVisible(
      fileUploadKey.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    return;
  }

  // Clear any previous error state
  setShowFileUploadError(false);

  // Everything valid, navigate to phones
  await context.push('/phones');
}
