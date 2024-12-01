import 'package:currency_converter_app/core/generic_bloc/generic_cubit.dart';
import 'package:currency_converter_app/domain/entity/history_Request.dart';
import 'package:currency_converter_app/domain/usecase/history_usecase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/extensions/app_extensions.dart';
import '../../domain/entity/converter_entity.dart';
import '../../domain/entity/country_entity.dart';
import '../../domain/entity/history_entity.dart';
import '../../domain/usecase/converter_usecase.dart';
import '../widgets/countries_sheet.dart';

class ConverterController {
  final GetRateUseCase getRateUseCase;
  final GetHistoryUseCase getHisrotyUseCase;
  ConverterController(this.getRateUseCase, this.getHisrotyUseCase);

  GenericBloc<Country?> base = GenericBloc(null);
  GenericBloc<Country?> target = GenericBloc(null);

  void selectBaseCountry(BuildContext context) {
    selectionBottomSheet(
      context: context,
      onTap: (country) => base.onUpdateData(country),
    );
    amountController.clear();
  }

  void selectTargetCountry(BuildContext context) {
    selectionBottomSheet(
      context: context,
      onTap: (country) => target.onUpdateData(country),
    );
    resultController.clear();
  }

  void selectionBottomSheet({
    required BuildContext context,
    required Function(Country) onTap,
  }) {
    showModalBottomSheet(
      context: context,
      barrierLabel: "countries",
      builder: (context) => CountriesSheet(
        onTap: (country) {
          onTap(country);
          context.pop();
        },
      ),
    );
  }

  Future<void> getRate(Function(String message) showMessage) async {
    if (base.state.data == null || target.state.data == null) {
      showMessage("You should select the currencies first");
      return;
    }
    await fetchRate((msg) => showMessage("Something went wrong"));
  }

  late final TextEditingController amountController;
  late final TextEditingController resultController;

  void onAmountChange() {
    if (rate == 0 ||
        amountController.text.isEmpty ||
        amountController.text == "0") {
      resultController.text = "";
      return;
    }
    double amount = double.tryParse(amountController.text) ?? 0;
    resultController.text = (amount * rate).toString();
  }

  void convert(Function(String message) showMessage) async {
    await getRate((msg) => showMessage(msg));
    onAmountChange();
  }

  double rate = 0;

  Future<void> fetchRate(Function(String message) showMessage) async {
    final result = await getRateUseCase(
      ConvertCurrencyRequest(
        fromCurrency: base.state.data!.currencyId,
        toCurrency: target.state.data!.currencyId,
      ),
    );
    result.fold(
      (exception) => showMessage("Something went wrong"),
      (rate) => this.rate = rate,
    );
  }

  GenericBloc<List<History>?> history = GenericBloc(null);
  Future<void> fetchHistory(Function(String message) showMessage) async {
    final result = await getHisrotyUseCase(
      HistoryRequest(
        fromCurrency: "EUR",
        toCurrency: "EGP",
        endDate: formatDate(DateTime.now()),
        startDate: formatDate(DateTime.now().subtract(const Duration(days: 7))),
      ),
    );
    result.fold(
      (exception) => showMessage("Something went wrong"),
      (result) => history.onUpdateData(result),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
