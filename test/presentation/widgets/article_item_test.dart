import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_news_client/helpers/database_helper_interface.dart';
import 'package:simple_news_client/models/article.dart';
import 'package:simple_news_client/presentation/pages/article_details_page.dart';
import 'package:simple_news_client/presentation/widgets/article_item.dart';
import 'package:simple_news_client/services/news_service_interface.dart';

import 'article_item_test.mocks.dart';

@GenerateMocks([INewsService, IDatabaseHelper])
void main() {
  final getIt = GetIt.instance;

  setUp(() {
    final mockNewsService = MockINewsService();
    final mockDatabaseHelper = MockIDatabaseHelper();

    getIt.registerSingleton<INewsService>(mockNewsService);
    getIt.registerSingleton<IDatabaseHelper>(mockDatabaseHelper);
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('ArticleItem displays article details',
      (WidgetTester tester) async {
    final article = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: 'Title 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://picsum.photos/200/300',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
    );

    when(getIt<INewsService>().isArticleBookmarked(article))
        .thenAnswer((_) async => false);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ArticleItem(article: article),
      ),
    ));

    expect(find.text('Title 1'), findsOneWidget);
    expect(find.text('Description 1'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
  });

  testWidgets('ArticleItem toggles bookmark status',
      (WidgetTester tester) async {
    final article = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: 'Title 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://picsum.photos/200/300',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
    );

    final mockDatabaseHelper = getIt<IDatabaseHelper>();

    // Define the initial state where the article is not bookmarked
    when(mockDatabaseHelper.getArticleByUrl(article.url))
        .thenAnswer((_) async => null);
    when(getIt<INewsService>().isArticleBookmarked(article))
        .thenAnswer((_) async => false);
    when(getIt<INewsService>().bookmarkArticle(article)).thenAnswer((_) async {
      when(mockDatabaseHelper.getArticleByUrl(article.url))
          .thenAnswer((_) async => article.copyWith(bookmarked: true));
      when(mockDatabaseHelper.insertArticle(article)).thenAnswer((_) async {});
    });
    when(getIt<INewsService>().unbookmarkArticle(article))
        .thenAnswer((_) async {});

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ArticleItem(article: article),
      ),
    ));

    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

    // Tap to bookmark the article
    await tester.tap(find.byIcon(Icons.bookmark_border));
    await tester.pumpAndSettle();

    verify(getIt<INewsService>().bookmarkArticle(article)).called(1);
  });

  testWidgets('ArticleItem toggles unbookmark status',
      (WidgetTester tester) async {
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

    final mockDatabaseHelper = getIt<IDatabaseHelper>();

    // Define the initial state where the article is bookmarked
    when(mockDatabaseHelper.getArticleByUrl(article.url))
        .thenAnswer((_) async => article.copyWith(bookmarked: true));
    when(getIt<INewsService>().isArticleBookmarked(article))
        .thenAnswer((_) async => true);
    when(getIt<INewsService>().bookmarkArticle(article))
        .thenAnswer((_) async {});
    when(getIt<INewsService>().unbookmarkArticle(article))
        .thenAnswer((_) async {});

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ArticleItem(article: article),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    // Tap to unbookmark the article
    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.pumpAndSettle();

    verify(getIt<INewsService>().unbookmarkArticle(article)).called(1);
  });

  testWidgets('ArticleItem navigates to ArticleDetailsPage on tap',
      (WidgetTester tester) async {
    final article = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: 'Title 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://picsum.photos/200/300',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
    );

    when(getIt<INewsService>().isArticleBookmarked(article))
        .thenAnswer((_) async => false);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ArticleItem(article: article),
      ),
    ));

    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();

    expect(find.byType(ArticleDetailsPage), findsOneWidget);
  });
}
