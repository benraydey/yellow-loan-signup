import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/pages/home/home_page.dart';
import 'package:yellow_loan_signup_flutter_app/pages/income/income_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
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
);
