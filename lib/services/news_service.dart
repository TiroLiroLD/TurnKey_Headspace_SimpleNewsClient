import 'package:injectable/injectable.dart';

import '../helpers/database_helper.dart';
import '../models/article.dart';
import '../models/source.dart';
import '../repositories/news_repository_interface.dart';
import 'news_service_interface.dart';

@Injectable(as: INewsService)
class NewsService implements INewsService {
  final INewsRepository newsRepository;
  final DatabaseHelper databaseHelper;

  NewsService({required this.newsRepository, required this.databaseHelper});

  @override
  Future<List<Article>> getArticles(
      {required Map<String, String> parameters}) async {
    try {
      return await newsRepository.fetchArticles(parameters: parameters);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Source>> getSources() async {
    try {
      return await newsRepository.fetchSources();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveArticle(Article article) async {
    try {
      await databaseHelper.insertArticle(article);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeArticle(String url) async {
    try {
      await databaseHelper.deleteArticle(url);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isArticleSaved(Article article) async {
    try {
      final savedArticles = await databaseHelper.fetchSavedArticles();
      return savedArticles
          .any((savedArticle) => savedArticle.url == article.url);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Article>> getBookmarkedArticles() async {
    try {
      final savedArticles = await databaseHelper.getBookmarkedArticles();
      return savedArticles.where((article) => article.bookmarked).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isArticleBookmarked(Article article) async {
    try {
      final savedArticle = await databaseHelper.getArticleByUrl(article.url);
      print(savedArticle?.bookmarked ?? false);
      return savedArticle?.bookmarked ?? false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> bookmarkArticle(Article article) async {
    try {
      final savedArticle = await databaseHelper.getArticleByUrl(article.url);
      if (savedArticle != null) {
        final updatedArticle = savedArticle.copyWith(bookmarked: true);
        await databaseHelper.updateArticle(updatedArticle);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unbookmarkArticle(Article article) async {
    try {
      final savedArticle = await databaseHelper.getArticleByUrl(article.url);
      if (savedArticle != null) {
        final updatedArticle = savedArticle.copyWith(bookmarked: false);
        await databaseHelper.updateArticle(updatedArticle);
      }
    } catch (e) {
      rethrow;
    }
  }

}
