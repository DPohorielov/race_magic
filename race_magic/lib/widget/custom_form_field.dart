import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required TextInputAction inputAction,
    required String label,
    required String hint,
    this.isObscure = false,
    this.isCapitalized = false,
    this.maxLines = 1,
    this.isLabelEnabled = true,
    this.enabled = true,
    this.focusNode,
  })  : _emailController = controller,
        _keyboardtype = keyboardType,
        _inputAction = inputAction,
        _label = label,
        _hint = hint,
        super(key: key);

  final TextEditingController _emailController;
  final TextInputType _keyboardtype;
  final TextInputAction _inputAction;
  final String _label;
  final String _hint;
  final bool isObscure;
  final bool isCapitalized;
  final int maxLines;
  final bool isLabelEnabled;
  final bool enabled;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      focusNode: focusNode,
      maxLines: maxLines,
      controller: _emailController,
      keyboardType: _keyboardtype,
      obscureText: isObscure,
      textCapitalization:
          isCapitalized ? TextCapitalization.words : TextCapitalization.none,
      textInputAction: _inputAction,
      decoration: InputDecoration(
        labelText: isLabelEnabled ? _label : null,
        hintText: _hint,
        hintStyle: const TextStyle(
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
