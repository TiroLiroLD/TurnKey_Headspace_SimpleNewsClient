import '../models/article.dart';
import '../models/source.dart';

abstract class INewsService {
  Future<List<Article>> getArticles({required Map<String, String> parameters});
  Future<List<Source>> getSources();
}
