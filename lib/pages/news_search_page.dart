import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_news_client/widgets/article_list.dart';

import '../models/article.dart';
import '../services/news_service_interface.dart';

class NewsSearchPage extends StatefulWidget {
  @override
  _NewsSearchPageState createState() => _NewsSearchPageState();
}

class _NewsSearchPageState extends State<NewsSearchPage> {
  late INewsService newsService;
  List<Article> articles = [];
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
            icon: Icon(Icons.source),
            onPressed: () {
              Navigator.pushNamed(context, '/sources');
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
          : ArticleList(articles: articles),
    );
  }
}
