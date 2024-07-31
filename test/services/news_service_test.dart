import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_news_client/helpers/database_helper_interface.dart';
import 'package:simple_news_client/models/article.dart';
import 'package:simple_news_client/models/source.dart';
import 'package:simple_news_client/repositories/news_repository_interface.dart';
import 'package:simple_news_client/services/news_service.dart';

@GenerateMocks([INewsRepository, IDatabaseHelper])
import 'news_service_test.mocks.dart';

void main() {
  late NewsService newsService;
  late MockINewsRepository mockNewsRepository;
  late MockIDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockNewsRepository = MockINewsRepository();
    mockDatabaseHelper = MockIDatabaseHelper();
    newsService = NewsService(
      newsRepository: mockNewsRepository,
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('NewsService', () {
    test('should fetch articles and not save them to the database', () async {
      final articles = [
        Article(
          source: ArticleSource(id: '1', name: 'Source 1'),
          author: 'Author 1',
          title: 'Title 1',
          description: 'Description 1',
          url: 'https://example.com/1',
          urlToImage: 'https://example.com/1.jpg',
          publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
          content: 'Content 1',
        ),
      ];
      final parameters = {'q': 'test'};
      when(mockNewsRepository.fetchArticles(parameters: parameters))
          .thenAnswer((_) async => articles);

      final result = await newsService.getArticles(parameters: parameters);

      expect(result, articles);
      verify(mockNewsRepository.fetchArticles(parameters: parameters))
          .called(1);
      // Verify that insertArticle is never called since getArticles does not save articles to DB
      verifyNever(mockDatabaseHelper.insertArticle(any));
    });

    test('should fetch sources', () async {
      // Arrange
      final sources = [
        Source(
          id: '1',
          name: 'Source 1',
          description: 'Description 1',
          url: 'https://source1.com',
          category: 'general',
          language: 'en',
          country: 'us',
        ),
        Source(
          id: '2',
          name: 'Source 2',
          description: 'Description 2',
          url: 'https://source2.com',
          category: 'general',
          language: 'en',
          country: 'us',
        ),
      ];
      when(mockNewsRepository.fetchSources()).thenAnswer((_) async => sources);

      final result = await newsService.getSources();

      expect(result, sources);
      verify(mockNewsRepository.fetchSources()).called(1);
    });

    test('should save an article', () async {
      final article = Article(
        source: ArticleSource(id: '1', name: 'Source 1'),
        author: 'Author 1',
        title: 'Title 1',
        description: 'Description 1',
        url: 'https://example.com/1',
        urlToImage: 'https://example.com/1.jpg',
        publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
        content: 'Content 1',
      );
      when(mockDatabaseHelper.insertArticle(article))
          .thenAnswer((_) async => 1);

      await newsService.saveArticle(article);

      verify(mockDatabaseHelper.insertArticle(article)).called(1);
    });

    test('should remove an article', () async {
      const url = 'https://example.com/1';
      when(mockDatabaseHelper.deleteArticle(url)).thenAnswer((_) async => 1);

      await newsService.removeArticle(url);

      verify(mockDatabaseHelper.deleteArticle(url)).called(1);
    });

    test('should check if article is saved', () async {
      final article = Article(
        source: ArticleSource(id: '1', name: 'Source 1'),
        author: 'Author 1',
        title: 'Title 1',
        description: 'Description 1',
        url: 'https://example.com/1',
        urlToImage: 'https://example.com/1.jpg',
        publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
        content: 'Content 1',
      );
      final savedArticles = [article];
      when(mockDatabaseHelper.fetchSavedArticles())
          .thenAnswer((_) async => savedArticles);

      final isSaved = await newsService.isArticleSaved(article);

      expect(isSaved, true);
      verify(mockDatabaseHelper.fetchSavedArticles()).called(1);
    });

    test('should fetch bookmarked articles', () async {
      final bookmarkedArticles = [
        Article(
          source: ArticleSource(id: '1', name: 'Source 1'),
          author: 'Author 1',
          title: 'Title 1',
          description: 'Description 1',
          url: 'https://example.com/1',
          urlToImage: 'https://example.com/1.jpg',
          publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
          content: 'Content 1',
          bookmarked: true,
        ),
      ];
      when(mockDatabaseHelper.getBookmarkedArticles())
          .thenAnswer((_) async => bookmarkedArticles);

      final result = await newsService.getBookmarkedArticles();

      expect(result, bookmarkedArticles);
      verify(mockDatabaseHelper.getBookmarkedArticles()).called(1);
    });

    test('should check if article is bookmarked', () async {
      final article = Article(
        source: ArticleSource(id: '1', name: 'Source 1'),
        author: 'Author 1',
        title: 'Title 1',
        description: 'Description 1',
        url: 'https://example.com/1',
        urlToImage: 'https://example.com/1.jpg',
        publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
        content: 'Content 1',
        bookmarked: true,
      );

      when(mockDatabaseHelper.getArticleByUrl(article.url))
          .thenAnswer((_) async => article);

      final isBookmarked = await newsService.isArticleBookmarked(article);

      expect(isBookmarked, true);
      verify(mockDatabaseHelper.getArticleByUrl(article.url)).called(1);
    });

    test('should bookmark an article', () async {
      final article = Article(
        source: ArticleSource(id: '1', name: 'Source 1'),
        author: 'Author 1',
        title: 'Title 1',
        description: 'Description 1',
        url: 'https://example.com/1',
        urlToImage: 'https://example.com/1.jpg',
        publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
        content: 'Content 1',
        bookmarked: false,
      );

      when(mockDatabaseHelper.getArticleByUrl(article.url))
          .thenAnswer((_) async => article);
      when(mockDatabaseHelper.updateArticle(any)).thenAnswer((_) async => 1);

      await newsService.bookmarkArticle(article);

      verify(mockDatabaseHelper.getArticleByUrl(article.url)).called(1);
      verify(mockDatabaseHelper.updateArticle(argThat(
        predicate<Article>((a) =>
            a.url == article.url &&
            a.bookmarked == true &&
            a.author == article.author &&
            a.title == article.title &&
            a.description == article.description),
      ))).called(1);
    });

    test('should unbookmark an article', () async {
      final article = Article(
        source: ArticleSource(id: '1', name: 'Source 1'),
        author: 'Author 1',
        title: 'Title 1',
        description: 'Description 1',
        url: 'https://example.com/1',
        urlToImage: 'https://example.com/1.jpg',
        publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
        content: 'Content 1',
        bookmarked: true,
      );

      when(mockDatabaseHelper.getArticleByUrl(article.url))
          .thenAnswer((_) async => article);
      when(mockDatabaseHelper.updateArticle(any)).thenAnswer((_) async => 1);

      await newsService.unbookmarkArticle(article);

      verify(mockDatabaseHelper.getArticleByUrl(article.url)).called(1);
      verify(mockDatabaseHelper.updateArticle(argThat(
        predicate<Article>((a) =>
            a.url == article.url &&
            a.bookmarked == false &&
            a.author == article.author &&
            a.title == article.title &&
            a.description == article.description),
      ))).called(1);
    });
  });
}
