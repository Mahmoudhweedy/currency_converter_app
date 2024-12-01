import 'package:currency_converter_app/domain/entity/converter_entity.dart';
import 'package:dartz/dartz.dart';

import '../entity/country_entity.dart';
import '../entity/history_Request.dart';
import '../entity/history_entity.dart';

abstract class ConverterRepository {
  Future<Either<Exception, List<Country>>> getCountries();
  Future<Either<Exception, double>> convertCurrency(
      ConvertCurrencyRequest request);
  Future<Either<Exception, List<History>>> getHistoryOfCurrency(
      HistoryRequest request);
}
