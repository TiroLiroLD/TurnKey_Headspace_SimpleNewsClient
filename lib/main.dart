import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_news_client/services/news_service_interface.dart';

import 'helpers/database_helper.dart';
import 'injection.dart';
import 'presentation/pages/news_search_page.dart';
import 'presentation/pages/bookmarked_articles_page.dart';
import 'presentation/pages/sources_page.dart';

const MethodChannel platformChannel =
    MethodChannel('com.headspace.simple_news_client/background_service');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  configureDependencies();
  await GetIt.instance.allReady();

  platformChannel.setMethodCallHandler(_handleMethodCall);

  runApp(MyApp());
}

Future<void> _handleMethodCall(MethodCall call) async {
  switch (call.method) {
    case 'fetchNews':
      await fetchNews();
      break;
    default:
      print('Method not implemented');
  }
}

Future<void> fetchNews() async {
  print("Fetching news...");
  final newsService = GetIt.instance<INewsService>();

  final sources = [
    'abc-news',
    'abc-news-au',
    'aftenposten',
    'al-jazeera-english',
    'ansa'
  ];
  final parameters = {
    'sources': sources.join(','),
  };

  final articles = await newsService.getArticles(parameters: parameters);

  for (var article in articles) {
    final existingArticle =
        await DatabaseHelper.instance.getArticleByUrl(article.url);

    if (existingArticle != null) {
      final updatedArticle =
          article.copyWith(bookmarked: existingArticle.bookmarked);
      await DatabaseHelper.instance.updateArticle(updatedArticle);
    } else {
      await DatabaseHelper.instance.insertArticle(article);
    }
  }

  for (var source in sources) {
    await DatabaseHelper.instance
        .setLastUpdateTimestamp(source, DateTime.now());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      routes: {
        '/sources': (context) => SourcesPage(),
        '/saved-articles': (context) => BookmarkedArticlesPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    SourcesPage(),
    NewsSearchPage(),
    BookmarkedArticlesPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.source),
            label: 'Sources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
