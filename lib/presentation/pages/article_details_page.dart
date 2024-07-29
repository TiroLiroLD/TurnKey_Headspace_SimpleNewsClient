import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/article.dart';
import '../../services/news_service_interface.dart';

class ArticleDetailsPage extends StatefulWidget {
  final Article article;
  final void Function() toggleSaveArticle;

  const ArticleDetailsPage({Key? key, required this.article, required this.toggleSaveArticle}) : super(key: key);

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  late INewsService newsService;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    newsService = GetIt.instance<INewsService>();
    checkIfArticleIsBookmarked();
  }

  Future<void> checkIfArticleIsBookmarked() async {
    final bookmarked = await newsService.isArticleBookmarked(widget.article);
    setState(() {
      isBookmarked = bookmarked;
    });
  }

  Future<void> toggleSaveArticle() async {
    widget.toggleSaveArticle();
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.title ?? 'Article Details'),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.red : null,
            ),
            onPressed: toggleSaveArticle,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.article.title ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 8),
              Text(
                'by ${widget.article.author ?? 'Unknown'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              widget.article.urlToImage != null
                  ? Image.network(widget.article.urlToImage!)
                  : Container(),
              const SizedBox(height: 16),
              Text(widget.article.content ?? 'No content available',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Text('Published at: ${widget.article.publishedAt}',
                  style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  //TODO Open the article URL in a WebView
                },
                child: const Text('Read Full Article'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
