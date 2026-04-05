import 'package:flutter/material.dart';
import 'package:grid_space/grid_space.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:yellow_loan_signup_flutter_app/config/constants.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/call_to_action_button.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/offer_card.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/old_primary_card.dart';

enum ContentStatus { initial, loading, moreLoading, loaded, error, refreshing }

/// {@template card_grid}
/// Grid to hold offer cards. Must have [GridSpaceContainer] as an ancestor.
/// {@endtemplate}
class CardGrid extends StatefulWidget {
  /// {@macro card_grid}
  const CardGrid({
    super.key,
    this.errorText = 'Something went wrong.',
    this.status = ContentStatus.initial,
    this.loadedItemBuilder,
    this.loadedItemCount,
    this.loadingItemCount = 6,
    this.loadMoreButtonVisible,
    this.maintainLoadMoreButtonSpace = true,
    String? loadMoreButtonText,
    this.loadMoreOnPressed,
    required this.loadMoreIndicatorEnabled,
    required this.disabledOnMoreLoading,
    this.loadingWidget,
    this.maintainLoadingIndicatorSize = true,
  }) : loadMoreButtonText = loadMoreButtonText ?? 'Load more';

  /// {@macro card_grid}
  factory CardGrid.mobile({
    required ContentStatus status,
    required int loadedItemCount,
    Widget Function(BuildContext context, int index)? loadedItemBuilder,
    Widget? loadingWidget,
    void Function(int numItemsPerRow)? loadMoreOnPressed,
    bool? loadMoreButtonVisible,
    bool maintainLoadMoreButtonSpace = true,
    String? loadMoreButtonText,
    int loadingItemCount = 6,
  }) {
    return CardGrid(
      status: status,
      loadedItemBuilder: loadedItemBuilder,
      loadedItemCount: loadedItemCount,
      loadMoreIndicatorEnabled: true,
      disabledOnMoreLoading: false,
      loadingWidget: loadingWidget,
      maintainLoadingIndicatorSize: false,
      loadMoreOnPressed: loadMoreOnPressed,
      loadMoreButtonText: loadMoreButtonText,
      loadMoreButtonVisible: loadMoreButtonVisible,
      maintainLoadMoreButtonSpace: maintainLoadMoreButtonSpace,
      loadingItemCount: loadingItemCount,
    );
  }

  /// {@macro card_grid}
  factory CardGrid.desktop({
    required ContentStatus status,
    required int loadedItemCount,
    Widget Function(BuildContext context, int index)? loadedItemBuilder,
    Widget? loadingWidget,
    void Function(int numItemsPerRow)? loadMoreOnPressed,
    bool? loadMoreButtonVisible,
    String? loadMoreButtonText,
    int loadingItemCount = 6,
  }) {
    return CardGrid(
      status: status,
      loadedItemBuilder: loadedItemBuilder,
      loadedItemCount: loadedItemCount,
      loadMoreIndicatorEnabled: false,
      loadMoreButtonVisible: loadMoreButtonVisible,
      disabledOnMoreLoading: true,
      loadingWidget: loadingWidget,
      loadMoreOnPressed: loadMoreOnPressed,
      loadMoreButtonText: loadMoreButtonText,
      loadingItemCount: loadingItemCount,
    );
  }

  /// Text to show when status is error
  final String errorText;

  /// Status
  final ContentStatus status;

  /// Loaded item builder
  final Widget Function(BuildContext context, int index)? loadedItemBuilder;

  /// Number of loaded items
  final int? loadedItemCount;

  /// Number of items shown to be loading
  final int loadingItemCount;

  final bool? loadMoreButtonVisible;

  final bool maintainLoadMoreButtonSpace;

  final String loadMoreButtonText;

  final void Function(int numItemsPerRow)? loadMoreOnPressed;

  /// Whether to show a loading indicator when [status] =
  /// [ContentStatus.moreLoading].
  ///
  /// Ignored when [loadMoreButtonVisible] != null
  final bool loadMoreIndicatorEnabled;

  /// Whether to whiten grid and disable touch when loading more
  final bool disabledOnMoreLoading;

  /// Widget to show when loading
  final Widget? loadingWidget;

  final bool maintainLoadingIndicatorSize;

  @override
  State<CardGrid> createState() => _CardGridState();
}

class _CardGridState extends State<CardGrid> {
  late int loadedItemCount;

  @override
  void initState() {
    loadedItemCount = widget.loadedItemCount ?? 0;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CardGrid oldWidget) {
    if (oldWidget.loadedItemCount != widget.loadedItemCount) {
      setState(() {
        loadedItemCount = widget.loadedItemCount ?? 0;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == ContentStatus.initial) {
      return Container();
    } else if (widget.status == ContentStatus.error) {
      return Center(
        child: Text(widget.errorText),
      );
    } else {
      return _buildGridArea;
    }
  }

  Widget get _buildGridArea {
    final loadMoreIndicatorEnabled =
        widget.loadMoreIndicatorEnabled && widget.loadMoreButtonVisible == null;
    return Stack(
      children: [
        Column(
          children: [
            _buildGrid,
            if (widget.loadMoreButtonVisible != null) _buildLoadMoreButton,
            if (loadMoreIndicatorEnabled) _buildLoadingIndicator,
          ],
        ),
        if (widget.status == ContentStatus.moreLoading &&
            widget.disabledOnMoreLoading)
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
      ],
    );
  }

  Widget get _buildLoadMoreButton {
    return Builder(
      builder: (context) {
        return Visibility(
          visible: widget.loadMoreButtonVisible!,
          maintainSize: widget.maintainLoadMoreButtonSpace,
          maintainAnimation: true,
          maintainState: true,
          child: Column(
            children: [
              extraLargeSpacing,
              CallToActionButton(
                onPressed: () => widget.loadMoreOnPressed?.call(
                  GridSpace.of(context).itemCountPerRow,
                ),
                isLoading: widget.status == ContentStatus.moreLoading,
                title: widget.loadMoreButtonText,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget get _buildLoadingIndicator {
    return Visibility(
      visible: widget.status == ContentStatus.moreLoading,
      maintainSize: widget.maintainLoadingIndicatorSize,
      maintainAnimation: true,
      maintainState: true,
      child: Column(
        children: [
          extraLargeSpacing,
          SizedBox(
            height: 40,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buildGrid {
    return GridSpaceBuilder(
      // center: true,
      itemCount: widget.status == ContentStatus.loading
          ? widget.loadingItemCount > 0
                ? widget.loadingItemCount
                : 6
          : loadedItemCount,
      itemBuilder: (context, index) {
        return Builder(
          builder: (context) {
            if (index < loadedItemCount) {
              return widget.loadedItemBuilder?.call(context, index) ??
                  _loadedItemBuilderDefault(context, index);
            } else {
              return Skeletonizer(child: _loadingItem);
            }
          },
        );
      },
    );
  }

  Widget _loadedItemBuilderDefault(BuildContext context, int index) {
    return OldPrimaryCard(
      elevation: 5,
      margin: EdgeInsets.zero,
      child: Container(),
    );
  }

  Widget get _loadingItem {
    return widget.loadingWidget ?? OfferCard.skeleton();
  }
}
