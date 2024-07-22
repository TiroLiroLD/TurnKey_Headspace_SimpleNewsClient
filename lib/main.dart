import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'pages/news_search_page.dart';
import 'injection.dart';
import 'services/news_service_interface.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  configureDependencies();
  await GetIt.instance.allReady();

  // Fetch sources on app initialization
  final newsService = GetIt.instance<INewsService>();
  final sources = await newsService.getSources();
  // Print the fetched sources
  print('Fetched Sources:');
  for (var source in sources) {
    print('Source ID: ${source.id}, Name: ${source.name}');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsSearchPage(),
    );
  }
}