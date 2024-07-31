import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/article.dart';
import 'database_helper_interface.dart';

class DatabaseHelper implements IDatabaseHelper {
  DatabaseHelper();

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('news.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const dateType = 'TEXT';
    const boolType = 'INTEGER';

    await db.execute('''
    CREATE TABLE articles (
      id $idType,
      sourceId $textType,
      sourceName $textType,
      author $textType,
      title $textType,
      description $textType,
      url $textType UNIQUE,
      urlToImage $textType,
      publishedAt $dateType,
      content $textType,
      bookmarked $boolType
    )
    ''');

    await db.execute('''
    CREATE TABLE updates (
      sourceId $textType PRIMARY KEY,
      lastUpdate $dateType
    )
    ''');
  }

  @override
  Future<void> insertArticle(Article article) async {
    final db = await instance.database;
    await db.insert('articles', article.toMap());
  }

  @override
  Future<void> updateArticle(Article article) async {
    final db = await instance.database;
    await db.update(
      'articles',
      article.toMap(),
      where: 'url = ?',
      whereArgs: [article.url],
    );
  }

  @override
  Future<Article?> getArticleByUrl(String url) async {
    final db = await instance.database;
    final result =
        await db.query('articles', where: 'url = ?', whereArgs: [url]);
    if (result.isNotEmpty) {
      return Article.fromMap(result.first);
    }
    return null;
  }

  @override
  Future<void> deleteArticle(String url) async {
    final db = await instance.database;
    await db.delete('articles', where: 'url = ?', whereArgs: [url]);
  }

  @override
  Future<List<Article>> fetchSavedArticles() async {
    final db = await instance.database;
    final result = await db.query('articles');
    return result.map((json) => Article.fromMap(json)).toList();
  }

  @override
  Future<List<Article>> fetchSavedArticlesOrderedByDate() async {
    final db = await instance.database;
    final result = await db.query('articles', orderBy: 'publishedAt DESC');
    return result.map((json) => Article.fromMap(json)).toList();
  }

  @override
  Future<List<Article>> fetchArticlesBySource(String sourceId) async {
    final db = await instance.database;
    final result = await db
        .query('articles', where: 'sourceId = ?', whereArgs: [sourceId]);
    return result.map((json) => Article.fromMap(json)).toList();
  }

  @override
  Future<List<Article>> getBookmarkedArticles() async {
    final db = await instance.database;
    final result = await db.query('articles', where: 'bookmarked = 1');
    return result.map((json) => Article.fromMap(json)).toList();
  }

  @override
  Future<void> setLastUpdateTimestamp(
      String sourceId, DateTime timestamp) async {
    final db = await instance.database;
    await db.insert(
      'updates',
      {'sourceId': sourceId, 'lastUpdate': timestamp.toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<DateTime?> getLastUpdateTimestamp(String sourceId) async {
    final db = await instance.database;
    final result = await db.query(
      'updates',
      where: 'sourceId = ?',
      whereArgs: [sourceId],
    );
    if (result.isNotEmpty) {
      return DateTime.parse(result.first['lastUpdate'] as String);
    }
    return null;
  }
}
