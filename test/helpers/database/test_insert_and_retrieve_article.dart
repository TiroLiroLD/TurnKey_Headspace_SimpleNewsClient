import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:simple_news_client/helpers/database_helper.dart';
import 'package:simple_news_client/models/article.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    databaseHelper = DatabaseHelper();
    await databaseHelper.database;
  });

  tearDown(() async {
    final db = await databaseHelper.database;
    await db.close();
  });

  test('Insert and retrieve article', () async {
    final article = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: 'Title 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://example.com/image.jpg',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
    );

    await databaseHelper.insertArticle(article);
    final retrievedArticle = await databaseHelper.getArticleByUrl(article.url);

    expect(retrievedArticle, isNotNull);
    expect(retrievedArticle?.title, article.title);

    // Clean up
    await databaseHelper.deleteArticle(article.url);
  });
}
