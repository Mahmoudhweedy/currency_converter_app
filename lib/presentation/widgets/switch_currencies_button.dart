import 'package:flutter/material.dart';

class SwitchCurrenciesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SwitchCurrenciesButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Icon(Icons.swap_horiz),
    );
  }
}
