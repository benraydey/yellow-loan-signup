import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formy/formy.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/app/router/app_router.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/income_upload_file/income_upload_file_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/selected_phone_cubit/selected_phone_cubit.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/submit_application_bloc/submit_application_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/config/app_form_field.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/app_primary_button.dart';

class SubmitApplicationButton extends StatelessWidget {
  const SubmitApplicationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return BlocListener<SubmitApplicationBloc, SubmitApplicationState>(
      listener: (context, state) async {
        if (state.status == SubmitApplicationStatus.error) {
          if (isMobile) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                duration: const Duration(seconds: 6),
              ),
            );
          } else {
            await showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(state.errorMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else if (state.status == SubmitApplicationStatus.success) {
          await context.push(AppRoute.applicationSuccess.path);
        }
      },
      child: BlocBuilder<SubmitApplicationBloc, SubmitApplicationState>(
        builder: (context, state) {
          return AppPrimaryButton(
            title: AppLocalizations.of(context).buttonSubmit,
            isLoading: state.isLoading,
            onPressed: () {
              if (Formy.of(context).validate(
                include: [
                  AppFormField.fullName.name,
                  AppFormField.monthlyIncome.name,
                ],
              )) {
                final fullName = Formy.of(context).getValue<String>(
                  AppFormField.fullName.name,
                );
                final idNumber = Formy.of(context).getValue<String>(
                  AppFormField.idNumber.name,
                );
                final monthlyIncome = Formy.of(context).getValue<String>(
                  AppFormField.monthlyIncome.name,
                );
                final phoneState = context.read<SelectedPhoneCubit>().state;
                final incomeFileState = context
                    .read<IncomeUploadFileBloc>()
                    .state;

                if (fullName != null &&
                    idNumber != null &&
                    monthlyIncome != null &&
                    phoneState.selectedPhone != null &&
                    incomeFileState.fileId != null) {
                  context.read<SubmitApplicationBloc>().add(
                    SubmitApplication(
                      fullName: fullName,
                      idNumber: idNumber,
                      monthlyIncome: monthlyIncome,
                      filename: incomeFileState.fileId ?? '',
                      selectedPhoneId: phoneState.selectedPhone!.id,
                    ),
                  );
                } else {
                  if (!isMobile) {
                    showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Incomplete Information'),
                        content: const Text(
                          'Please ensure all required information is complete before submitting.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please ensure all required information is complete before submitting.',
                        ),
                        duration: Duration(seconds: 6),
                      ),
                    );
                  }
                }
              }
            },
          );
        },
      ),
    );
  }
}
