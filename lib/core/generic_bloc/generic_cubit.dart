import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'generic_state.dart';

class GenericBloc<T> extends Cubit<GenericState<T>> {
  GenericBloc(T data) : super(GenericInitialState<T>(data));

  void onUpdateData(T data) {
    emit(GenericUpdateState<T>(data, !state.changed));
  }

  void onLoadingData() {
    emit(GenericLoadingState<T>(super.state.data, !state.changed));
  }

  void onFailure() {
    emit(GenericFailState<T>(super.state.data, !state.changed));
  }
}
