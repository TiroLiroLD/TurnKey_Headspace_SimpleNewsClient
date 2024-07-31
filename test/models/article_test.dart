import 'package:flutter_test/flutter_test.dart';
import 'package:simple_news_client/models/article.dart';

void main() {
  group('Article JSON serialization', () {
    test('fromJson', () {
      final json = {
        'source': {'id': '1', 'name': 'Source 1'},
        'author': 'Author 1',
        'title': 'Title 1',
        'description': 'Description 1',
        'url': 'https://example.com/1',
        'urlToImage': 'https://example.com/image.jpg',
        'publishedAt': '2024-07-29T00:00:00Z',
        'content': 'Content 1',
        'bookmarked': false,
      };

      final article = Article.fromJson(json);

      expect(article.source?.id, '1');
      expect(article.source?.name, 'Source 1');
      expect(article.author, 'Author 1');
      expect(article.title, 'Title 1');
      expect(article.description, 'Description 1');
      expect(article.url, 'https://example.com/1');
      expect(article.urlToImage, 'https://example.com/image.jpg');
      expect(article.publishedAt?.toIso8601String(), '2024-07-29T00:00:00.000Z');
      expect(article.content, 'Content 1');
      expect(article.bookmarked, false);
    });

    test('toJson', () {
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

      final json = article.toJson();

      expect(json['source'].id, '1');
      expect(json['source'].name, 'Source 1');
      expect(json['author'], 'Author 1');
      expect(json['title'], 'Title 1');
      expect(json['description'], 'Description 1');
      expect(json['url'], 'https://example.com/1');
      expect(json['urlToImage'], 'https://example.com/image.jpg');
      expect(json['publishedAt'], '2024-07-29T00:00:00.000Z');
      expect(json['content'], 'Content 1');
      expect(json['bookmarked'], false);
    });
  });

  group('Article Map conversion', () {
    test('fromMap', () {
      final map = {
        'sourceId': '1',
        'sourceName': 'Source 1',
        'author': 'Author 1',
        'title': 'Title 1',
        'description': 'Description 1',
        'url': 'https://example.com/1',
        'urlToImage': 'https://example.com/image.jpg',
        'publishedAt': '2024-07-29T00:00:00Z',
        'content': 'Content 1',
        'bookmarked': 0,
      };

      final article = Article.fromMap(map);

      expect(article.source?.id, '1');
      expect(article.source?.name, 'Source 1');
      expect(article.author, 'Author 1');
      expect(article.title, 'Title 1');
      expect(article.description, 'Description 1');
      expect(article.url, 'https://example.com/1');
      expect(article.urlToImage, 'https://example.com/image.jpg');
      expect(article.publishedAt?.toIso8601String(), '2024-07-29T00:00:00.000Z');
      expect(article.content, 'Content 1');
      expect(article.bookmarked, false);
    });

    test('toMap', () {
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

      final map = article.toMap();

      expect(map['sourceId'], '1');
      expect(map['sourceName'], 'Source 1');
      expect(map['author'], 'Author 1');
      expect(map['title'], 'Title 1');
      expect(map['description'], 'Description 1');
      expect(map['url'], 'https://example.com/1');
      expect(map['urlToImage'], 'https://example.com/image.jpg');
      expect(map['publishedAt'], '2024-07-29T00:00:00.000Z');
      expect(map['content'], 'Content 1');
      expect(map['bookmarked'], 0);
    });
  });

  group('Article copyWith', () {
    test('copyWith', () {
      final article = Article(
        source: ArticleSource(id: '1', name: 'Source 1'),
        author: 'Author 1',
        title: 'Title 1',
        description: 'Description 1',
        url: 'https://example.com/1',
        urlToImage: 'https://example.com/image.jpg',
        publishedAt: DateTime.parse('2024-07-29T00:00:00Z'),
        content: 'Content 1',
        bookmarked: false,
      );

      final updatedArticle = article.copyWith(
        author: 'Updated Author',
        bookmarked: true,
      );

      expect(updatedArticle.source?.id, '1');
      expect(updatedArticle.source?.name, 'Source 1');
      expect(updatedArticle.author, 'Updated Author');
      expect(updatedArticle.title, 'Title 1');
      expect(updatedArticle.description, 'Description 1');
      expect(updatedArticle.url, 'https://example.com/1');
      expect(updatedArticle.urlToImage, 'https://example.com/image.jpg');
      expect(updatedArticle.publishedAt?.toIso8601String(), '2024-07-29T00:00:00.000Z');
      expect(updatedArticle.content, 'Content 1');
      expect(updatedArticle.bookmarked, true);
    });
  });
}
