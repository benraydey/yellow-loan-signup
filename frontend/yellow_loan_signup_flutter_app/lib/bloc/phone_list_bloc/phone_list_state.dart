part of 'phone_list_bloc.dart';

enum PhoneListStatus { initial, loading, loaded, error }

class PhoneListState extends Equatable {
  const PhoneListState({
    this.status = PhoneListStatus.initial,
    this.phones = const [],
    this.errorMessage = '',
  });

  final PhoneListStatus status;
  final List<Phone> phones;
  final String errorMessage;

  bool get isLoading => status == PhoneListStatus.loading;

  PhoneListState copyWith({
    PhoneListStatus? status,
    List<Phone>? phones,
    String? errorMessage,
  }) {
    return PhoneListState(
      status: status ?? this.status,
      phones: phones ?? this.phones,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, phones, errorMessage];
}
