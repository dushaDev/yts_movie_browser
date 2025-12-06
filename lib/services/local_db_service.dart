import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class LocalDbService {
  static final LocalDbService _instance = LocalDbService._internal();
  static Database? _database;

  factory LocalDbService() => _instance;

  LocalDbService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'yts_movies.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY,
            title TEXT,
            year INTEGER,
            rating REAL,
            image_url TEXT,
            summary TEXT,
            genres TEXT
          )
        ''');
      },
    );
  }

  // SAVE (Insert or Replace if exists)
  Future<void> saveMovie(Movie movie) async {
    final db = await database;
    await db.insert(
      'favorites',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // DELETE
  Future<void> removeMovie(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  // GET ALL
  Future<List<Movie>> getSavedMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    // Convert List<Map> to List<Movie>
    return List.generate(maps.length, (i) {
      return Movie.fromMap(maps[i]);
    });
  }

  // CHECK IF EXISTS (For the Heart Icon)
  Future<bool> isSaved(int id) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}
