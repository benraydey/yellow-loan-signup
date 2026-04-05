import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yellow_loan_signup_flutter_app/model/phone.dart';

part 'selected_phone_state.dart';

class SelectedPhoneCubit extends Cubit<SelectedPhoneState> {
  SelectedPhoneCubit() : super(const SelectedPhoneState());

  void selectPhone(Phone phone) {
    emit(SelectedPhoneState(selectedPhone: phone));
  }

  void clearSelection() {
    emit(const SelectedPhoneState());
  }
}
