import 'package:flutter/material.dart';
import 'package:yellow_loan_signup_flutter_app/app/router/desktop_shell.dart';
import 'package:yellow_loan_signup_flutter_app/app/router/mobile_shell.dart';
import 'package:yellow_loan_signup_flutter_app/util/is_mobile.dart';

class ResponsiveShell extends StatelessWidget {
  const ResponsiveShell({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return MobileShell(child: child);
    } else {
      return DesktopShell(child: child);
    }
  }
}
