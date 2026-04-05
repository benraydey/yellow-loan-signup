import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/phone_list_bloc/phone_list_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone/phone_page_desktop.dart';
import 'package:yellow_loan_signup_flutter_app/pages/phone/phone_page_mobile.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';

final GlobalKey<State<StatefulWidget>> phoneListBlocGlobalKey = GlobalKey();

class PhonePage extends StatelessWidget {
  const PhonePage({super.key});

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
