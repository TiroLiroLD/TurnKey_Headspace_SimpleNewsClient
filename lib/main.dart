import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'injection.dart';
import 'services/news_service_interface.dart';
import 'models/article.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  configureDependencies();
  await getIt.allReady();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late INewsService newsService;
  List<Article> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    newsService = getIt<INewsService>();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      List<Article> fetchedArticles = await newsService.getArticles('microsoft');
      setState(() {
        articles = fetchedArticles;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print('Error fetching articles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(articles[index].title),
            subtitle: Text(articles[index].description ?? ''),
          );
        },
      ),
    );
  }
}
