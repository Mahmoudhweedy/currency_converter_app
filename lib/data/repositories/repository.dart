import 'package:currency_converter_app/data/models/history_model.dart';
import 'package:currency_converter_app/domain/entity/history_Request.dart';
import 'package:currency_converter_app/domain/entity/history_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/entity/converter_entity.dart';
import '../../domain/entity/country_entity.dart';
import '../../domain/repository/converter_repository.dart';
import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';

class ConverterRepositoryImpl implements ConverterRepository {
  final ConverterRemoteDataSource remoteDataSource;
  final ConverterLocalDataSource localDataSource;

  ConverterRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Exception, List<Country>>> getCountries() async {
    try {
      final localCountries = await localDataSource.getCachedCountries();
      if (localCountries.isNotEmpty) {
        return Right(localCountries);
      }
      final remoteCountries = await remoteDataSource.getCountries();
      await localDataSource.cacheCountries(remoteCountries);
      return Right(remoteCountries);
    } on DioException catch (e) {
      return Left(Exception(e.message ?? 'Server Error'));
    } catch (e) {
      return Left(Exception("Cache Failure"));
    }
  }

  @override
  Future<Either<Exception, double>> convertCurrency(
      ConvertCurrencyRequest request) async {
    try {
      final convertedAmount = await remoteDataSource.convertCurrency(
        fromCurrency: request.fromCurrency,
        toCurrency: request.toCurrency,
      );
      return Right(convertedAmount);
    } catch (e) {
      return Left(Exception('Error fetching the result: $e'));
    }
  }

  @override
  Future<Either<Exception, List<History>>> getHistoryOfCurrency(
      HistoryRequest request) async {
    try {
      final history = await remoteDataSource.getHistoryOfCurrency(
        fromCurrency: request.fromCurrency,
        toCurrency: request.toCurrency,
        endDate: request.endDate,
        startDate: request.startDate,
      );

      final List<History> historyList =
          history.entries.map((entry) => HistoryModel.fromJson(entry)).toList();
      return Right(historyList);
    } catch (e) {
      return Left(Exception('Error fetching the result: $e'));
    }
  }
}
