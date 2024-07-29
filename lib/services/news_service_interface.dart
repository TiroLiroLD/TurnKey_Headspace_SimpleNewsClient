import '../models/article.dart';
import '../models/source.dart';

abstract class INewsService {
  Future<List<Article>> getArticles({required Map<String, String> parameters});

  Future<List<Source>> getSources();

  Future<void> saveArticle(Article article);

  Future<void> removeArticle(String url);

  Future<bool> isArticleSaved(Article article);

  Future<List<Article>> getBookmarkedArticles();

  Future<bool> isArticleBookmarked(Article article);

  Future<void> bookmarkArticle(Article article);

  Future<void> unbookmarkArticle(Article article);
}
