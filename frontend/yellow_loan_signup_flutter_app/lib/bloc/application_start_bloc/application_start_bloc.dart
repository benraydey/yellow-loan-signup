import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'application_start_event.dart';
part 'application_start_state.dart';

class ApplicationStartBloc
    extends Bloc<ApplicationStartEvent, ApplicationStartState> {
  ApplicationStartBloc() : super(const ApplicationStartState()) {
    on<StartApplication>(_onStartApplication);
  }

  Future<void> _onStartApplication(
    StartApplication event,
    Emitter<ApplicationStartState> emit,
  ) async {
    emit(state.copyWith(status: ApplicationStartStatus.loading));

    try {
      final existingApplications =
          await Supabase.instance.client
                  .from('applications')
                  .select()
                  .eq('id_number', event.idNumber)
              as List<dynamic>;

      final applicationExists = existingApplications.isNotEmpty;

      emit(
        state.copyWith(
          status: ApplicationStartStatus.loaded,
          applicationExists: applicationExists,
          errorMessage: '',
        ),
      );
    } on PostgrestException catch (e) {
      emit(
        state.copyWith(
          status: ApplicationStartStatus.error,
          errorMessage: e.message,
        ),
      );
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: ApplicationStartStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
