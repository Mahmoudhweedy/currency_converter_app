import 'package:equatable/equatable.dart';

import '../../domain/entity/country_entity.dart';

abstract class ConverterState extends Equatable {
  @override
  List<Object> get props => [];
}

class CountryInitial extends ConverterState {}

class CountryLoading extends ConverterState {}

class CountryLoaded extends ConverterState {
  final List<Country> countries;

  CountryLoaded(this.countries);

  @override
  List<Object> get props => [countries];
}

class CountryError extends ConverterState {
  final String message;

  CountryError(this.message);

  @override
  List<Object> get props => [message];
}
