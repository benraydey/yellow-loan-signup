import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:formy/formy.dart';
import 'package:yellow_loan_signup_flutter_app/app/router/app_router.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/application_start_bloc/application_start_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/income_upload_file/income_upload_file_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/selected_phone_cubit/selected_phone_cubit.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/submit_application_bloc/submit_application_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/l10n.dart';

final incomeUploadFileBlocGlobalKey = GlobalKey<State>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ApplicationStartBloc(),
        ),
        BlocProvider(
          create: (context) => IncomeUploadFileBloc(),
        ),
        BlocProvider(
          create: (context) => SelectedPhoneCubit(),
        ),
        BlocProvider(
          create: (context) => SubmitApplicationBloc(),
        ),
      ],
      child: Formy(
        autoValidateRules: const AutoValidateRules.standard(),
        nullValidator: (value, label) {
          if (value == null) {
            return '$label is required';
          }
          return null;
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xfffcd809),
              primary: const Color(0xfffcd809),
              onPrimary: Colors.black,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            ),
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
