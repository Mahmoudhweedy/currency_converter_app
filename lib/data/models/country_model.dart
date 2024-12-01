import 'package:hive/hive.dart';

import '../../domain/entity/country_entity.dart';

part 'country_model.g.dart';

@HiveType(typeId: 0)
class CountryModel extends Country {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String name;

  @override
  @HiveField(2)
  final String currencyId;

  @override
  @HiveField(3)
  final String currencyName;

  @override
  @HiveField(4)
  final String currencySymbol;

  const CountryModel({
    required this.id,
    required this.name,
    required this.currencyId,
    required this.currencyName,
    required this.currencySymbol,
  }) : super(
          id: id,
          name: name,
          currencyId: currencyId,
          currencyName: currencyName,
          currencySymbol: currencySymbol,
        );

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] ?? 'EG',
      name: json['name'] ?? 'EGYPT',
      currencyId: json['currencyId'] ?? 'EGP',
      currencyName: json['currencyName'] ?? 'EGP',
      currencySymbol: json['currencySymbol'] ?? 'EGP',
    );
  }
}
