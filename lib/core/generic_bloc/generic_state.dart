part of 'generic_cubit.dart';

abstract class GenericState<T> extends Equatable {
  final T data;
  final bool changed;
  const GenericState(this.data, this.changed);
}

class GenericInitialState<T> extends GenericState<T> {
  const GenericInitialState(T data) : super(data, false);

  @override
  List<Object> get props => [data!, changed];
}

class GenericUpdateState<T> extends GenericState<T> {
  const GenericUpdateState(super.data, super.changed);

  @override
  List<Object> get props => [data!, changed];
}

class GenericLoadingState<T> extends GenericState<T> {
  const GenericLoadingState(super.data, super.changed);

  @override
  List<Object> get props => [data!, changed];
}

class GenericFailState<T> extends GenericState<T> {
  const GenericFailState(super.data, super.changed);

  @override
  List<Object> get props => [data!, changed];
}
