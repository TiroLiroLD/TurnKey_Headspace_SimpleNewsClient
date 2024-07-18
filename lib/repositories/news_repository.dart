import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../models/source.dart';

class NewsRepository {
  final String apiKey;
  final String baseUrl;

  NewsRepository({required this.apiKey, this.baseUrl = 'https://newsapi.org/v2'});

  Future<List<Article>> fetchArticles({required String query}) async {
    // count the time it takes to fetch the articles
    // TODO: Remove stopwatch after optimized
    final stopwatch = Stopwatch()..start();
    print(Uri.parse('$baseUrl/everything?q=$query&apiKey=$apiKey'));
    final response = await http.get(Uri.parse('$baseUrl/everything?q=$query&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> articlesJson = json['articles'];
      print('Fetched ${articlesJson.length} articles in ${stopwatch.elapsedMilliseconds}ms');
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<List<Source>> fetchSources() async {
    final response = await http.get(Uri.parse('$baseUrl/sources?apiKey=$apiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> sourcesJson = json['sources'];
      return sourcesJson.map((json) => Source.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sources');
    }
  }
}
