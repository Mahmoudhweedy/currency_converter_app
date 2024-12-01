import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/countries_usecase.dart';
import 'converter_state.dart';

class ConverterCubit extends Cubit<ConverterState> {
  final GetCountriesUseCase getCountriesUseCase;

  ConverterCubit(this.getCountriesUseCase) : super(CountryInitial());

  Future<void> fetchCountries() async {
    emit(CountryLoading());
    final result = await getCountriesUseCase();
    result.fold(
      (exception) => emit(CountryError(exception.toString())),
      (countries) => emit(CountryLoaded(countries)),
    );
  }
}
