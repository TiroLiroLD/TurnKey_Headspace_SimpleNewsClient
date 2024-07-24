import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/article.dart';
import '../services/news_service_interface.dart';

class ArticleItem extends StatefulWidget {
  final Article article;

  const ArticleItem({required this.article});

  @override
  _ArticleItemState createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItem> {
  late INewsService newsService;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    newsService = GetIt.instance<INewsService>();
    checkIfArticleIsSaved();
  }

  Future<void> checkIfArticleIsSaved() async {
    final saved = await newsService.isArticleSaved(widget.article);
    setState(() {
      isSaved = saved;
    });
  }

  Future<void> toggleSaveArticle() async {
    if (isSaved) {
      await newsService.removeArticle(widget.article.url);
    } else {
      await newsService.saveArticle(widget.article);
    }
    checkIfArticleIsSaved();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.article.title ?? 'No Title'),
      subtitle: Text(widget.article.description ?? ''),
      trailing: IconButton(
        icon: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: isSaved ? Colors.red : null,
        ),
        onPressed: toggleSaveArticle,
      ),
      onTap: () {
        // TODO Implement navigation to article details
      },
    );
  }
}
