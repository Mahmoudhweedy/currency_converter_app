import 'package:hive/hive.dart';

import '../models/country_model.dart';

abstract class ConverterLocalDataSource {
  Future<List<CountryModel>> getCachedCountries();
  Future<void> cacheCountries(List<CountryModel> countries);
}

class CountryLocalDataSourceImpl implements ConverterLocalDataSource {
  CountryLocalDataSourceImpl();

  @override
  Future<List<CountryModel>> getCachedCountries() async {
    final box = await Hive.openBox<CountryModel>('conList');
    return box.values.toList();
  }

  @override
  Future<void> cacheCountries(List<CountryModel> countries) async {
    final box = await Hive.openBox<CountryModel>('conList');
    await box.clear();
    for (var country in countries) {
      await box.put(country.id, country);
    }
  }
}
