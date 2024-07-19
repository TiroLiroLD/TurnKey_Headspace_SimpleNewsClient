import '../models/article.dart';
import '../models/source.dart';

abstract class INewsRepository {
  Future<List<Article>> fetchArticles({required Map<String, String> parameters});
  Future<List<Source>> fetchSources();
}
