import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {

  static Database? _database;

  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _initDatabase();
    print("✅BASE DE DATOS OBTENIDA CON EXITO");
    return _database!;
  }


  Future<Database> _initDatabase() async {
    try {
      final path = join(await getDatabasesPath(), 'gym_app.db');

      return await openDatabase(
        path,
        version: 1,
        onConfigure: (db) async {
          //HABILITAN LLAVES FORANEAS 
          await db.execute("PRAGMA foreign_keys = ON;");
        },
        onCreate: (db, version) async {
          await db.execute(
            '''
            CREATE TABLE clientes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombres TEXT NOT NULL,
            apellidos TEXT NOT NULL,
            telefono TEXT NOT NULL,
            estatus TEXT NOT NULL,
            fotoPath TEXT
            )
            '''
          );

          await db.execute(
            '''
            CREATE TABLE pagos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_cliente INTEGER NOT NULL,
            monto_pago REAL NOT NULL,
            fecha_pago TEXT NOT NULL,
            proxima_fecha_pago TEXT NOT NULL,
            tipo_pago TEXT NOT NULL,
            FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE CASCADE
            )
            '''
          );
          print("✅ BASE DE DATOS CREADA CON EXITO");//--------------------
        },
      );
    }
    catch(e){
      print("❌ ERROR al crear la base de datos: $e");
      rethrow;
    }    
  }
}