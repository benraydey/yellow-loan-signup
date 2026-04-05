part of 'application_start_bloc.dart';

abstract class ApplicationStartEvent extends Equatable {
  const ApplicationStartEvent();

  @override
  List<Object?> get props => [];
}

class StartApplication extends ApplicationStartEvent {
  const StartApplication({required this.idNumber});

  final String idNumber;

  @override
  List<Object?> get props => [idNumber];
}
