import '../models/article.dart';

abstract class IDatabaseHelper {
  Future<void> insertArticle(Article article);

  Future<void> updateArticle(Article article);

  Future<Article?> getArticleByUrl(String url);

  Future<void> deleteArticle(String url);

  Future<List<Article>> fetchSavedArticles();

  Future<List<Article>> fetchSavedArticlesOrderedByDate();

  Future<List<Article>> fetchArticlesBySource(String sourceId);

  Future<List<Article>> getBookmarkedArticles();

  Future<void> setLastUpdateTimestamp(String sourceId, DateTime timestamp);

  Future<DateTime?> getLastUpdateTimestamp(String sourceId);
}
