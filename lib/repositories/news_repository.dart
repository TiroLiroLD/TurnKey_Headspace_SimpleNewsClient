import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../models/article.dart';
import '../models/source.dart';
import 'news_repository_interface.dart';

@Injectable(as: INewsRepository)
class NewsRepository implements INewsRepository {
  final String apiKey;
  final String baseUrl;

  NewsRepository({
    @Named('apiKey') required this.apiKey,
    @Named('baseUrl') required this.baseUrl,
  });

  @override
  Future<List<Article>> fetchArticles({required Map<String, String> parameters}) async {
    // count the time it takes to fetch the articles
    // TODO: Remove stopwatch after optimized
    final stopwatch = Stopwatch()..start();

    parameters['apiKey'] = apiKey;
    final uri = Uri.parse('$baseUrl/everything').replace(queryParameters: parameters);
    print(uri);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> articlesJson = json['articles'];
      print('Fetched ${articlesJson.length} articles in ${stopwatch.elapsedMilliseconds}ms');
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  @override
  Future<List<Source>> fetchSources() async {
    final uri = Uri.parse('$baseUrl/sources').replace(queryParameters: {'apiKey': apiKey});

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> sourcesJson = json['sources'];
      return sourcesJson.map((json) => Source.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sources');
    }
  }
}
