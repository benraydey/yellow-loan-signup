import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'submit_application_event.dart';
part 'submit_application_state.dart';

class SubmitApplicationBloc
    extends Bloc<SubmitApplicationEvent, SubmitApplicationState> {
  SubmitApplicationBloc() : super(const SubmitApplicationState()) {
    on<SubmitApplication>(_onSubmitApplication);
    on<ResetSubmitApplication>(_onReset);
  }

  Future<void> _onSubmitApplication(
    SubmitApplication event,
    Emitter<SubmitApplicationState> emit,
  ) async {
    emit(state.copyWith(status: SubmitApplicationStatus.loading));

    try {
      await Supabase.instance.client.from('applications').insert({
        'full_name': event.fullName,
        'id_number': event.idNumber,
        'monthly_income': event.monthlyIncome,
        'proof_document': event.filename,
        'phone_id': event.selectedPhoneId,
      });

      emit(
        state.copyWith(
          status: SubmitApplicationStatus.success,
          errorMessage: '',
        ),
      );
    } on PostgrestException catch (e) {
      emit(
        state.copyWith(
          status: SubmitApplicationStatus.error,
          errorMessage: e.message,
        ),
      );
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: SubmitApplicationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onReset(
    ResetSubmitApplication event,
    Emitter<SubmitApplicationState> emit,
  ) {
    emit(const SubmitApplicationState());
  }
}
