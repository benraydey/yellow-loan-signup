import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/bloc/income_upload_file_bloc.dart';
import 'package:yellow_loan_signup_flutter_app/l10n/l10n.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_error_icon.dart';
import 'package:yellow_loan_signup_flutter_app/widgets/income_success_icon.dart';

const mediumWidthSpacing = SizedBox(width: 12);
const extraSmallSpacing = SizedBox(height: 4);

class IncomeFileUploadInput extends StatelessWidget {
  final bool showError;

  const IncomeFileUploadInput({
    super.key,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<IncomeUploadFileBloc, IncomeUploadFileState>(
      listener: _onUploadStateChanged,
      child: BlocBuilder<IncomeUploadFileBloc, IncomeUploadFileState>(
        builder: (context, state) {
          final isInvalid =
              showError &&
              (state.status != IncomeUploadFileStatus.success ||
                  state.fileId == null);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 56,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isInvalid
                            ? Theme.of(context).colorScheme.error
                            : Colors.grey,
                        width: isInvalid ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      minVerticalPadding: 0,
                      contentPadding: const EdgeInsets.only(left: 16),
                      onTap: state.status == IncomeUploadFileStatus.initial
                          ? () => _pickFile(context)
                          : null,
                      title: Center(
                        child: Row(
                          children: [
                            ..._leadingWidgets(context, state.status),
                            Expanded(
                              child: _buildTextPanel(context, state),
                            ),
                            if (state.status == IncomeUploadFileStatus.initial)
                              const SizedBox(
                                width: 48,
                                height: 48,
                                child: Icon(Icons.folder_outlined, size: 24),
                              )
                            else
                              Container(
                                width: 48,
                                height: 48,
                                margin: const EdgeInsets.only(right: 12),
                                child: IconButton(
                                  onPressed: () => context
                                      .read<IncomeUploadFileBloc>()
                                      .add(const IncomeDeleteFile()),
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    size: 24,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              extraSmallSpacing,
              Text(
                AppLocalizations.of(context).incomeProofOfIncomeHint,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: isInvalid ? Theme.of(context).colorScheme.error : null,
                ),
              ),
              if (state.errorMessage != null &&
                  state.status == IncomeUploadFileStatus.error)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    state.errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _onUploadStateChanged(
    BuildContext context,
    IncomeUploadFileState state,
  ) {
    // Clear error when file upload succeeds
    if (state.status == IncomeUploadFileStatus.success &&
        state.fileId != null) {
      // The error will be cleared when validation passes
    }
  }

  Widget _buildTextPanel(
    BuildContext context,
    IncomeUploadFileState state,
  ) {
    if (state.fileNameLocal != null) {
      return Tooltip(
        message: state.fileNameLocal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.fileNameLocal!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (state.fileSizeFormatted != null)
              Text(
                state.fileSizeFormatted!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      );
    } else {
      return Text(
        AppLocalizations.of(context).incomeProofOfIncomeLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
  }

  List<Widget> _leadingWidgets(
    BuildContext context,
    IncomeUploadFileStatus status,
  ) {
    final widgetsToAdd = <Widget>[];
    switch (status) {
      case IncomeUploadFileStatus.initial:
        return widgetsToAdd;
      case IncomeUploadFileStatus.loading:
        widgetsToAdd.add(
          SizedBox(
            height: 24,
            width: 24,
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        );
        break;
      case IncomeUploadFileStatus.success:
        widgetsToAdd.add(
          const IncomeSuccessIcon(),
        );
        break;
      case IncomeUploadFileStatus.error:
        widgetsToAdd.add(
          const IncomeErrorIcon(),
        );
        break;
    }
    widgetsToAdd.add(mediumWidthSpacing);
    return widgetsToAdd;
  }

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final fileBytes = file.bytes;

      if (fileBytes != null) {
        if (!context.mounted) return;
        context.read<IncomeUploadFileBloc>().add(
          IncomeUploadFileRequest(
            fileBytes: fileBytes.toList(),
            fileName: file.name,
            source: IncomeUploadFileSource.file,
          ),
        );
      }
    }
  }
}
