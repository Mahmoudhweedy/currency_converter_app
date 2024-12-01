import 'package:currency_converter_app/domain/entity/history_Request.dart';
import 'package:dartz/dartz.dart';

import '../entity/history_entity.dart';
import '../repository/converter_repository.dart';

class GetHistoryUseCase {
  final ConverterRepository repository;

  GetHistoryUseCase(this.repository);

  Future<Either<Exception, List<History>>> call(HistoryRequest request) async {
    return await repository.getHistoryOfCurrency(request);
  }
}
