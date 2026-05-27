import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class AppNumpad extends StatelessWidget {
  const AppNumpad({
    required this.controller,
    this.decimalSeparator = ',',
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final String decimalSeparator;
  final bool enabled;

  static const double _preferredKeyHeight = AppSpacing.xxxl;
  static const int _rowCount = 4;

  static const List<_AppNumpadKey> _keys = [
    _AppNumpadDigitKey('1'),
    _AppNumpadDigitKey('2'),
    _AppNumpadDigitKey('3'),
    _AppNumpadDigitKey('4'),
    _AppNumpadDigitKey('5'),
    _AppNumpadDigitKey('6'),
    _AppNumpadDigitKey('7'),
    _AppNumpadDigitKey('8'),
    _AppNumpadDigitKey('9'),
    _AppNumpadDecimalKey(),
    _AppNumpadDigitKey('0'),
    _AppNumpadBackspaceKey(),
  ];

  @override
  Widget build(BuildContext context) {
    final color = enabled
        ? context.colors.textPrimary
        : context.colors.textMuted;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        const preferredHeight =
            (_preferredKeyHeight * _rowCount) +
            (AppSpacing.sm * (_rowCount - 1));
        final height = constraints.hasBoundedHeight
            ? math.min(constraints.maxHeight, preferredHeight)
            : preferredHeight;
        final childAspectRatio = _gridChildAspectRatio(
          Size(availableWidth, height),
        );

        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _keys.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSpacing.lg,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                final key = _keys[index];
                return Semantics(
                  button: true,
                  label: key.semanticLabel(decimalSeparator),
                  child: Material(
                    color: Colors.transparent,
                    child: InkResponse(
                      onTap: enabled
                          ? () {
                              key.apply(controller, decimalSeparator);
                            }
                          : null,
                      radius: AppSpacing.xxl,
                      child: Center(
                        child: key.icon == null
                            ? Text(
                                key.label(decimalSeparator),
                                style: context.text.displaySmall?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : Icon(
                                key.icon,
                                color: color,
                                size: AppSizes.iconLg,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  double _gridChildAspectRatio(Size size) {
    final cellWidth = (size.width - (AppSpacing.lg * 2)) / 3;
    final cellHeight = (size.height - (AppSpacing.sm * 3)) / 4;
    if (cellWidth <= 0 || cellHeight <= 0) {
      return 1;
    }
    return cellWidth / cellHeight;
  }
}

sealed class _AppNumpadKey {
  const _AppNumpadKey();

  IconData? get icon => null;

  String label(String decimalSeparator);

  String semanticLabel(String decimalSeparator);

  void apply(TextEditingController controller, String decimalSeparator);
}

class _AppNumpadDigitKey extends _AppNumpadKey {
  const _AppNumpadDigitKey(this.value);

  final String value;

  @override
  String label(String decimalSeparator) => value;

  @override
  String semanticLabel(String decimalSeparator) => value;

  @override
  void apply(TextEditingController controller, String decimalSeparator) {
    _replaceSelection(controller, value);
  }
}

class _AppNumpadDecimalKey extends _AppNumpadKey {
  const _AppNumpadDecimalKey();

  @override
  String label(String decimalSeparator) => decimalSeparator;

  @override
  String semanticLabel(String decimalSeparator) => 'Decimal separator';

  @override
  void apply(TextEditingController controller, String decimalSeparator) {
    final text = controller.text;
    final selection = controller.selection;
    final selectedText = selection.isValid
        ? text.substring(selection.start, selection.end)
        : '';
    final remainingText = selection.isValid
        ? text.replaceRange(selection.start, selection.end, '')
        : text;

    if (remainingText.contains('.') || remainingText.contains(',')) {
      return;
    }

    final prefix = selectedText == text || text.isEmpty ? '0' : '';
    _replaceSelection(controller, '$prefix$decimalSeparator');
  }
}

class _AppNumpadBackspaceKey extends _AppNumpadKey {
  const _AppNumpadBackspaceKey();

  @override
  IconData get icon => Icons.backspace_outlined;

  @override
  String label(String decimalSeparator) => '';

  @override
  String semanticLabel(String decimalSeparator) => 'Delete';

  @override
  void apply(TextEditingController controller, String decimalSeparator) {
    final text = controller.text;
    final selection = controller.selection;
    if (text.isEmpty) {
      return;
    }

    if (selection.isValid && !selection.isCollapsed) {
      _replaceSelection(controller, '');
      return;
    }

    final cursor = selection.isValid ? selection.start : text.length;
    if (cursor <= 0) {
      return;
    }

    final replacement = text.replaceRange(cursor - 1, cursor, '');
    controller.value = TextEditingValue(
      text: replacement,
      selection: TextSelection.collapsed(offset: cursor - 1),
    );
  }
}

void _replaceSelection(TextEditingController controller, String value) {
  final text = controller.text;
  final selection = controller.selection;
  final start = selection.isValid ? selection.start : text.length;
  final end = selection.isValid ? selection.end : text.length;
  final replacement = text.replaceRange(start, end, value);
  controller.value = TextEditingValue(
    text: replacement,
    selection: TextSelection.collapsed(offset: start + value.length),
  );
}
