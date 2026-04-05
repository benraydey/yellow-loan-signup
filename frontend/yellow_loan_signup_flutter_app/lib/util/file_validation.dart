const List<String> allowedFileExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

bool isValidFileType(String fileName) {
  final extension = fileName.split('.').last.toLowerCase();
  return allowedFileExtensions.contains(extension);
}

String? validateFileType(String fileName) {
  if (!isValidFileType(fileName)) {
    return 'Only PDF, JPG, and PNG files are allowed';
  }
  return null;
}
