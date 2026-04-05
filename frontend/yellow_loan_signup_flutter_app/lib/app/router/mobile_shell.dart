import 'package:flutter/material.dart';

class MobileShell extends StatelessWidget {
  const MobileShell({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            centerTitle: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 10,
            shadowColor: Colors.black.withValues(alpha: 0.4),
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(18, 6, 0, 6),
              child: Image.asset(
                'assets/yellow_logo.png',
                height: 40,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: child,
          ),
        ],
      ),
    );
  }
}
