import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppChipVariant { filled, outlined, elevated }

/// Ideole chip widget for selection/filtering
class AppChip extends StatefulWidget {
  final String label;
  final AppChipVariant variant;
  final bool selected;
  final VoidCallback? onSelected;
  final Widget? avatar;
  final Widget? deleteIcon;
  final VoidCallback? onDeleted;
  final bool enabled;
  final Color? selectedColor;

  const AppChip({
    super.key,
    required this.label,
    this.variant = AppChipVariant.filled,
    this.selected = false,
    this.onSelected,
    this.avatar,
    this.deleteIcon,
    this.onDeleted,
    this.enabled = true,
    this.selectedColor,
  });

  @override
  State<AppChip> createState() => _AppChipState();
}

class _AppChipState extends State<AppChip> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  void _handleSelected() {
    if (!widget.enabled) return;
    setState(() {
      _selected = !_selected;
    });
    widget.onSelected?.call();
  }

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color? textColor;
    Color? borderColor;

    if (!widget.enabled) {
      bgColor = AppColors.surfaceContainerLowest;
      textColor = AppColors.outline;
      borderColor = AppColors.outlineVariant;
    } else if (_selected) {
      bgColor = widget.selectedColor ?? AppColors.primaryContainer;
      textColor = AppColors.onPrimaryContainer;
      borderColor = null;
    } else {
      switch (widget.variant) {
        case AppChipVariant.filled:
          bgColor = AppColors.surfaceContainerLow;
          textColor = AppColors.onSurface;
          borderColor = null;
          break;
        case AppChipVariant.outlined:
          bgColor = Colors.transparent;
          textColor = AppColors.onSurface;
          borderColor = AppColors.outline;
          break;
        case AppChipVariant.elevated:
          bgColor = AppColors.surface;
          textColor = AppColors.onSurface;
          borderColor = null;
          break;
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleSelected,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1)
                : null,
            borderRadius: BorderRadius.circular(20),
            boxShadow: widget.variant == AppChipVariant.elevated
                ? [
                    BoxShadow(
                      color: AppColors.outline.withValues(alpha: 0.12),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.avatar != null) ...[
                widget.avatar!,
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: AppTextStyles.labelMedium.copyWith(color: textColor),
              ),
              if (widget.onDeleted != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: widget.enabled ? widget.onDeleted : null,
                  child: Icon(
                    widget.deleteIcon != null ? widget.deleteIcon as IconData : Icons.clear,
                    size: 16,
                    color: textColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Input chip for tags/search
class AppInputChip extends StatefulWidget {
  final String? initialValue;
  final String hintText;
  final List<String> tags;
  final void Function(List<String>) onTagsChanged;

  const AppInputChip({
    super.key,
    this.initialValue,
    this.hintText = 'Add tag',
    required this.tags,
    required this.onTagsChanged,
  });

  @override
  State<AppInputChip> createState() => _AppInputChipState();
}

class _AppInputChipState extends State<AppInputChip> {
  late List<String> _tags;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.tags);
    _controller.text = widget.initialValue ?? '';
  }

  void _addTag() {
    final value = _controller.text.trim();
    if (value.isNotEmpty && !_tags.contains(value)) {
      setState(() {
        _tags.add(value);
      });
      _controller.clear();
      widget.onTagsChanged(_tags);
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    widget.onTagsChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._tags.map((tag) => AppChip(
          label: tag,
          onDeleted: () => _removeTag(tag),
          deleteIcon: Icon(Icons.close),
        )),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onSubmitted: (_) => _addTag(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
