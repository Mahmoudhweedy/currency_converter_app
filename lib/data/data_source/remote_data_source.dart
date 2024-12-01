import 'package:currency_converter_app/core/networking/api_constants.dart';
import 'package:dio/dio.dart';

import '../models/country_model.dart';

abstract class ConverterRemoteDataSource {
  Future<List<CountryModel>> getCountries();
  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
  });
  Future<Map<String, dynamic>> getHistoryOfCurrency({
    required String fromCurrency,
    required String toCurrency,
    required String startDate,
    required String endDate,
  });
}

class ConverterRemoteDataSourceImpl implements ConverterRemoteDataSource {
  final Dio dio;

  ConverterRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CountryModel>> getCountries() async {
    final response = await dio.get(ApiConstants.countries);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data['results'];
      return data.values.map((json) => CountryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch countries');
    }
  }

  @override
  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    final response = await dio.get(
      '${ApiConstants.convertAPI}?q=${fromCurrency}_$toCurrency&compact=ultra&apiKey=${ApiConstants.apiKey}',
    );

    if (response.statusCode == 200) {
      final conversionRate = response.data['${fromCurrency}_$toCurrency'];
      return conversionRate;
    } else {
      throw Exception('Failed to convert currency');
    }
  }

  @override
  Future<Map<String, dynamic>> getHistoryOfCurrency({
    required String fromCurrency,
    required String toCurrency,
    required String startDate,
    required String endDate,
  }) async {
    String currencies = '${fromCurrency}_$toCurrency';
    final response = await dio.get(
      '${ApiConstants.convertAPI}?q=$currencies&compact=ultra&date=$startDate&endDate=$endDate&apiKey=${ApiConstants.apiKey}',
    );

    if (response.statusCode == 200) {
      final history = response.data[currencies];
      return history;
    } else {
      throw Exception('Failed to fetch history');
    }
  }
}
