import '../repositories/news_repository.dart';
import '../models/article.dart';
import '../models/source.dart';

class NewsService {
  final NewsRepository newsRepository;

  NewsService({required this.newsRepository});

  Future<List<Article>> getArticles(String query) async {
    try {
      return await newsRepository.fetchArticles(query: query);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Source>> getSources() async {
    try {
      return await newsRepository.fetchSources();
    } catch (e) {
      rethrow;
    }
  }
}
