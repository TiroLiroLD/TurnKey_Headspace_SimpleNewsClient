import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_news_client/models/article.dart';
import 'package:simple_news_client/presentation/widgets/article_item.dart';
import 'package:simple_news_client/presentation/widgets/article_list.dart';
import 'package:simple_news_client/services/news_service_interface.dart';

import 'article_list_test.mocks.dart';

@GenerateMocks([INewsService])
void main() {
  final getIt = GetIt.instance;

  setUp(() {
    final mockNewsService = MockINewsService();
    getIt.registerSingleton<INewsService>(mockNewsService);
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('ArticleList displays list of articles with correct bookmark status', (WidgetTester tester) async {
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
        bookmarked: false,
      ),
    ];

    // Mocking the news service to return the correct bookmark status
    when(getIt<INewsService>().isArticleBookmarked(articles[0])).thenAnswer((_) async => true);
    when(getIt<INewsService>().isArticleBookmarked(articles[1])).thenAnswer((_) async => false);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ArticleList(articles: articles),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.byType(ArticleItem), findsNWidgets(2));
    expect(find.text('Title 1'), findsOneWidget);
    expect(find.text('Title 2'), findsOneWidget);
    expect(find.text('Description 1'), findsOneWidget);
    expect(find.text('Description 2'), findsOneWidget);

    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bookmark).first);
    await tester.tap(find.byIcon(Icons.bookmark_border).first);
    await tester.pumpAndSettle();

    verify(getIt<INewsService>().unbookmarkArticle(articles[0])).called(1);
    verify(getIt<INewsService>().bookmarkArticle(articles[1])).called(1);
  });
}
