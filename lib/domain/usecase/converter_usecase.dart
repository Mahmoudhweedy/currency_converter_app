import 'package:currency_converter_app/domain/entity/converter_entity.dart';
import 'package:dartz/dartz.dart';

import '../repository/converter_repository.dart';

class GetRateUseCase {
  final ConverterRepository repository;

  GetRateUseCase(this.repository);

  Future<Either<Exception, double>> call(ConvertCurrencyRequest request) async {
    return await repository.convertCurrency(request);
  }
}
