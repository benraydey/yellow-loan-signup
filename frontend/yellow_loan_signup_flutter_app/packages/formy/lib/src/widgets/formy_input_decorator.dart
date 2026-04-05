import 'package:flutter/material.dart';
import 'package:formy/src/models/formy_field_state.dart';
import 'package:formy/src/widgets/formy_input_decoration.dart';

class FormyInputDecorator extends StatelessWidget {
  const FormyInputDecorator({
    required this.fieldState,
    Key? key,
  }) : super(key: key);

  final FormyFieldState<dynamic> fieldState;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
        decoration: formyInputDecoration(
      context,
      fieldState,
    ));
  }
}
