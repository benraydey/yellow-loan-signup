import 'package:flutter/material.dart';

/// Outlined button used as for call to action events
class CallToActionButton extends StatelessWidget {
  const CallToActionButton({
    super.key,
    this.onPressed,
    this.title,
    this.isLoading,
    this.maintainSizeWhenLoading = true,
  });

  /// Function to run when button is pressed
  final void Function()? onPressed;

  /// Button text
  final String? title;

  /// Whether to show loading animation.
  final bool? isLoading;

  /// Whether button should stay the same size as before when [isLoading]
  /// becomes true.
  final bool maintainSizeWhenLoading;

  @override
  Widget build(BuildContext context) {
    final isLoadingResolved = isLoading ?? false;
    final titleResolved = title ?? '';
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 46),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          24,
          6,
          24,
          6,
        ),
        child: maintainSizeWhenLoading
            ? Stack(
                children: [
                  _buildText(
                    context,
                    title: titleResolved,
                    isTransparent: isLoadingResolved,
                  ),
                  if (isLoadingResolved)
                    Positioned.fill(
                      child: Center(child: _buildLoadingCircle(context)),
                    ),
                ],
              )
            : isLoadingResolved
                ? _buildLoadingCircle(context)
                : _buildText(
                    context,
                    title: titleResolved,
                  ),
      ),
    );
  }

  SizedBox _buildLoadingCircle(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
        strokeWidth: 3,
      ),
    );
  }

  Text _buildText(
    BuildContext context, {
    required String title,
    bool isTransparent = false,
  }) {
    return Text(
      title,
      key: UniqueKey(),
      maxLines: 2,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      textWidthBasis: TextWidthBasis.longestLine,
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isTransparent
                ? Colors.transparent
                : Theme.of(context).colorScheme.primary,
          ),
    );
  }
}
