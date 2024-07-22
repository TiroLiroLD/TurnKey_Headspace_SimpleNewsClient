import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleItem extends StatelessWidget {
  final Article article;
  final bool isSaved;
  final Function(Article) onToggleSave;

  ArticleItem({
    required this.article,
    required this.isSaved,
    required this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(article.title ?? 'No Title'),
      subtitle: Text(article.description ?? ''),
      trailing: IconButton(
        icon: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: isSaved ? Colors.red : null,
        ),
        onPressed: () {
          onToggleSave(article);
        },
      ),
      onTap: () {
        // TODO Implement navigation to article details
      },
    );
  }
}
