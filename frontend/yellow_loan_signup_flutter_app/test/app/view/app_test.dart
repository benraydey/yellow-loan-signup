// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:yellow_loan_signup_flutter_app/app/app.dart';
import 'package:yellow_loan_signup_flutter_app/home/home.dart';

void main() {
  group('App', () {
    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
