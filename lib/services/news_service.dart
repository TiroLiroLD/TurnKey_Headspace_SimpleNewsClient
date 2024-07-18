import 'package:injectable/injectable.dart';
import '../repositories/news_repository_interface.dart';
import '../models/article.dart';
import '../models/source.dart';
import 'news_service_interface.dart';

@Injectable(as: INewsService)
class NewsService implements INewsService {
  final INewsRepository newsRepository;

  NewsService({required this.newsRepository});

  @override
  Future<List<Article>> getArticles(String query) async {
    try {
      return await newsRepository.fetchArticles(query: query);
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
}
