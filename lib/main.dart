import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import 'injection.dart';
import 'pages/news_search_page.dart';
import 'pages/saved_articles_page.dart';
import 'pages/sources_page.dart';
import 'services/background_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  configureDependencies();
  await GetIt.instance.allReady();

  // Start the background service when the app launches
  await BackgroundService.startService();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsSearchPage(),
      routes: {
        '/sources': (context) => SourcesPage(),
        '/saved-articles': (context) => SavedArticlesPage(),
      },
    );
  }
}
