import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formy/formy.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/income_upload_file/income_upload_file_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/selected_phone_cubit/selected_phone_cubit.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/submit_application_bloc/submit_application_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/pages/application_success/application_success_page_desktop.dart';
import 'package:yellow_loan_signup_flutter_app/pages/application_success/application_success_page_mobile.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';

class ApplicationSuccessPage extends StatelessWidget {
  const ApplicationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    // add post frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;
      // Reset all blocs and form fields
      context.read<SubmitApplicationBloc>().add(
        const ResetSubmitApplication(),
      );
      context.read<IncomeUploadFileBloc>().add(
        const IncomeResetUploadFile(),
      );
      context.read<SelectedPhoneCubit>().clearSelection();
      Formy.of(context).reset();
    });

    if (isMobile(context)) {
      return const ApplicationSuccessPageMobile();
    } else {
      return const ApplicationSuccessPageDesktop();
    }
  }
}
