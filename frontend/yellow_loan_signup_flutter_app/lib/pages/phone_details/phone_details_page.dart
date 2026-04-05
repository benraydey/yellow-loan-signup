import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/selected_phone_cubit/selected_phone_cubit.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone_details/phone_details_page_desktop.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone_details/phone_details_page_mobile.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';

class PhoneDetailsPage extends StatefulWidget {
  const PhoneDetailsPage({super.key});

  @override
  State<PhoneDetailsPage> createState() => _PhoneDetailsPageState();
}

class _PhoneDetailsPageState extends State<PhoneDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final selectedPhoneState = context.watch<SelectedPhoneCubit>().state;

    // If no phone is selected, redirect to home page
    if (selectedPhoneState.selectedPhone == null) {
      // add post frame callback to avoid calling context.push during build
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 600), () {});
        if (!context.mounted) return;
        if (ModalRoute.of(context)?.isCurrent != true) return;
        if (context.read<SelectedPhoneCubit>().state.selectedPhone != null) {
          return;
        }
        await context.push('/');
      });
    }

    if (isMobile(context)) {
      return const PhoneDetailsPageMobile();
    } else {
      return const PhoneDetailsPageDesktop();
    }
  }
}
