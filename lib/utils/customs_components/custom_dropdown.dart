import 'package:flutter/material.dart';
import '../colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final List<T> items;
  final Function(T?)? onChanged;
  final String? labelText;
  final bool isLoading;
  final String? emptyText;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? padding;
  final Color borderColor;
  final double borderRadius;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.isLoading = false,
    this.emptyText,
    this.suffixIcon,
    this.padding,
    this.borderColor = Colors.grey,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
          const SizedBox(height: 4),
        ],
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (items.isEmpty && emptyText != null)
          Text(emptyText!)
        else
          Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                hint: Text(hintText),
                isExpanded: true,
                icon: suffixIcon ?? const Icon(Icons.arrow_drop_down, color: MyColors.myPrimary),
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                dropdownColor: Colors.white,
                onChanged: onChanged,
                items: items.map<DropdownMenuItem<T>>((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString()),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}