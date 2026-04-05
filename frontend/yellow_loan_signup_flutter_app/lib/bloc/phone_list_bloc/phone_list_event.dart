part of 'phone_list_bloc.dart';

abstract class PhoneListEvent extends Equatable {
  const PhoneListEvent();

  @override
  List<Object?> get props => [];
}

class FetchPhones extends PhoneListEvent {
  const FetchPhones();
}
