part of 'application_start_bloc.dart';

enum ApplicationStartStatus { initial, loading, loaded, error }

class ApplicationStartState extends Equatable {
  const ApplicationStartState({
    this.status = ApplicationStartStatus.initial,
    this.applicationExists = false,
    this.errorMessage = '',
  });

  final ApplicationStartStatus status;
  final bool applicationExists;
  final String errorMessage;

  bool get isLoading => status == ApplicationStartStatus.loading;

  ApplicationStartState copyWith({
    ApplicationStartStatus? status,
    bool? applicationExists,
    String? errorMessage,
  }) {
    return ApplicationStartState(
      status: status ?? this.status,
      applicationExists: applicationExists ?? this.applicationExists,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, applicationExists, errorMessage];
}
