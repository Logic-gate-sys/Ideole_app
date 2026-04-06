import 'package:flutter/material.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';

/// Text input field following Sahara design
class SaharaTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;

  const SaharaTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
  });

  @override
  State<SaharaTextField> createState() => _SaharaTextFieldState();
}

class _SaharaTextFieldState extends State<SaharaTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            widget.label,
            style: SaharaTypography.labelMedium.copyWith(
              color: SaharaColors.onSurface,
            ),
          ),
        ),
        // Input field
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          obscureText: widget.obscureText,
          style: SaharaTypography.bodyMedium.copyWith(
            color: SaharaColors.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: SaharaTypography.bodyMedium.copyWith(
              color: SaharaColors.onSurfaceVariant,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor: _isFocused
                ? SaharaColors.surface
                : SaharaColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.errorText != null
                    ? SaharaColors.error
                    : SaharaColors.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.errorText != null
                    ? SaharaColors.error
                    : SaharaColors.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: SaharaColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: SaharaColors.error,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        // Error message
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.errorText!,
              style: SaharaTypography.bodySmall.copyWith(
                color: SaharaColors.error,
              ),
            ),
          ),
      ],
    );
  }
}

/// Password input field with show/hide toggle
class SaharaPasswordField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const SaharaPasswordField({
    super.key,
    required this.label,
    this.hint = 'Enter your password',
    this.controller,
    this.onChanged,
    this.errorText,
  });

  @override
  State<SaharaPasswordField> createState() => _SaharaPasswordFieldState();
}

class _SaharaPasswordFieldState extends State<SaharaPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SaharaTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      errorText: widget.errorText,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: SaharaColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
