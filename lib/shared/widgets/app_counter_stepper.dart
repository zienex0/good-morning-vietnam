import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class AppCounterStepper extends StatelessWidget {
  const AppCounterStepper({
    required this.label,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    super.key,
  });

  final String label;
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: context.text.titleSmall)),
        _CounterButton(icon: Icons.remove, onPressed: onDecrement),
        SizedBox(
          width: AppSizes.controlSm,
          child: Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: context.text.titleSmall,
          ),
        ),
        _CounterButton(icon: Icons.add, onPressed: onIncrement),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSizes.controlSm,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.square(AppSizes.controlSm),
          padding: const EdgeInsets.all(AppSpacing.none),
          shape: const CircleBorder(),
        ),
        child: Icon(icon, size: AppSizes.iconSm),
      ),
    );
  }
}
