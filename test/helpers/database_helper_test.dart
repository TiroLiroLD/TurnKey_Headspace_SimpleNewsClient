import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:simple_news_client/helpers/database_helper.dart';
import 'package:simple_news_client/models/article.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseHelper databaseHelper;

  setUpAll(() async {
    databaseHelper = DatabaseHelper();
    await databaseHelper.database;
  });

  tearDownAll(() async {
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

  test('Update article', () async {
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
    final updatedArticle = article.copyWith(title: 'Updated Title 1');
    await databaseHelper.updateArticle(updatedArticle);

    final retrievedArticle = await databaseHelper.getArticleByUrl(article.url);

    expect(retrievedArticle, isNotNull);
    expect(retrievedArticle?.title, 'Updated Title 1');

    // Clean up
    await databaseHelper.deleteArticle(article.url);
  });

  test('Delete article', () async {
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
    await databaseHelper.deleteArticle(article.url);

    final retrievedArticle = await databaseHelper.getArticleByUrl(article.url);

    expect(retrievedArticle, isNull);
  });

  test('Fetch saved articles', () async {
    final article1 = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: 'Title 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://example.com/image.jpg',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
    );

    final article2 = Article(
      source: ArticleSource(id: '2', name: 'Source 2'),
      author: 'Author 2',
      title: 'Title 2',
      description: 'Description 2',
      url: 'https://example.com/2',
      urlToImage: 'https://example.com/image2.jpg',
      publishedAt: DateTime.parse('2024-07-30T00:00:00Z'),
      content: 'Content 2',
    );

    await databaseHelper.insertArticle(article1);
    await databaseHelper.insertArticle(article2);

    final articles = await databaseHelper.fetchSavedArticles();

    expect(articles.length, 2);

    // Clean up
    await databaseHelper.deleteArticle(article1.url);
    await databaseHelper.deleteArticle(article2.url);
  });

  test('Fetch saved articles ordered by date', () async {
    final article1 = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: 'Title 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://example.com/image.jpg',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
    );

    final article2 = Article(
      source: ArticleSource(id: '2', name: 'Source 2'),
      author: 'Author 2',
      title: 'Title 2',
      description: 'Description 2',
      url: 'https://example.com/2',
      urlToImage: 'https://example.com/image2.jpg',
      publishedAt: DateTime.parse('2024-07-30T00:00:00Z'),
      content: 'Content 2',
    );

    await databaseHelper.insertArticle(article1);
    await databaseHelper.insertArticle(article2);

    final articles = await databaseHelper.fetchSavedArticlesOrderedByDate();

    expect(articles.length, 2);
    expect(articles.first.title, 'Title 2'); // Most recent article first

    // Clean up
    await databaseHelper.deleteArticle(article1.url);
    await databaseHelper.deleteArticle(article2.url);
  });

  test('Fetch articles by source', () async {
    final article1 = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: 'Title 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://example.com/image.jpg',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
    );

    final article2 = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 2',
      title: 'Title 2',
      description: 'Description 2',
      url: 'https://example.com/2',
      urlToImage: 'https://example.com/image2.jpg',
      publishedAt: DateTime.parse('2024-07-30T00:00:00Z'),
      content: 'Content 2',
    );

    final article3 = Article(
      source: ArticleSource(id: '2', name: 'Source 2'),
      author: 'Author 3',
      title: 'Title 3',
      description: 'Description 3',
      url: 'https://example.com/3',
      urlToImage: 'https://example.com/image3.jpg',
      publishedAt: DateTime.parse('2024-07-31T00:00:00Z'),
      content: 'Content 3',
    );

    await databaseHelper.insertArticle(article1);
    await databaseHelper.insertArticle(article2);
    await databaseHelper.insertArticle(article3);

    final articles = await databaseHelper.fetchArticlesBySource('1');

    expect(articles.length, 2);
    expect(articles.every((article) => article.source?.id == '1'), isTrue);

    // Clean up
    await databaseHelper.deleteArticle(article1.url);
    await databaseHelper.deleteArticle(article2.url);
    await databaseHelper.deleteArticle(article3.url);
  });

  test('Get bookmarked articles', () async {
    final article1 = Article(
      source: ArticleSource(id: '1', name: 'Source 1'),
      author: 'Author 1',
      title: 'Title 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      urlToImage: 'https://example.com/image.jpg',
      publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
      content: 'Content 1',
      bookmarked: true,
    );

    final article2 = Article(
      source: ArticleSource(id: '2', name: 'Source 2'),
      author: 'Author 2',
      title: 'Title 2',
      description: 'Description 2',
      url: 'https://example.com/2',
      urlToImage: 'https://example.com/image2.jpg',
      publishedAt: DateTime.parse('2024-07-30T00:00:00Z'),
      content: 'Content 2',
      bookmarked: false,
    );

    await databaseHelper.insertArticle(article1);
    await databaseHelper.insertArticle(article2);

    final bookmarkedArticles = await databaseHelper.getBookmarkedArticles();

    expect(bookmarkedArticles.length, 1);
    expect(bookmarkedArticles.first.bookmarked, isTrue);

    // Clean up
    await databaseHelper.deleteArticle(article1.url);
    await databaseHelper.deleteArticle(article2.url);
  });

  test('Set and get last update timestamp', () async {
    const sourceId = '1';
    final timestamp = DateTime.now();

    await databaseHelper.setLastUpdateTimestamp(sourceId, timestamp);

    final retrievedTimestamp =
        await databaseHelper.getLastUpdateTimestamp(sourceId);

    expect(retrievedTimestamp, isNotNull);
    expect(retrievedTimestamp, timestamp);

    // Clean up
    final db = await databaseHelper.database;
    await db.delete('updates',
        where: 'sourceId = ?', whereArgs: [sourceId]);
  });
}
