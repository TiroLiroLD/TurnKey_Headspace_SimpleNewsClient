import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../helpers/database_helper.dart';
import '../models/article.dart';
import '../services/news_service_interface.dart';

class NewsSearchPage extends StatefulWidget {
  @override
  _NewsSearchPageState createState() => _NewsSearchPageState();
}

class _NewsSearchPageState extends State<NewsSearchPage> {
  late INewsService newsService;
  List<Article> articles = [];
  List<Article> savedArticles = [];
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  String query = '';
  bool exactMatch = false;
  String includeWords = '';
  String excludeWords = '';
  String fromDate = '';
  String toDate = '';
  String language = 'en'; // Default value for language
  String sortBy = 'publishedAt'; // Default value for sortBy
  String pageSize = '20';

  @override
  void initState() {
    super.initState();
    newsService = GetIt.instance<INewsService>();
    fetchArticles();
    fetchSavedArticles();
  }

  Future<void> fetchSavedArticles() async {
    savedArticles = await DatabaseHelper.instance.fetchSavedArticles();
  }

  Future<void> fetchArticles() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    // Combining query parameters
    String combinedQuery = query;
    if (includeWords.isNotEmpty)
      combinedQuery += ' +${includeWords.replaceAll(' ', ' +')}';
    if (excludeWords.isNotEmpty)
      combinedQuery += ' -${excludeWords.replaceAll(' ', ' -')}';

    final parameters = <String, String>{
      if (combinedQuery.isNotEmpty) 'q': combinedQuery,
      if (fromDate.isNotEmpty) 'from': fromDate,
      if (toDate.isNotEmpty) 'to': toDate,
      if (language.isNotEmpty) 'language': language,
      if (sortBy.isNotEmpty) 'sortBy': sortBy,
      if (pageSize.isNotEmpty) 'pageSize': pageSize,
    };

    try {
      List<Article> fetchedArticles =
          await newsService.getArticles(parameters: parameters);
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

  Future<void> toggleSaveArticle(Article article) async {
    if (isArticleSaved(article)) {
      await removeArticle(article);
    } else {
      await saveArticle(article);
    }
  }

  Future<void> saveArticle(Article article) async {
    try {
      await DatabaseHelper.instance.insertArticle(article);
      setState(() {
        savedArticles.add(article);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Article saved: ${article.title}')),
      );
    } catch (e) {
      print('Error saving article: $e');
    }
  }

  Future<void> removeArticle(Article article) async {
    try {
      await DatabaseHelper.instance.deleteArticle(article.url);
      setState(() {
        savedArticles
            .removeWhere((savedArticle) => savedArticle.url == article.url);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Article removed: ${article.title}')),
      );
    } catch (e) {
      print('Error removing article: $e');
    }
  }

  bool isArticleSaved(Article article) {
    return savedArticles.any((savedArticle) => savedArticle.url == article.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'Query'),
                                  onChanged: (value) {
                                    setState(() {
                                      query = value;
                                    });
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Include Words'),
                                  onChanged: (value) {
                                    setState(() {
                                      includeWords = value;
                                    });
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Exclude Words'),
                                  onChanged: (value) {
                                    setState(() {
                                      excludeWords = value;
                                    });
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'From Date (YYYY-MM-DD)'),
                                  onChanged: (value) {
                                    setState(() {
                                      fromDate = value;
                                    });
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'To Date (YYYY-MM-DD)'),
                                  onChanged: (value) {
                                    setState(() {
                                      toDate = value;
                                    });
                                  },
                                ),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                      labelText: 'Language'),
                                  value: language,
                                  items: [
                                    const DropdownMenuItem(
                                        value: 'ar', child: Text('Arabic')),
                                    const DropdownMenuItem(
                                        value: 'de', child: Text('German')),
                                    const DropdownMenuItem(
                                        value: 'en', child: Text('English')),
                                    const DropdownMenuItem(
                                        value: 'es', child: Text('Spanish')),
                                    const DropdownMenuItem(
                                        value: 'fr', child: Text('French')),
                                    const DropdownMenuItem(
                                        value: 'he', child: Text('Hebrew')),
                                    const DropdownMenuItem(
                                        value: 'it', child: Text('Italian')),
                                    const DropdownMenuItem(
                                        value: 'nl', child: Text('Dutch')),
                                    const DropdownMenuItem(
                                        value: 'no', child: Text('Norwegian')),
                                    const DropdownMenuItem(
                                        value: 'pt', child: Text('Portuguese')),
                                    const DropdownMenuItem(
                                        value: 'ru', child: Text('Russian')),
                                    const DropdownMenuItem(
                                        value: 'sv', child: Text('Swedish')),
                                    const DropdownMenuItem(
                                        value: 'ud', child: Text('Urdu')),
                                    const DropdownMenuItem(
                                        value: 'zh', child: Text('Chinese')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      language = value!;
                                    });
                                  },
                                ),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                      labelText: 'Sort By'),
                                  value: sortBy,
                                  items: [
                                    const DropdownMenuItem(
                                        value: 'relevancy',
                                        child: Text('Relevancy')),
                                    const DropdownMenuItem(
                                        value: 'popularity',
                                        child: Text('Popularity')),
                                    const DropdownMenuItem(
                                        value: 'publishedAt',
                                        child: Text('Published At')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      sortBy = value!;
                                    });
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Page Size'),
                                  initialValue: pageSize,
                                  onChanged: (value) {
                                    setState(() {
                                      pageSize = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              fetchArticles();
                            },
                            child: const Text('Apply Filters'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.pushNamed(context, '/saved-articles');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                final isSaved = isArticleSaved(article);
                return ListTile(
                  title: Text(article.title ?? 'No Title'),
                  subtitle: Text(article.description ?? ''),
                  trailing: IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? Colors.red : null,
                    ),
                    onPressed: () {
                      toggleSaveArticle(article);
                    },
                  ),
                );
              },
            ),
    );
  }
}
