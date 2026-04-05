import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/app/router/responsive_shell.dart';
import 'package:yellow_loan_signup_flutter_app/pages/home/home_page.dart';
import 'package:yellow_loan_signup_flutter_app/pages/income/income_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ResponsiveShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/income',
          builder: (context, state) => const IncomePage(),
        ),
      ],
    ),
    GoRoute(
      path: '/phones',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Phones Page - Coming Soon'),
        ),
      ),
    ),
  ],
);
