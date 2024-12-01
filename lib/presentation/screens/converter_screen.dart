import 'package:currency_converter_app/core/di/di.dart';
import 'package:currency_converter_app/core/extensions/app_extensions.dart';
import 'package:currency_converter_app/core/generic_bloc/generic_cubit.dart';
import 'package:currency_converter_app/domain/entity/country_entity.dart';
import 'package:currency_converter_app/presentation/bloc/converter_bloc.dart';
import 'package:currency_converter_app/presentation/screens/converter_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/history_entity.dart';
import '../bloc/converter_state.dart';
import '../widgets/currency_card_widget.dart';
import '../widgets/history_list_widget.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final ConverterController controller = getIt<ConverterController>();

  @override
  void initState() {
    super.initState();
    controller.amountController = TextEditingController();
    controller.resultController = TextEditingController();
    controller.fetchHistory((msg) => showSnackBar(context, msg));
  }

  @override
  void dispose() {
    controller.amountController.dispose();
    controller.resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: BlocBuilder<ConverterCubit, ConverterState>(
          bloc: context.read<ConverterCubit>(),
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<GenericBloc<Country?>, GenericState<Country?>>(
                      bloc: controller.base,
                      builder: (context, state) {
                        return CurrencyCard(
                          controller: controller.amountController,
                          country: state.data,
                          onSelect: () => controller.selectBaseCountry(context),
                          hintText: "Amount",
                          onChanged: (v) => controller.onAmountChange(),
                        );
                      }),
                  verticalSpace(16),
                  BlocBuilder<GenericBloc<Country?>, GenericState<Country?>>(
                      bloc: controller.target,
                      builder: (context, state) {
                        return CurrencyCard(
                          controller: controller.resultController,
                          country: state.data,
                          hintText: "Result",
                          enabled: false,
                          onSelect: () =>
                              controller.selectTargetCountry(context),
                        );
                      }),
                  verticalSpace(16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => controller.convert(
                        (msg) => showSnackBar(context, msg),
                      ),
                      child: const Text("Convert"),
                    ),
                  ),
                  verticalSpace(16),
                  Text(
                    "History of EGP the last 7 days",
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                  verticalSpace(16),
                  Expanded(
                    child: BlocBuilder<GenericBloc<List<History>?>,
                        GenericState<List<History>?>>(
                      bloc: controller.history,
                      builder: (context, state) {
                        return HistoryList(
                          history: state.data ?? [],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }
}
