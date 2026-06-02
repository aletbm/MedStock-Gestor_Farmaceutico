import 'package:medstock/domain/entities/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductDatabaseHelper {
  static final ProductDatabaseHelper _instance = ProductDatabaseHelper._internal();
  factory ProductDatabaseHelper() => _instance;
  ProductDatabaseHelper._internal();

  static Database? _database;
  
  Future<Database> get database async{
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'products.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate:(db, version) async {
        await db.execute('''
        CREATE TABLE products (
          id            INTEGER PRIMARY KEY AUTOINCREMENT,
          nombreComercial    TEXT    NOT NULL,
          nombreGenerico     TEXT    NOT NULL,
          concentracion      TEXT    NOT NULL,
          formato            TEXT    NOT NULL,
          presentacion       TEXT    NOT NULL,
          laboratorio        TEXT    NOT NULL,
          categoria          TEXT    NOT NULL,
          stock              INTEGER NOT NULL,
          precioVenta        REAL    NOT NULL,
          proveedor          TEXT    NOT NULL
        )
      ''');
      },
    );
  }

  Future<int> insertProduct(Product product) async{
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}