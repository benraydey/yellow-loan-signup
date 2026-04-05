import 'package:flutter/material.dart';
import 'package:formy/src/models/formy_field_state.dart';
import 'package:formy/src/widgets/formy_field.dart';
import 'package:pinput/pinput.dart';

/// A text field for user input
class FormyPinField extends FormyField<String> {
  /// Creates a text field for user input
  const FormyPinField({
    required super.name,
    required super.label,
    super.key,
    super.autoValidateRules,
    super.inheritAutoValidateRules = true,
    super.inheritNullValidator = true,
    super.validator,
    super.nullValidator,
    super.nullValues = const [''],
    super.unfocusOnTapOutside = true,
    super.autofocus = false,
    this.onCompleted,
    this.onChanged,
    this.enabled = true,
    this.keyboardType = TextInputType.number,
    this.length = 4,
    this.height,
    this.width,
  }) : super(inputDecorationEnabled: false, focusEnabled: false);

  /// Keyboard type for the text field
  final TextInputType keyboardType;

  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final bool enabled;
  final int length;
  final double? width;
  final double? height;

  @override
  FormyFieldWidgetState<String, FormyPinField> createState() =>
      _FormyPinFieldState();
}

class _FormyPinFieldState extends FormyFieldWidgetState<String, FormyPinField> {
  late final TextEditingController pinController;
  String? appSignature;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController(text: currentValue ?? '');
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  void fieldListener(
    BuildContext context,
    FormyFieldState<String> fieldState,
  ) {
    if (fieldState.value != pinController.text) {
      pinController.text = fieldState.value ?? '';
      setState(() {});
    }
  }

  @override
  Widget fieldBuilder(
    BuildContext context,
    FormyFieldState<String> fieldState,
  ) {
    const focusedBorderColor = Colors.black;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Colors.black26;

    final defaultPinTheme = PinTheme(
      width: widget.width ?? 56,
      height: widget.height ?? 56,
      textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );

    return Pinput(
      length: widget.length,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      controller: pinController,
      focusNode: focusNode,
      onTapOutside: (_) {
        if (widget.unfocusOnTapOutside) {
          focusNode.unfocus();
        }
      },
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => const SizedBox(width: 8),
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onCompleted: widget.onCompleted,
      keyboardType: widget.keyboardType,
      onChanged: onChanged,
      errorText: fieldState.error,
      forceErrorState: fieldState.error != null,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: fillColor,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyBorderWith(
        border: Border.all(color: Colors.redAccent),
      ),
    );
  }

  @override
  void onChanged(String value) {
    super.onChanged(value);
    widget.onChanged?.call(value);
  }
}
