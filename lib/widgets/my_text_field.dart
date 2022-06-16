import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {Key? key,
      this.onChanged,
      this.labelText,
      this.prefixIcon,
      this.hintText})
      : super(key: key);

  final String? labelText;
  final String? hintText;
  final Function(String val)? onChanged;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (val) {
        if (onChanged != null) {
          onChanged!(val);
        }
      },
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        border: InputBorder.none,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                size: 20,
              )
            : null,
        fillColor: Colors.grey[200],
        filled: true,
      ),
    );
  }
}
