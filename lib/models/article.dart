import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  final ArticleSource? source;
  final String? author;
  final String? title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
  final bool bookmarked;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.bookmarked = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  // Convert a Article into a Map.
  // Keys correspond to column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'sourceId': source?.id,
      'sourceName': source?.name,
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt?.toIso8601String(),
      'content': content,
      'bookmarked': bookmarked ? 1 : 0,
    };
  }

  // Implement fromMap to convert a map into an Article
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      source: map['sourceId'] != null || map['sourceName'] != null
          ? ArticleSource(id: map['sourceId'], name: map['sourceName'])
          : null,
      author: map['author'],
      title: map['title'],
      description: map['description'],
      url: map['url'],
      urlToImage: map['urlToImage'],
      publishedAt: map['publishedAt'] != null ? DateTime.parse(map['publishedAt']) : null,
      content: map['content'],
      bookmarked: map['bookmarked'] == 1,
    );
  }

  Article copyWith({
    ArticleSource? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    DateTime? publishedAt,
    String? content,
    bool? bookmarked,
  }) {
    return Article(
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      bookmarked: bookmarked ?? this.bookmarked,
    );
  }
}

@JsonSerializable()
class ArticleSource {
  final String? id;
  final String? name;

  ArticleSource({
    this.id,
    this.name,
  });

  factory ArticleSource.fromJson(Map<String, dynamic> json) => _$ArticleSourceFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleSourceToJson(this);
}
