part of 'income_upload_file_bloc.dart';

enum IncomeUploadFileStatus { initial, loading, success, error }

class IncomeUploadFileState extends Equatable {
  const IncomeUploadFileState({
    this.status = IncomeUploadFileStatus.initial,
    this.fileNameLocal,
    this.fileSizeFormatted,
    this.errorMessage,
    this.fileId,
  });

  final IncomeUploadFileStatus status;
  final String? fileNameLocal;
  final String? fileSizeFormatted;
  final String? errorMessage;
  final String? fileId;

  IncomeUploadFileState copyWith({
    IncomeUploadFileStatus? status,
    String? fileNameLocal,
    String? fileSizeFormatted,
    String? errorMessage,
    String? fileId,
  }) {
    return IncomeUploadFileState(
      status: status ?? this.status,
      fileNameLocal: fileNameLocal ?? this.fileNameLocal,
      fileSizeFormatted: fileSizeFormatted ?? this.fileSizeFormatted,
      errorMessage: errorMessage ?? this.errorMessage,
      fileId: fileId ?? this.fileId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    fileNameLocal,
    fileSizeFormatted,
    errorMessage,
    fileId,
  ];
}
