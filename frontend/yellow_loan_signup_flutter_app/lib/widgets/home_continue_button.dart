import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/app/router/app_router.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/index.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/gen/app_localizations.dart';
import 'package:yellow_loan_signup_flutter_app/util/home_continue.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/app_primary_button.dart';

class HomeContinueButton extends StatelessWidget {
  const HomeContinueButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApplicationStartBloc, ApplicationStartState>(
      listener: (context, state) async {
        if (state.status == ApplicationStartStatus.error) {
          if (!isMobile(context)) {
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
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              duration: const Duration(seconds: 6),
            ),
          );
        } else if (state.status == ApplicationStartStatus.loaded) {
          if (state.applicationExists) {
            if (!isMobile(context)) {
              await showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Application Exists'),
                  content: Text(
                    AppLocalizations.of(context).homeApplicationExists,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).homeApplicationExists,
                ),
                duration: const Duration(seconds: 6),
              ),
            );
          } else {
            // Application doesn't exist, proceed to next page
            await context.push(AppRoute.income.path);
          }
        }
      },
      child: BlocBuilder<ApplicationStartBloc, ApplicationStartState>(
        builder: (context, state) {
          return AppPrimaryButton(
            title: AppLocalizations.of(context).buttonContinue,
            isLoading: state.isLoading,
            onPressed: () => homeContinue(context),
          );
        },
      ),
    );
  }
}
