import 'package:flutter/material.dart';

class MobileAppBarSliver extends StatelessWidget {
  const MobileAppBarSliver({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      centerTitle: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 10,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Image.asset(
          'assets/yellow_logo.png',
          height: 40,
        ),
      ),
    );
  }
}
