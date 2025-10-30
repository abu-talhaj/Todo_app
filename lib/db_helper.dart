import 'package:sqflite/sqflite.dart';
import 'todo_model.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  static String DB_NAME = "todo.db";
  static String TABLE_NAME = "todos";

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

 Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DB_NAME);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
      CREATE TABLE $TABLE_NAME(
      
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      content TEXT,
      date TEXT
      )
      
      """);
      },
    );
  }

  Future<int> insertTask(TodoModel task) async {
    final db = await database;
    return await db.insert(TABLE_NAME, task.toMap());
  }

  Future<List<TodoModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);
    return List.generate(maps.length, (i) => TodoModel.fromMap(maps[i]));
  }

  Future<int> updateTask(TodoModel task) async {
    final db = await database;
    return await db.update(
      TABLE_NAME,
      task.toMap(),
      where: "id=?",
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(TABLE_NAME, where: "id=?", whereArgs: [id]);
  }
}
