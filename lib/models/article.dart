import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  final ArticleSource source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;

  Article({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

@JsonSerializable()
class ArticleSource {
  final String? id;
  final String name;

  ArticleSource({
    this.id,
    required this.name,
  });

  factory ArticleSource.fromJson(Map<String, dynamic> json) => _$ArticleSourceFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleSourceToJson(this);
}
