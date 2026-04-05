part of 'selected_phone_cubit.dart';

class SelectedPhoneState extends Equatable {
  const SelectedPhoneState({
    this.selectedPhone,
  });

  final Phone? selectedPhone;

  @override
  List<Object?> get props => [selectedPhone];
}
