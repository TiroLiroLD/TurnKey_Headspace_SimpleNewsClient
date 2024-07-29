import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/article.dart';
import '../../services/news_service_interface.dart';
import '../widgets/article_list.dart';

class NewsSearchPage extends StatefulWidget {
  @override
  _NewsSearchPageState createState() => _NewsSearchPageState();
}

class _NewsSearchPageState extends State<NewsSearchPage> {
  late INewsService newsService;
  List<Article> articles = [];
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  final FocusNode _searchFocusNode = FocusNode();

  Future<void> fetchArticles() async {
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

  void _openAdvancedSearch() {
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
                        decoration: const InputDecoration(labelText: 'Query'),
                        onChanged: (value) {
                          setState(() {
                            query = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Include Words'),
                        onChanged: (value) {
                          setState(() {
                            includeWords = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Exclude Words'),
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
                        decoration:
                            const InputDecoration(labelText: 'Language'),
                        value: language,
                        items: const [
                          DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                          DropdownMenuItem(value: 'de', child: Text('German')),
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'es', child: Text('Spanish')),
                          DropdownMenuItem(value: 'fr', child: Text('French')),
                          DropdownMenuItem(value: 'he', child: Text('Hebrew')),
                          DropdownMenuItem(value: 'it', child: Text('Italian')),
                          DropdownMenuItem(value: 'nl', child: Text('Dutch')),
                          DropdownMenuItem(
                              value: 'no', child: Text('Norwegian')),
                          DropdownMenuItem(
                              value: 'pt', child: Text('Portuguese')),
                          DropdownMenuItem(value: 'ru', child: Text('Russian')),
                          DropdownMenuItem(value: 'sv', child: Text('Swedish')),
                          DropdownMenuItem(value: 'ud', child: Text('Urdu')),
                          DropdownMenuItem(value: 'zh', child: Text('Chinese')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            language = value!;
                          });
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Sort By'),
                        value: sortBy,
                        items: const [
                          DropdownMenuItem(
                              value: 'relevancy', child: Text('Relevancy')),
                          DropdownMenuItem(
                              value: 'popularity', child: Text('Popularity')),
                          DropdownMenuItem(
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
                        decoration:
                            const InputDecoration(labelText: 'Page Size'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          focusNode: _searchFocusNode,
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              query = value;
            });
          },
          onSubmitted: (value) {
            fetchArticles();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openAdvancedSearch,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ArticleList(articles: articles),
    );
  }
}
