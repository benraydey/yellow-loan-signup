import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/util/file_validation.dart';
import 'package:yellow_loan_signup_flutter_app/util/supabase_upload.dart';

part 'income_upload_file_event.dart';
part 'income_upload_file_state.dart';

class IncomeUploadFileBloc
    extends Bloc<IncomeUploadFileEvent, IncomeUploadFileState> {
  IncomeUploadFileBloc() : super(const IncomeUploadFileState()) {
    on<IncomeUploadFileRequest>(_onUploadFileRequest);
    on<IncomeDeleteFile>(_onDeleteFile);
    on<IncomeResetUploadFile>(_onResetUploadFile);
  }

  Future<void> _onUploadFileRequest(
    IncomeUploadFileRequest event,
    Emitter<IncomeUploadFileState> emit,
  ) async {
    emit(state.copyWith(status: IncomeUploadFileStatus.loading));

    try {
      // Validate file type
      final validationError = validateFileType(event.fileName);
      if (validationError != null) {
        emit(
          state.copyWith(
            status: IncomeUploadFileStatus.error,
            errorMessage: validationError,
          ),
        );
        return;
      }

      // Upload to Supabase
      final fileId = await uploadFileToSupabase(
        fileBytes: event.fileBytes,
        fileName: event.fileName,
      );

      final fileSizeKB = (event.fileBytes.length / 1024).toStringAsFixed(2);
      final fileSizeFormatted = '$fileSizeKB KB';

      emit(
        state.copyWith(
          status: IncomeUploadFileStatus.success,
          fileNameLocal: event.fileName,
          fileSizeFormatted: fileSizeFormatted,
          fileId: fileId,
        ),
      );
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: IncomeUploadFileStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteFile(
    IncomeDeleteFile event,
    Emitter<IncomeUploadFileState> emit,
  ) async {
    emit(const IncomeUploadFileState());
  }

  Future<void> _onResetUploadFile(
    IncomeResetUploadFile event,
    Emitter<IncomeUploadFileState> emit,
  ) async {
    emit(const IncomeUploadFileState());
  }
}
