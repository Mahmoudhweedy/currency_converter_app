import 'package:dartz/dartz.dart';

import '../entity/country_entity.dart';
import '../repository/converter_repository.dart';

class GetCountriesUseCase {
  final ConverterRepository repository;

  GetCountriesUseCase(this.repository);

  Future<Either<Exception, List<Country>>> call() async {
    return await repository.getCountries();
  }
}
