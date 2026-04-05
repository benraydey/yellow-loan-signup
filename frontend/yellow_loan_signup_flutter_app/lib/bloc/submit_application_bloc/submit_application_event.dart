part of 'submit_application_bloc.dart';

abstract class SubmitApplicationEvent extends Equatable {
  const SubmitApplicationEvent();

  @override
  List<Object?> get props => [];
}

class SubmitApplication extends SubmitApplicationEvent {
  const SubmitApplication({
    required this.fullName,
    required this.idNumber,
    required this.monthlyIncome,
    required this.filename,
    required this.selectedPhoneId,
  });

  final String fullName;
  final String idNumber;
  final String monthlyIncome;
  final String filename;
  final String selectedPhoneId;

  @override
  List<Object?> get props => [
    fullName,
    idNumber,
    monthlyIncome,
    filename,
    selectedPhoneId,
  ];
}

class ResetSubmitApplication extends SubmitApplicationEvent {
  const ResetSubmitApplication();
}
