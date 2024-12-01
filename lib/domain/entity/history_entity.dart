import 'package:equatable/equatable.dart';

class History extends Equatable {
  final String date;
  final double rate;

  const History({required this.date, required this.rate});

  @override
  List<Object?> get props => [date, rate];
}
