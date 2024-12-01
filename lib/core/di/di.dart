import 'package:currency_converter_app/data/data_source/local_data_source.dart';
import 'package:currency_converter_app/domain/repository/converter_repository.dart';
import 'package:currency_converter_app/domain/usecase/converter_usecase.dart';
import 'package:currency_converter_app/domain/usecase/countries_usecase.dart';
import 'package:currency_converter_app/domain/usecase/history_usecase.dart';
import 'package:currency_converter_app/presentation/bloc/converter_bloc.dart';
import 'package:currency_converter_app/presentation/screens/converter_controller.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/data_source/remote_data_source.dart';
import '../../data/repositories/repository.dart';
import '../networking/dio_helper.dart';

final getIt = GetIt.instance;

void init() {
  Dio dio = DioHelper.getDio();

  // Cubit
  getIt.registerFactory(() => ConverterCubit(getIt()));
  getIt.registerFactory(() => ConverterController(getIt(), getIt()));

  // Use Cases
  getIt.registerLazySingleton(() => GetCountriesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetRateUseCase(getIt()));
  getIt.registerLazySingleton(() => GetHistoryUseCase(getIt()));

  // Repository
  getIt.registerLazySingleton<ConverterRepository>(
      () => ConverterRepositoryImpl(getIt(), getIt()));

  // Data Sources
  getIt.registerLazySingleton<ConverterRemoteDataSource>(
      () => ConverterRemoteDataSourceImpl(dio));
  getIt.registerLazySingleton<ConverterLocalDataSource>(
      () => CountryLocalDataSourceImpl());
}
