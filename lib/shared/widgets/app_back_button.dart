import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: context.pop,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(context.colors.canvas),
      ),
      icon: const Icon(Icons.arrow_back),
    );
  }
}
