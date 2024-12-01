import 'package:currency_converter_app/data/data_source/local_data_source.dart';
import 'package:currency_converter_app/data/data_source/remote_data_source.dart';
import 'package:currency_converter_app/data/models/country_model.dart';
import 'package:currency_converter_app/data/models/history_model.dart';
import 'package:currency_converter_app/data/repositories/repository.dart';
import 'package:currency_converter_app/domain/entity/converter_entity.dart';
import 'package:currency_converter_app/domain/entity/history_Request.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'converter_reposirory_test.mocks.dart';

@GenerateMocks([ConverterRemoteDataSource, ConverterLocalDataSource])
void main() {
  late ConverterRepositoryImpl repository;
  late MockConverterRemoteDataSource mockRemoteDataSource;
  late MockConverterLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockConverterRemoteDataSource();
    mockLocalDataSource = MockConverterLocalDataSource();
    repository =
        ConverterRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  group('getCountries', () {
    final countriesList = [
      const CountryModel(
        id: 'EG',
        name: 'Egypt',
        currencyId: 'EGP',
        currencyName: 'Egyptial Pound',
        currencySymbol: 'ج.م',
      ),
      const CountryModel(
        id: 'US',
        name: 'United States',
        currencyId: 'USD',
        currencyName: 'US Dollar',
        currencySymbol: '\$',
      ),
    ];

    test('should return cached countries when they exist locally', () async {
      when(mockLocalDataSource.getCachedCountries())
          .thenAnswer((_) async => countriesList);

      final result = await repository.getCountries();

      verify(mockLocalDataSource.getCachedCountries()).called(1);
      expect(result, Right(countriesList));
      verifyNever(mockRemoteDataSource.getCountries());
    });
    test(
        'should fetch remote countries and cache them when no cached countries exist',
        () async {
      when(mockLocalDataSource.getCachedCountries())
          .thenAnswer((_) async => []);
      when(mockRemoteDataSource.getCountries())
          .thenAnswer((_) async => countriesList);

      final result = await repository.getCountries();

      expect(result, Right(countriesList));
      verify(mockLocalDataSource.getCachedCountries()).called(1);
      verify(mockRemoteDataSource.getCountries()).called(1);
      verify(mockLocalDataSource.cacheCountries(countriesList)).called(1);
    });

    test('should return a DioException message when DioException is thrown',
        () async {
      when(mockLocalDataSource.getCachedCountries())
          .thenAnswer((_) async => []);
      when(mockRemoteDataSource.getCountries()).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/countries'),
          message: 'Server Error'));

      final result = await repository.getCountries();

      expect(result is Left, true);
      expect((result as Left).value, isA<Exception>());
      verify(mockLocalDataSource.getCachedCountries()).called(1);
      verify(mockRemoteDataSource.getCountries()).called(1);
    });
    test(
        'should return a cache failure message when a non-DioException is thrown',
        () async {
      when(mockLocalDataSource.getCachedCountries())
          .thenAnswer((_) async => []);
      when(mockRemoteDataSource.getCountries())
          .thenThrow(Exception("Unknown Error"));

      final result = await repository.getCountries();

      expect(result is Left, true);
      expect((result as Left).value, isA<Exception>());
      verify(mockLocalDataSource.getCachedCountries()).called(1);
      verify(mockRemoteDataSource.getCountries()).called(1);
    });
  });

  group('convertCurrency', () {
    const request =
        ConvertCurrencyRequest(fromCurrency: 'USD', toCurrency: 'EGP');
    const conversionRate = 50.5;

    test('should return conversion rate on success', () async {
      when(mockRemoteDataSource.convertCurrency(
        fromCurrency: request.fromCurrency,
        toCurrency: request.toCurrency,
      )).thenAnswer((_) async => conversionRate);

      final result = await repository.convertCurrency(request);

      verify(mockRemoteDataSource.convertCurrency(
        fromCurrency: request.fromCurrency,
        toCurrency: request.toCurrency,
      ));
      expect(result, const Right(conversionRate));
    });

    test('should return an exception on failure', () async {
      when(mockRemoteDataSource.convertCurrency(
        fromCurrency: request.fromCurrency,
        toCurrency: request.toCurrency,
      )).thenThrow(Exception('API failure'));

      final result = await repository.convertCurrency(request);

      verify(mockRemoteDataSource.convertCurrency(
        fromCurrency: request.fromCurrency,
        toCurrency: request.toCurrency,
      ));
      expect(result.isLeft(), true);
      expect((result as Left).value, isA<Exception>());
    });
  });

  group('getHistoryOfCurrency', () {
    const request = HistoryRequest(
      fromCurrency: 'USD',
      toCurrency: 'EGP',
      startDate: '2024-11-22',
      endDate: '2024-11-29',
    );

    final mockHistoryResponse = {
      '2024-11-22': 50.0,
      '2024-11-23': 50.5,
    };

    final mockHistoryList = [
      const HistoryModel(date: '2024-11-22', rate: 50.0),
      const HistoryModel(date: '2024-11-23', rate: 50.5),
    ];

    test('should return history list on success', () async {
      when(mockRemoteDataSource.getHistoryOfCurrency(
        fromCurrency: request.fromCurrency,
        toCurrency: request.toCurrency,
        startDate: request.startDate,
        endDate: request.endDate,
      )).thenAnswer((_) async => mockHistoryResponse);

      final result = await repository.getHistoryOfCurrency(request);

      verify(mockRemoteDataSource.getHistoryOfCurrency(
        fromCurrency: request.fromCurrency,
        toCurrency: request.toCurrency,
        startDate: request.startDate,
        endDate: request.endDate,
      ));
      expect(result.isRight(), true);
      expect((result as Right).value, mockHistoryList);
    });

    test('should return an exception on failure', () async {
      when(mockRemoteDataSource.getHistoryOfCurrency(
        fromCurrency: request.fromCurrency,
        toCurrency: request.toCurrency,
        startDate: request.startDate,
        endDate: request.endDate,
      )).thenThrow(Exception('API failure'));

      final result = await repository.getHistoryOfCurrency(request);

      verify(mockRemoteDataSource.getHistoryOfCurrency(
        fromCurrency: request.fromCurrency,
        toCurrency: request.toCurrency,
        startDate: request.startDate,
        endDate: request.endDate,
      ));
      expect(result.isLeft(), true);
      expect((result as Left).value, isA<Exception>());
    });
  });
}
