import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:simple_news_client/models/article.dart';
import 'package:simple_news_client/models/source.dart';
import 'package:simple_news_client/repositories/news_repository.dart';

void main() {/*
  group('NewsRepository', () {
    late NewsRepository newsRepository;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient((request) async {
        return http.Response('{}', 200);
      });
      newsRepository = NewsRepository(
        apiKey: 'test_api_key',
        baseUrl: 'https://newsapi.org/v2',
        client: mockClient,
      );
    });

    test('fetchArticles returns list of articles if the http call completes successfully', () async {
      final mockResponse = {
        "status": "ok",
        "totalResults": 2,
        "articles": [
          {
            "source": {"id": "1", "name": "Source 1"},
            "author": "Author 1",
            "title": "Title 1",
            "description": "Description 1",
            "url": "https://example.com/1",
            "urlToImage": "https://example.com/1.jpg",
            "publishedAt": "2024-07-29T00:00:00Z",
            "content": "Content 1"
          },
          {
            "source": {"id": "2", "name": "Source 2"},
            "author": "Author 2",
            "title": "Title 2",
            "description": "Description 2",
            "url": "https://example.com/2",
            "urlToImage": "https://example.com/2.jpg",
            "publishedAt": "2024-07-30T00:00:00Z",
            "content": "Content 2"
          }
        ]
      };

      mockClient = MockClient((request) async {
        return http.Response(jsonEncode(mockResponse), 200);
      });

      newsRepository = NewsRepository(
        apiKey: 'test_api_key',
        baseUrl: 'https://newsapi.org/v2',
        client: mockClient,
      );

      final result = await newsRepository.fetchArticles(parameters: {'q': 'test'});

      expect(result, isA<List<Article>>());
      expect(result.length, 2);
      expect(result[0].title, 'Title 1');
      expect(result[1].title, 'Title 2');
    });

    test('fetchSources returns list of sources if the http call completes successfully', () async {
      final mockResponse = {
        "status": "ok",
        "sources": [
          {
            "id": "abc-news-au",
            "name": "ABC News (AU)",
            "description": "Australia's most trusted source of local, national and world news. Comprehensive, independent, in-depth analysis, the latest business, sport, weather and more.",
            "url": "https://www.abc.net.au/news",
            "category": "general",
            "language": "en",
            "country": "au"
          },
          {
            "id": "australian-financial-review",
            "name": "Australian Financial Review",
            "description": "The Australian Financial Review reports the latest news from business, finance, investment and politics, updated in real time. It has a reputation for independent, award-winning journalism and is essential reading for the business and investor community.",
            "url": "http://www.afr.com",
            "category": "business",
            "language": "en",
            "country": "au"
          }
        ]
      };

      mockClient = MockClient((request) async {
        return http.Response(jsonEncode(mockResponse), 200);
      });

      newsRepository = NewsRepository(
        apiKey: 'test_api_key',
        baseUrl: 'https://newsapi.org/v2',
        client: mockClient,
      );

      final result = await newsRepository.fetchSources();

      expect(result, isA<List<Source>>());
      expect(result.length, 2);
      expect(result[0].name, 'ABC News (AU)');
      expect(result[1].name, 'Australian Financial Review');
    });

    test('fetchTopHeadlines returns list of articles if the http call completes successfully', () async {
      final mockResponse = {
        "status": "ok",
        "totalResults": 1,
        "articles": [
          {
            "source": {"id": "google-news", "name": "Google News"},
            "author": "BBC.com",
            "title": "Peru: Uncontacted indigenous people sighted near river - BBC.com",
            "description": null,
            "url": "https://news.google.com/rss/articles/CBMiLGh0dHBzOi8vd3d3LmJiYy5jb20vbmV3cy92aWRlb3MvY3pyajBuZXlrNGtv0gEA?oc=5",
            "urlToImage": null,
            "publishedAt": "2024-07-17T23:42:20Z",
            "content": null
          }
        ]
      };

      mockClient = MockClient((request) async {
        return http.Response(jsonEncode(mockResponse), 200);
      });

      newsRepository = NewsRepository(
        apiKey: 'test_api_key',
        baseUrl: 'https://newsapi.org/v2',
        client: mockClient,
      );

      final result = await newsRepository.fetchArticles(parameters: {'country': 'us'});

      expect(result, isA<List<Article>>());
      expect(result.length, 1);
      expect(result[0].title, 'Peru: Uncontacted indigenous people sighted near river - BBC.com');
    });

    test('fetchArticles throws an exception if the http call completes with an error', () async {
      mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      newsRepository = NewsRepository(
        apiKey: 'test_api_key',
        baseUrl: 'https://newsapi.org/v2',
        client: mockClient,
      );

      expect(newsRepository.fetchArticles(parameters: {'q': 'test'}), throwsException);
    });

    test('fetchSources throws an exception if the http call completes with an error', () async {
      mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      newsRepository = NewsRepository(
        apiKey: 'test_api_key',
        baseUrl: 'https://newsapi.org/v2',
        client: mockClient,
      );

      expect(newsRepository.fetchSources(), throwsException);
    });
  });*/
}
