import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'helpers/database_helper.dart';
import 'helpers/database_helper_interface.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  final apiKey = dotenv.env['API_KEY'];
  if (apiKey == null) {
    throw Exception('API_KEY not found in .env file');
  }
  getIt.registerSingleton<String>(apiKey,
      instanceName: 'apiKey'); // Registering apiKey with a name
  getIt.registerSingleton<String>('https://newsapi.org/v2',
      instanceName: 'baseUrl'); // Registering baseUrl with a name

  getIt.registerLazySingleton<IDatabaseHelper>(() => DatabaseHelper());
  getIt.init();
}
