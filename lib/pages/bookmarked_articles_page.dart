import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/article.dart';
import '../services/news_service_interface.dart';
import '../widgets/article_list.dart';

class BookmarkedArticlesPage extends StatefulWidget {
  @override
  _BookmarkedArticlesPageState createState() => _BookmarkedArticlesPageState();
}

class _BookmarkedArticlesPageState extends State<BookmarkedArticlesPage> {
  late INewsService newsService;
  List<Article> bookmarkedArticles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    newsService = GetIt.instance<INewsService>();
    fetchBookmarkedArticles();
  }

  Future<void> fetchBookmarkedArticles() async {
    setState(() {
      isLoading = true;
    });
    try {
      bookmarkedArticles = await newsService.getBookmarkedArticles();
    } catch (e) {
      print('Error fetching bookmarked articles: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Articles'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookmarkedArticles.isEmpty
              ? Center(child: Text('No saved articles'))
              : ArticleList(
                  articles: bookmarkedArticles,
                ),
    );
  }
}
