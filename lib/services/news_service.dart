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

  Future<void> saveArticle(Article article) async {
    try {
      await databaseHelper.insertArticle(article);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeArticle(String url) async {
    try {
      await databaseHelper.deleteArticle(url);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isArticleSaved(Article article) async {
    try {
      final savedArticles = await databaseHelper.fetchSavedArticles();
      return savedArticles
          .any((savedArticle) => savedArticle.url == article.url);
    } catch (e) {
      rethrow;
    }
  }
}
