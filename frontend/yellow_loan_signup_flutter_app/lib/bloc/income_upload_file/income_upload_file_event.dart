part of 'income_upload_file_bloc.dart';

abstract class IncomeUploadFileEvent extends Equatable {
  const IncomeUploadFileEvent();

  @override
  List<Object?> get props => [];
}

class IncomeUploadFileRequest extends IncomeUploadFileEvent {
  const IncomeUploadFileRequest({
    required this.fileBytes,
    required this.fileName,
    required this.source,
  });

  final List<int> fileBytes;
  final String fileName;
  final IncomeUploadFileSource source;

  @override
  List<Object?> get props => [fileBytes, fileName, source];
}

class IncomeDeleteFile extends IncomeUploadFileEvent {
  const IncomeDeleteFile();
}

class IncomeResetUploadFile extends IncomeUploadFileEvent {
  const IncomeResetUploadFile();
}

enum IncomeUploadFileSource { file, camera }
