import '../models/article.dart';
import '../models/source.dart';

abstract class INewsService {
  Future<List<Article>> getArticles({required Map<String, String> parameters});

  Future<List<Source>> getSources();

  Future<void> saveArticle(Article article);

  Future<void> removeArticle(String url);

  Future<bool> isArticleSaved(Article article);
}
