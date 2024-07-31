import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_news_client/models/article.dart';
import 'package:simple_news_client/services/news_service_interface.dart';
import 'package:simple_news_client/presentation/pages/article_details_page.dart';

import 'article_details_page_test.mocks.dart';

@GenerateMocks([INewsService])
void main() {
  final getIt = GetIt.instance;

  setUp(() {
    final mockNewsService = MockINewsService();
    getIt.registerSingleton<INewsService>(mockNewsService);

    // Mock the behavior of the news service
    when(mockNewsService.isArticleBookmarked(any))
        .thenAnswer((_) async => false);
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('ArticleDetailsPage displays article details correctly with title', (WidgetTester tester) async {
    final article = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: 'Title 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://mock.image.url',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
    );

    await tester.pumpWidget(MaterialApp(
      home: ArticleDetailsPage(
        article: article,
        toggleSaveArticle: () {},
      ),
    ));

    //expect(find.text('Title 1'), findsOneWidget); //or find 2 widgets:
    expect(find.text('Title 1'), findsNWidgets(2));
    expect(find.text('by Author 1'), findsOneWidget);
    expect(find.text('Content 1'), findsOneWidget);
    expect(find.text('Published at: 2024-07-29 00:00:00.000Z'), findsOneWidget);
  });

  testWidgets('ArticleDetailsPage displays article details correctly with null title', (WidgetTester tester) async {
    final article = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: null,
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://mock.image.url',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
    );

    await tester.pumpWidget(MaterialApp(
      home: ArticleDetailsPage(
        article: article,
        toggleSaveArticle: () {},
      ),
    ));

    expect(find.text(''), findsOneWidget);
    expect(find.text('Article Details'), findsOneWidget);
    expect(find.text('by Author 1'), findsOneWidget);
    expect(find.text('Content 1'), findsOneWidget);
    expect(find.text('Published at: 2024-07-29 00:00:00.000Z'), findsOneWidget);
  });

  testWidgets('Bookmark icon toggles correctly', (WidgetTester tester) async {
    final article = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: 'Title 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://mock.image.url',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
    );

    bool isBookmarked = false;
    await tester.pumpWidget(MaterialApp(
      home: ArticleDetailsPage(
        article: article,
        toggleSaveArticle: () {
          isBookmarked = !isBookmarked;
        },
      ),
    ));

    // Initial state: not bookmarked
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsNothing);

    // Tap the bookmark icon to bookmark
    await tester.tap(find.byIcon(Icons.bookmark_border));
    await tester.pumpAndSettle();

    // State: bookmarked
    expect(find.byIcon(Icons.bookmark_border), findsNothing);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
  });
}
