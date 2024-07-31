import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../helpers/database_helper_interface.dart';
import '../../models/article.dart';
import '../../models/source.dart';
import '../../services/news_service_interface.dart';
import '../widgets/article_item.dart';
import '../widgets/article_list.dart';

class ArticlesBySourcePage extends StatefulWidget {
  final Source source;

  const ArticlesBySourcePage({required this.source});

  @override
  _ArticlesBySourcePageState createState() => _ArticlesBySourcePageState();
}

class _ArticlesBySourcePageState extends State<ArticlesBySourcePage> {
  late INewsService newsService;
  late IDatabaseHelper databaseHelper;
  List<Article> articles = [];
  bool isLoading = true;
  DateTime? lastUpdate;

  @override
  void initState() {
    super.initState();
    newsService = GetIt.instance<INewsService>();
    databaseHelper = GetIt.instance<IDatabaseHelper>();
    _loadArticles();
    fetchLastUpdate();
  }

  Future<void> fetchLastUpdate() async {
    final lastUpdateTimestamp = await databaseHelper.getLastUpdateTimestamp(widget.source.id);
    setState(() {
      lastUpdate = lastUpdateTimestamp;
    });
  }

  Future<void> _loadArticles() async {
    final articlesFromDB = await databaseHelper.fetchArticlesBySource(widget.source.id);
    if (articlesFromDB.isEmpty) {
      await fetchArticlesFromAPI();
    } else {
      setState(() {
        articles = articlesFromDB;
        isLoading = false;
      });
    }
  }

  Future<void> fetchArticlesFromAPI() async {
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

      await databaseHelper.setLastUpdateTimestamp(widget.source.id, DateTime.now());

      for (var article in fetchedArticles) {
        final existingArticle = await databaseHelper.getArticleByUrl(article.url);
        if (existingArticle != null) {
          final updatedArticle = article.copyWith(bookmarked: existingArticle.bookmarked);
          await databaseHelper.updateArticle(updatedArticle);
        } else {
          await databaseHelper.insertArticle(article);
        }
      }

      fetchLastUpdate();
    } catch (e) {
      // Handle error
      print('Error fetching articles: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshArticles() async {
    await fetchArticlesFromAPI();
    await _loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.source.name),
      ),
      body: isLoading && articles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (lastUpdate != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Last updated: ${lastUpdate!.toLocal()}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshArticles,
                    child: ArticleList(articles: articles),
                  ),
                ),
              ],
            ),
    );
  }
}
