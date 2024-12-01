import 'package:bloc_test/bloc_test.dart';
import 'package:currency_converter_app/data/models/country_model.dart';
import 'package:currency_converter_app/domain/usecase/countries_usecase.dart';
import 'package:currency_converter_app/presentation/bloc/converter_bloc.dart';
import 'package:currency_converter_app/presentation/bloc/converter_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'converter_bloc_test.mocks.dart';

@GenerateMocks([GetCountriesUseCase])
void main() {
  late ConverterCubit cubit;
  late MockGetCountriesUseCase mockGetCountriesUseCase;

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

  setUp(() {
    mockGetCountriesUseCase = MockGetCountriesUseCase();
    cubit = ConverterCubit(mockGetCountriesUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('fetchCountries', () {
    blocTest<ConverterCubit, ConverterState>(
      'emits CountryLoading, CountryLoaded when data is fetched successfully',
      build: () {
        when(mockGetCountriesUseCase())
            .thenAnswer((_) async => Right(countriesList));
        return cubit;
      },
      act: (cubit) => cubit.fetchCountries(),
      expect: () => [
        CountryLoading(),
        CountryLoaded(countriesList),
      ],
    );

    blocTest<ConverterCubit, ConverterState>(
      'emits CountryLoading, CountryError when fetching data fails',
      build: () {
        when(mockGetCountriesUseCase()).thenAnswer(
            (_) async => Left(Exception('Failed to fetch countries')));
        return cubit;
      },
      act: (cubit) => cubit.fetchCountries(),
      expect: () => [
        CountryLoading(),
        CountryError('Exception: Failed to fetch countries'),
      ],
    );
  });
}
