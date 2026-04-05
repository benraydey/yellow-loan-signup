import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formy/src/models/formy_field_state.dart';
import 'package:formy/src/utils/string_extensions.dart';
import 'package:formy/src/widgets/formy_field.dart';

/// A text field for user input
class FormyTextField extends FormyField<String> {
  /// Creates a text field for user input
  const FormyTextField({
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
    super.initialValue,
    this.keyboardType = TextInputType.text,
    this.onEditingComplete,
    this.onTapOutside,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.showObscureTextSwitch = false,
    this.obscureTextInitial = false,
    this.capitalizeWords,
    this.suggestCapitalization = false,
    this.addCurrencyPrefix = false,
    this.hintText = '',
    this.suffixIcon,
    this.trimCharacterBefore,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
  }) : super(inputDecorationEnabled: false, focusEnabled: false);

  /// Creates a password text field
  factory FormyTextField.password({
    required String label,
    required String name,
    Key? key,
    void Function()? onEditingComplete,
    bool unfocusOnTapOutside = false,
    bool autofocus = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) =>
      FormyTextField(
        key: key,
        label: label,
        name: name,
        onEditingComplete: onEditingComplete,
        unfocusOnTapOutside: unfocusOnTapOutside,
        autofocus: autofocus,
        showObscureTextSwitch: true,
        obscureTextInitial: true,
        keyboardType: keyboardType,
        textInputAction: textInputAction ?? TextInputAction.go,
      );

  /// Keyboard type for the text field
  final TextInputType? keyboardType;

  /// Whether to show obscure text switch
  final bool showObscureTextSwitch;

  /// Whether the text field is initially obscured
  final bool obscureTextInitial;

  /// Defaults to going to the next field as long as [textInputAction] is
  /// [TextInputAction.next]
  final void Function()? onEditingComplete;

  /// Action to take when the user taps outside the text field
  final void Function()? onTapOutside;

  /// Action to take when the user taps on the text field
  final void Function()? onTap;

  /// Action to take when the user hits the enter button on the keyboard
  final TextInputAction textInputAction;

  /// List of input formatters to apply to the text field
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to capitalize each word in the text field
  ///
  /// If unspecified, defaults to true if [keyboardType]
  /// is [TextInputType.name] and false otherwise
  final bool? capitalizeWords;

  /// Whether to show a capitalization suggestion when the user types
  final bool suggestCapitalization;

  /// Whether to show the currency prefix (R) for the input
  final bool addCurrencyPrefix;

  /// Show a hint underneath the input
  final String hintText;

  ///An icon that appears after the editable part of the text field and after
  ///the suffix or suffixText, within the decoration's container.
  ///if not null, then [showObscureTextSwitch] is ignored.
  final Widget? suffixIcon;

  /// If [trimCharacterBefore] is set, the text field will trim everything
  /// after the first occurrence of that character when the field gains focus.
  ///
  /// Example:
  ///   text = "Hello (World)" and trimCharacterBefore = '('
  ///   result after focus = "Hello"
  final String? trimCharacterBefore;

  /// Whether the text field is enabled or disabled. Defaults to true (enabled).
  final bool enabled;

  /// Whether the text field is read-only. Defaults to false (editable).
  final bool readOnly;

  @override
  FormyFieldWidgetState<String, FormyTextField> createState() =>
      _FormyTextFieldState();
}

class _FormyTextFieldState
    extends FormyFieldWidgetState<String, FormyTextField> {
  late final TextEditingController _controller;
  late bool _isObscured;
  late bool capitalizeWords;
  late final List<TextInputFormatter> _inputFormatters;
  String? _capitalizationSuggestion;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: currentValue);
    capitalizeWords =
        widget.capitalizeWords ?? (widget.keyboardType == TextInputType.name);
    _isObscured = widget.obscureTextInitial;
    _inputFormatters = [];
    if (widget.inputFormatters != null) {
      _inputFormatters.addAll(widget.inputFormatters!);
    }
    // if (capitalizeWords) {
    //   _inputFormatters.add(TitleCaseTextFormatter());
    // }

    focusNode.addListener(() {
      if (!focusNode.hasFocus || widget.trimCharacterBefore == null) return;

      final charToTrim = widget.trimCharacterBefore;

      if (charToTrim == null) return;

      final text = _controller.text;
      final index = text.indexOf(charToTrim);

      if (index != -1) {
        final trimmed = text.substring(0, index).trim();
        if (trimmed != text) {
          _controller.text = trimmed;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: trimmed.length),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget fieldBuilder(
    BuildContext context,
    FormyFieldState<String> fieldState,
  ) {
    return Stack(
      children: [
        TextField(
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          focusNode: focusNode,
          obscureText: _isObscured,
          key: const Key('default_text_field'),
          controller: _controller,
          onTapOutside: widget.unfocusOnTapOutside
              ? (_) => FocusScope.of(context).unfocus()
              : null,
          decoration: !widget.addCurrencyPrefix
              ? inputDecoration(context, fieldState).copyWith(
                  helperMaxLines: 4,
                  helperText: widget.hintText,
                  suffixIcon: widget.suffixIcon ??
                      (widget.showObscureTextSwitch
                          ? IconButton(
                              icon: Icon(
                                _isObscured
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () => setState(() {
                                _isObscured = !_isObscured;
                              }),
                            )
                          : null),
                )
              : inputDecoration(context, fieldState).copyWith(
                  prefixText: 'R ',
                  helperText: widget.hintText,
                ),
          style: fieldTextStyle(context),
          keyboardType: widget.keyboardType,
          onChanged: onChanged,
          onEditingComplete: widget.onEditingComplete ??
              (widget.textInputAction == TextInputAction.next
                  ? () => FocusScope.of(context).nextFocus()
                  : null),
          onTapUpOutside: (details) => widget.onTapOutside?.call(),
          textInputAction: TextInputAction.next,
          inputFormatters: _inputFormatters,
          textCapitalization: capitalizeWords
              ? TextCapitalization.words
              : TextCapitalization.none,
        ),
        if (widget.suggestCapitalization)
          Positioned(
            left: 30,
            top: 0,
            bottom: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              // add a fading transition
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: _capitalizationSuggestion != null
                  ? _capitalizationSuggestionButton(context)
                  : Container(),
            ),
          ),
      ],
    );
  }

  TextStyle fieldTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  Widget _capitalizationSuggestionButton(BuildContext context) {
    return Row(
      children: [
        IgnorePointer(
          child: Text(
            _controller.text,
            style: fieldTextStyle(context).copyWith(
              color: Colors.transparent,
              backgroundColor: Colors.transparent,
              decorationColor: Colors.transparent,
            ),
          ),
        ),
        Tooltip(
          message: 'Use name case',
          child: ElevatedButton(
            focusNode: FocusNode(skipTraversal: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              minimumSize: Size.zero,
            ),
            onPressed: () {
              setState(() {
                _capitalizationSuggestion = null;
                _controller.text = _controller.text.toTitleCase();
                onChanged.call(_controller.text);
              });
            },
            child: Text(
              _capitalizationSuggestion!,
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void onChanged(String value) {
    if (widget.suggestCapitalization) {
      if (value.length > 1 && value.toTitleCase() != value) {
        setState(() {
          _capitalizationSuggestion = '${value.toTitleCase()}?';
        });
      } else {
        setState(() {
          _capitalizationSuggestion = null;
        });
      }
    }
    super.onChanged(value);
  }
}

/// Capitalizes each word in a text field
class TitleCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toTitleCase(),
      selection: newValue.selection,
    );
  }
}
