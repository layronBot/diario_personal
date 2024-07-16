import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:diario2/modelos/usuario.dart';
import 'package:diario2/modelos/diario.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'diarios.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Nombre TEXT,
        ApellidoPaterno TEXT,
        usuario TEXT,
        Contrasena TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE diarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        titulo TEXT,
        descripcion TEXT,
        fechahora TEXT,
        FOREIGN KEY(userId) REFERENCES usuarios(id)
      )
    ''');
  }

  Future<int> insertUsuario(Usuario usuario) async {
    Database db = await database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> getUsuario(String usuario, String contrasena) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'usuarios',
      where: 'usuario = ? AND Contrasena = ?',
      whereArgs: [usuario, contrasena],
    );
    if (results.isNotEmpty) {
      return Usuario.fromMap(results.first);
    }
    return null;
  }

  Future<int> insertDiario(Diario diario) async {
    Database db = await database;
    return await db.insert('diarios', diario.toMap());
  }

  Future<List<Diario>> getDiarios(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'diarios',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return results.map((map) => Diario.fromMap(map)).toList();
  }

  Future<int> updateDiario(Diario diario) async {
    Database db = await database;
    return await db.update(
      'diarios',
      diario.toMap(),
      where: 'id = ?',
      whereArgs: [diario.id],
    );
  }

  Future<int> deleteDiario(int id) async {
    Database db = await database;
    return await db.delete(
      'diarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


