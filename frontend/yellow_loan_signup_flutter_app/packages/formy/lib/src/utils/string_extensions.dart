/// String extensions
extension StringExtensions on String {
  /// make string lowercase except when a word is all uppercase
  String toLowerCaseExceptUppercase() {
    return split(' ').map((word) {
      if (word == word.toUpperCase()) {
        return word;
      }
      return word.toLowerCase();
    }).join(' ');
  }

  /// Capitalizes each word in a string
  String toTitleCase({bool splitOnHyphens = true}) {
    // Split on spaces and hyphens
    // Split on spaces and hyphens
    final output = split(' ').map((word) {
      if (splitOnHyphens) {
        return word
            .split('-')
            .map(
              (word) => word[0].toUpperCase() + word.substring(1).toLowerCase(),
            )
            .join('-');
      }
      return word;
    }).join(' ');
    return output;
  }

  /// Returns the string with only numeric characters
  String numbersOnly() {
    var numberString = '';
    for (final char in split('')) {
      if (RegExp(r'^[0-9]*$').hasMatch(char)) {
        numberString += char;
      }
    }
    return numberString;
  }
}

/// Multi split extension
///
/// copied from https://stackoverflow.com/a/67525800
extension UtilExtensions on String {
  List<String> multiSplit(Iterable<String> delimeters) => delimeters.isEmpty
      ? [this]
      : split(RegExp(delimeters.map(RegExp.escape).join('|')));
}
