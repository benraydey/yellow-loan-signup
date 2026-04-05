import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formy/formy.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/phone_list_bloc/phone_list_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/config/app_form_field.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone/phone_page_desktop.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone/phone_page_mobile.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';

final GlobalKey<State<StatefulWidget>> phoneListBlocGlobalKey = GlobalKey();

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check if the income page form is valid
      final isFormValid = Formy.of(context).validate(
        include: [
          AppFormField.monthlyIncome.name,
        ],
      );

      // If the form is not valid, redirect to home page
      if (!isFormValid) {
        await context.push('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: phoneListBlocGlobalKey,
      create: (context) => PhoneListBloc()..add(const FetchPhones()),
      child: const _PhonePageResponsive(),
    );
  }
}

class _PhonePageResponsive extends StatelessWidget {
  const _PhonePageResponsive();

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return const PhonePageMobile();
    } else {
      return const PhonePageDesktop();
    }
  }
}
