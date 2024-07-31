import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_news_client/models/article.dart';
import 'package:simple_news_client/presentation/pages/bookmarked_articles_page.dart';
import 'package:simple_news_client/services/news_service_interface.dart';
import 'package:simple_news_client/presentation/widgets/article_list.dart';

import 'bookmarked_articles_page_test.mocks.dart';

@GenerateMocks([INewsService])
void main() {
  final getIt = GetIt.instance;

  setUp(() {
    final mockNewsService = MockINewsService();
    getIt.registerSingleton<INewsService>(mockNewsService);

    // Mock the behavior of the news service
    when(mockNewsService.getBookmarkedArticles()).thenAnswer((_) async => []);
    when(mockNewsService.isArticleBookmarked(any)).thenAnswer((_) async => false);
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('BookmarkedArticlesPage displays loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BookmarkedArticlesPage(),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('BookmarkedArticlesPage displays no saved articles message', (WidgetTester tester) async {
    when(getIt<INewsService>().getBookmarkedArticles()).thenAnswer((_) async => []);

    await tester.pumpWidget(MaterialApp(
      home: BookmarkedArticlesPage(),
    ));

    await tester.pump(); // Rebuild the widget with the fetched articles

    expect(find.text('No saved articles'), findsOneWidget);
  });

  testWidgets('BookmarkedArticlesPage displays list of bookmarked articles', (WidgetTester tester) async {
    final articles = [
      Article(
        source: ArticleSource(id: '1', name: 'Source 1'),
        author: 'Author 1',
        title: 'Title 1',
        description: 'Description 1',
        url: 'https://example.com/1',
        urlToImage: 'https://picsum.photos/200/300',
        publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
        content: 'Content 1',
        bookmarked: true,
      ),
      Article(
        source: ArticleSource(id: '2', name: 'Source 2'),
        author: 'Author 2',
        title: 'Title 2',
        description: 'Description 2',
        url: 'https://example.com/2',
        urlToImage: 'https://picsum.photos/200/300',
        publishedAt: DateTime.parse('2024-07-30T00:00:00Z'),
        content: 'Content 2',
        bookmarked: true,
      ),
    ];

    when(getIt<INewsService>().getBookmarkedArticles()).thenAnswer((_) async => articles);

    await tester.pumpWidget(MaterialApp(
      home: BookmarkedArticlesPage(),
    ));

    await tester.pump(); // Rebuild the widget with the fetched articles

    expect(find.byType(ArticleList), findsOneWidget);
    expect(find.text('Title 1'), findsOneWidget);
    expect(find.text('Title 2'), findsOneWidget);
  });

  testWidgets('BookmarkedArticlesPage handles fetch error', (WidgetTester tester) async {
    // Simulate an error
    when(getIt<INewsService>().getBookmarkedArticles()).thenThrow(Exception('Fetch error'));

    await tester.pumpWidget(MaterialApp(
      home: BookmarkedArticlesPage(),
    ));

    await tester.pump(); // Rebuild the widget after error

    // Check if the error message is printed (not visible in UI, but check console for coverage)
    expect(find.text('No saved articles'), findsOneWidget);
  });
/*
  testWidgets('BookmarkedArticlesPage bookmarks and unbookmarks an article', (WidgetTester tester) async {
    final article = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: 'Title 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://picsum.photos/200/300',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
      bookmarked: true,
    );

    when(getIt<INewsService>().getBookmarkedArticles()).thenAnswer((_) async => [article]);
    when(getIt<INewsService>().isArticleBookmarked(article)).thenAnswer((_) async => true);
    when(getIt<INewsService>().bookmarkArticle(article)).thenAnswer((_) async {});
    when(getIt<INewsService>().unbookmarkArticle(article)).thenAnswer((_) async {});

    await tester.pumpWidget(MaterialApp(
      home: BookmarkedArticlesPage(),
    ));

    await tester.pump(); // Rebuild the widget with the fetched articles

    expect(find.text('Title 1'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    // Tap to unbookmark the article
    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.pumpAndSettle();

    verify(getIt<INewsService>().unbookmarkArticle(article)).called(1);

    // Simulate unbookmarking the article
    when(getIt<INewsService>().isArticleBookmarked(article)).thenAnswer((_) async => false);
    await tester.pump();

    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

    // Tap to bookmark the article again
    await tester.tap(find.byIcon(Icons.bookmark_border));
    await tester.pumpAndSettle();

    verify(getIt<INewsService>().bookmarkArticle(article)).called(1);
  });*/
}
