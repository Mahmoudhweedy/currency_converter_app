import 'package:currency_converter_app/data/models/country_model.dart';
import 'package:currency_converter_app/domain/entity/history_entity.dart';
import 'package:currency_converter_app/domain/usecase/converter_usecase.dart';
import 'package:currency_converter_app/domain/usecase/history_usecase.dart';
import 'package:currency_converter_app/presentation/screens/converter_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'converter_controller_test.mocks.dart';

@GenerateMocks([GetRateUseCase, GetHistoryUseCase])
void main() {
  late ConverterController controller;
  late MockGetRateUseCase mockGetRateUseCase;
  late MockGetHistoryUseCase mockGetHistoryUseCase;

  setUp(() {
    mockGetRateUseCase = MockGetRateUseCase();
    mockGetHistoryUseCase = MockGetHistoryUseCase();
    controller = ConverterController(mockGetRateUseCase, mockGetHistoryUseCase);
    controller.amountController = TextEditingController();
    controller.resultController = TextEditingController();
  });

  group('ConverterController Tests', () {
    const CountryModel us = CountryModel(
      id: 'US',
      name: 'United States',
      currencyId: 'USD',
      currencyName: 'US Dollar',
      currencySymbol: "\$",
    );
    const CountryModel egypt = CountryModel(
      id: 'EG',
      name: 'Egypt',
      currencyId: 'EGP',
      currencyName: 'Egyptial Pound',
      currencySymbol: 'ج.م',
    );

    test('selectBaseCountry updates base data and clears amountController', () {
      controller.base.onUpdateData(egypt);

      expect(controller.base.state.data, equals(egypt));
      expect(controller.amountController.text, isEmpty);
    });

    test('selectTargetCountry updates target data and clears resultController',
        () {
      controller.target.onUpdateData(egypt);

      expect(controller.target.state.data, equals(egypt));
      expect(controller.resultController.text, isEmpty);
    });

    test(
        'onAmountChange calculates and updates resultController text correctly',
        () {
      controller.rate = 30.0;
      controller.amountController.text = "2";

      controller.onAmountChange();

      expect(controller.resultController.text, equals("60.0"));
    });

    test('onAmountChange clears resultController if input is invalid', () {
      controller.rate = 30.0;
      controller.amountController.text = "";

      controller.onAmountChange();

      expect(controller.resultController.text, isEmpty);
    });

    test('fetchRate updates rate on success', () async {
      controller.base.onUpdateData(us);
      controller.target.onUpdateData(egypt);

      when(mockGetRateUseCase(any)).thenAnswer((_) async => const Right(30.0));

      await controller.fetchRate((msg) {});

      expect(controller.rate, equals(30.0));
    });

    test('fetchRate shows error message on failure', () async {
      controller.base.onUpdateData(egypt);
      controller.target.onUpdateData(us);

      var message = "";

      when(mockGetRateUseCase(any))
          .thenAnswer((_) async => Left(Exception("Error")));

      await controller.fetchRate((msg) {
        message = msg;
      });

      expect(message, equals("Something went wrong"));
      expect(controller.rate, equals(0)); // Rate remains unchanged
    });

    test('fetchHistory updates history data on success', () async {
      final historyList = [
        const History(date: "2024-01-01", rate: 30.0),
        const History(date: "2024-01-02", rate: 31.0),
      ];

      when(mockGetHistoryUseCase(any))
          .thenAnswer((_) async => Right(historyList));

      await controller.fetchHistory((msg) {});

      expect(controller.history.state.data, equals(historyList));
    });

    test('fetchHistory shows error message on failure', () async {
      var message = "";

      when(mockGetHistoryUseCase(any))
          .thenAnswer((_) async => Left(Exception("Error")));

      await controller.fetchHistory((msg) {
        message = msg;
      });

      expect(message, equals("Something went wrong"));
      expect(controller.history.state.data, isNull);
    });
  });
}
