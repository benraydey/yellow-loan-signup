import 'package:flutter/material.dart';
import 'package:formy/src/cubit/formy_cubit.dart';
import 'package:formy/src/models/formy_field_state.dart';
import 'package:formy/src/widgets/formy_field.dart';
import 'package:formy/src/widgets/formy_input_decoration.dart';

class FormyDropdownMenu<T> extends FormyField<T> {
  FormyDropdownMenu({
    required super.name,
    required super.label,
    required this.items,
    super.initialValue,
    super.key,
    super.autoValidateRules,
    super.inheritAutoValidateRules = true,
    super.inheritNullValidator = true,
    super.validator,
    super.nullValidator,
    super.nullValues = const [''],
    super.unfocusOnTapOutside = true,
    super.autofocus = false,
  })  : assert(
          items.map((item) => item.value).toSet().length == items.length,
          'Items must have unique values',
        ),
        super(
          inputDecorationEnabled: false,
          focusEnabled: false,
          builder: (context, state) {
            return _DropdownMenu<T>(
              state: state,
              items: items,
            );
          },
        );

  /// Menu items
  final List<FormyDropdownItem<T>> items;
}

class FormyDropdownItem<T> {
  FormyDropdownItem({
    required this.value,
    required this.label,
    this.leading,
  });

  /// Output value
  final T value;

  /// Label shown to user
  final String label;

  /// Widget to show left of the label
  final Widget? leading;
}

class _DropdownMenu<T> extends StatefulWidget {
  const _DropdownMenu({
    required this.state,
    required this.items,
    super.key,
  });

  final FormyFieldState<T> state;
  final List<FormyDropdownItem<T>> items;

  @override
  State<_DropdownMenu<T>> createState() => _DropdownMenuState<T>();
}

class _DropdownMenuState<T> extends State<_DropdownMenu<T>> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      focusNode: _focusNode,
      onSaved: (_) => _focusNode.unfocus(),
      focusColor: Colors.transparent,
      alignment: Alignment.centerLeft,
      borderRadius: BorderRadius.circular(4),
      dropdownColor: const Color(0xffECEEEF),
      initialValue: widget.state.value,
      hint: Text(
        'Select ${widget.state.label.toLowerCase()}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      decoration: formyInputDecoration(context, widget.state),
      items: widget.items.map((item) {
        return _buildDropdownMenuItem(context, item: item);
      }).toList(),
      onChanged: (value) {
        _focusNode.unfocus();
        FormyCubit.of(context).updateValue(widget.state.name, value);
      },
    );
  }

  DropdownMenuItem<T> _buildDropdownMenuItem(
    BuildContext context, {
    required FormyDropdownItem<T> item,
  }) {
    return DropdownMenuItem(
      value: item.value,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (item.leading != null) ...[
            item.leading!,
            const SizedBox(width: 15),
          ],
          Text(
            item.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
