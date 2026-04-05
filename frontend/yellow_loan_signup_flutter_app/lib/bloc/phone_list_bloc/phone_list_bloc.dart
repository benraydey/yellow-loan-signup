import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yellow_loan_signup_flutter_app/model/phone.dart';

part 'phone_list_event.dart';
part 'phone_list_state.dart';

class PhoneListBloc extends Bloc<PhoneListEvent, PhoneListState> {
  PhoneListBloc() : super(const PhoneListState()) {
    on<FetchPhones>(_onFetchPhones);
  }

  Future<void> _onFetchPhones(
    FetchPhones event,
    Emitter<PhoneListState> emit,
  ) async {
    emit(state.copyWith(status: PhoneListStatus.loading));

    try {
      final phonesData =
          await Supabase.instance.client.from('phones').select()
              as List<dynamic>;

      final phones = phonesData
          .map((json) => Phone.fromJson(json as Map<String, dynamic>))
          .toList();

      emit(
        state.copyWith(
          status: PhoneListStatus.loaded,
          phones: phones,
          errorMessage: '',
        ),
      );
    } on PostgrestException catch (e) {
      emit(
        state.copyWith(
          status: PhoneListStatus.error,
          errorMessage: e.message,
        ),
      );
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: PhoneListStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
