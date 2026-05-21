import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class AppDropdownOption<T extends Object> {
  const AppDropdownOption({
    required this.value,
    required this.child,
    this.selectedChild,
  });

  final T value;
  final Widget child;
  final Widget? selectedChild;
}

class AppDropdown<T extends Object> extends StatefulWidget {
  const AppDropdown({
    required this.options,
    required this.onChanged,
    this.value,
    this.placeholder = const Text('None'),
    this.showNoneOption = true,
    super.key,
  });

  final T? value;
  final List<AppDropdownOption<T>> options;
  final ValueChanged<T?> onChanged;
  final Widget placeholder;
  final bool showNoneOption;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T extends Object> extends State<AppDropdown<T>> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final selectedOption = _selectedOption;
    final hasSelection = widget.value != null;
    final borderColor = hasSelection || _isOpen
        ? AppColors.borderStrong
        : AppColors.border;

    return _DropdownField(
      isPlaceholder: !hasSelection,
      isOpen: _isOpen,
      borderColor: borderColor,
      onTap: _openMenu,
      child:
          selectedOption?.selectedChild ??
          selectedOption?.child ??
          widget.placeholder,
    );
  }

  AppDropdownOption<T>? get _selectedOption {
    for (final option in widget.options) {
      if (option.value == widget.value) {
        return option;
      }
    }

    return null;
  }

  Future<void> _openMenu() async {
    final renderBox = context.findRenderObject() as RenderBox?;
    final overlay =
        Navigator.of(context).overlay?.context.findRenderObject() as RenderBox?;
    if (renderBox == null || overlay == null) {
      return;
    }

    setState(() => _isOpen = true);

    final topLeft = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final fieldRect = topLeft & renderBox.size;
    final menuTop = fieldRect.bottom + AppSpacing.sm;
    final position = RelativeRect.fromLTRB(
      fieldRect.left,
      menuTop,
      overlay.size.width - fieldRect.right,
      overlay.size.height - menuTop,
    );
    final currentValue = widget.value;

    final result = await showMenu<_DropdownSelection<T>>(
      context: context,
      position: position,
      initialValue: currentValue == null
          ? _DropdownSelection<T>.none()
          : _DropdownSelection<T>.value(currentValue),
      color: AppColors.sheet,
      surfaceTintColor: AppColors.sheet,
      elevation: AppSpacing.none,
      menuPadding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(width: renderBox.size.width),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadii.lg),
        side: BorderSide(color: AppColors.border),
      ),
      popUpAnimationStyle: const AnimationStyle(
        curve: Easing.emphasizedDecelerate,
        duration: AppDurations.dropdownExpand,
        reverseCurve: Easing.emphasizedAccelerate,
        reverseDuration: AppDurations.dropdownExpand,
      ),
      items: [
        if (widget.showNoneOption)
          PopupMenuItem<_DropdownSelection<T>>(
            value: _DropdownSelection<T>.none(),
            child: _DropdownMenuRowContent(
              selected: widget.value == null,
              muted: true,
              child: widget.placeholder,
            ),
          ),
        for (final option in widget.options)
          PopupMenuItem<_DropdownSelection<T>>(
            value: _DropdownSelection<T>.value(option.value),
            child: _DropdownMenuRowContent(
              selected: widget.value == option.value,
              child: option.child,
            ),
          ),
      ],
    );

    if (mounted) {
      setState(() => _isOpen = false);
    }

    if (result == null) {
      return;
    }

    widget.onChanged(result.value);
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.child,
    required this.isPlaceholder,
    required this.isOpen,
    required this.borderColor,
    required this.onTap,
  });

  final Widget child;
  final bool isPlaceholder;
  final bool isOpen;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = isPlaceholder
        ? context.mutedText.bodyMedium
        : context.text.bodyMedium;

    return Material(
      color: AppColors.surfaceRaised,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(AppRadii.pill),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(AppRadii.pill),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: DefaultTextStyle.merge(
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: child,
                ),
              ),
              AnimatedRotation(
                turns: isOpen ? 0.5 : 0,
                duration: AppDurations.dropdownExpand,
                curve: AppCurves.standard,
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuRowContent extends StatelessWidget {
  const _DropdownMenuRowContent({
    required this.child,
    required this.selected,
    this.muted = false,
  });

  final Widget child;
  final bool selected;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final textStyle = muted
        ? context.mutedText.bodyMedium
        : context.text.bodyMedium;

    return DefaultTextStyle.merge(
      style: textStyle,
      child: IconTheme.merge(
        data: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppSizes.iconMd,
        ),
        child: Row(
          children: [
            Expanded(child: child),
            if (selected)
              const Icon(
                Icons.check_rounded,
                color: AppColors.textPrimary,
                size: AppSizes.iconMd,
              ),
          ],
        ),
      ),
    );
  }
}

class _DropdownSelection<T extends Object> {
  const _DropdownSelection.none() : value = null;

  const _DropdownSelection.value(this.value);

  final T? value;

  @override
  bool operator ==(Object other) {
    return other is _DropdownSelection<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
