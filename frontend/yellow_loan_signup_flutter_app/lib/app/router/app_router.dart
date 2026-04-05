import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formy/formy.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/app/router/responsive_shell.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/selected_phone_cubit/selected_phone_cubit.dart';
import 'package:yellow_loan_signup_flutter_app/config/app_form_field.dart';
import 'package:yellow_loan_signup_flutter_app/pages/application_success/application_success_page.dart';
import 'package:yellow_loan_signup_flutter_app/pages/home/home_page.dart';
import 'package:yellow_loan_signup_flutter_app/pages/income/income_page.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone/phone_page.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone_details/phone_details_page.dart';

enum AppRoute {
  home('/'),
  income('/income'),
  phones('/phones'),
  phoneDetails('/phone-details'),
  applicationSuccess('/application-success')
  ;

  const AppRoute(this.path);

  final String path;
}

final appRouter = GoRouter(
  initialLocation: AppRoute.home.path,
  routes: [
    ShellRoute(
      builder: (context, state, child) => ResponsiveShell(child: child),
      routes: [
        GoRoute(
          path: AppRoute.home.path,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoute.income.path,
          redirect: (context, state) {
            // Check if the form is valid
            final isFormValid = Formy.of(context).validate(
              include: [
                AppFormField.fullName.name,
                AppFormField.idNumber.name,
              ],
            );

            // If the form is not valid, redirect to home page
            if (!isFormValid) {
              return AppRoute.home.path;
            }

            // If the form is valid, allow navigation to income page
            return null;
          },
          builder: (context, state) => const IncomePage(),
        ),
        GoRoute(
          path: AppRoute.phones.path,
          redirect: (context, state) {
            // Check if the income page form is valid
            final isFormValid = Formy.of(context).validate(
              include: [
                AppFormField.monthlyIncome.name,
              ],
            );

            // If the form is not valid, redirect to home page
            if (!isFormValid) {
              return AppRoute.home.path;
            }

            // If the form is valid, allow navigation to phones page
            return null;
          },
          builder: (context, state) => const PhonePage(),
        ),
        GoRoute(
          path: AppRoute.phoneDetails.path,
          redirect: (context, state) {
            // Check if a phone is selected
            final selectedPhoneState = context.read<SelectedPhoneCubit>().state;

            // If no phone is selected, redirect to home page
            if (selectedPhoneState.selectedPhone == null) {
              return AppRoute.home.path;
            }

            // If a phone is selected, allow navigation to phone details page
            return null;
          },
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PhoneDetailsPage(),
          ),
        ),
        GoRoute(
          path: AppRoute.applicationSuccess.path,
          builder: (context, state) => const ApplicationSuccessPage(),
        ),
      ],
    ),
  ],
);
