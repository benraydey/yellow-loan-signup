import 'package:go_router/go_router.dart';
import 'package:yellow_loan_signup_flutter_app/home/home.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
