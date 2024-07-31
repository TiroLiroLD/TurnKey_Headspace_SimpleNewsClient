import 'package:flutter_test/flutter_test.dart';
import 'package:simple_news_client/models/source.dart';

void main() {
  group('Source JSON serialization', () {
    test('fromJson', () {
      final json = {
        'id': '1',
        'name': 'Source 1',
        'description': 'Description 1',
        'url': 'https://example.com',
        'category': 'Category 1',
        'language': 'en',
        'country': 'US',
      };

      final source = Source.fromJson(json);

      expect(source.id, '1');
      expect(source.name, 'Source 1');
      expect(source.description, 'Description 1');
      expect(source.url, 'https://example.com');
      expect(source.category, 'Category 1');
      expect(source.language, 'en');
      expect(source.country, 'US');
    });

    test('toJson', () {
      final source = Source(
        id: '1',
        name: 'Source 1',
        description: 'Description 1',
        url: 'https://example.com',
        category: 'Category 1',
        language: 'en',
        country: 'US',
      );

      final json = source.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Source 1');
      expect(json['description'], 'Description 1');
      expect(json['url'], 'https://example.com');
      expect(json['category'], 'Category 1');
      expect(json['language'], 'en');
      expect(json['country'], 'US');
    });
  });

  group('Source Map conversion', () {
    test('fromMap', () {
      final map = {
        'id': '1',
        'name': 'Source 1',
        'description': 'Description 1',
        'url': 'https://example.com',
        'category': 'Category 1',
        'language': 'en',
        'country': 'US',
      };

      final source = Source.fromJson(map);

      expect(source.id, '1');
      expect(source.name, 'Source 1');
      expect(source.description, 'Description 1');
      expect(source.url, 'https://example.com');
      expect(source.category, 'Category 1');
      expect(source.language, 'en');
      expect(source.country, 'US');
    });

    test('toMap', () {
      final source = Source(
        id: '1',
        name: 'Source 1',
        description: 'Description 1',
        url: 'https://example.com',
        category: 'Category 1',
        language: 'en',
        country: 'US',
      );

      final map = source.toJson();

      expect(map['id'], '1');
      expect(map['name'], 'Source 1');
      expect(map['description'], 'Description 1');
      expect(map['url'], 'https://example.com');
      expect(map['category'], 'Category 1');
      expect(map['language'], 'en');
      expect(map['country'], 'US');
    });
  });
}
