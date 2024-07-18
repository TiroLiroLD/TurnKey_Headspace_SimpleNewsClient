import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models/article.dart';
import 'repositories/news_repository.dart';
import 'services/news_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
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
  late NewsService newsService;
  List<Article> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['API_KEY']!;
    final newsRepository = NewsRepository(apiKey: apiKey);
    newsService = NewsService(newsRepository: newsRepository);
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      List<Article> fetchedArticles =
          await newsService.getArticles('microsoft');
      setState(() {
        articles = fetchedArticles;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
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
