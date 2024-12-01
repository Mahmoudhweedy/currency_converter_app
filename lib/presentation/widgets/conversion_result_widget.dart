import 'package:flutter/material.dart';

class ConversionResult extends StatefulWidget {
  final String fromCurrency;
  final String toCurrency;
  final double amount;

  const ConversionResult({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
  });

  @override
  State<ConversionResult> createState() => _ConversionResultState();
}

class _ConversionResultState extends State<ConversionResult> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Conversion Result:'),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text('${widget.amount.toStringAsFixed(2)} $widget.fromCurrency'),
            const Icon(Icons.arrow_forward),
            Text('20 $widget.toCurrency'),
          ],
        ),
      ],
    );
  }
}
