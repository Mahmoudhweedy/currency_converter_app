import 'package:currency_converter_app/data/data_source/remote_data_source.dart';
import 'package:currency_converter_app/data/models/country_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'converter_remote_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late ConverterRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = ConverterRemoteDataSourceImpl(mockDio);
  });

  group('getCountries', () {
    test('should return a list of CountryModel when the API call is successful',
        () async {
      final mockResponseData = {
        'results': {
          "EG": {
            "alpha3": "EGY",
            "currencyId": "EGP",
            "currencyName": "Egyptian pound",
            "currencySymbol": "£",
            "id": "EG",
            "name": "Egypt"
          }
        }
      };

      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: mockResponseData,
        ),
      );

      final result = await dataSource.getCountries();

      expect(result, isA<List<CountryModel>>());
      expect(result.length, 1);
      expect(result.first.name, 'Egypt');
    });

    test('should throw an exception when the API call fails', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
        ),
      );

      // Act & Assert
      expect(() => dataSource.getCountries(), throwsException);
    });
  });

  group('convertCurrency', () {
    const fromCurrency = 'USD';
    const toCurrency = 'EGP';
    const mockConversionRate = 50.5;

    test('should return the conversion rate when the API call is successful',
        () async {
      final mockResponseData = {
        'USD_EGP': mockConversionRate,
      };

      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: mockResponseData,
        ),
      );

      final result = await dataSource.convertCurrency(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      );

      expect(result, mockConversionRate);
    });

    test('should throw an exception when the API call fails', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.convertCurrency(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
        ),
        throwsException,
      );
    });
  });

  group('getHistoryOfCurrency', () {
    const fromCurrency = 'USD';
    const toCurrency = 'EGP';
    const startDate = '2024-11-22';
    const endDate = '2024-11-29';
    final mockHistoryData = {
      'USD_EGP': {
        '2024-11-22': 50.0,
        '2024-11-23': 50.5,
        '2024-11-24': 51.0,
        '2024-11-25': 51.5,
        '2024-11-26': 52.0,
        '2024-11-27': 52.5,
        '2024-11-28': 53.0,
        '2024-11-29': 30.0,
      },
    };

    test('should return historical data when the API call is successful',
        () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: mockHistoryData,
        ),
      );

      final result = await dataSource.getHistoryOfCurrency(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        startDate: startDate,
        endDate: endDate,
      );

      expect(result, isA<Map<String, dynamic>>());
      expect(result['2024-11-22'], 50.0);
    });

    test('should throw an exception when the API call fails', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.getHistoryOfCurrency(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          startDate: startDate,
          endDate: endDate,
        ),
        throwsException,
      );
    });
  });
}
