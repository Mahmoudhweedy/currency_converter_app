import '../../domain/entity/history_entity.dart';

class HistoryModel extends History {
  const HistoryModel({required super.date, required super.rate});
  factory HistoryModel.fromJson(MapEntry<String, dynamic> json) {
    return HistoryModel(
      date: json.key,
      rate: json.value.toDouble(),
    );
  }
}
