import 'package:flutter/material.dart';

class BudgetingMenuButton extends StatelessWidget {
  const BudgetingMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Trips',
      child: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: const Icon(Icons.menu),
      ),
    );
  }
}
