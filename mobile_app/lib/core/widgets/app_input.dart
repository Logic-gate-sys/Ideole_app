import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Ideole-specific text input field
class AppInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextInputType keyboardType;
  final int maxLines;
  final int? maxLength;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isEnabled;
  final TextCapitalization textCapitalization;
  final bool showCounter;

  const AppInput({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.textInputAction,
    this.onChanged,
    this.onEditingComplete,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.isEnabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.showCounter = false,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.isEnabled
                ? AppColors.surfaceContainerLowest
                : AppColors.surfaceContainer,
            enabled: widget.isEnabled,
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.outline,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: widget.prefixIcon,
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
            suffixIcon: widget.suffixIcon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.obscureText)
                        IconButton(
                          onPressed: () {
                            setState(() => _obscureText = !_obscureText);
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.outline,
                            size: 20,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: widget.suffixIcon,
                      ),
                    ],
                  )
                : widget.obscureText
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 48),
                        onPressed: () {
                          setState(() => _obscureText = !_obscureText);
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.outline,
                          size: 20,
                        ),
                      )
                    : null,
            counterText: widget.showCounter ? null : '',
            errorMaxLines: 1,
          ),
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          obscureText: _obscureText,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurface,
          ),
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          validator: widget.validator,
        ),
      ],
    );
  }
}
