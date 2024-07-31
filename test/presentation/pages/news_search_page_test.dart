import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_news_client/helpers/database_helper_interface.dart';
import 'package:simple_news_client/main.dart';
import 'package:simple_news_client/models/article.dart';
import 'package:simple_news_client/presentation/pages/bookmarked_articles_page.dart';
import 'package:simple_news_client/presentation/pages/news_search_page.dart';
import 'package:simple_news_client/presentation/pages/sources_page.dart';
import 'package:simple_news_client/presentation/widgets/article_item.dart';
import 'package:simple_news_client/services/news_service_interface.dart';

import 'news_search_page_test.mocks.dart';

@GenerateMocks([INewsService, IDatabaseHelper])
void main() {
  final getIt = GetIt.instance;

  setUp(() {
    final mockNewsService = MockINewsService();
    final mockDatabaseHelper = MockIDatabaseHelper();

    getIt.registerSingleton<INewsService>(mockNewsService);
    getIt.registerSingleton<IDatabaseHelper>(mockDatabaseHelper);

    // Mock the behavior of the news service if needed
    when(mockNewsService.getArticles(parameters: anyNamed('parameters')))
        .thenAnswer((_) async => []);
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('NewsSearchPage displays initial state',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewsSearchPage()));

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.filter_list), findsOneWidget);
    expect(find.byType(ListView), findsOne);
    expect(find.byType(ArticleItem), findsNothing);
  });

  testWidgets('NewsSearchPage opens advanced search and applies filters',
      (WidgetTester tester) async {
    final mockNewsService = getIt<INewsService>();
    final articles = [
      Article(
        source: ArticleSource(id: '1', name: 'Source 1'),
        author: 'Author 1',
        title: 'Title 1',
        description: 'Description 1',
        url: 'https://example.com/1',
        urlToImage: 'https://example.com/image.jpg',
        publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
        content: 'Content 1',
      ),
    ];

    when(mockNewsService.getArticles(parameters: {}))
        .thenAnswer((_) async => articles);

    await tester.pumpWidget(MaterialApp(home: NewsSearchPage()));

    // Open advanced search modal
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    expect(find.text('Include Words'), findsOneWidget);
  });

  testWidgets('BottomNavigationBar switches pages',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(SourcesPage), findsOneWidget);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    expect(find.byType(NewsSearchPage), findsOneWidget);

    await tester.tap(find.text('Saved'));
    await tester.pumpAndSettle();

    expect(find.byType(BookmarkedArticlesPage), findsOneWidget);
  });
}
