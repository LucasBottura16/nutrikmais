import 'package:flutter/material.dart';
import 'package:nutrikmais/globals/configs/colors.dart';

// O 'T' genérico torna o componente flexível para diferentes tipos de dados.
class CustomMultiSelectDropdown<T> extends StatefulWidget {
  final List<T>? value;
  final String hintText;
  final List<T> items;
  final ValueSetter<List<T>>? onChanged;
  final String? labelText;
  final bool isLoading;
  final String? emptyText;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? padding;
  final Color borderColor;
  final double borderRadius;
  final List<String> selectItemfinal;

  const CustomMultiSelectDropdown({
    super.key,
    this.value,
    required this.hintText,
    required this.items,
    this.onChanged,
    this.labelText,
    this.isLoading = false,
    this.emptyText,
    this.suffixIcon,
    this.padding,
    this.borderColor = Colors.grey,
    this.borderRadius = 8.0,
    this.selectItemfinal = const [],
  });

  @override
  State<CustomMultiSelectDropdown<T>> createState() =>
      _CustomMultiSelectDropdownState<T>();
}

class _CustomMultiSelectDropdownState<T>
    extends State<CustomMultiSelectDropdown<T>> {
  bool _isExpanded = false;
  late List<T> _selectedItems;
  late List<String> selectItemfinal = selectItemfinal;

  @override
  void initState() {
    super.initState();
    _selectedItems = widget.value ?? [];
  }

  @override
  void didUpdateWidget(covariant CustomMultiSelectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedItems = widget.value ?? [];
    }
  }

  void _onOptionSelected(T option, bool? isChecked) {
    setState(() {
      if (isChecked == true) {
        _selectedItems.add(option);
      } else {
        _selectedItems.remove(option);
      }
      // Notifica a tela pai sobre a mudança
      if (widget.onChanged != null) {
        widget.onChanged!(_selectedItems);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
          const SizedBox(height: 4),
        ],
        if (widget.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (widget.items.isEmpty && widget.emptyText != null)
          Text(widget.emptyText!)
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: widget.borderColor, width: 1),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Container(
                    padding:
                        widget.padding ??
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedItems.isEmpty
                                ? widget.hintText
                                : _selectedItems
                                      .map((e) => e.toString())
                                      .join(', '),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        widget.suffixIcon ??
                            Icon(
                              _isExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: MyColors.myPrimary,
                            ),
                      ],
                    ),
                  ),
                ),
                if (_isExpanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.items.map((option) {
                      return CheckboxListTile(
                        activeColor: MyColors.myPrimary,
                        title: Text(option.toString()),
                        value: _selectedItems.contains(option),
                        onChanged: (isChecked) =>
                            _onOptionSelected(option, isChecked),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        if (_selectedItems.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _selectedItems
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '')
                .split(',')
                .map((item) => Chip(label: Text(item.trim())))
                .toList(),
          ),
      ],
    );
  }
}
