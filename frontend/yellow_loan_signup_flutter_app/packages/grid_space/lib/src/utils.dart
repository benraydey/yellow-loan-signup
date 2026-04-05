import 'dart:math';

/// Returns the number of items per row which will result in a totalWidth
/// (items + spaces) less than or equal to a [contentMaxWidth].
int calcNumItemsPerRow({
  required double contentMaxWidth,
  required double itemWidth,
  required int minItemsPerRow,
  double itemSpacing = 0,
  int? maxItemsPerRow,
  double? itemMinWidth,
  double contentMinWidth = 0,
}) {
  return _numItemsPerRowRecursive(
    1,
    contentMaxWidth: contentMaxWidth,
    itemWidth: itemWidth,
    itemSpacing: itemSpacing,
    minItemsPerRow: minItemsPerRow,
    maxItemsPerRow: (maxItemsPerRow != null) ? maxItemsPerRow : 100000,
    itemMinWidth: itemMinWidth,
    contentMinWidth: contentMinWidth,
  );
}

int _numItemsPerRowRecursive(
  int numItems, {
  required double contentMaxWidth,
  required double itemWidth,
  required double itemSpacing,
  required int minItemsPerRow,
  required int maxItemsPerRow,
  double? itemMinWidth,
  double contentMinWidth = 0,
}) {
  final itemMinWidthResolved = itemMinWidth ?? itemWidth;

  if (contentWidth(numItems, itemWidth, itemSpacing) > contentMaxWidth) {
    final proposedNumItems = min(
      max(numItems - 1, minItemsPerRow),
      maxItemsPerRow,
    );
    if (contentWidth(
          proposedNumItems,
          itemWidth,
          itemSpacing,
        ) <
        contentMinWidth) {
      // Recalculate number of items per row, replacing itemWidth with
      // itemMinWidth
      return _numItemsPerRowRecursive(
        proposedNumItems,
        contentMaxWidth: contentMaxWidth,
        itemWidth: itemMinWidthResolved,
        itemSpacing: itemSpacing,
        minItemsPerRow: minItemsPerRow,
        maxItemsPerRow: maxItemsPerRow,
      );
    }
    return proposedNumItems;
  } else {
    return _numItemsPerRowRecursive(
      numItems + 1,
      contentMaxWidth: contentMaxWidth,
      itemWidth: itemWidth,
      itemSpacing: itemSpacing,
      minItemsPerRow: minItemsPerRow,
      maxItemsPerRow: maxItemsPerRow,
      itemMinWidth: itemMinWidth,
      contentMinWidth: contentMinWidth,
    );
  }
}

/// Returns the width a group of items of count [numItems] and width
/// [itemWidth] if the space between consecutive items is [itemSpacing].
double contentWidth(
  int numItems,
  double itemWidth,
  double itemSpacing,
) {
  return numItems * itemWidth + (numItems - 1) * itemSpacing;
}
