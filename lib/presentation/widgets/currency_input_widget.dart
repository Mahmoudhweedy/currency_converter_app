import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyInput extends StatefulWidget {
  final double initialAmount;
  final void Function(double) onAmountChanged;

  const CurrencyInput({
    super.key,
    required this.initialAmount,
    required this.onAmountChanged,
  });

  @override
  State<CurrencyInput> createState() => _CurrencyInputState();
}

class _CurrencyInputState extends State<CurrencyInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.initialAmount.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: const InputDecoration(
        hintText: 'Enter amount',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        final amount = double.tryParse(value) ?? 0.0;
        widget.onAmountChanged(amount);
      },
    );
  }
}
