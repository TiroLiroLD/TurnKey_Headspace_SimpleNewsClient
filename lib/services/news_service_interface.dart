import '../models/article.dart';
import '../models/source.dart';

abstract class INewsService {
  Future<List<Article>> getArticles(String query);
  Future<List<Source>> getSources();
}
