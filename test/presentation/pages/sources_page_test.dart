import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_news_client/helpers/database_helper_interface.dart';
import 'package:simple_news_client/models/source.dart';
import 'package:simple_news_client/presentation/pages/articles_by_source_page.dart';
import 'package:simple_news_client/presentation/pages/sources_page.dart';
import 'package:simple_news_client/services/news_service_interface.dart';

import 'sources_page_test.mocks.dart';

@GenerateMocks([INewsService, IDatabaseHelper])
void main() {
  final getIt = GetIt.instance;

  setUp(() {
    final mockNewsService = MockINewsService();
    final mockDatabaseHelper = MockIDatabaseHelper();
    getIt.registerSingleton<INewsService>(mockNewsService);
    getIt.registerSingleton<IDatabaseHelper>(mockDatabaseHelper);

    when(mockDatabaseHelper.fetchArticlesBySource(any))
        .thenAnswer((_) async => []);
    when(mockDatabaseHelper.getLastUpdateTimestamp(any))
        .thenAnswer((_) async => DateTime.now());
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('SourcesPage displays loading indicator',
      (WidgetTester tester) async {
    // Arrange
    when(getIt<INewsService>().getSources())
        .thenAnswer((_) async => Future.delayed(Duration(seconds: 1)));

    // Act
    await tester.pumpWidget(MaterialApp(
      home: SourcesPage(),
    ));

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let the future complete
    await tester.pumpAndSettle();
  });

  testWidgets('SourcesPage displays list of sources',
      (WidgetTester tester) async {
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

    when(getIt<INewsService>().getSources()).thenAnswer((_) async => sources);

    // Act
    await tester.pumpWidget(MaterialApp(
      home: SourcesPage(),
    ));

    // Let the future complete
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.text('Source 1'), findsOneWidget);
    expect(find.text('Source 2'), findsOneWidget);
  });

  testWidgets('SourcesPage handles fetch error', (WidgetTester tester) async {
    // Arrange
    when(getIt<INewsService>().getSources())
        .thenThrow(Exception('Fetch error'));

    // Act
    await tester.pumpWidget(MaterialApp(
      home: SourcesPage(),
    ));

    // Let the future complete
    await tester.pumpAndSettle();

    // Assert
    // Check if the loading indicator is removed after the error
    expect(find.byType(CircularProgressIndicator), findsNothing);
    // Error message not shown in UI, but ensure the list is empty
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('SourcesPage navigates to ArticlesBySourcePage on tap',
      (WidgetTester tester) async {
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
    ];

    when(getIt<INewsService>().getSources()).thenAnswer((_) async => sources);
    when(getIt<INewsService>().getArticles(parameters: {'source': '1'}))
        .thenAnswer((_) async => []);

    // Act
    await tester.pumpWidget(MaterialApp(
      home: SourcesPage(),
    ));

    // Let the future complete
    await tester.pumpAndSettle();

    // Tap on the first ListTile
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(ArticlesBySourcePage), findsOneWidget);
    expect(find.text('Source 1'), findsOneWidget);
  });
}
