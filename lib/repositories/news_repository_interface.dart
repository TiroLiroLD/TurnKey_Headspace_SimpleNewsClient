import '../models/article.dart';
import '../models/source.dart';

abstract class INewsRepository {
  Future<List<Article>> fetchArticles({required String query});
  Future<List<Source>> fetchSources();
}
