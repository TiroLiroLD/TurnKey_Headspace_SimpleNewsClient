import 'package:flutter/material.dart';

import '../models/article.dart';
import 'article_item.dart';

class ArticleList extends StatelessWidget {
  final List<Article> articles;

  const ArticleList({required this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ArticleItem(
          article: articles[index],
        );
      },
    );
  }
}
