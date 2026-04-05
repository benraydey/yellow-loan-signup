part of 'submit_application_bloc.dart';

enum SubmitApplicationStatus { initial, loading, success, error }

class SubmitApplicationState extends Equatable {
  const SubmitApplicationState({
    this.status = SubmitApplicationStatus.initial,
    this.errorMessage = '',
  });

  final SubmitApplicationStatus status;
  final String errorMessage;

  bool get isLoading => status == SubmitApplicationStatus.loading;

  SubmitApplicationState copyWith({
    SubmitApplicationStatus? status,
    String? errorMessage,
  }) {
    return SubmitApplicationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
