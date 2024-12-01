import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_converter_app/core/di/di.dart';
import 'package:currency_converter_app/core/networking/api_constants.dart';
import 'package:currency_converter_app/domain/entity/country_entity.dart';
import 'package:currency_converter_app/domain/usecase/countries_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/converter_bloc.dart';
import '../bloc/converter_state.dart';

class CountriesSheet extends StatelessWidget {
  const CountriesSheet({super.key, required this.onTap});
  final Function(Country country) onTap;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            ConverterCubit(getIt<GetCountriesUseCase>())..fetchCountries(),
        child: BlocBuilder<ConverterCubit, ConverterState>(
          builder: (context, state) {
            if (state is CountryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CountryLoaded) {
              final countries = state.countries;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      onTap: () => onTap(country),
                      title: Text(country.name),
                      subtitle: Text(country.currencyName),
                      leading: Container(
                        height: 50,
                        width: 50,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              '${ApiConstants.flagsBaseUrl}${country.id.toLowerCase()}.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is CountryError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No data available.'));
            }
          },
        ));
  }
}
