import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:formy/formy.dart';
import 'package:formy/src/cubit/formy_cubit.dart';
import 'package:formy/src/models/formy_field_state.dart';
import 'package:formy/src/widgets/formy_field.dart';

/// A searchable dropdown menu
class FormySearchableDropdown<T> extends FormyField<T> {
  FormySearchableDropdown({
    required super.name,
    required super.label,
    required this.items,
    this.unselectedLabel = defaultUnselectedLabel,
    this.valueIfUnselectedButNotNull,
    this.noItemsFoundText = 'No items found',
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
        assert(
          items.map((item) => item.label).toSet().length == items.length,
          'Items must have unique labels',
        ),
        super(
          inputDecorationEnabled: false,
          focusEnabled: false,
          builder: (context, state) {
            return _SearchableDropdown<T>(
              state: state,
              items: items,
              unselectedLabel: unselectedLabel,
              valueIfUnselectedButNotNull: valueIfUnselectedButNotNull,
              noItemsFoundText: noItemsFoundText,
            );
          },
        );

  /// Menu items
  final List<FormyDropdownItem<T>> items;

  /// Label shown before a value has been selected
  ///
  /// Defaults to [defaultUnselectedLabel]
  final String Function(String label) unselectedLabel;

  /// Value to set if user types a non-valid option
  final T? valueIfUnselectedButNotNull;

  /// Text to show when no items are found
  final String noItemsFoundText;

  /// Default unselected label function
  static String defaultUnselectedLabel(String label) =>
      'Select ${label.toLowerCase()}';
}

class _SearchableDropdown<T> extends StatefulWidget {
  const _SearchableDropdown({
    required this.state,
    required this.items,
    required this.unselectedLabel,
    required this.valueIfUnselectedButNotNull,
    required this.noItemsFoundText,
    super.key,
  });

  final FormyFieldState<T> state;
  final List<FormyDropdownItem<T>> items;
  final String Function(String label) unselectedLabel;
  final T? valueIfUnselectedButNotNull;
  final String noItemsFoundText;

  @override
  State<_SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<_SearchableDropdown<T>> {
  late final TextEditingController _textController;
  final _suggestionsController = SuggestionsBoxController();
  late final List<String> labels;
  late bool _showClearButton;
  final FocusNode _focusNode = FocusNode();
  bool _dropdownVisible = false;

  @override
  void initState() {
    _textController = TextEditingController(
      text: widget.items
              .where(
                (item) => item.value == widget.state.value,
              )
              .firstOrNull
              ?.label ??
          '',
    );
    _showClearButton = _textController.text.isNotEmpty;
    labels = widget.items.map((item) => item.label.toLowerCase()).toList();
    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

    super.initState();
  }

  void _onFocusChanged() {
    setState(() {
      _dropdownVisible = _focusNode.hasFocus;
    });
    if (_focusNode.hasFocus) {
      FormyCubit.of(context).focus<T>(widget.state.name);
    } else {
      // ignore: avoid_print
      FormyCubit.of(context).unfocus<T>(widget.state.name);
    }
  }

  void _onTextChanged() {
    final text = _textController.text;
    final textIsAnItem = labels.contains(text.toLowerCase());
    if (textIsAnItem) {
      final item = widget.items
          .where(
            (item) => item.label.toLowerCase() == text.toLowerCase(),
          )
          .firstOrNull;
      FormyCubit.of(context).updateValue(widget.state.name, item?.value);
    } else {
      if (text.isEmpty) {
        FormyCubit.of(context).updateValue<String?>(widget.state.name, null);
      } else {
        FormyCubit.of(context)
            .updateValue(widget.state.name, widget.valueIfUnselectedButNotNull);
      }
    }
    setState(() {
      _showClearButton = _textController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _textController
      ..removeListener(_onTextChanged)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _SearchableDropdown<T> oldWidget) {
    if (oldWidget.state.error != widget.state.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _suggestionsController.resize();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DropDownSearchField(
      isMultiSelectDropdown: false,
      displayAllSuggestionWhenTap: false,
      noItemsFoundBuilder: (context) {
        return ListTile(
          title: Text(widget.noItemsFoundText),
        );
      },
      suggestionsBoxController: _suggestionsController,
      textFieldConfiguration: TextFieldConfiguration(
        controller: _textController,
        focusNode: _focusNode,
        autofocus: true,
        onSubmitted: (pattern) {
          final suggestions = _getSuggestions(pattern);
          if (suggestions.isNotEmpty) {
            _textController.text = suggestions.first.label;
          }
        },
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_showClearButton) ...[
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _textController.clear();
                    },
                  ),
                  const SizedBox(width: 4),
                ],
                IconButton(
                  icon: Icon(
                    _dropdownVisible
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                  onPressed: _focusNode.requestFocus,
                ),
              ],
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          label: Text(widget.state.label),
          hintText: 'Select ${widget.state.label.toLowerCase()}',
          errorText: widget.state.error,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          focusColor: Colors.transparent,
          errorMaxLines: 5,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          fillColor: const Color(0xffECEEEF),
        ),
      ),
      suggestionsCallback: _getSuggestions,
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: suggestion.leading,
          title: Text(suggestion.label),
        );
      },
      onSuggestionSelected: (suggestion) {
        _textController.text = suggestion.label;
      },
    );
  }

  List<FormyDropdownItem<T>> _getSuggestions(String pattern) {
    return widget.items
        .where(
          (item) => item.label.toLowerCase().contains(
                pattern.toLowerCase(),
              ),
        )
        .toList();
  }
}
