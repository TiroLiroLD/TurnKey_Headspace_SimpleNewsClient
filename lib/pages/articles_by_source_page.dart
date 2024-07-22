import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/article.dart';
import '../models/source.dart';
import '../services/news_service_interface.dart';

class ArticlesBySourcePage extends StatefulWidget {
  final Source source;

  ArticlesBySourcePage({required this.source});

  @override
  _ArticlesBySourcePageState createState() => _ArticlesBySourcePageState();
}

class _ArticlesBySourcePageState extends State<ArticlesBySourcePage> {
  late INewsService newsService;
  List<Article> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    newsService = GetIt.instance<INewsService>();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    setState(() {
      isLoading = true;
    });

    final parameters = <String, String>{
      'sources': widget.source.id,
    };

    try {
      List<Article> fetchedArticles = await newsService.getArticles(parameters: parameters);
      setState(() {
        articles = fetchedArticles;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print('Error fetching articles: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.source.name),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ListTile(
            title: Text(article.title ?? ''),
            subtitle: Text(article.description ?? ''),
            onTap: () {
              // Implement article detail navigation if needed
            },
          );
        },
      ),
    );
  }
}
