import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/article.dart';

class DatabaseHelper {
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

    await db.execute('''
    CREATE TABLE articles (
      id $idType,
      sourceId $textType,
      sourceName $textType,
      author $textType,
      title $textType,
      description $textType,
      url $textType,
      urlToImage $textType,
      publishedAt $dateType,
      content $textType
    )
    ''');
  }

  Future<void> insertArticle(Article article) async {
    final db = await instance.database;
    await db.insert('articles', article.toMap());
  }

  Future<void> deleteArticle(String url) async {
    final db = await instance.database;
    await db.delete('articles', where: 'url = ?', whereArgs: [url]);
  }

  Future<List<Article>> fetchSavedArticles() async {
    final db = await instance.database;
    final result = await db.query('articles');
    print(result);
    return result.map((json) => Article.fromMap(json)).toList();
  }
}
