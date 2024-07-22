import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/article.dart';

class SavedArticlesPage extends StatefulWidget {
  @override
  _SavedArticlesPageState createState() => _SavedArticlesPageState();
}

class _SavedArticlesPageState extends State<SavedArticlesPage> {
  List<Article> savedArticles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSavedArticles();
  }

  Future<void> fetchSavedArticles() async {
    setState(() {
      isLoading = true;
    });
    savedArticles = await DatabaseHelper.instance.fetchSavedArticles();
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
          : savedArticles.isEmpty
          ? Center(child: Text('No saved articles'))
          : ListView.builder(
        itemCount: savedArticles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(savedArticles[index].title ?? ''),
            subtitle: Text(savedArticles[index].description ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper.instance
                    .deleteArticle(savedArticles[index].url);
                fetchSavedArticles();
              },
            ),
          );
        },
      ),
    );
  }
}
