import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formy/src/models/formy_field_state.dart';
import 'package:formy/src/widgets/formy_field.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FormyDatePicker extends FormyField<String> {
  const FormyDatePicker({
    required super.name,
    required super.label,
    required this.format,
    super.key,
    super.autoValidateRules,
    super.inheritAutoValidateRules = true,
    super.inheritNullValidator = true,
    super.validator,
    super.nullValidator,
    super.nullValues = const [''],
    super.unfocusOnTapOutside = true,
    super.autofocus = false,
    this.maskInput = true,
  }) : super(inputDecorationEnabled: false, focusEnabled: false);

  /// Date format to use
  final String format;

  /// Whether to format the input to match the date format
  final bool maskInput;

  @override
  FormyFieldWidgetState<String, FormyDatePicker> createState() =>
      _FormyTextFieldState();
}

class _FormyTextFieldState
    extends FormyFieldWidgetState<String, FormyDatePicker> {
  late final TextEditingController _controller;
  late final List<TextInputFormatter> _inputFormatters;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: currentValue);
    _inputFormatters = widget.maskInput
        ? [
            maskInputFormatter(
              initialText: currentValue,
            )
          ]
        : [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final dateSelected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
            textButtonTheme: Theme.of(context).textButtonTheme,
          ),
          child: child!,
        );
      },
    );
    if (dateSelected != null) {
      final formattedDate = DateFormat(widget.format).format(dateSelected);
      setState(() {
        _controller.text = formattedDate;
      });
      onChanged.call(formattedDate);
    }
  }

  TextInputFormatter maskInputFormatter({String? initialText = ''}) {
    final format = widget.format;
    final mask = format.replaceAll(
      RegExp('[a-zA-Z]'),
      '#',
    );
    return MaskTextInputFormatter(
      mask: mask,
      initialText: initialText,
      filter: {
        '#': RegExp('[0-9]'),
      },
      type: MaskAutoCompletionType.eager,
    );
  }

  @override
  Widget fieldBuilder(
    BuildContext context,
    FormyFieldState<String> fieldState,
  ) {
    return TextField(
      controller: _controller,
      focusNode: focusNode,
      onChanged: onChanged,
      inputFormatters: _inputFormatters,
      keyboardType: TextInputType.datetime,
      decoration: inputDecoration(context, fieldState).copyWith(
        hintText: widget.format.toUpperCase(),
        suffixIcon: InkWell(
          onTap: () => _selectDate(context),
          child: const Icon(Icons.calendar_month_outlined),
        ),
      ),
    );
  }
}
